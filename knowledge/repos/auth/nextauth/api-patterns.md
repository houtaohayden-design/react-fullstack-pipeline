# NextAuth.js (Auth.js) — API Design Patterns

> Source: [nextauthjs/next-auth](https://github.com/nextauthjs/next-auth)
> Trained: 2026-05-18

## Auth API Architecture

Auth.js exposes a set of REST API endpoints under a configurable `basePath` (default `/api/auth` for Next.js, `/auth` for other frameworks). The API is implemented as a single handler function that routes requests based on the `action` extracted from the URL path.

```
GET/POST /api/auth/[action]/:provider?
                    │
                    ▼
          Auth(request, config)
                    │
                    ▼
          toInternalRequest()
                    │
         ┌─────────┴──────────┐
         ▼                    ▼
    assertConfig          AuthInternal
         │                    │
    (validate config)    ┌────┴────────────────────────────┐
                         │  Route by request.action:        │
                         │  ┌──────────┐ ┌──────────────┐ │
                         │  │ signin   │ │ callback     │ │
                         │  │ signout  │ │ session      │ │
                         │  │ csrf     │ │ providers    │ │
                         │  │ error    │ │ verify-req.  │ │
                         │  │ web-authn│ │              │ │
                         │  └──────────┘ └──────────────┘ │
                         └─────────────────────────────────┘
                                    │
                                    ▼
                            toResponse()
```

## Endpoint Details

### `GET /signin`
Renders the built-in sign-in page listing all configured providers. Each provider gets a "Sign in with {name}" button.

Returns: HTML page (or redirects to custom `pages.signIn` if configured)

### `POST /signin/:provider`
Initiates sign-in flow for a specific provider.

**OAuth/OIDC flow:**
```
Request:  POST /api/auth/signin/github
           Body: { csrfToken, callbackUrl }
Response: 302 Redirect to provider's authorization URL
           Set-Cookie: state, pkce_code_verifier, nonce
```

**Email flow:**
```
Request:  POST /api/auth/signin/resend
           Body: { csrfToken, email, callbackUrl }
Response: 302 Redirect to /verify-request page
           (Email sent with verification token link)
```

**Credentials flow:**
```
For credentials provider, signIn redirects to callback endpoint:
Request:  POST /api/auth/callback/credentials
           Body: { csrfToken, email, password, callbackUrl }
```

### `GET /callback/:provider`
Handles OAuth/OIDC callback after user authorizes at the provider.

```
Request:  GET /api/auth/callback/github?code=...&state=...
Response: 302 Redirect to callbackUrl
           Set-Cookie: session token
```

Processing steps:
1. Validate `state` parameter against cookie
2. Validate PKCE `code_verifier` against cookie
3. Exchange authorization `code` for tokens
4. Validate `nonce` in ID token (OIDC only)
5. Fetch user profile from provider's userinfo endpoint
6. Map profile to User via `profile()` callback
7. Check `signIn()` callback for authorization
8. Create or update user in database (via adapter)
9. Create account link (via adapter)
10. Run `jwt()` callback for JWT session
11. Encode JWT or create DB session
12. Set session cookie
13. Call `events.signIn()`
14. Redirect to `callbackUrl` (or `pages.newUser`)

### `POST /callback/:provider`
Handles Credentials and WebAuthn callbacks.

**Credentials callback:**
```
Request:  POST /api/auth/callback/credentials
           Body: { csrfToken, email, password, callbackUrl }
Response: 302 Redirect to callbackUrl (on success) or signin?error=CredentialsSignin
```

### `GET /signout`
Renders the built-in sign-out page (confirmation).

Returns: HTML page (or redirects to custom `pages.signOut`)

### `POST /signout`
Destroys the current session.

```
Request:  POST /api/auth/signout
           Body: { csrfToken, callbackUrl }
Response: 302 Redirect to callbackUrl
           Set-Cookie: session token cleared (maxAge=0)
```

Processing:
1. Validate CSRF token
2. If JWT strategy: decode JWT, call `events.signOut({ token })`
3. If database strategy: `adapter.deleteSession(sessionToken)`, call `events.signOut({ session })`
4. Clear session cookie(s)
5. Redirect to `callbackUrl`

### `GET /session`
Returns the current session as JSON.

```
Request:  GET /api/auth/session
Response: 200 { user: { name, email, image }, expires: "ISO-date" }
Headers:  Cache-Control: private, no-cache, no-store
           Expires: 0
           Pragma: no-cache
```

If no session:
```
Response: 200 null
```

Processing:
1. Read session token from cookie
2. **JWT**: decode JWT, run `jwt()` callback, run `session()` callback
3. **Database**: `adapter.getSessionAndUser()`, check expiry, throttle update, run `session()` callback
4. Re-encode JWT / extend DB session expiry
5. Update cookie with new expiry
6. Return session JSON

### `POST /session`
Updates the current session (CSRF protected).

```
Request:  POST /api/auth/session
           Body: { csrfToken, data: { ... } }
Response: 200 { user: { ... }, expires: "..." }
```

Processing:
1. Validate CSRF token
2. JWT: decode, call `jwt({ trigger: "update", session: data })`, encode, set cookie
3. Database: call `session({ trigger: "update", newSession: data })`, update DB
4. Return updated session JSON

### `GET /csrf`
Returns the CSRF token for client-side use.

```
Request:  GET /api/auth/csrf
Response: 200 { csrfToken: "random-32-byte-hex-string" }
Set-Cookie: __Host-authjs.csrf-token = "token|hash"
```

The token is also set as a cookie. The hash in the cookie prevents tampering.

### `GET /providers`
Returns a client-safe list of configured providers.

```
Request:  GET /api/auth/providers
Response: 200 {
  "github": { id: "github", name: "GitHub", type: "oauth", signinUrl: "...", callbackUrl: "..." },
  "credentials": { id: "credentials", name: "Credentials", type: "credentials", ... }
}
```

Note: Provider secrets, client IDs, and other sensitive data are NOT exposed.

### `GET /error`
Renders the built-in error page. Passed `?error=` query parameter indicating error type.

### `GET /verify-request`
Renders a page telling the user to check their email for the magic link.

### `GET /webauthn-options`
Returns WebAuthn options for registration or authentication (experimental).

## Protected API Route Patterns

### Next.js App Router (v5)

```ts
// Pattern 1: Wrap route handler with auth()
import { auth } from "@/auth"

export const GET = auth(async (req) => {
  if (!req.auth) {
    return Response.json({ error: "Unauthorized" }, { status: 401 })
  }
  // Access user: req.auth.user
  return Response.json({ data: "protected" })
})

export const POST = auth(async (req) => {
  if (!req.auth) {
    return Response.json({ error: "Unauthorized" }, { status: 401 })
  }
  return Response.json({ success: true })
})
```

```ts
// Pattern 2: Inline auth check in Server Component
import { auth } from "@/auth"
import { redirect } from "next/navigation"

export default async function ProtectedPage() {
  const session = await auth()
  if (!session) redirect("/api/auth/signin")
  return <div>Protected content for {session.user.name}</div>
}
```

```ts
// Pattern 3: Role-based route protection
export const DELETE = auth(async (req) => {
  if (req.auth?.user?.role !== "admin") {
    return Response.json({ error: "Forbidden" }, { status: 403 })
  }
  // Admin-only mutation
  await db.delete(...)
  return Response.json({ success: true })
})
```

### Next.js Pages Router

```ts
// Pattern: getServerSideProps with auth check
import { auth } from "@/auth"

export const getServerSideProps = (async (context) => {
  const session = await auth(context.req, context.res)
  if (!session) {
    return { redirect: { destination: "/api/auth/signin", permanent: false } }
  }
  return { props: { session } }
})

export default function Page({ session }) {
  return <div>Hello {session.user.name}</div>
}
```

### Express Integration

```ts
import { Auth } from "@auth/core"
import { authConfig } from "./auth.config"

// Auth handler
app.all("/api/auth/*", async (req, res) => {
  const request = new Request(
    `${req.protocol}://${req.get("host")}${req.originalUrl}`,
    {
      headers: new Headers(Object.entries(req.headers).map(([k, v]) => [k, Array.isArray(v) ? v[0] : v ?? ""])),
      method: req.method,
      body: ["GET", "HEAD"].includes(req.method) ? undefined : JSON.stringify(req.body),
    }
  )
  const response = await Auth(request, authConfig)

  res.status(response.status)
  response.headers.forEach((value, key) => res.setHeader(key, value))

  const location = response.headers.get("Location")
  if (location) {
    res.redirect(response.status, location)
  } else {
    const body = await response.text()
    res.send(body)
  }
})

// Protected route middleware
async function requireAuth(req, res, next) {
  const sessionToken = req.cookies["authjs.session-token"]
  if (!sessionToken) return res.status(401).json({ error: "Unauthorized" })
  const session = await adapter.getSessionAndUser(sessionToken)
  if (!session || session.session.expires < new Date()) {
    return res.status(401).json({ error: "Session expired" })
  }
  req.user = session.user
  next()
}

app.get("/api/protected", requireAuth, (req, res) => {
  res.json({ user: req.user })
})
```

### Hono Integration

```ts
import { Auth } from "@auth/core"
import { Hono } from "hono"

const app = new Hono()

app.all("/api/auth/*", async (c) => {
  const request = new Request(c.req.url, {
    headers: c.req.raw.headers,
    method: c.req.method,
    body: c.req.method !== "GET" && c.req.method !== "HEAD"
      ? await c.req.raw.clone().text()
      : undefined,
  })
  const response = await Auth(request, authConfig)
  return response
})

// Protected route
app.get("/api/protected", async (c) => {
  const authHeader = c.req.header("Authorization")
  if (!authHeader?.startsWith("Bearer ")) {
    return c.json({ error: "Unauthorized" }, 401)
  }
  const token = await getToken({
    req: { headers: c.req.raw.headers },
    secret: process.env.AUTH_SECRET,
  })
  if (!token) return c.json({ error: "Unauthorized" }, 401)
  return c.json({ data: "protected" })
})
```

## CSRF Endpoint

### Client-Side Usage

```ts
// All state-changing operations require CSRF token
async function protectedAction() {
  // 1. Get CSRF token
  const csrfResponse = await fetch("/api/auth/csrf")
  const { csrfToken } = await csrfResponse.json()

  // 2. Include in POST body
  const response = await fetch("/api/auth/signin/credentials", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-Auth-Return-Redirect": "1",
    },
    body: new URLSearchParams({
      csrfToken,
      email: "user@example.com",
      password: "secret",
    }),
  })

  const { url, error } = await response.json()
  if (error) console.error("Sign in failed:", error)
  else if (url) window.location.href = url
}
```

### `X-Auth-Return-Redirect` Header

When this header is present, Auth.js returns JSON `{ url }` instead of a 302 redirect. This enables client-side redirect handling (useful for SPAs and form actions):

```
Without header:  302 Redirect → browser follows
With header:     200 JSON { url: "/dashboard" } → JS handles redirect
```

## Callback URL Patterns

### Same-Origin Validation (Default)

```ts
// Default redirect callback: only allows same-origin URLs
async redirect({ url, baseUrl }) {
  if (url.startsWith("/")) return `${baseUrl}${url}`
  if (new URL(url).origin === baseUrl) return url
  return baseUrl  // Fallback to home
}
```

### Custom Callback URL Handling

```ts
// Allow specific external domains
callbacks: {
  async redirect({ url, baseUrl }) {
    const allowedDomains = ["example.com", "app.example.com"]
    const urlObj = new URL(url)
    if (allowedDomains.includes(urlObj.hostname)) return url
    if (url.startsWith("/")) return `${baseUrl}${url}`
    return baseUrl
  }
}
```

### Deep Linking After Sign In

```ts
// On sign-in page: encode current page as callbackUrl
import { signIn } from "next-auth/react"

function SignInButton() {
  return (
    <button onClick={() => signIn("github", {
      callbackUrl: window.location.pathname
    })}>
      Sign in with GitHub
    </button>
  )
}
```

## Session Update Patterns

### Client-Side Session Update

```ts
import { useSession } from "next-auth/react"

function SettingsForm() {
  const { data: session, update } = useSession()

  const handleUpdate = async (name: string) => {
    // Update session with new data
    const updatedSession = await update({ name })

    // Session is now updated client-side
    // JWT callback runs with trigger: "update"
    // New JWT encoded, cookie updated
    console.log("Updated session:", updatedSession)
  }
}
```

### Server-Side Session Invalidation

```ts
// Force re-authentication for sensitive operations
export const POST = auth(async (req) => {
  // Require fresh login (< 5 minutes old)
  const sessionAge = Date.now() - new Date(req.auth.expires).getTime()
  if (sessionAge > 5 * 60 * 1000) {
    return Response.json(
      { error: "Re-authentication required" },
      { status: 401 }
    )
  }
  // Process sensitive operation
})
```

## Error Code Patterns

### Error Response Format

```
Redirect URL (client-safe errors):
  /error?error=CredentialsSignin&code=credentials
  /signin?error=OAuthAccountNotLinked
  /signin?error=AccessDenied

JSON Response (X-Auth-Return-Redirect):
  { url: "/error?error=CredentialsSignin&code=credentials" }

API Response (POST /session error):
  null (status 400)
```

### Credentials Error Customization

```ts
import { CredentialsSignin } from "@auth/core/errors"

class InvalidInput extends CredentialsSignin {
  code = "invalid_input"  // Sent as ?code=invalid_input in URL
}

// In authorize():
if (!credentials.email) throw new InvalidInput("Email is required")
if (!credentials.password) throw new InvalidInput("Password is required")
```

### Error Page Customization

```ts
// Custom error page (Next.js App Router)
// app/auth/error/page.tsx
export default function AuthErrorPage({
  searchParams,
}: {
  searchParams: { error?: string }
}) {
  const errorMessages: Record<string, string> = {
    CredentialsSignin: "Invalid email or password.",
    OAuthAccountNotLinked: "This email is already registered with another provider.",
    AccessDenied: "You do not have permission to sign in.",
    Verification: "The sign in link has expired. Please request a new one.",
    default: "An authentication error occurred.",
  }

  return (
    <div>
      <h1>Sign In Error</h1>
      <p>{errorMessages[searchParams.error ?? "default"]}</p>
      <a href="/api/auth/signin">Try again</a>
    </div>
  )
}
```

## Auth Action Routing

The `AuthAction` type defines all supported routes:

```ts
type AuthAction =
  | "callback"       // OAuth callback, credentials callback
  | "csrf"           // CSRF token endpoint
  | "error"          // Error page
  | "providers"      // List configured providers
  | "session"        // Get/update session
  | "signin"         // Sign-in page / initiate sign-in
  | "signout"        // Sign-out page / execute sign-out
  | "verify-request" // Email verification pending page
  | "webauthn-options" // WebAuthn options

// URL pattern: {basePath}/{action}/{providerId?}
// Examples:
//   /api/auth/signin/github
//   /api/auth/callback/google
//   /api/auth/session
//   /api/auth/csrf
```

## Middleware Integration Patterns

### Next.js Middleware (Edge)

```ts
// middleware.ts
import { auth } from "@/auth"
import { NextResponse } from "next/server"

export default auth((req) => {
  const isAuth = !!req.auth
  const isAuthPage = req.nextUrl.pathname.startsWith("/auth")

  // Redirect to sign in if not authenticated
  if (!isAuth && !isAuthPage) {
    return NextResponse.redirect(
      new URL(`/auth/signin?callbackUrl=${req.url}`, req.url)
    )
  }

  // Redirect to dashboard if already authenticated
  if (isAuth && isAuthPage) {
    return NextResponse.redirect(new URL("/dashboard", req.url))
  }
})

// Configure which routes middleware runs on
export const config = {
  matcher: ["/((?!api|_next/static|_next/image|favicon.ico).*)"],
}
```

### Universal Auth Check

```ts
// Reusable auth check function (works with any framework)
import { getToken } from "@auth/core/jwt"

async function getAuthUser(
  request: Request
): Promise<{ userId: string; email: string } | null> {
  const token = await getToken({
    req: request,
    secret: process.env.AUTH_SECRET!,
    secureCookie: process.env.NODE_ENV === "production",
  })
  if (!token?.sub) return null
  return { userId: token.sub, email: token.email as string }
}

// Usage in any API route
export async function GET(request: Request) {
  const user = await getAuthUser(request)
  if (!user) return Response.json({ error: "Unauthorized" }, { status: 401 })
  return Response.json({ userId: user.userId })
}
```

## Provider Configuration Pattern

```ts
// auth.ts — central auth configuration
import NextAuth from "next-auth"
import GitHub from "next-auth/providers/github"
import Google from "next-auth/providers/google"
import Credentials from "next-auth/providers/credentials"
import { PrismaAdapter } from "@auth/prisma-adapter"
import { prisma } from "./prisma"

export const { handlers, auth, signIn, signOut } = NextAuth({
  adapter: PrismaAdapter(prisma),
  session: { strategy: "jwt" },
  providers: [
    GitHub({
      clientId: process.env.GITHUB_CLIENT_ID,
      clientSecret: process.env.GITHUB_CLIENT_SECRET,
    }),
    Google({
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    }),
    Credentials({
      name: "Credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        // Validate against database
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) token.id = user.id
      return token
    },
    async session({ session, token }) {
      session.user.id = token.id as string
      return session
    },
  },
  pages: {
    signIn: "/auth/signin",
    error: "/auth/error",
  },
})
```
