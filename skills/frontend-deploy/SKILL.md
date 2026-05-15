---
name: react-pipeline:frontend-deploy
description: Use when deploying a React frontend to production — covers build optimization, static hosting platforms, CI/CD deployment, and environment variables.
---

# Deploying React Frontend

## Core Principle
Optimize the build, then deploy to the right platform. SPA routing must work. Environment variables must be injected at build time.

## Build Optimization

### Vite (Recommended)
```bash
npm run build
# Output: dist/
```

```ts
// vite.config.ts optimization
export default defineConfig({
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          router: ['react-router'],
          query: ['@tanstack/react-query']
        }
      }
    },
    chunkSizeWarningLimit: 500
  }
})
```

### SPA Routing Handling
Every platform needs SPA fallback to `index.html`:
- **Vercel**: `vercel.json` rewrites
- **Netlify**: `_redirects` file (`/* /index.html 200`)
- **Nginx**: `try_files $uri $uri/ /index.html;`
- **S3/CloudFront**: Custom error response 404 → /index.html
- **GitHub Pages**: `404.html` hack or hash-based routing

## Platform Deploy Commands

### Vercel
```bash
vercel --prod
# Auto-detects Vite/CRA/Next.js
# Preview deploys per branch
```

### Netlify
```bash
npm install -g netlify-cli
netlify deploy --prod --dir=dist
```

### Cloudflare Pages
```bash
npm install -g wrangler
wrangler pages deploy dist --project-name myapp
```

### S3 + CloudFront (AWS)
```bash
aws s3 sync dist/ s3://my-bucket --delete
aws cloudfront create-invalidation --distribution-id <ID> --paths "/*"
```

### VPS (scp)
```bash
npm run build
scp -r dist/* user@host:/var/www/myapp/
```

## Environment Variables

```
# .env.production
VITE_API_URL=https://api.example.com
VITE_APP_TITLE=My App
```

```tsx
// Usage
const apiUrl = import.meta.env.VITE_API_URL

// WARNING: Only VITE_ prefixed vars exposed to client
// NEVER put secrets in VITE_ vars
```

## Pre-Deploy Checklist
- [ ] `npm run build` succeeds
- [ ] `npm run preview` (Vite) works locally
- [ ] All environment variables set
- [ ] SPA routing configured for platform
- [ ] HTTPS configured
- [ ] CORS headers set if API on different domain
- [ ] Bundle analyzed (no accidental large deps)
