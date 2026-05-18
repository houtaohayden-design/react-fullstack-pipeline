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
| 视频素材 / 专业摄影 | **影视飓风素材库** | API，无需 token |
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

## 7. 影视飓风素材库 — 专业视频/摄影/声音素材

影视飓风（Mediastorm）是国内顶级影视制作团队的公开素材平台。提供专业级视频素材、照片、声音、音乐和素材包。

### 两层级访问权限

| 层级 | 可获取内容 | 认证要求 | 适用场景 |
|------|-----------|----------|----------|
| **公开 CDN** | 封面图（原图可调尺寸）、视频预览（mp4 短片段） | 无需 token | 网站配图、卡片缩略图、Hero 背景视频 |
| **完整源文件** | 4K 原始视频（.R3D/.CRM/.MP4）、原始照片 | 需要账号登录 + 免费下单 | 视频编辑、高清素材下载 |

**API Base**: `https://base.ysjf.com/media_storm`
**交易 API**: `https://base.ysjf.com/storm_trade`（需要 Bearer token）
**CDN**: `https://public.ysjf.com/mediastorm/`
**免费额度**: 无限制

### AppId（固定值，从 JS bundle 提取）

```tsx
const APP_ID = 'TWVkaWFTdG9ybS1XRUItamZSbHJuNDBXUEJmMkJmenE'
```

### 素材类型

| 类型 | API type 参数 | 说明 |
|------|-------------|------|
| 视频 | `video` | 专业视频素材（含 mp4 预览），索尼/RED/Canon 等设备拍摄 |
| 照片 | `image` | 专业摄影作品，含相机和镜头参数 |
| 素材包 | `pack` | 打包素材合集 |
| 声音 | `audio` | 音效素材 |
| 音乐 | `music` | 音乐素材 |
| 节目与合集 | — | 按系列/节目的合集 |

### API 端点

**GET 素材列表**
```
GET https://base.ysjf.com/media_storm/material_items
  ?pageNo=1
  &pageSize=20
  &keyword=自然
  &type=image
  &sort=hot
  &tags=动物:近景:SONY
Headers:
  AppId: TWVkaWFTdG9ybS1XRUItamZSbHJuNDBXUEJmMkJmenE
```

**GET 素材详情**
```
GET https://base.ysjf.com/media_storm/materials/{id}
```

**GET 合集详情**
```
GET https://base.ysjf.com/media_storm/collections/{id}
```

### 筛选标签

用于 `tags` 参数，格式 `内容类型:景别:相机品牌`（用 `:` 连接）：

| 标签类型 | 可用值 |
|----------|--------|
| 内容 | 城市人文, 延时, 自然风景, 动物, 人文, 显微摄影, 航拍, 空镜, 极限运动 |
| 景别 | 全景, 远景, 中景, 近景, 特写 |
| 相机品牌 | DJI, SONY, Canon, Apple, FUJIFILM, Ember, NiKon, RED, Panasonic, GoPro, BMD, LEICA |
| 节目(热门标签) | DJIFlip评测, 样片日记-川西, 黑水摄影, 开车去罗马, 等等 |

### 排序

| 参数值 | 说明 |
|--------|------|
| `time` | 最近更新 |
| `hot` | 热度最高 |

### 完整源文件下载流程（需要账号登录）

所有素材在网站上都是免费"购买"的。视频的 `preview` 只是预览短片，要获取 4K 原始文件（.R3D/.CRM/.MP4 等），需要走交易流程：

#### 流程（5 步）

```
1. 浏览素材 → 获取 material 和 sku 信息
2. 加入购物车 → POST /storm_trade/shopping_cart { productId, count }
3. 创建订单   → POST /storm_trade/order { /* cart items */ }
4. 支付(￥0)  → POST /storm_trade/payment/{id}/action/web_pay
5. 获取下载链接 → GET /storm_trade/order/{orderId}  (details 中含下载 URL)
```

#### 前提条件

- 在 [ysjf.com](https://www.ysjf.com) 注册账号（微信/Apple/手机验证码登录）
- 登录后从浏览器获取 Bearer token（localStorage 或 Network 面板）
- Token 有过期时间，过期后需重新登录

#### 购物车 / 订单 API

```
Base: https://base.ysjf.com/storm_trade
Auth: Bearer {token}
AppId: TWVkaWFTdG9ybS1XRUItamZSbHJuNDBXUEJmMkJmenE
```

| 端点 | 方法 | 说明 |
|------|------|------|
| `/shopping_cart` | GET | 获取购物车 |
| `/shopping_cart` | POST | 加入购物车 `{productId, count}` |
| `/shopping_cart/{id}` | DELETE | 移除购物车项 |
| `/order?scope=MediaStorm` | GET | 获取订单列表 |
| `/order` | POST | 创建订单（从购物车结算） |
| `/order/{orderId}` | GET | 获取订单详情（含下载链接） |
| `/order/payment/{paymentId}` | GET | 通过支付 ID 获取订单 |
| `/payment/{id}/action/web_pay` | POST | Web 支付（￥0 订单直接完成） |
| `/product?products=id1,id2` | GET | 批量获取商品详情 |

#### 从素材到 productId

素材详情中每个 SKU 有一个 `product` 字段，如：
```json
{
  "skus": [{
    "id": "s-000272033554669899776",
    "name": "4K",
    "price": 0.0,
    "product": "pd-000272033555155259392",
    "license": "personal_learning"
  }]
}
```

用 `product` 的值作为 `productId` 加入购物车。

#### 实际的公开可用方式（推荐）

对于网站开发场景，**直接用公开 CDN 的预览视频和封面图即可，不需要走交易流程**：

- **视频预览**：`public.ysjf.com/mediastorm/material/material_preview/{filename}.mp4` — 足够做 Hero 背景
- **封面图**：`public.ysjf.com/mediastorm/material/material/{filename}.jpg` — 去掉 resize 参数拿原图

完整的 4K 源文件下载适合视频编辑场景，需要用户手动登录网站操作，不适合程序化集成。

### 图片 URL 处理（OSS 图片处理）

所有封面图使用阿里云 OSS，可通过 URL 参数调整尺寸：

```
# 原图（500px 宽）
https://public.ysjf.com/mediastorm/material/material/example.jpg?x-oss-process=image/resize,w_500

# 改成 1200px 宽
https://public.ysjf.com/mediastorm/material/material/example.jpg?x-oss-process=image/resize,w_1200
```

### React Hook

```tsx
interface YSJFMaterial {
  id: string
  name: string
  type: 'video' | 'image' | 'music' | 'audio'
  cover: string
  preview: { url: string; type: string }[] | null
  tags: { name: string; type: string; priority: number }[]
  downloadCount: number
  createTime: string
}

const YSJF_CONFIG = {
  baseURL: 'https://base.ysjf.com/media_storm',
  appId: 'TWVkaWFTdG9ybS1XRUItamZSbHJuNDBXUEJmMkJmenE',
}

async function fetchYSJFMaterials(params: {
  keyword?: string
  type?: 'video' | 'image' | 'music' | 'audio'
  sort?: 'hot' | 'time'
  tags?: string[]
  pageNo?: number
  pageSize?: number
}) {
  const searchParams = new URLSearchParams()
  searchParams.set('pageNo', String(params.pageNo ?? 1))
  searchParams.set('pageSize', String(params.pageSize ?? 20))
  if (params.keyword) searchParams.set('keyword', params.keyword)
  if (params.type) searchParams.set('type', params.type)
  if (params.sort) searchParams.set('sort', params.sort)
  if (params.tags?.length) searchParams.set('tags', params.tags.join(','))

  const res = await fetch(`${YSJF_CONFIG.baseURL}/material_items?${searchParams}`, {
    headers: { AppId: YSJF_CONFIG.appId },
  })
  if (!res.ok) throw new Error(`YSJF API: ${res.status}`)
  const json = await res.json()
  return json.data as { total: number; entities: YSJFMaterial[] }
}

function useYSJFImages(keyword: string, count = 10) {
  const [images, setImages] = useState<YSJFMaterial[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchYSJFMaterials({ keyword, type: 'image', pageSize: count, sort: 'hot' })
      .then(data => setImages(data.entities))
      .catch(console.error)
      .finally(() => setLoading(false))
  }, [keyword, count])

  return { images, loading }
}
```

### React 组件示例

```tsx
function YSJFImageGrid({ keyword = '自然风景' }: { keyword?: string }) {
  const { images, loading } = useYSJFImages(keyword)

  if (loading) return <div className="skeleton-grid" />

  return (
    <div className="image-grid">
      {images.map(img => {
        // 把封面图从 w_500 升级到 w_1200
        const hdCover = img.cover.replace('w_500', 'w_1200')
        return (
          <figure key={img.id}>
            <img src={hdCover} alt={img.name} loading="lazy" />
            <figcaption>
              <span>{img.name}</span>
              <span className="tags">
                {img.tags.map(t => t.name).join(' · ')}
              </span>
            </figcaption>
          </figure>
        )
      })}
    </div>
  )
}
```

### 归因要求

虽无强制要求，但建议标注来源：

```tsx
<footer className="text-xs text-gray-400">
  素材来源：<a href="https://www.ysjf.com/material">影视飓风素材库</a>
</footer>
```

### 适用场景

- **视频背景** — 专业 4K 视频素材作为网站 Hero 背景
- **摄影作品展示** — 高质量照片直接用作卡片配图
- **自然/旅行主题网站** — 大量延时摄影和自然风光
- **产品演示视频** — 视频预览可直接嵌入
- **创作型网站** — 相比普通 stock photo，画面更有艺术感

---

## 最佳实践

1. **开发用 Picsum** — 零配置，不需要 API key，`import.meta.env.DEV` 条件切换
2. **生产用 Unsplash/Pexels** — 根据场景选（摄影 → Unsplash，多样性 → Pexels，矢量 → Pixabay）
3. **环境变量隔离** — API key 只存在 `.env`，`.env.example` 仅保留空占位
4. **始终设置 fallback** — API 挂了降级到 Picsum 或纯色占位
5. **Unsplash 需要归因** — license 要求链接回 Unsplash 和摄影师
6. **图片尺寸优化** — 使用 API 返回的 `small`/`medium`/`regular` 而非 `raw`，避免加载 10MB 原图
7. **SVG 优先用于插画** — unDraw / Humaaans 等 SVG 插图体积小、可交互、可改色
