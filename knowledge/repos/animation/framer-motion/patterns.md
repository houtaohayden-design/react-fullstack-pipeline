# framer-motion — Patterns

## 定位

**React 动画的事实标准。** 声明式 API，物理弹簧引擎，完整手势支持。比 react-bits 更强大，但 bundle 也更大 (~30KB vs ~5KB)。

## 与 react-bits 的分工

| 场景 | framer-motion | react-bits |
|------|--------------|------------|
| 复杂自定义动画 | 优先 | 受限 |
| 页面过渡 | 优先 (AnimatePresence) | 可用 |
| 手势动画 | 优先 | 不支持 |
| 文本特效 / 背景特效 | 不支持 | 优先 |
| 快速 UI 微交互 | 重 | 优先 (轻量) |
| Scroll-linked | 优先 (useScroll) | 部分支持 |

**推荐：两者混用，framer-motion 做页面级/Panel 级，react-bits 做文字特效/背景装饰。**

## 高频模式

### 列表动画 (stagger)

```tsx
const container = {
  hidden: { opacity: 0 },
  visible: { opacity: 1, transition: { staggerChildren: 0.05 } }
}

<motion.ul variants={container} initial="hidden" animate="visible">
  {items.map(item => (
    <motion.li key={item.id} variants={{ hidden: { opacity: 0, y: 20 }, visible: { opacity: 1, y: 0 } }}>
      {item.name}
    </motion.li>
  ))}
</motion.ul>
```

### 页面切换

```tsx
// 配合 React Router
const location = useLocation()
<AnimatePresence mode="wait">
  <Routes location={location} key={location.pathname}>
    <Route path="/" element={<motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} />} />
  </Routes>
</AnimatePresence>
```

### 抽屉/面板滑入

```tsx
<motion.aside
  initial={{ x: '100%' }}
  animate={{ x: isOpen ? 0 : '100%' }}
  transition={{ type: 'spring', damping: 30, stiffness: 300 }}
>
  <Sidebar />
</motion.aside>
```

### 渐变计数/数值

```tsx
import { useMotionValue, useTransform, animate } from 'framer-motion'

const count = useMotionValue(0)
const rounded = useTransform(count, v => Math.round(v))

useEffect(() => {
  const controls = animate(count, 100, { duration: 2 })
  return controls.stop
}, [])
```

## 与知识库其他库配合

### + react-bits
framer-motion 页面级 + react-bits 组件级：
```tsx
<motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
  <Squares />        // react-bits 背景
  <FadeContent>      // react-bits 淡入
    <h1>Welcome</h1>
  </FadeContent>
</motion.div>
```

### + Shineout
Shineout Modal 用 framer-motion 做弹出动画：
```tsx
// 将 Shineout Modal content 包裹在 motion.div 中
<AnimatePresence>
  {showModal && (
    <motion.div initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} exit={{ scale: 0.9, opacity: 0 }}>
      <Modal visible={showModal}>{content}</Modal>
    </motion.div>
  )}
</AnimatePresence>
```
