# NextAuth.js (Auth.js) — Backend Architecture Patterns

> Source: [nextauthjs/next-auth](https://github.com/nextauthjs/next-auth)
> Trained: 2026-05-18

## JWT vs Database Session Tradeoffs

### JWT Strategy (Default)

**Architecture:** Session data lives in an encrypted JWT stored in the client cookie. No server-side session store needed.

**JWT Construction:**
```
Encoded JWT = EncryptJWT(payload)
  .setProtectedHeader({ alg: "dir", enc: "A256CBC-HS512", kid: thumbprint })
  .setIssuedAt()
  .setExpirationTime(now() + maxAge)
  .setJti(crypto.randomUUID())
  .encrypt(encryptionKey)
```

**Encryption Key Derivation:**
```
encryptionKey = HKDF(
  hash: "sha256",
  keyMaterial: secret,
  salt: cookieName,
  info: "Auth.js Generated Encryption Key (${salt})",
  length: 64 bytes (for A256CBC-HS512)
)
```

**Advantages:**
- Zero database overhead for sessions
- Stateless — no session store to maintain
- Naturally distributed (works across multiple server instances)
- Can store arbitrary claims without schema changes
- JWT claims available server-side without DB lookup

**Disadvantages:**
- Cannot invalidate sessions server-side (must wait for expiry)
- Session size limited by cookie limit (~4KB per cookie, chunked for larger)
- JWT grows with claims over time
- Refresh token rotation requires custom implementation

### Database Strategy

**Architecture:** Session token (random string) stored in cookie. Session data lives in database. Each request queries the DB.

**Session Lookup:**
```
1. Read sessionToken from cookie
2. adapter.getSessionAndUser(sessionToken)
3. If session.expires < Date.now(): deleteSession + return null
4. If sessionIsDueToBeUpdated: updateSession(expiry)
   Formula: (expires - maxAge) + updateAge
5. callbacks.session({ session, user })
6. Return session to client
```

**Advantages:**
- Sessions can be revoked immediately (delete from DB)
- Unlimited session data (stored in DB, not cookie)
- Can query all active sessions for a user
- Audit trail of session creation/deletion
- Works with large session payloads

**Disadvantages:**
- Database query on every authenticated request
- Requires database adapter
- Session throttling logic needed to reduce DB writes
- More complex to scale (shared session store)

### Strategy Selection Guide

| Requirement | Strategy |
|-------------|----------|
| Single server, max control | Database |
| Serverless, zero infra | JWT |
| Need immediate session revocation | Database |
| Multi-region, low latency | JWT |
| Audit logging of sessions | Database |
| Simplicity, no DB setup | JWT |
| Large session payload | Database |

## Token Rotation & Secret Management

### Secret Rotation (JWT Strategy)

Auth.js supports multiple secrets for zero-downtime rotation:

```ts
// Config
secret: [process.env.AUTH_SECRET_NEW, process.env.AUTH_SECRET_OLD]

// Encoding: uses the first (newest) secret
// Decoding: tries each secret until one succeeds
// Key identification: JWT header includes `kid` (JWK thumbprint of encryption key)
```

**Rotation Process:**
1. Add new secret to start of array (or `AUTH_SECRET` env var)
2. Deploy — new sessions encoded with new secret
3. Old sessions still decodable because old secret is in array
4. After `maxAge` (30 days), all sessions use new secret
5. Remove old secret from array

### OAuth Token Rotation

Auth.js stores `refresh_token` and `expires_at` in the database Account model but does NOT implement automatic refresh. Must be done in the `jwt` callback:

```ts
callbacks: {
  async jwt({ token, account }) {
    // Persist tokens on first sign in
    if (account) {
      token.accessToken = account.access_token
      token.refreshToken = account.refresh_token
      token.expiresAt = account.expires_at
    }
    // Return if still valid (5 min buffer)
    if (token.expiresAt && Date.now() / 1000 + 300 < token.expiresAt) {
      return token
    }
    // Refresh
    const refreshed = await refreshAccessToken(token.refreshToken)
    return { ...token, ...refreshed }
  }
}
```

## Session Validation Middleware

### Framework-Agnostic Validation

```ts
// Manual JWT validation (using @auth/core/jwt)
import { getToken } from "@auth/core/jwt"

async function validateSession(request: Request): Promise<JWT | null> {
  return await getToken({
    req: request,
    secret: process.env.AUTH_SECRET,
    salt: "__Secure-authjs.session-token",  // cookie name used as HKDF salt
    secureCookie: process.env.NODE_ENV === "production",
  })
}

// Database validation (using adapter directly)
async function validateDatabaseSession(request: Request, adapter: Adapter) {
  const cookieHeader = request.headers.get("cookie")
  const cookies = parse(cookieHeader ?? "")
  const sessionToken = cookies["authjs.session-token"]

  if (!sessionToken) return null
  const result = await adapter.getSessionAndUser(sessionToken)
  if (!result) return null

  const { session, user } = result
  if (session.expires.valueOf() < Date.now()) {
    await adapter.deleteSession?.(sessionToken)
    return null
  }
  return { session, user }
}
```

### JWT Validation Detail

The `getToken()` function supports two token sources:
1. **Cookie**: Reads session token from cookie (default)
2. **Authorization header**: Reads `Bearer <token>` from headers (for API clients)

```ts
// Server-side usage
import { getToken } from "@auth/core/jwt"

const token = await getToken({
  req: request,           // Request object (or { headers } object)
  secret: secretArray,    // string | string[]
  salt: cookieName,       // Used for HKDF key derivation
  raw: false,             // true = return raw JWT string, false = decode payload
  secureCookie: true,     // In production
  cookieName: "__Secure-authjs.session-token",
  decode: customDecodeFn, // Optional: override JWT decoding
  logger: console,
})
```

## Cookie Security Architecture

### Cookie Configuration Matrix

| Cookie | Name Pattern | httpOnly | secure | sameSite | path | maxAge |
|--------|-------------|----------|--------|----------|------|--------|
| Session Token | `__Secure-authjs.session-token` | true | auto | lax | / | 30 days |
| CSRF Token | `__Host-authjs.csrf-token` | true | auto | lax | / | — |
| Callback URL | `__Secure-authjs.callback-url` | true | auto | lax | / | — |
| PKCE Verifier | `__Secure-authjs.pkce.code_verifier` | true | auto | lax | / | 15 min |
| State | `__Secure-authjs.state` | true | auto | lax | / | 15 min |
| Nonce | `__Secure-authjs.nonce` | true | auto | lax | / | — |
| WebAuthn Challenge | `__Secure-authjs.challenge` | true | auto | lax | / | 15 min |

### Cookie Prefix Semantics

- `__Secure-` prefix: browser requires HTTPS to set cookie
- `__Host-` prefix: browser requires HTTPS + path=/) + no Domain attribute
- CSRF token uses `__Host-` for maximum protection
- All other cookies use `__Secure-`

### Conditional Security

```ts
// Auto-detection of secure setting
const useSecureCookies = request.url.startsWith("https://")
// Falls back to http:// for localhost automatically
```

### Session Cookie Chunking

For cookies exceeding 4096 bytes:
```
SessionToken = full JWT string
Estimated empty cookie overhead = 160 bytes
Chunk size = 4096 - 160 = 3936 bytes

If JWT is 8000 bytes:
  Cookie: __Secure-authjs.session-token.0 = bytes[0..3935]
  Cookie: __Secure-authjs.session-token.1 = bytes[3936..7999]
```

On read, chunks are sorted by suffix number and concatenated.

## CSRF Protection (Double Submit Cookie)

### Architecture

Auth.js implements the OWASP Double-Submit Cookie pattern:

```
1. GET /api/auth/csrf
   → Server generates random CSRF token (32 bytes)
   → Creates hash = SHA256(token + secret)
   → Sets cookie: __Host-authjs.csrf-token = "token|hash"
   → Returns: { csrfToken: "token" }

2. POST /api/auth/signin/github
   → Client sends csrfToken in request body
   → Server reads cookie, splits on "|"
   → Recomputes expectedHash = SHA256(cookieToken + secret)
   → Compares: expectedHash === cookieHash
   → Compares: cookieToken === bodyToken
   → If both match → CSRF verified
```

### Implementation Details

```ts
// Token generation
const csrfToken = randomString(32)
const csrfTokenHash = await createHash(`${csrfToken}${options.secret}`)
const cookie = `${csrfToken}|${csrfTokenHash}`

// Validation
const [csrfToken, csrfTokenHash] = cookieValue.split("|")
const expectedHash = await createHash(`${csrfToken}${options.secret}`)
const csrfTokenVerified = csrfTokenHash === expectedHash && isPost && csrfToken === bodyValue
```

All state-changing endpoints are CSRF-protected:
- `POST /signin/:provider`
- `POST /signout`
- `POST /session` (update)

## Rate Limiting (Implementation Guide)

Auth.js does not include built-in rate limiting. Implement at the framework level:

```ts
// Express example with express-rate-limit
import rateLimit from "express-rate-limit"

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,  // 15 minutes
  max: 20,                    // 20 attempts per window
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: "Too many requests, please try again later." }
})

// Apply to auth endpoints
app.use("/api/auth/signin", authLimiter)
app.use("/api/auth/callback", authLimiter)
```

```ts
// Next.js middleware example
import { NextResponse } from "next/server"
import type { NextRequest } from "next/server"

const rateLimitMap = new Map<string, { count: number; resetTime: number }>()

export function middleware(request: NextRequest) {
  if (request.nextUrl.pathname.startsWith("/api/auth/signin")) {
    const ip = request.ip ?? "anonymous"
    const now = Date.now()
    const windowMs = 15 * 60 * 1000
    const maxRequests = 20

    const record = rateLimitMap.get(ip)
    if (!record || now > record.resetTime) {
      rateLimitMap.set(ip, { count: 1, resetTime: now + windowMs })
    } else {
      record.count++
      if (record.count > maxRequests) {
        return NextResponse.json(
          { error: "Too many requests" },
          { status: 429 }
        )
      }
    }
  }
}
```

## Password Hashing Strategies

### bcrypt Configuration

```ts
import bcrypt from "bcrypt"

const SALT_ROUNDS = 12  // Recommended: 10-12 for balance of security/performance

// Hash password
async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS)
}

// Verify password (constant-time comparison)
async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return bcrypt.compare(password, hash)
}
```

### Argon2id (Recommended for new projects)

```ts
import { hash, verify } from "argon2"

// Hash with recommended params
async function hashPassword(password: string): Promise<string> {
  return hash(password, {
    type: argon2id,         // Hybrid mode, resistant to side-channel + GPU
    memoryCost: 65536,      // 64 MB
    timeCost: 3,            // 3 iterations
    parallelism: 4,         // 4 threads
  })
}

// Verify
async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return verify(hash, password)
}
```

### Security Considerations

- Never store plaintext passwords
- Use constant-time comparison (bcrypt/argon2 handle this)
- Minimum iterations: bcrypt: 10, argon2: 3
- Salt must be unique per password (bcrypt/argon2 handle this internally)
- Store password hash only, never the raw password
- Re-hash if algorithm parameters change

## OAuth Flow: Server-Side Details

### Authorization Request

```ts
// 1. Generate security parameters
const state = await generateState(secret)        // CSRF protection
const codeVerifier = await generatePKCE()        // Code interception protection
const codeChallenge = SHA256(codeVerifier)
const nonce = await generateNonce()             // Replay protection (OIDC)

// 2. Store in httpOnly cookies
Set-Cookie: __Secure-authjs.state = <encrypted>
Set-Cookie: __Secure-authjs.pkce.code_verifier = <raw>
Set-Cookie: __Secure-authjs.nonce = <raw>

// 3. Redirect to provider
Location: https://provider.com/authorize?
  response_type=code
  &client_id=<clientId>
  &redirect_uri=https://app.com/api/auth/callback/provider
  &state=<encrypted>
  &code_challenge=<codeChallenge>
  &code_challenge_method=S256
  &scope=openid profile email
  &nonce=<nonce>
```

### Callback Processing

```ts
// 1. Validate OAuth response
const params = o.validateAuthResponse(as, client, urlParams, state)

// 2. Verify PKCE
// Send code_verifier, provider hashes and compares to stored code_challenge

// 3. Exchange code for tokens
const response = await o.authorizationCodeGrantRequest(
  as, client, clientAuth, params, redirect_uri, codeVerifier
)

// 4. Process response
const tokens = await o.processAuthorizationCodeResponse(as, client, response, {
  expectedNonce: nonce,  // Validate nonce in id_token
})

// 5. Fetch userinfo
const userinfo = await o.userInfoRequest(as, client, tokens.access_token)
const profile = await userinfo.json()

// 6. Map profile to User via provider.profile() callback
const user = await provider.profile(profile, tokens)

// 7. Create/link user in database
const { user: dbUser, isNewUser } = await handleLoginOrRegister(...)

// 8. Create session (JWT or database)
// 9. Set cookies, redirect to callbackUrl
```

### Token Endpoint Authentication Methods

| Method | Description | Security |
|--------|-------------|----------|
| `client_secret_basic` | HTTP Basic Auth header | Good (HTTPS required) |
| `client_secret_post` | Secret in POST body | Standard |
| `client_secret_jwt` | Signed JWT assertion | Better |
| `private_key_jwt` | Asymmetric key JWT | Best |
| `none` | No authentication (public clients) | Only for PKCE |

### OIDC Discovery

For OIDC providers, Auth.js uses OpenID Connect Discovery:
```
GET {issuer}/.well-known/openid-configuration
→ Returns JSON with authorization_endpoint, token_endpoint, userinfo_endpoint, etc.
```

This auto-configures endpoints from the `issuer` URL only.

## Error Handling Architecture

### Server vs Client Errors

```ts
// Server-only errors (masked from client):
const serverErrors = [
  "MissingSecret", "InvalidCallbackUrl", "UntrustedHost",
  "CallbackRouteError", "JWTSessionError", "SessionTokenError",
  "MissingAdapter", "MissingAdapterMethods", "MissingAuthorize",
  "UnsupportedStrategy", "InvalidProvider", "InvalidEndpoints",
  "InvalidCheck", "OAuthProfileParseError",
]

// Client-safe errors (exposed in redirect URL):
const clientErrors = [
  "CredentialsSignin", "OAuthAccountNotLinked", "OAuthCallbackError",
  "AccessDenied", "Verification", "MissingCSRF",
  "AccountNotLinked", "WebAuthnVerificationError",
]
```

Server-only errors are replaced with `Configuration` when redirecting to client. The full error is logged server-side with `logger.error()`.

### Error Response Flow

```
Request → try { Auth handler }
  ├─ Success → 200/Redirect with cookies
  └─ Error
      ├─ POST /session → 400 JSON (null)
      ├─ X-Auth-Return-Redirect header → 200 JSON { url: "/error?error=Type" }
      └─ Default → 302 Redirect to /error?error=Type
```

## Key Rotation (Secrets)

```ts
// Support for multiple secrets
secret: [
  "NEW_SECRET_FROM_ENV",    // Index 0: used for encoding new sessions
  "OLD_SECRET_FROM_ENV",    // Index 1: can still decode old sessions
]

// During decode, JWT `kid` header identifies which secret was used
// kid = JWK thumbprint of the derived encryption key
// Each secret is tried until one matches the kid
```

## Framework Integration Architecture

Auth.js uses the standard Web API `Request`/`Response` interface internally:

```
Framework-specific middleware
  → Converts framework request to standard Request
  → Calls Auth(request, config)
  → Converts standard Response back to framework response
```

This design enables a single core to work with any framework:

```ts
// The core is framework-agnostic
export async function Auth(
  request: Request,
  config: AuthConfig
): Promise<Response>

// Each framework provides an adapter
// Next.js: wraps in Route Handlers
// Express: wraps in middleware
// SvelteKit: wraps in hooks
// SolidStart: wraps in middleware
```
