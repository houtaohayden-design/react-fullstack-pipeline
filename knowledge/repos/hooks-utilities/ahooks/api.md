# ahooks — API Reference

> ahooks v3.9.7 | 阿里/蚂蚁 React Hooks 库 | 85+ hooks

## Setup

```bash
npm install ahooks
```

```tsx
import { useRequest, useBoolean, useDebounceFn } from 'ahooks'
```

## Hook 分类

### State 状态管理
- **useBoolean** — boolean 状态管理 (`{ value, setTrue, setFalse, toggle }`)
- **useToggle** — 两值切换 (`{ state, toggle, set, setLeft, setRight }`)
- **useSet** — Set 类型状态
- **useMap** — Map 类型状态
- **useSetState** — 合并式 setState (类 class 组件)
- **usePrevious** — 保存上一次值
- **useLatest** — 获取最新值的 ref
- **useRafState** — RAF 节流的 setState
- **useSafeState** — 防卸载后 setState 警告
- **useResetState** — 可重置状态
- **useGetState** — 在 callback 中获取最新 state (防闭包)
- **useCounter** — 计数器
- **useHistoryTravel** — 撤销/重做历史

### Effect 副作用
- **useAsyncEffect** — 异步 effect
- **useUpdateEffect** — 跳过 mount 的 useEffect
- **useUpdateLayoutEffect** — 跳过 mount 的 useLayoutEffect
- **useDeepCompareEffect** — 深比较依赖的 useEffect
- **useTrackedEffect** — 追踪变化依赖的 effect

### DOM 交互
- **useClickAway** — 点击外部区域
- **useHover** — 鼠标悬浮
- **useMouse** — 鼠标位置
- **useScroll** — 滚动位置
- **useSize** — 元素尺寸
- **useInViewport** — 是否在视口
- **useFocusWithin** — 焦点在内
- **useEventListener** — 事件监听
- **useKeyPress** — 键盘按键
- **useLongPress** — 长按
- **useDrag** / **useDrop** — 拖拽/放置
- **useDocumentVisibility** — 页面可见性
- **useFullscreen** — 全屏
- **useMutationObserver** — DOM 变化监听
- **useResponsive** — 响应式断点

### Request 请求
- **useRequest** — 核心请求 Hook
  - 自动/手动请求
  - 轮询 (pollingInterval)
  - 防抖/节流
  - 依赖刷新 (refreshDeps)
  - 错误重试 (retryCount, retryInterval)
  - 缓存 (staleTime, cacheTime)
  - 并行请求
  - Loading Delay

```tsx
const { data, loading, error, run, refresh, cancel } = useRequest(fetchUser, {
  manual: true,
  pollingInterval: 5000,
  retryCount: 3
})
```

### 性能优化
- **useDebounce** — 防抖值
- **useDebounceFn** — 防抖函数
- **useDebounceEffect** — 防抖 Effect
- **useThrottle** — 节流值
- **useThrottleFn** — 节流函数
- **useThrottleEffect** — 节流 Effect
- **useMemoizedFn** — 持久化函数引用（替代 useCallback）

### 定时器
- **useInterval** — setInterval 封装
- **useTimeout** — setTimeout 封装
- **useRafInterval** — RAF setInterval
- **useRafTimeout** — RAF setTimeout
- **useCountDown** — 倒计时

### 存储
- **useLocalStorageState** — localStorage 状态
- **useSessionStorageState** — sessionStorage 状态
- **useCookieState** — Cookie 状态

### 场景
- **useVirtualList** — 虚拟列表
- **useInfiniteScroll** — 无限滚动
- **usePagination** — 分页
- **useDynamicList** — 动态列表 (增删改)
- **useAntdTable** — Ant Design 表格集成
- **useFusionTable** — Fusion 表格集成
- **useSelections** — 多选
- **useWebSocket** — WebSocket 连接
- **useNetwork** — 网络状态
- **useTitle** — 页面标题
- **useFavicon** — 页面图标
- **useExternal** — 动态加载外部资源
- **useTheme** — 主题模式 (dark/light)
- **useControllableValue** — 受控/非受控兼容
- **useEventEmitter** — 事件总线
- **useEventTarget** — 事件目标 value 提取
- **useLockFn** — 异步函数加锁 (防重复提交)
- **useWhyDidYouUpdate** — 调试组件重渲染
- **useTextSelection** — 文本选中
- **useCreation** — 惰性创建 (替代 useRef 初始化)
