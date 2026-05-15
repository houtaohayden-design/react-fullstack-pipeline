# dnd kit — API Reference

> @dnd-kit/core v6.3.1 | React 拖拽库 | React >= 16.8

## Setup

```bash
npm install @dnd-kit/core @dnd-kit/sortable @dnd-kit/utilities
```

## Core API

### 基础拖拽

```tsx
import { DndContext, useDraggable, useDroppable } from '@dnd-kit/core'

function App() {
  return (
    <DndContext onDragEnd={handleDragEnd}>
      <Draggable id="item-1">Drag me</Draggable>
      <Droppable id="zone-1">Drop here</Droppable>
    </DndContext>
  )
}
```

### Draggable (可拖拽)

```tsx
function Draggable({ id, children }) {
  const { attributes, listeners, setNodeRef, transform, isDragging } = useDraggable({ id })

  const style = transform ? {
    transform: `translate3d(${transform.x}px, ${transform.y}px, 0)`
  } : undefined

  return (
    <div ref={setNodeRef} style={style} {...listeners} {...attributes}>
      {children}
    </div>
  )
}
```

### Droppable (可放置)

```tsx
function Droppable({ id, children }) {
  const { setNodeRef, isOver } = useDroppable({ id })

  return (
    <div ref={setNodeRef} style={{ background: isOver ? '#e0f0ff' : undefined }}>
      {children}
    </div>
  )
}
```

### 排序 (Sortable)

```tsx
import { SortableContext, useSortable, verticalListSortingStrategy } from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'

// 排序列表
<DndContext onDragEnd={handleDragEnd}>
  <SortableContext items={items} strategy={verticalListSortingStrategy}>
    {items.map(item => <SortableItem key={item.id} id={item.id}>{item.name}</SortableItem>)}
  </SortableContext>
</DndContext>

// 可排序项
function SortableItem({ id, children }) {
  const { attributes, listeners, setNodeRef, transform, transition } = useSortable({ id })

  return (
    <div
      ref={setNodeRef}
      style={{ transform: CSS.Transform.toString(transform), transition }}
      {...attributes}
      {...listeners}
    >
      {children}
    </div>
  )
}
```

### handleDragEnd

```tsx
import { arrayMove } from '@dnd-kit/sortable'

function handleDragEnd(event) {
  const { active, over } = event
  if (!over || active.id === over.id) return

  setItems((items) => {
    const oldIndex = items.findIndex(i => i.id === active.id)
    const newIndex = items.findIndex(i => i.id === over.id)
    return arrayMove(items, oldIndex, newIndex)
  })
}
```

### 传感器 (Sensors)

```tsx
import { PointerSensor, KeyboardSensor, TouchSensor, useSensor, useSensors } from '@dnd-kit/core'

const sensors = useSensors(
  useSensor(PointerSensor, { activationConstraint: { distance: 8 } }),
  useSensor(KeyboardSensor),
  useSensor(TouchSensor)
)

<DndContext sensors={sensors} onDragEnd={handleDragEnd}>
```

### 拖拽覆盖 (DragOverlay)

```tsx
import { DragOverlay } from '@dnd-kit/core'

<DndContext onDragStart={handleDragStart} onDragEnd={handleDragEnd}>
  {/* ... */}
  <DragOverlay>
    {activeId ? <Item id={activeId} /> : null}
  </DragOverlay>
</DndContext>
```

## 包结构

| 包 | 用途 |
|------|------|
| `@dnd-kit/core` | 核心引擎、DndContext、useDraggable、useDroppable |
| `@dnd-kit/sortable` | 排序功能、SortableContext、useSortable |
| `@dnd-kit/utilities` | CSS 变换工具、arrayMove 等 |
| `@dnd-kit/accessibility` | 无障碍 |
| `@dnd-kit/modifiers` | 拖拽约束（限制方向、范围） |

## 关键特性

- 可访问性 (键盘操作)
- 触摸支持
- 多种排序策略 (垂直/水平/网格)
- 碰撞检测算法
- 拖拽覆盖层
- 可组合传感器
- 轻量 (~10KB gzip)
