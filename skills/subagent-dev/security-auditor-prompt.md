# Security Auditor Prompt Template

Use when dispatching a `security-auditor` subagent (agent type: `agent-skills:security-auditor`).

## Template

```
Security-audit the <project-name> backend at <path>. You are a security engineer.

## Scope
<backend-path>

## Focus Areas

### P0 — Authentication & Authorization
- [ ] JWT: secret strength, expiry, revocation mechanism, hardcoded fallbacks
- [ ] Password hashing: algorithm, salt rounds, hash never returned to client
- [ ] Middleware: all protected routes use authMiddleware, no bypasses
- [ ] User isolation: user A cannot access user B's data (IDOR)

### P1 — Input Validation & Injection
- [ ] All user inputs validated (Zod schemas, type guards)
- [ ] SQL injection surface (parameterized queries? raw SQL? LIKE wildcards?)
- [ ] XSS: is user content rendered unsanitized?
- [ ] File upload: type restrictions, size limits, path traversal

### P2 — API Security
- [ ] Rate limiting on auth endpoints (login, register)
- [ ] CORS configuration (origins, methods, credentials)
- [ ] Security headers (HSTS, X-Content-Type-Options, X-Frame-Options, CSP)
- [ ] Error messages: no stack traces or internal details exposed to clients
- [ ] CSRF protection for cookie-based sessions

### P3 — Data & Infrastructure
- [ ] Secrets management (.env in git? hardcoded keys?)
- [ ] HTTPS enforcement in production
- [ ] Dependency vulnerabilities (npm audit)
- [ ] Logging: no sensitive data (tokens, passwords, PII)

## Output Format

Report findings ranked by severity:

| Severity | Finding | Location | Fix |
|----------|---------|----------|-----|

Severities: CRITICAL (immediate action), HIGH (this sprint), MEDIUM (next sprint), LOW (backlog)

Also list positive observations (things done correctly).

## Context Files
- Route files: <list>
- Middleware: <list>
- Schema: <list>
- Config: <list>
```
