---
name: react-pipeline:auth
description: Use when implementing authentication or authorization — JWT/OAuth/session management, RBAC guards, secure cookie handling, OWASP best practices.
---

# Authentication for React Apps

## Core Principle
Never roll your own crypto. Use battle-tested libraries. JWT for SPAs, sessions for traditional apps, OAuth for social login.

## Auth Approach Decision

| Approach | Best For | Complexity |
|----------|----------|------------|
| **JWT (access + refresh)** | SPAs, mobile APIs | Medium |
| **Session-based** | Traditional server-rendered | Low |
| **OAuth 2.0 (Google/GitHub)** | Social login | Low (with library) |
| **NextAuth / Lucia** | Framework-managed | Low-medium |

**Default recommendation for SPAs:** JWT with short-lived access token (15min) + refresh token (7d) stored in httpOnly cookie.

## JWT Implementation (Hono)

```ts
import { sign, verify } from 'hono/jwt'

// Login: generate tokens
app.post('/api/auth/login', async (c) => {
  const { email, password } = await c.req.json()
  const user = await db.select().from(users).where(eq(users.email, email)).get()

  if (!user || !await bcrypt.compare(password, user.passwordHash)) {
    return c.json({ error: 'Invalid credentials' }, 401)
  }

  const accessToken = await sign({ sub: user.id, exp: Math.floor(Date.now()/1000) + 900 }, SECRET)
  const refreshToken = crypto.randomUUID()

  return c.json({ accessToken, refreshToken })
})

// Middleware: protect routes
async function authMiddleware(c: Context, next: Next) {
  const header = c.req.header('Authorization')
  if (!header?.startsWith('Bearer ')) return c.json({ error: 'Unauthorized' }, 401)

  try {
    const payload = await verify(header.slice(7), SECRET)
    c.set('userId', payload.sub)
    await next()
  } catch {
    return c.json({ error: 'Invalid token' }, 401)
  }
}

app.get('/api/me', authMiddleware, (c) => {
  const userId = c.get('userId')
  return c.json({ userId })
})
```

## Frontend Auth Flow

```tsx
// stores/auth.ts (zustand)
import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface AuthState {
  accessToken: string | null
  refreshToken: string | null
  user: User | null
  login: (email: string, password: string) => Promise<void>
  logout: () => void
}

export const useAuth = create<AuthState>()(persist((set) => ({
  accessToken: null,
  refreshToken: null,
  user: null,
  login: async (email, password) => {
    const res = await fetch('/api/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email, password })
    })
    if (!res.ok) throw new Error('Login failed')
    const data = await res.json()
    set({ accessToken: data.accessToken, refreshToken: data.refreshToken })
  },
  logout: () => set({ accessToken: null, refreshToken: null, user: null })
}), { name: 'auth' }))
```

```tsx
// hooks/useApi.ts — auto-attach token
export function useApi() {
  const token = useAuth(s => s.accessToken)
  const logout = useAuth(s => s.logout)

  return async (url, options = {}) => {
    const res = await fetch(url, {
      ...options,
      headers: {
        ...options.headers,
        Authorization: token ? `Bearer ${token}` : ''
      }
    })
    if (res.status === 401) logout()
    return res
  }
}
```

## RBAC (Role-Based Access Control)

```ts
// Middleware: check role
function requireRole(...roles: string[]) {
  return async (c: Context, next: Next) => {
    const userId = c.get('userId')
    const user = await db.select().from(users).where(eq(users.id, userId)).get()
    if (!user || !roles.includes(user.role)) {
      return c.json({ error: 'Forbidden' }, 403)
    }
    await next()
  }
}

app.delete('/api/users/:id', authMiddleware, requireRole('admin'), handler)
```

## Security Checklist
- [ ] Passwords hashed with bcrypt/argon2
- [ ] JWT secrets strong, rotated, stored in env vars
- [ ] Access tokens short-lived (15-60 min)
- [ ] Refresh tokens stored securely (httpOnly cookie, not localStorage)
- [ ] Rate limiting on login endpoints (5 attempts/min)
- [ ] HTTPS only in production
- [ ] CSRF protection if using cookies
- [ ] CORS limited to specific origins
