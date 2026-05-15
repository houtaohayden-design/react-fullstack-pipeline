---
name: react-pipeline:tdd
description: Use when implementing any React feature or bugfix, before writing implementation code. Test-first cycle with Jest + React Testing Library.
---

# Test-Driven Development for React

## Core Principle
Write the test FIRST, watch it FAIL, then write MINIMAL code to pass it. Never write implementation before test.

## When to Use
- Implementing any React component, hook, or utility
- Fixing a bug (write regression test first)
- Adding a feature to existing component

## RED-GREEN-REFACTOR Cycle

### RED: Write Failing Test
```tsx
// src/components/__tests__/TodoList.test.tsx
import { render, screen, fireEvent } from '@testing-library/react'
import { TodoList } from '../TodoList'

describe('TodoList', () => {
  it('renders todo items from props', () => {
    const todos = [{ id: '1', text: 'Buy milk', done: false }]
    render(<TodoList todos={todos} onToggle={vi.fn()} />)
    expect(screen.getByText('Buy milk')).toBeInTheDocument()
  })
})
```

### GREEN: Minimal Implementation
```tsx
// src/components/TodoList.tsx
interface TodoListProps {
  todos: { id: string; text: string; done: boolean }[]
  onToggle: (id: string) => void
}

export function TodoList({ todos, onToggle }: TodoListProps) {
  return (
    <ul>
      {todos.map(todo => (
        <li key={todo.id} onClick={() => onToggle(todo.id)}>
          {todo.text}
        </li>
      ))}
    </ul>
  )
}
```

### REFACTOR
Only after GREEN — extract helpers, optimize, improve readability. Tests must stay green.

## React Testing Patterns

### Component Testing
```tsx
// User interaction
fireEvent.click(screen.getByRole('button', { name: /submit/i }))
await waitFor(() => expect(onSubmit).toHaveBeenCalledWith(data))

// Async rendering
await screen.findByText(/loaded/i)

// Accessibility queries (preferred)
screen.getByRole('button')
screen.getByLabelText('Email')
```

### Hook Testing
```tsx
import { renderHook, act } from '@testing-library/react'
import { useCounter } from '../useCounter'

test('increments counter', () => {
  const { result } = renderHook(() => useCounter())
  act(() => result.current.increment())
  expect(result.current.count).toBe(1)
})
```

### API Mocking (MSW)
```tsx
import { http, HttpResponse } from 'msw'
import { setupServer } from 'msw/node'

const server = setupServer(
  http.get('/api/todos', () => HttpResponse.json([{ id: 1, text: 'test' }]))
)
```

## No Exceptions
- Don't write code first as "reference"
- Don't keep untested code
- Tests passing immediately = suspicious (test may not exercise code)
- Write test → watch it fail → write minimal code → all green

See `react-testing-patterns.md` for comprehensive patterns.
