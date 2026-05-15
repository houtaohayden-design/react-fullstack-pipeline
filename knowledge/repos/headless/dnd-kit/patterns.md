# dnd kit — Patterns

## 定位

**现代 React 拖拽库。** 可访问性优先，支持键盘、触摸、鼠标。比 react-beautiful-dnd 更新、更维护。

## 高频模式

### 列表排序
最常用场景：卡片列表拖拽排序。

```tsx
<DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
  <SortableContext items={items} strategy={verticalListSortingStrategy}>
    {items.map(item => (
      <SortableItem key={item.id} id={item.id}>
        <Card>{item.name}</Card>
      </SortableItem>
    ))}
  </SortableContext>
</DndContext>
```

### 看板 (Kanban)
多个容器间拖拽：

```tsx
<DndContext onDragEnd={handleDragEnd}>
  {columns.map(col => (
    <Droppable key={col.id} id={col.id}>
      <SortableContext items={col.items} strategy={verticalListSortingStrategy}>
        {col.items.map(item => <SortableItem key={item.id} id={item.id} />)}
      </SortableContext>
    </Droppable>
  ))}
  <DragOverlay>{activeItem ? <ItemCard item={activeItem} /> : null}</DragOverlay>
</DndContext>
```

## 与知识库其他库配合

### + Shineout
Shineout 的卡片/表格行 + dnd-kit 排序：
```tsx
<DndContext onDragEnd={handleReorder}>
  <SortableContext items={tableData}>
    {tableData.map(row => (
      <SortableItem key={row.id} id={row.id}>
        <CardGroup item={row} />
      </SortableItem>
    ))}
  </SortableContext>
</DndContext>
```

### + react-bits
拖拽过程中添加 react-bits 动画：
```tsx
<DragOverlay>
  <ScaleAnimation>{activeItem && <ItemCard item={activeItem} />}</ScaleAnimation>
</DragOverlay>
```

### + zustand
拖拽结果存入全局状态：
```tsx
function handleDragEnd(event) {
  const newOrder = calculateOrder(event)
  useOrderStore.getState().reorder(newOrder)
}
```
