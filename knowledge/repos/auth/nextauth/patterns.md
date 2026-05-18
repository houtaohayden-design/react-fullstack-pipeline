# NextAuth.js (Auth.js) — Auth Architecture Patterns

> Source: [nextauthjs/next-auth](https://github.com/nextauthjs/next-auth)
> Trained: 2026-05-18

## Architecture Overview

Auth.js is a **unified authentication layer** that sits between your application and identity providers. It handles the complex OAuth/OIDC flows, session management, CSRF protection, and user persistence through a pluggable adapter system.

```
┌─────────────────────────────────────────────────┐
│                   Your App                       │
│  ┌──────────┐  ┌──────────┐  ┌───────────────┐ │
│  │  Server  │  │  Client  │  │  API Routes   │ │
│  │ auth()   │  │useSession│  │  middleware    │ │
│  └────┬─────┘  └────┬─────┘  └───────┬───────┘ │
└───────┼──────────────┼────────────────┼─────────┘
        │              │                │
┌───────┴──────────────┴────────────────┴─────────┐
│                 @auth/core                       │
│  ┌──────────────────────────────────────────┐   │
│  │  Auth() handler (Request → Response)      │   │
│  │  ┌────────┐ ┌──────────┐ ┌────────────┐  │   │
│  │  │Sign In │ │ Callback │ │  Session   │  │   │
│  │  │ Flow   │ │ Handler  │ │ Management │  │   │
│  │  └────────┘ └──────────┘ └────────────┘  │   │
│  │  ┌────────┐ ┌──────────┐ ┌────────────┐  │   │
│  │  │ CSRF   │ │   JWT    │ │  Cookies   │  │   │
│  │  │Protect.│ │Encoder   │ │  Manager   │  │   │
│  │  └────────┘ └──────────┘ └────────────┘  │   │
│  └──────────────────────────────────────────┘   │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │ Providers│  │ Adapters │  │ Callbacks    │  │
│  │ (95+)    │  │ (23)    │  │ (signIn, jwt,│  │
│  │          │  │         │  │ session,     │  │
│  │          │  │         │  │ redirect)    │  │
│  └──────────┘  └──────────┘  └──────────────┘  │
└─────────────────────────────────────────────────┘
```

## Pattern 1: Middleware Protection

### Next.js App Router (v5)

Route protection via wrapping route handlers:
```ts
// app/api/protected/route.ts
import { auth } from "@/auth"

export const GET = auth(async (req) => {
  if (!req.auth) return Response.json({ error: "Unauthorized" }, { status: 401 })
  // req.auth.user is available
  return Response.json({ data: "Protected" })
})

export const POST = auth(async (req) => {
  // Authenticated handler
})
```

### Server Component Protection

```ts
// app/dashboard/page.tsx
import { auth } from "@/auth"
import { redirect } from "next/navigation"

export default async function DashboardPage() {
  const session = await auth()
  if (!session) redirect("/api/auth/signin")
  return <Dashboard user={session.user} />
}
```

### Express Middleware (Framework-agnostic)

```ts
import { Auth } from "@auth/core"
import { authConfig } from "./auth.config"

// Wrap Express middleware for Auth.js
app.all("/api/auth/*", async (req, res) => {
  const request = new Request(`${req.protocol}://${req.get("host")}${req.url}`, {
    headers: req.headers,
    method: req.method,
    body: req.method !== "GET" && req.method !== "HEAD" ? JSON.stringify(req.body) : undefined,
  })
  const response = await Auth(request, authConfig)
  // Pipe response back
  res.status(response.status)
  response.headers.forEach((v, k) => res.setHeader(k, v))
  const body = await response.text()
  res.send(body)
})

// Protected route middleware
async function requireAuth(req, res, next) {
  const sessionToken = req.cookies["authjs.session-token"]
  if (!sessionToken) return res.status(401).json({ error: "Unauthorized" })
  // Decode JWT or query DB via adapter
  next()
}
```

## Pattern 2: Role-Based Access Control (RBAC)

```ts
// 1. Store role in JWT callback
callbacks: {
  async jwt({ token, user }) {
    if (user) {
      token.role = user.role  // "admin" | "user" | "moderator"
      token.permissions = user.permissions
    }
    return token
  },
  // 2. Expose to client in session callback
  async session({ session, token }) {
    session.user.role = token.role
    session.user.permissions = token.permissions
    return session
  }
}

// 3. Server-side role check
export const GET = auth(async (req) => {
  if (req.auth?.user?.role !== "admin") {
    return Response.json({ error: "Forbidden" }, { status: 403 })
  }
  // Admin-only logic
})

// 4. Client-side role guard
function AdminPanel() {
  const { data: session } = useSession({ required: true })
  if (session?.user?.role !== "admin") return <AccessDenied />
  return <Dashboard />
}
```

## Pattern 3: Credential Auth with bcrypt

```ts
import Credentials from "@auth/core/providers/credentials"
import bcrypt from "bcrypt"

// Registration
async function registerUser(email: string, password: string) {
  const hashedPassword = await bcrypt.hash(password, 12)  // 12 salt rounds
  const user = await db.user.create({
    data: { email, hashedPassword }
  })
  return user
}

// Auth config
Credentials({
  async authorize(credentials) {
    const user = await db.user.findUnique({
      where: { email: credentials.email as string }
    })
    if (!user) return null  // Don't reveal if email exists

    const isValid = await bcrypt.compare(
      credentials.password as string,
      user.hashedPassword
    )
    if (!isValid) return null  // Don't reveal which field was wrong

    return {
      id: user.id,
      email: user.email,
      name: user.name,
      image: user.image,
    }
  }
})

// Custom error codes
import { CredentialsSignin } from "@auth/core/errors"

class InvalidCredentials extends CredentialsSignin {
  code = "invalid_credentials"  // Shown in URL query param
}
```

## Pattern 4: OAuth Login Flow

```
1. User clicks "Sign in with GitHub"
2. POST /api/auth/signin/github  (with CSRF token)
3. Server generates state + PKCE code_verifier, sets cookies
4. Redirect to GitHub authorization URL:
   GET https://github.com/login/oauth/authorize?
     client_id=...
     &redirect_uri=https://app.com/api/auth/callback/github
     &state=<encrypted>
     &code_challenge=<SHA256(code_verifier)>
     &scope=user:email
5. User authorizes on GitHub
6. GitHub redirects to /api/auth/callback/github?code=...&state=...
7. Server validates state cookie, exchanges code for tokens
8. Server fetches user profile from GitHub API
9. Server calls profile() callback to normalize user data
10. Server creates/links user via adapter (or JWT)
11. Server calls signIn, jwt, session callbacks
12. Server sets session cookie, redirects to callbackUrl
```

### Security Checks in OAuth Flow

| Check | Purpose | Cookie MaxAge |
|-------|---------|---------------|
| `state` | Prevent CSRF in OAuth redirect | 15 min |
| `pkce` (code_verifier) | Prevent authorization code interception | 15 min |
| `nonce` | Prevent replay attacks (OIDC) | Session duration |

All check values are stored in `httpOnly` cookies and validated on callback.

## Pattern 5: Email Magic Link

```ts
import Resend from "@auth/core/providers/resend"

Resend({
  from: "auth@app.com",
  // Server sends email with verification token
})

// Flow:
// 1. User enters email → POST /api/auth/signin/resend
// 2. Server creates VerificationToken in DB (hashed with secret)
// 3. Server sends email with link: /api/auth/callback/resend?token=<raw>&email=<email>
// 4. User clicks link → GET /api/auth/callback/resend
// 5. Server hashes token, looks up in DB
// 6. If match & not expired → create session, delete token
```

Custom send verification request:
```ts
Email({
  server: process.env.EMAIL_SERVER,
  from: "auth@app.com",
  async sendVerificationRequest({ identifier, url, provider }) {
    await transporter.sendMail({
      to: identifier,
      subject: "Sign in to App",
      html: `<a href="${url}">Click here to sign in</a>`
    })
  }
})
```

## Pattern 6: Multi-Tenant Auth

```ts
// 1. Store tenant in JWT
callbacks: {
  async jwt({ token, user, profile }) {
    if (user) {
      // Lookup tenant from user's organization
      const membership = await db.membership.findFirst({
        where: { userId: user.id },
        include: { tenant: true }
      })
      token.tenantId = membership?.tenantId
      token.tenant = membership?.tenant
    }
    return token
  },
  async session({ session, token }) {
    session.tenantId = token.tenantId
    session.tenant = token.tenant
    return session
  }
}

// 2. Multi-tenant middleware
export const GET = auth(async (req) => {
  const tenantId = req.auth?.user?.tenantId
  const data = await db.data.findMany({ where: { tenantId } })
  return Response.json({ data })
})

// 3. Tenant-aware sign-in
async signIn({ user, account, profile }) {
  const domain = user.email?.split("@")[1]
  const tenant = await db.tenant.findUnique({ where: { domain } })
  if (!tenant) return false  // Block unknown domains
  return true
}
```

## Pattern 7: Session Management

### JWT Session Lifecycle

```
Create:  On sign-in → encode(JWT) → set cookie
Read:    Every request → decode cookie → callbacks.jwt → callbacks.session
Update:  useSession().update(data) → POST /session → callbacks.jwt(trigger: "update")
Refresh: Every session access → re-encode with new expiry → update cookie
Expire:  jwt.setExpirationTime(now + maxAge) → cookie expires → forced re-auth
Delete:  POST /signout → clear cookie → events.signOut
```

### Database Session Lifecycle

```
Create:  On sign-in → adapter.createSession → set sessionToken cookie
Read:    Every request → adapter.getSessionAndUser(sessionToken) → callbacks.session
Update:  Throttled (updateAge) → adapter.updateSession → new expiry
Expire:  Check expires < Date.now() → adapter.deleteSession → clear cookie
Delete:  POST /signout → adapter.deleteSession → clear cookie → events.signOut
```

### Multi-window Synchronization

NextAuth uses `BroadcastChannel API` for cross-tab session sync:
- Sign in/out in one tab broadcasts event
- All other tabs receive `message` event and refresh session
- `visibilitychange` event triggers re-fetch when tab regains focus
- `refetchInterval` polls session periodically (optional)
- `refetchOnWindowFocus` fetches on tab focus (default: true)

### Session Cookie Chunking

For large JWTs (>4096 bytes):
- Chunked into multiple cookies: `session-token.0`, `session-token.1`, etc.
- Reassembled in order on read
- Cleaned up when session changes

## Pattern 8: Account Linking

```ts
// Built-in: OAuth accounts auto-link when user signs in with same provider
// Manual linking (e.g., link GitHub to existing email account):
// 1. User must be signed in first
// 2. Then initiate OAuth with the additional provider
// 3. Auth.js links the OAuth account to the existing user

// Dangerous auto-linking (use with caution):
GitHub({
  allowDangerousEmailAccountLinking: true,
  // If email from GitHub matches existing user, auto-link accounts
})

// Manual account linking in API route:
async function linkAccount(userId: string, provider: string, providerAccountId: string) {
  await adapter.linkAccount({
    userId,
    type: "oauth",
    provider,
    providerAccountId,
  })
}
```

## Pattern 9: Token Rotation & Refresh

```ts
callbacks: {
  async jwt({ token, account }) {
    // On sign in, persist tokens
    if (account) {
      token.accessToken = account.access_token
      token.refreshToken = account.refresh_token
      token.expiresAt = account.expires_at
    }

    // Check if token is still valid
    if (token.expiresAt && Date.now() / 1000 < token.expiresAt) {
      return token
    }

    // Token expired, refresh it
    try {
      const response = await fetch("https://oauth.provider.com/token", {
        method: "POST",
        body: new URLSearchParams({
          client_id: process.env.PROVIDER_CLIENT_ID,
          client_secret: process.env.PROVIDER_CLIENT_SECRET,
          grant_type: "refresh_token",
          refresh_token: token.refreshToken,
        }),
      })
      const tokens = await response.json()
      return {
        ...token,
        accessToken: tokens.access_token,
        refreshToken: tokens.refresh_token ?? token.refreshToken,
        expiresAt: Math.floor(Date.now() / 1000) + tokens.expires_in,
      }
    } catch (error) {
      return { ...token, error: "RefreshTokenError" }
    }
  },
  async session({ session, token }) {
    session.accessToken = token.accessToken
    session.error = token.error
    return session
  }
}
```

## Pattern 10: Passkeys / WebAuthn (Experimental)

```ts
// Enable in config:
experimental: { enableWebAuthn: true }

// Provider:
import WebAuthn from "@auth/core/providers/webauthn"

WebAuthn({
  // Relaying party config
  // Requires adapter with authenticator methods
})
```

WebAuthn supports two operations:
- **Register**: Create new passkey credential
- **Authenticate**: Sign in with existing passkey (including Conditional UI for autofill)

## Security Patterns Summary

| Pattern | Implementation |
|---------|---------------|
| CSRF Protection | Double-submit cookie with SHA-256 hash |
| OAuth State | Encrypted state cookie, validated on callback |
| PKCE | `code_challenge` + `code_verifier` cookies |
| OIDC Nonce | Nonce cookie validated against id_token |
| Session JWT | Encrypted JWE (`A256CBC-HS512`), key from HKDF |
| Cookie Security | `httpOnly`, `secure`, `sameSite: lax`, `__Secure-`/`__Host-` prefix |
| Secret Rotation | Array of secrets, newest first for encode, iterate for decode |
| Error Sanitization | Only client-safe errors exposed in URLs; server errors masked |
| Callback URL Validation | Only same-origin URLs allowed by default |
