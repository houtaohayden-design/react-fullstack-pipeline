# Image Sources — Free Stock Photos & Illustrations

> 所有来源均可免费用于商业项目。开发阶段用直接 URL（无需 API key），生产环境用 API。

## Quick Decision

| 场景 | 推荐源 | 方式 |
|------|--------|------|
| 开发占位图 | Lorem Picsum | 直接 URL，无需 key |
| Hero / 大图背景 | Unsplash | API，高质量摄影 |
| 通用配图 / 多样性高 | Pexels | API，20000 req/m |
| 矢量图 / 插画 | Pixabay | API，含矢量图 |
| 空状态 / Onboarding 插画 | unDraw | 开源 SVG，可改色 |
| 头像 | UI Avatars / DiceBear | 直接 URL |
| Logo / 图标 | Lucide (已有知识库) | npm 包 |

---

## 1. Lorem Picsum — 开发占位图

无需 API key，最简方式。图片会被缓存在 CDN，同 URL 返回同一张图。

```
https://picsum.photos/{width}/{height}?random={seed}
```

### React Component

```tsx
const PicsumImage = ({ width = 800, height = 600, seed = 1, alt = '' }: {
  width?: number; height?: number; seed?: number; alt?: string;
}) => (
  <img
    src={`https://picsum.photos/${width}/${height}?random=${seed}`}
    alt={alt}
    loading="lazy"
  />
)
```

### 列表占位（不同图片）

```tsx
{items.map((item, i) => (
  <img
    key={item.id}
    src={`https://picsum.photos/400/300?random=${i}`}
    alt={item.title}
  />
))}
```

**限制**：无搜索功能，图片质量参差不齐，不适合生产环境。

---

## 2. Unsplash — 高质量艺术摄影

**注册**：[unsplash.com/developers](https://unsplash.com/developers) → 创建 App → 获取 Access Key
**免费额度**：50 req/h (demo), 5000 req/h (production approval)
**格式**：`Authorization: Client-ID {ACCESS_KEY}`

### 随机图片（按关键词）

```
GET https://api.unsplash.com/photos/random?query=nature&orientation=landscape&count=1
Authorization: Client-ID {ACCESS_KEY}
```

### React Hook

```tsx
interface UnsplashPhoto {
  id: string
  urls: { raw: string; regular: string; small: string; thumb: string }
  alt_description: string
  user: { name: string; links: { html: string } }
}

const UNSPLASH_KEY = import.meta.env.VITE_UNSPLASH_ACCESS_KEY

async function fetchUnsplash(query: string, count = 1): Promise<UnsplashPhoto[]> {
  if (!UNSPLASH_KEY) throw new Error('Missing VITE_UNSPLASH_ACCESS_KEY')
  const params = new URLSearchParams({ query, orientation: 'landscape', count: String(count) })
  const res = await fetch(`https://api.unsplash.com/photos/random?${params}`, {
    headers: { Authorization: `Client-ID ${UNSPLASH_KEY}` }
  })
  if (!res.ok) throw new Error(`Unsplash: ${res.status}`)
  return res.json()
}

function useUnsplash(query: string) {
  const [photos, setPhotos] = useState<UnsplashPhoto[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchUnsplash(query, 3)
      .then(setPhotos)
      .catch(console.error)
      .finally(() => setLoading(false))
  }, [query])

  return { photos, loading }
}
```

### Unsplash 归因要求

```tsx
<footer>
  Photo by <a href={photo.user.links.html}>{photo.user.name}</a> on
  <a href="https://unsplash.com">Unsplash</a>
</footer>
```

---

## 3. Pexels — 通用素材（照片+视频）

**注册**：[pexels.com/api](https://www.pexels.com/api/) → 获取 API Key
**免费额度**：200 req/h, 20000 req/m
**格式**：`Authorization: {API_KEY}`（不需要 "Bearer" 前缀）

### 搜索图片

```
GET https://api.pexels.com/v1/search?query=nature&per_page=3&orientation=landscape
Authorization: {API_KEY}
```

### React Hook

```tsx
interface PexelsPhoto {
  id: number
  src: { original: string; large: string; medium: string; small: string }
  alt: string
  photographer: string
  photographer_url: string
}

const PEXELS_KEY = import.meta.env.VITE_PEXELS_API_KEY

async function fetchPexels(query: string, perPage = 3): Promise<PexelsPhoto[]> {
  if (!PEXELS_KEY) throw new Error('Missing VITE_PEXELS_API_KEY')
  const params = new URLSearchParams({ query, per_page: String(perPage), orientation: 'landscape' })
  const res = await fetch(`https://api.pexels.com/v1/search?${params}`, {
    headers: { Authorization: PEXELS_KEY }
  })
  if (!res.ok) throw new Error(`Pexels: ${res.status}`)
  const data = await res.json()
  return data.photos
}
```

### Pexels 归因

```tsx
<footer>
  Photo by <a href={photo.photographer_url}>{photo.photographer}</a> on
  <a href="https://www.pexels.com">Pexels</a>
</footer>
```

---

## 4. Pixabay — 照片+矢量图+视频

**注册**：[pixabay.com/api/docs](https://pixabay.com/api/docs/) → 获取 API Key
**免费额度**：无严格限制（~100 req/min）
**格式**：key 作为查询参数

### 搜索

```
GET https://pixabay.com/api/?key={API_KEY}&q=nature&per_page=3&orientation=horizontal
```

### React Hook

```tsx
interface PixabayImage {
  id: number
  webformatURL: string
  largeImageURL: string
  tags: string
  user: string
}

const PIXABAY_KEY = import.meta.env.VITE_PIXABAY_API_KEY

async function fetchPixabay(query: string): Promise<PixabayImage[]> {
  if (!PIXABAY_KEY) throw new Error('Missing VITE_PIXABAY_API_KEY')
  const params = new URLSearchParams({ key: PIXABAY_KEY, q: query, per_page: '3' })
  const res = await fetch(`https://pixabay.com/api/?${params}`)
  if (!res.ok) throw new Error(`Pixabay: ${res.status}`)
  const data = await res.json()
  return data.hits
}
```

**注意**：Pixabay 返回 `webformatURL`（适合网页展示）和 `largeImageURL`（高清原图），一般用 `webformatURL`。

---

## 5. unDraw — 开源 SVG 插画

无需 API key。所有插画 MIT 开源，可通过 URL 参数改变主色调。

```
https://undraw.co/api/illustrations?primaryColor={HEX}
```

### React 集成

```tsx
// 方式 1: 使用 unDraw 的 SVG 文件（推荐 — 离线可用）
import EmptyState from '@/assets/undraw/empty.svg?react'

function EmptyPage() {
  return (
    <div className="empty-state">
      <EmptyState className="w-64 h-64" />
      <p>Nothing here yet</p>
    </div>
  )
}
```

```tsx
// 方式 2: 动态加载（在线 — 可按主题搜索）
const UNDRAW_BASE = 'https://undraw.co/api/illustrations'

function useUndraw(primaryColor = '6366f1') {
  const [svgs, setSvgs] = useState<string[]>([])

  useEffect(() => {
    fetch(`${UNDRAW_BASE}?primaryColor=${primaryColor}`)
      .then(r => r.json())
      .then(data => setSvgs(data.illustrations.map((i: { image: string }) => i.image)))
      .catch(() => {/* fallback to local */})
  }, [primaryColor])

  return svgs
}
```

**使用场景**：空状态、Onboarding、Hero 配图、功能说明页。

---

## 6. 头像生成（无需 API key）

### UI Avatars

```
https://ui-avatars.com/api/?name=John+Doe&background=6366f1&color=fff&size=128
```

### DiceBear（可选风格：avataaars, bottts, pixel-art 等）

```
https://api.dicebear.com/7.x/avataaars/svg?seed=John
```

```tsx
const avatarUrl = (name: string, style = 'avataaars') =>
  `https://api.dicebear.com/7.x/${style}/svg?seed=${encodeURIComponent(name)}`
```

---

## 环境变量配置

在项目的 `.env` 文件中：

```bash
# .env
VITE_UNSPLASH_ACCESS_KEY=your_unsplash_access_key
VITE_PEXELS_API_KEY=your_pexels_api_key
VITE_PIXABAY_API_KEY=your_pixabay_api_key
```

`.env.example`（提交到 git）：

```bash
# Image APIs (free — sign up for production use)
VITE_UNSPLASH_ACCESS_KEY=
VITE_PEXELS_API_KEY=
VITE_PIXABAY_API_KEY=
```

---

## 统一封装：StockImage 组件

```tsx
type ImageSource = 'unsplash' | 'pexels' | 'pixabay' | 'picsum'

interface StockImageProps {
  source: ImageSource
  query: string
  width?: number
  height?: number
  alt?: string
  className?: string
}

function StockImage({ source, query, width = 800, height = 600, alt = '', className }: StockImageProps) {
  const [url, setUrl] = useState<string>('')

  useEffect(() => {
    // 开发阶段降级到 picsum
    if (import.meta.env.DEV && source !== 'picsum') {
      setUrl(`https://picsum.photos/${width}/${height}?random=${query.length}`)
      return
    }

    const fetchers: Record<ImageSource, () => Promise<string>> = {
      picsum: async () => `https://picsum.photos/${width}/${height}?random=${query.length}`,
      unsplash: async () => {
        const photos = await fetchUnsplash(query, 1)
        return photos[0]?.urls?.regular ?? ''
      },
      pexels: async () => {
        const photos = await fetchPexels(query, 1)
        return photos[0]?.src?.large ?? ''
      },
      pixabay: async () => {
        const images = await fetchPixabay(query)
        return images[0]?.webformatURL ?? ''
      },
    }

    fetchers[source]().then(setUrl).catch(() => {
      setUrl(`https://picsum.photos/${width}/${height}?random=${query.length}`)
    })
  }, [source, query, width, height])

  if (!url) return <div className={className} style={{ width, height, background: '#e5e7eb' }} />

  return <img src={url} alt={alt} loading="lazy" className={className} />
}
```

---

## 最佳实践

1. **开发用 Picsum** — 零配置，不需要 API key，`import.meta.env.DEV` 条件切换
2. **生产用 Unsplash/Pexels** — 根据场景选（摄影 → Unsplash，多样性 → Pexels，矢量 → Pixabay）
3. **环境变量隔离** — API key 只存在 `.env`，`.env.example` 仅保留空占位
4. **始终设置 fallback** — API 挂了降级到 Picsum 或纯色占位
5. **Unsplash 需要归因** — license 要求链接回 Unsplash 和摄影师
6. **图片尺寸优化** — 使用 API 返回的 `small`/`medium`/`regular` 而非 `raw`，避免加载 10MB 原图
7. **SVG 优先用于插画** — unDraw / Humaaans 等 SVG 插图体积小、可交互、可改色
