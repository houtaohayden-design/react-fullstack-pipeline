# NextAuth.js (Auth.js) API Reference

> Source: [nextauthjs/next-auth](https://github.com/nextauthjs/next-auth) (25k+ stars)
> Trained: 2026-05-18

## Overview

Auth.js (formerly NextAuth.js) is a framework-agnostic authentication library for web applications. It provides a unified API for multiple authentication providers, session management, and secure cookie handling. The core package (`@auth/core`) is runtime-agnostic and works with any web framework (Next.js, SvelteKit, Express, Qwik, SolidStart).

## Package Architecture

```
@auth/core          — Framework-agnostic core (all auth logic)
next-auth           — Next.js integration (React hooks, SessionProvider, middleware)
@auth/express       — Express integration
@auth/sveltekit     — SvelteKit integration
@auth/solid-start   — SolidStart integration
```

## Configuration (`AuthConfig`)

### Core Setup

```ts
import { Auth } from "@auth/core"

const response = await Auth(request, {
  providers: [...],
  secret: process.env.AUTH_SECRET,
  trustHost: true,
})
```

### Key Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `providers` | `Provider[]` | `[]` | Authentication providers |
| `secret` | `string\|string[]` | required | Encrypt cookies, hash tokens. Array enables key rotation |
| `session.strategy` | `"jwt"` \| `"database"` | `"jwt"` (no adapter), `"database"` (with adapter) | Session persistence strategy |
| `session.maxAge` | `number` | `2592000` (30 days) | Session expiry in seconds |
| `session.updateAge` | `number` | `86400` (1 day) | Throttle DB writes, in seconds |
| `pages` | `Partial<PagesOptions>` | `{}` | Custom signIn/signOut/error/verifyRequest/newUser routes |
| `useSecureCookies` | `boolean` | auto (based on URL scheme) | Force secure cookies |
| `trustHost` | `boolean` | `false` | Must be `true` in production (relies on host header) |
| `basePath` | `string` | `"/api/auth"` (next-auth), `"/auth"` (others) | API route prefix |
| `redirectProxyUrl` | `string` | — | For preview deployments with single redirect_uri |
| `debug` | `boolean` | `false` | Enable debug logging |
| `theme` | `Theme` | — | Customize built-in pages (colorScheme, logo, brandColor) |

### Cookie Options

Customize individual cookie names and serialization options:

```ts
cookies: {
  sessionToken: { name: "__Secure-authjs.session-token", options: { httpOnly: true, sameSite: "lax", path: "/", secure: true } },
  callbackUrl:  { name: "__Secure-authjs.callback-url",  options: { httpOnly: true, sameSite: "lax", path: "/", secure: true } },
  csrfToken:    { name: "__Host-authjs.csrf-token",      options: { httpOnly: true, sameSite: "lax", path: "/", secure: true } },
  pkceCodeVerifier: { name: "__Secure-authjs.pkce.code_verifier", options: { httpOnly: true, sameSite: "lax", path: "/", secure: true, maxAge: 900 } },
  state:        { name: "__Secure-authjs.state",          options: { httpOnly: true, sameSite: "lax", path: "/", secure: true, maxAge: 900 } },
  nonce:        { name: "__Secure-authjs.nonce",          options: { httpOnly: true, sameSite: "lax", path: "/", secure: true } },
  webauthnChallenge: { name: "__Secure-authjs.challenge", options: { httpOnly: true, sameSite: "lax", path: "/", secure: true, maxAge: 900 } },
}
```

Cookie prefix convention: `__Secure-` for HTTPS, `__Host-` for CSRF token (stricter).

## Supported Provider Types

| Type | Description | Examples |
|------|-------------|---------|
| `oauth` | OAuth 2.0 providers | GitHub, Google, Facebook, Discord |
| `oidc` | OpenID Connect providers | Auth0, Keycloak, Azure AD, Authentik |
| `email` | Passwordless / magic link | Resend, SendGrid, Nodemailer, Postmark |
| `credentials` | Username/password auth | Custom login forms |
| `webauthn` | Passkeys / biometric | FIDO2, fingerprint, face recognition |

## OAuth Provider Configuration

```ts
interface OAuth2Config<Profile> {
  id: string                    // Provider ID (e.g., "github")
  name: string                  // Display name ("Sign in with GitHub")
  type: "oauth" | "oidc"
  clientId: string              // OAuth client ID
  clientSecret: string         // OAuth client secret
  issuer?: string               // For OIDC providers
  authorization?: string | EndpointHandler  // Authorization endpoint URL
  token?: string | EndpointHandler          // Token endpoint URL
  userinfo?: string | EndpointHandler       // Userinfo endpoint URL
  profile?: (profile: Profile, tokens: TokenSet) => Awaitable<User>  // Map provider profile to User
  checks?: ("pkce" | "state" | "nonce" | "none")[]  // OAuth security checks
  client?: { token_endpoint_auth_method?: "client_secret_basic" | "client_secret_post" | "client_secret_jwt" | "private_key_jwt" | "none" }
  allowDangerousEmailAccountLinking?: boolean  // Auto-link accounts by email
  redirectProxyUrl?: string     // Per-provider redirect proxy override
}
```

### Built-in OAuth/OIDC Providers (95+)

**Major platforms:** GitHub, Google, Facebook, Apple, Twitter, Discord, Slack, LinkedIn, Twitch, Spotify, Reddit, TikTok, Instagram, Atlassian, GitLab, Bitbucket, Notion, Figma, Dropbox, Box, HubSpot, Salesforce, Zoho, Zoom, Wordpress, Medium, Pinterest, Dribbble, Patreon

**Identity & SSO:** Auth0, Keycloak, Microsoft Entra ID (Azure AD), Azure AD B2C, Okta, OneLogin, Ping Identity, Duende IdentityServer, IdentityServer4, Authentik, Zitadel, FusionAuth, Ory Hydra, Logto, Kinde, Descope, Frontegg, Asgardeo, WorkOS, Passage, BeyondIdentity, BoxyHQ SAML, Netlify, Cognito

**Gaming:** Battle.net, Bungie, EVE Online, FaceIT, osu!, Roblox, Trakt

**Region-specific:** Kakao, Naver, Line, VK, Yandex, Mail.ru, WeChat, ViPPS, BankID Norway

**Email (magic link):** Resend, SendGrid, Postmark, Nodemailer, Mailgun, Mailchimp, ForwardEmail, SimpleLogin, Loops

**Others:** Coinbase, 42 School, ClickUp, Eventbrite, FreshBooks, Mattermost, Netsuite, Nextcloud, OSSO, PipeDrive, Strava, Todoist, Wikimedia, United Effects, Concept2

## Credentials Provider

```ts
import Credentials from "@auth/core/providers/credentials"

Credentials({
  name: "Credentials",
  credentials: {
    email: { label: "Email", type: "email" },
    password: { label: "Password", type: "password" }
  },
  authorize: async (credentials, request) => {
    // Validate credentials against your database
    const user = await db.user.findUnique({ where: { email: credentials.email } })
    if (!user || !bcrypt.compareSync(credentials.password, user.hashedPassword)) {
      throw new CredentialsSignin()  // or return null
    }
    return { id: user.id, name: user.name, email: user.email, image: user.image }
  }
})
```

## Session Strategies

### JWT Strategy (default)

- Session data stored in encrypted JWT (JWE) cookie
- Uses `A256CBC-HS512` encryption via `jose` library
- Key derived from `secret` via HKDF (SHA-256)
- Supports multiple secrets for key rotation (newest first)
- Cookie chunking: sessions >4096 bytes split across multiple cookies
- No database required
- `maxAge`: 30 days default, `updateAge`: 1 day default

### Database Strategy

- Session token stored in cookie, session data in database
- Requires an adapter implementing `Adapter` interface
- Session lookup via `getSessionAndUser(sessionToken)`
- Throttles writes based on `updateAge` to reduce DB load
- Sessions removed on expiry

## Callbacks

### `signIn` callback
Controls whether a user is allowed to sign in:
```ts
async signIn({ user, account, profile, email, credentials }) {
  // Return true to allow, false to deny, string to redirect
  return profile?.email?.endsWith("@example.com") ?? false
}
```

### `jwt` callback  
Called when JWT is created or updated. Customize the token payload:
```ts
async jwt({ token, user, account, profile, trigger }) {
  if (user) token.role = user.role  // Add custom claims on sign in
  return token
}
```

### `session` callback
Called when session is checked. Controls what is exposed to the client:
```ts
async session({ session, token, user }) {
  session.user.role = token.role  // Forward custom claims to client
  return session
}
```

### `redirect` callback
Controls redirect destination after sign in/out:
```ts
async redirect({ url, baseUrl }) {
  if (url.startsWith("/")) return `${baseUrl}${url}`
  if (new URL(url).origin === baseUrl) return url
  return baseUrl  // Fallback to home
}
```

## Events (Audit Logging)

```ts
events: {
  signIn:    ({ user, account, profile, isNewUser }) => { /* audit log */ },
  signOut:   ({ token }) | ({ session }) => { /* audit log */ },
  createUser: ({ user }) => { /* audit log */ },
  updateUser: ({ user }) => { /* audit log */ },
  linkAccount: ({ user, account, profile }) => { /* audit log */ },
  session:   ({ session, token }) => { /* audit log */ },
}
```

## React Hooks & Functions (next-auth)

### `SessionProvider`
Context provider wrapping the app:
```tsx
<SessionProvider session={session} refetchInterval={5 * 60} refetchOnWindowFocus={true}>
  <Component {...pageProps} />
</SessionProvider>
```

### `useSession()`
Client-side hook returning session state:
```tsx
const { data: session, status, update } = useSession()
// status: "authenticated" | "unauthenticated" | "loading"

// Require authentication:
useSession({ required: true, onUnauthenticated: () => { /* redirect */ } })
```

### `signIn()`
Initiate sign-in from client components (POST with CSRF token):
```ts
await signIn("github", { callbackUrl: "/dashboard" })
await signIn("credentials", { email, password, redirect: false })
```

### `signOut()`
Initiate sign-out (POST with CSRF token):
```ts
await signOut({ callbackUrl: "/" })
await signOut({ redirect: false })
```

### `getSession()`
Fetch session on client side:
```ts
const session = await getSession()
```

### `getCsrfToken()`
Get CSRF token for manual API calls:
```ts
const csrfToken = await getCsrfToken()
```

### `getProviders()`
Get list of configured providers:
```ts
const providers = await getProviders()
```

## Server-Side Session (next-auth v5)

```ts
// In App Router (Server Components):
import { auth } from "@/auth"

export default async function Page() {
  const session = await auth()
  if (!session) return <SignIn />
  return <div>Hello {session.user.name}</div>
}
```

## Middleware (next-auth v5)

Middleware is deprecated in v5. Use `auth()` in Server Components or Route Handlers instead:
```ts
// app/api/protected/route.ts
import { auth } from "@/auth"

export const GET = auth(async (req) => {
  if (!req.auth) return Response.json({ error: "Unauthorized" }, { status: 401 })
  return Response.json({ data: "Protected data" })
})
```

## REST API Endpoints

All endpoints are under the `basePath` (default `/api/auth`):

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/signin` | GET | Built-in sign-in page (lists providers) |
| `/signin/:provider` | POST | Initiate sign-in for a provider |
| `/callback/:provider` | GET/POST | OAuth callback / credentials callback |
| `/signout` | GET | Built-in sign-out page |
| `/signout` | POST | Execute sign-out (CSRF protected) |
| `/session` | GET | Get current session (JSON) |
| `/session` | POST | Update session (CSRF protected) |
| `/csrf` | GET | Get CSRF token (JSON: `{ csrfToken }`) |
| `/providers` | GET | List configured providers (client-safe) |
| `/error` | GET | Built-in error page |
| `/verify-request` | GET | Email verification pending page |
| `/webauthn-options` | GET | WebAuthn registration/authentication options |

## Database Adapters (23 official)

| Adapter | Database |
|---------|----------|
| `@auth/prisma-adapter` | Prisma ORM (PostgreSQL, MySQL, SQLite, SQL Server, MongoDB, CockroachDB) |
| `@auth/drizzle-adapter` | Drizzle ORM (PostgreSQL, MySQL, SQLite) |
| `@auth/pg-adapter` | PostgreSQL (native driver) |
| `@auth/supabase-adapter` | Supabase |
| `@auth/neon-adapter` | Neon (serverless PostgreSQL) |
| `@auth/mongodb-adapter` | MongoDB |
| `@auth/firebase-adapter` | Firebase Firestore |
| `@auth/dynamodb-adapter` | AWS DynamoDB |
| `@auth/upstash-redis-adapter` | Upstash Redis |
| `@auth/kysely-adapter` | Kysely query builder |
| `@auth/mikro-orm-adapter` | MikroORM |
| `@auth/typeorm-adapter` | TypeORM |
| `@auth/sequelize-adapter` | Sequelize ORM |
| `@auth/dgraph-adapter` | Dgraph |
| `@auth/edgedb-adapter` | EdgeDB |
| `@auth/fauna-adapter` | Fauna |
| `@auth/hasura-adapter` | Hasura GraphQL |
| `@auth/neo4j-adapter` | Neo4j |
| `@auth/pouchdb-adapter` | PouchDB |
| `@auth/surrealdb-adapter` | SurrealDB |
| `@auth/unstorage-adapter` | Unstorage |
| `@auth/xata-adapter` | Xata |
| `@auth/d1-adapter` | Cloudflare D1 |
| `@auth/azure-tables-adapter` | Azure Tables |

### Adapter Interface

```ts
interface Adapter {
  createUser?(user: AdapterUser): Awaitable<AdapterUser>
  getUser?(id: string): Awaitable<AdapterUser | null>
  getUserByEmail?(email: string): Awaitable<AdapterUser | null>
  getUserByAccount?(providerAccountId: { provider, providerAccountId }): Awaitable<AdapterUser | null>
  updateUser?(user: Partial<AdapterUser> & { id: string }): Awaitable<AdapterUser>
  deleteUser?(userId: string): Awaitable<AdapterUser | null | undefined>
  linkAccount?(account: AdapterAccount): Awaitable<AdapterAccount | null | undefined>
  unlinkAccount?(providerAccountId: { provider, providerAccountId }): Awaitable<AdapterAccount | undefined>
  createSession?(session: { sessionToken, userId, expires }): Awaitable<AdapterSession>
  getSessionAndUser?(sessionToken: string): Awaitable<{ session, user } | null>
  updateSession?(session: Partial<AdapterSession> & { sessionToken }): Awaitable<AdapterSession | null | undefined>
  deleteSession?(sessionToken: string): Awaitable<AdapterSession | null | undefined>
  createVerificationToken?(token: VerificationToken): Awaitable<VerificationToken | null | undefined>
  useVerificationToken?({ identifier, token }): Awaitable<VerificationToken | null>
  getAccount?(providerAccountId, provider): Awaitable<AdapterAccount | null>
  createAuthenticator?(authenticator: AdapterAuthenticator): Awaitable<AdapterAuthenticator>
  getAuthenticator?(credentialID: string): Awaitable<AdapterAuthenticator | null>
  listAuthenticatorsByUserId?(userId: string): Awaitable<AdapterAuthenticator[]>
  updateAuthenticatorCounter?(credentialID, newCounter): Awaitable<AdapterAuthenticator>
}
```

### Database Models

```
User               — id, name, email, emailVerified, image
Account            — id, userId, type, provider, providerAccountId, refresh_token, access_token, expires_at, token_type, scope, id_token, session_state
Session            — id, sessionToken, userId, expires
VerificationToken  — identifier, token, expires
Authenticator      — userId, providerAccountId, counter, credentialBackedUp, credentialID, credentialPublicKey, transports, credentialDeviceType
```

## CSRF Protection

Double-submit cookie pattern (OWASP recommended):
1. Server sets `__Host-authjs.csrf-token` cookie with `token|hash` value
2. Hash = SHA-256(token + secret)
3. All state-changing requests (POST signIn, signOut, session update) must include matching CSRF token in request body
4. Can be disabled with `skipCSRFCheck` (not recommended)

## Error Types

| Error Class | Type | Client-Safe | Description |
|-------------|------|-------------|-------------|
| `CredentialsSignin` | CredentialsSignin | Yes | Invalid credentials |
| `AccessDenied` | AccessDenied | Yes | signIn callback returned false |
| `OAuthAccountNotLinked` | OAuthAccountNotLinked | Yes | Email already linked to different provider |
| `OAuthCallbackError` | OAuthCallbackError | Yes | OAuth provider returned error |
| `Verification` | Verification | Yes | Invalid/expired email token |
| `MissingCSRF` | MissingCSRF | Yes | CSRF token validation failed |
| `AccountNotLinked` | AccountNotLinked | Yes | Account not linked to existing user |
| `MissingSecret` | MissingSecret | No | AUTH_SECRET not configured |
| `InvalidCallbackUrl` | InvalidCallbackUrl | No | Callback URL validation failed |
| `UntrustedHost` | UntrustedHost | No | trustHost not set to true |
| `CallbackRouteError` | CallbackRouteError | No | Generic callback error |
| `JWTSessionError` | JWTSessionError | No | JWT decode/encode failure |
| `SessionTokenError` | SessionTokenError | No | Database session retrieval failure |

Client-safe errors are sent to the client in the redirect URL. Server-only errors are masked as `Configuration` errors.

## CLI

```bash
npx auth secret     # Generate a random secret
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `AUTH_SECRET` | Primary secret (auto-detected) |
| `AUTH_SECRET_1`, `AUTH_SECRET_2`, ... | Additional secrets for rotation |
| `AUTH_URL` / `NEXTAUTH_URL` | Canonical URL of the site |
| `AUTH_REDIRECT_PROXY_URL` | Redirect proxy for preview deployments |
| `AUTH_TRUST_HOST` | Auto-set trustHost |
