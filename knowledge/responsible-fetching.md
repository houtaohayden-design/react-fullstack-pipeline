# Responsible Website Fetching Policy

> **MANDATORY** — applies to ALL website design extraction agents. Violating these rules can cause real financial harm to target website owners (bandwidth costs, OSS egress fees, CDN bills).

## Why This Exists

Small websites often operate on metered bandwidth (OSS object storage + CDN with no circuit breaker). A single aggressive extraction session can consume their monthly bandwidth allocation. Even larger sites behind CDNs incur costs. We are guests — act accordingly.

## Request Budget (Hard Limits)

| Limit | Value | Notes |
|-------|-------|-------|
| Max total HTTP requests per site | **15** | Including all pages, CSS files, JS files |
| Max pages fetched | **3** | Homepage + up to 2 key sub-pages |
| Max external CSS files fetched | **5** | Only if needed beyond inline styles |
| Max JS files fetched | **3** | Only to understand animation libraries used |
| Max individual resource size | **500 KB** | Abort and skip if larger |
| Max total downloaded per site | **2 MB** | Stop all fetching when reached |

## Rate Limiting

- **Minimum 2-second delay** between ALL requests to the same origin
- Never make concurrent requests to the same domain — always sequential
- If the site returns a `Retry-After` header, respect it exactly
- If the site returns `429 Too Many Requests`, **abort the entire extraction** and report it

## Circuit Breaker (Stop Conditions)

Stop ALL fetching immediately when ANY of these occur:

| Condition | Action |
|-----------|--------|
| HTTP 429 (Rate Limited) | Abort extraction. Report: "Site rate-limited us — stopping" |
| HTTP 403 (Forbidden) | Abort extraction. Site is blocking automated access |
| HTTP 503 (Service Unavailable) | Abort extraction. Don't add load to an already struggling server |
| 3 consecutive non-2xx responses | Circuit open — abort extraction |
| Single resource > 500 KB | Skip that resource, continue (don't abort) |
| robots.txt disallows the path | Skip that path, continue with allowed paths only |

## Pre-Fetch Assessment

Before making ANY request, assess the site:

### Small Site Indicators (use reduced budget: 5 requests, homepage only)
- Non-standard TLD or subdomain (e.g., `myshop.shopify.com`, `blog.mycompany.io`)
- Personal blog, portfolio, small business site
- No visible CDN (no `cdn.`, `static.`, `assets.` subdomain pattern)
- Site appears to be on shared hosting or VPS

### Enterprise / CDN-Backed (standard 15-request budget OK)
- Major CDN patterns: `cdn.`, `static.`, `assets.`, CloudFront, Cloudflare, Fastly, Vercel, Netlify
- Well-known SaaS: stripe.com, vercel.com, linear.app, framer.com
- Large consumer brands: apple.com, dji.com, mi.com

### SAFE BY DEFAULT — if unsure, treat as small site (5 requests, homepage only)

## CSS Extraction Strategy

Parse efficiently to minimize requests:

1. **First pass** — Extract all CSS from the homepage HTML inline `<style>` tags and `style` attributes. This is zero additional requests.
2. **Second pass** — Identify linked stylesheets. Fetch up to 5, prioritizing:
   - Stylesheets with `--` custom properties in the URL or filename (likely design tokens)
   - Stylesheets named `theme`, `tokens`, `variables`, `global`, `design-system`
   - Skip third-party CSS (Google Fonts, analytics, ad trackers, CDN libraries)
3. **Parse, don't download fully** — When fetching CSS, extract only:
   - CSS custom properties (`--*`)
   - `@font-face` declarations
   - Keyframe animations (`@keyframes`)
   - Media query breakpoints
   - Ignore: reset styles, vendor prefixes, utility class definitions, base element styles

## Respectful Identification

All requests must include headers that identify us honestly:

```
User-Agent: DesignSystemAnalyzer/1.0 (design research; 1 request/2s; https://github.com/houtaohayden-design/react-fullstack-pipeline)
```

This tells site operators:
- Who we are (not a scraper or botnet)
- Our rate (1 request per 2 seconds — slow enough to be harmless)
- Where to find our source code and contact

## Post-Extraction Cleanup

- Delete any downloaded CSS/JS files after parsing — they should never be stored
- Only the final `design-system.md` file persists
- Never cache or re-serve the target site's assets

## Checklist (Agent Must Verify Before Starting)

- [ ] Pre-fetch assessment done (small site or enterprise?)
- [ ] Request budget calculated and communicated
- [ ] robots.txt checked (if fetchable)
- [ ] Rate limiter armed (2s minimum between requests)
- [ ] Circuit breaker armed (stop on 429/403/503 or 3 consecutive errors)
- [ ] Resource size cap armed (500KB per resource, 2MB total)
- [ ] CSS prioritization list prepared (max 5 external stylesheets)
- [ ] User-Agent header configured

## What To Do When Limited

If the circuit breaker trips or budget is exhausted:

1. **Extract from what you already have** — the homepage HTML and inline styles alone contain significant design information
2. **Use visual analysis** — describe what you can SEE in the fetched content (layout, spacing, typography, color from rendered HTML)
3. **Note gaps honestly** — in the design-system.md, add a section: "## Extraction Limitations" listing what couldn't be fully analyzed
4. **Never retry** — don't attempt the same site again in the same session

## Sanity Check

Before dispatching ANY design extraction agent, ask: "If this were my personal blog running on a $5 VPS with metered OSS bandwidth, would I be OK with what this agent is about to do?"

If the answer is no, reduce the budget.
