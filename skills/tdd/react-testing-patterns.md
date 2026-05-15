# React Testing Patterns — Quick Reference

## Jest + React Testing Library Setup

```bash
npm install -D vitest @testing-library/react @testing-library/jest-dom @testing-library/user-event jsdom msw
```

## Component Test Template

```tsx
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, it, expect, vi } from 'vitest'

describe('ComponentName', () => {
  // 1. Renders correctly
  it('renders with required props', () => {
    render(<ComponentName requiredProp="value" />)
    expect(screen.getByText(/value/i)).toBeInTheDocument()
  })

  // 2. Handles user interaction
  it('calls onClick when clicked', async () => {
    const onClick = vi.fn()
    render(<ComponentName onClick={onClick} />)
    await userEvent.click(screen.getByRole('button'))
    expect(onClick).toHaveBeenCalled()
  })

  // 3. Loading state
  it('shows loading skeleton when loading', () => {
    render(<ComponentName loading={true} />)
    expect(screen.getByRole('status')).toBeInTheDocument()
  })

  // 4. Empty state
  it('shows empty message when no data', () => {
    render(<ComponentName items={[]} />)
    expect(screen.getByText(/no items/i)).toBeInTheDocument()
  })

  // 5. Error state
  it('shows error message on error', () => {
    render(<ComponentName error={new Error('Failed')} />)
    expect(screen.getByText(/failed/i)).toBeInTheDocument()
  })
})
```

## Hook Test Template

```tsx
import { renderHook, act } from '@testing-library/react'
import { describe, it, expect, vi } from 'vitest'

describe('useHookName', () => {
  it('returns initial state', () => {
    const { result } = renderHook(() => useHookName())
    expect(result.current.value).toBe(initialValue)
  })

  it('updates when action called', () => {
    const { result } = renderHook(() => useHookName())
    act(() => result.current.update(newValue))
    expect(result.current.value).toBe(newValue)
  })
})
```

## Context-Requiring Hook Test

```tsx
import { renderHook } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

const wrapper = ({ children }: { children: React.ReactNode }) => (
  <QueryClientProvider client={new QueryClient()}>
    {children}
  </QueryClientProvider>
)

const { result } = renderHook(() => useTodoList(), { wrapper })
```

## MSW API Mocking

```tsx
import { http, HttpResponse } from 'msw'
import { setupServer } from 'msw/node'

const server = setupServer(
  http.get('/api/users/:id', ({ params }) =>
    HttpResponse.json({ id: params.id, name: 'Test' })
  ),
  http.post('/api/users', async ({ request }) => {
    const body = await request.json()
    return HttpResponse.json({ id: 'new', ...body })
  })
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())
```

## Common Assertions

```tsx
// Element existence
expect(screen.getByText('Hello')).toBeInTheDocument()
expect(screen.queryByText('Not here')).not.toBeInTheDocument()

// Accessibility
expect(screen.getByRole('button')).toHaveAttribute('aria-label', 'Close')
expect(screen.getByRole('textbox')).toHaveAccessibleName('Email')

// Styles
expect(element).toHaveClass('active')
expect(element).toHaveStyle({ display: 'none' })

// Async
expect(await screen.findByText(/loaded/)).toBeInTheDocument()
await waitFor(() => expect(mock).toHaveBeenCalled())
```

## File Naming
- Component tests: `src/components/__tests__/ComponentName.test.tsx`
- Hook tests: `src/hooks/__tests__/useHookName.test.ts`
- Utility tests: `src/utils/__tests__/helper.test.ts`
