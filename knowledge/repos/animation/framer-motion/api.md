# framer-motion — API Reference

> framer-motion v11+ | React 动画库 | React >= 18

## Setup

```bash
npm install framer-motion
```

## Core API

### motion 组件

```tsx
import { motion } from 'framer-motion'

// HTML 元素
<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.3, ease: 'easeOut' }}
>
  Hello
</motion.div>

// 简写 (m.div = motion.div)
import { m } from 'framer-motion'
<m.div animate={{ scale: 1.1 }} />
```

### AnimatePresence (退出动画)

```tsx
import { AnimatePresence } from 'framer-motion'

<AnimatePresence mode="wait">
  {isVisible && (
    <motion.div
      key="modal"
      initial={{ opacity: 0, scale: 0.9 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 0.9 }}
      transition={{ duration: 0.2 }}
    >
      <Modal />
    </motion.div>
  )}
</AnimatePresence>

// mode: 'sync' | 'wait' | 'popLayout'
```

### Variants (动画编排)

```tsx
const variants = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0 },
  exit: { opacity: 0, y: -20 }
}

<motion.div
  variants={variants}
  initial="hidden"
  animate="visible"
  exit="exit"
/>
```

### 手势动画

```tsx
<motion.button
  whileHover={{ scale: 1.05 }}
  whileTap={{ scale: 0.95 }}
  whileFocus={{ boxShadow: '0 0 0 3px #3b82f6' }}
  transition={{ type: 'spring', stiffness: 400, damping: 17 }}
>
  Click me
</motion.button>
```

### 拖拽

```tsx
<motion.div
  drag="x"
  dragConstraints={{ left: -100, right: 100 }}
  dragElastic={0.2}
  dragSnapToOrigin
  onDragEnd={(_, info) => console.log(info.offset.x)}
/>
```

### Layout 动画

```tsx
// 自动 FLIP 动画
<motion.div layout>
  <h2>{item.title}</h2>
  {expanded && <p>{item.description}</p>}
</motion.div>

// 共享 layout 动画
{isMenuOpen && <motion.nav layoutId="menu">Menu</motion.nav>}
{!isMenuOpen && <motion.button layoutId="menu">Open</motion.button>}
```

### Scroll-linked 动画

```tsx
import { useScroll, useTransform, motion } from 'framer-motion'

function ScrollProgress() {
  const { scrollYProgress } = useScroll()
  const scaleX = useTransform(scrollYProgress, [0, 1], [0, 1])

  return <motion.div style={{ scaleX, transformOrigin: '0 0' }} />
}

// useScroll 返回值
const { scrollX, scrollY, scrollXProgress, scrollYProgress } = useScroll({
  container: containerRef, // 默认 window
  axis: 'y'
})
```

### useMotionValue / useSpring

```tsx
const x = useMotionValue(0)
const scale = useTransform(x, [-100, 100], [0.8, 1.2])
const springX = useSpring(x, { stiffness: 300, damping: 30 })

// 跟踪 motionValue 变化
useMotionValueEvent(x, 'change', (latest) => console.log(latest))
```

### useAnimate (命令式动画)

```tsx
const [scope, animate] = useAnimate()

useEffect(() => {
  const enter = async () => {
    await animate('li', { opacity: 1, x: 0 }, { delay: stagger(0.1) })
  }
  enter()
}, [])

return <ul ref={scope}>{items.map(i => <li key={i.id}>{i.name}</li>)}</ul>
```

### Reorder (拖拽排序)

```tsx
import { Reorder } from 'framer-motion'

<Reorder.Group axis="y" values={items} onReorder={setItems}>
  {items.map(item => (
    <Reorder.Item key={item.id} value={item}>
      {item.name}
    </Reorder.Item>
  ))}
</Reorder.Group>
```

## 关键 Hooks

| Hook | 用途 |
|------|------|
| `useAnimate()` | 命令式动画 `[scope, animate]` |
| `useAnimationControls()` | 外部动画控制 |
| `useScroll()` | 滚动进度 MotionValues |
| `useTransform()` | 值映射变换 |
| `useMotionValue()` | 创建 MotionValue |
| `useSpring()` | 弹簧物理 MotionValue |
| `useInView()` | 元素是否在视口 |
| `useDragControls()` | 外部拖拽控制 |
| `useCycle()` | 值循环切换 |
| `useTime()` | 时间 MotionValue |
| `useVelocity()` | 速度追踪 |

## Transition 配置

```tsx
// 弹簧动画
<motion.div transition={{ type: 'spring', stiffness: 300, damping: 30, mass: 1 }} />

// 贝塞尔
<motion.div transition={{ duration: 0.3, ease: [0.4, 0, 0.2, 1] }} />

// 延迟 + 交错
<motion.div transition={{ delay: 0.2, staggerChildren: 0.05 }} />

// 重复
<motion.div transition={{ repeat: Infinity, repeatType: 'reverse', duration: 2 }} />
```

## Feature Bundle (按需加载)

```tsx
import { domAnimation } from 'framer-motion'

// domMin: 仅动画
// domAnimation: 动画 + hover/tap/focus/inView
// domMax (默认): 动画 + 手势 + drag + layout
```

## 关键特性

- 声明式 API (initial/animate/exit)
- Variants 编排
- Gesture 动画 (hover/tap/focus)
- Layout 动画 (FLIP)
- Spring 物理动画
- 拖拽支持
- Scroll-linked 动画
- GPU 加速 (transform/opacity)
- SSR 兼容
- ~30KB gzip
