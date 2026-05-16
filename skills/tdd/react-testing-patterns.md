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

---

## Backend API Testing (Hono + Drizzle + SQL.js)

### Test DB Setup (In-Memory SQL.js)

```typescript
// src/__tests__/test-db.ts
import Database from 'better-sqlite3'; // or sql.js
import { drizzle } from 'drizzle-orm/better-sqlite3';
import { schema } from '../db/schema';

export function createTestDb() {
  const sqlite = new Database(':memory:');
  const db = drizzle(sqlite, { schema });
  // Run migrations programmatically (NOT raw SQL that duplicates schema)
  db.run(`CREATE TABLE IF NOT EXISTS users (...)`);
  return db;
}
```

**CRITICAL:** Never duplicate Drizzle schema as raw SQL CREATE TABLE statements in seed/test setup. If you must use raw SQL for table creation, extract it into a shared `migrations.ts` file used by both production and test code.

### Test App Instance

```typescript
// src/__tests__/test-app.ts
import { Hono } from 'hono';
import { createTestDb } from './test-db';
import { registerRoutes } from '../index';

export function createTestApp() {
  const app = new Hono();
  const db = createTestDb();
  // Inject test db into app context
  app.use('*', async (c, next) => {
    c.set('db', db);
    await next();
  });
  registerRoutes(app);
  return app;
}
```

### API Test Template

```typescript
import { describe, it, expect, beforeAll } from 'vitest';
import { createTestApp } from './test-app';

describe('GET /api/resource', () => {
  let app: Hono;

  beforeAll(() => { app = createTestApp(); });

  it('returns 401 without auth token', async () => {
    const res = await app.request('/api/resource');
    expect(res.status).toBe(401);
  });

  it('returns data with valid auth token', async () => {
    const res = await app.request('/api/resource', {
      headers: { Authorization: 'Bearer <test-token>' },
    });
    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body).toHaveProperty('data');
  });

  it('returns 400 on invalid input', async () => {
    const res = await app.request('/api/resource', {
      method: 'POST',
      headers: {
        'Authorization': 'Bearer <test-token>',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ invalid: true }),
    });
    expect(res.status).toBe(400);
  });

  it('isolates data per user', async () => {
    // Create data as user A
    await app.request('/api/resource', {
      method: 'POST',
      headers: { Authorization: 'Bearer <token-a>' },
      body: JSON.stringify({ name: 'A-only' }),
    });
    // User B should not see user A's data
    const res = await app.request('/api/resource', {
      headers: { Authorization: 'Bearer <token-b>' },
    });
    const body = await res.json();
    expect(body.find((item: any) => item.name === 'A-only')).toBeUndefined();
  });
});
```

### Hono Auth Middleware Testing

```typescript
describe('authMiddleware', () => {
  it('rejects expired tokens', async () => {
    const expiredToken = jwt.sign(
      { userId: 1, email: 'test@test.com' },
      JWT_SECRET,
      { expiresIn: '0s' }
    );
    const res = await app.request('/api/protected', {
      headers: { Authorization: `Bearer ${expiredToken}` },
    });
    expect(res.status).toBe(401);
  });

  it('rejects tampered tokens', async () => {
    const res = await app.request('/api/protected', {
      headers: { Authorization: 'Bearer invalid.token.here' },
    });
    expect(res.status).toBe(401);
  });

  it('sets user context for valid tokens', async () => {
    const res = await app.request('/api/auth/me', {
      headers: { Authorization: `Bearer ${validToken}` },
    });
    expect(res.status).toBe(200);
  });
});
```

### Drizzle + SQL.js Gotchas

1. **No `lastInsertRowid`**: `.run()` returns `{ changes: number }` only. After INSERT, query by unique key instead.
2. **Batch queries with `inArray`**: Never fetch related rows in a loop. Use `inArray(column, values)` for batch fetching.
3. **Fresh DB per test suite**: Use `:memory:` SQLite. Do NOT reuse DB instances across test files.

### Test Structure for Backend

```
src/__tests__/
  test-db.ts        # Shared test DB factory
  test-app.ts        # Shared test Hono app factory
  auth.test.ts       # Auth endpoints
  recipes.test.ts    # Recipe CRUD
  meal-plans.test.ts # Meal plan logic
  ...
```

### Common Backend Test Patterns

```typescript
// Seed data helper
function seedUser(db: DrizzleDB) {
  const hash = bcryptjs.hashSync('password123', 10);
  db.insert(schema.users).values({
    email: 'test@example.com',
    passwordHash: hash,
  }).run();
  return db.select().from(schema.users).all()[0];
}

// Auth header helper
function authHeader(userId: number) {
  const token = jwt.sign({ userId, email: 'test@example.com' }, JWT_SECRET);
  return { Authorization: `Bearer ${token}` };
}

// JSON body helper
function jsonBody(data: unknown) {
  return {
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  };
}
```
