---
name: react-pipeline:server-setup
description: Use when deploying a React app or setting up a server — provisions VPS, configures Nginx reverse proxy, SSL certificates, domain DNS, and firewall rules.
---

# Server Setup for React Apps

## Core Principle
Choose the right hosting tier for the project size. Managed platforms for speed, VPS for control, cloud for scale.

## Hosting Decision Tree

```
App size? → Static SPA? → Vercel/Netlify/Cloudflare Pages (free tier)
         → Needs backend? → 
              Small (<50K/day)? → VPS ($4-6/mo Hetzner) + Nginx + PM2
              Medium? → Vercel + separate API serverless function
              Large? → AWS/Cloud infrastructure
```

## Option A: Managed Platform (Vercel)

```bash
npm install -g vercel
vercel login
vercel --prod
```

```js
// vercel.json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "X-Content-Type-Options", "value": "nosniff" }
      ]
    }
  ]
}
```

## Option B: VPS with Nginx

### Step 1: Provision VPS
```bash
# Hetzner / DigitalOcean / Linode
# Ubuntu 22.04 LTS, 1 vCPU, 1GB RAM ($4-6/mo)
ssh root@<vps-ip>

# First steps
apt update && apt upgrade -y
ufw allow 22/tcp && ufw allow 80/tcp && ufw allow 443/tcp && ufw enable
```

### Step 2: Install & Configure Nginx
```bash
apt install nginx certbot python3-certbot-nginx -y
```

```nginx
# /etc/nginx/sites-available/myapp
server {
    listen 80;
    server_name example.com www.example.com;

    root /var/www/myapp;
    index index.html;

    # SPA routing
    location / {
        try_files $uri $uri/ /index.html;
    }

    # API reverse proxy
    location /api/ {
        proxy_pass http://localhost:3001/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Gzip
    gzip on;
    gzip_types text/css application/javascript image/svg+xml;
}
```

### Step 3: SSL (Let's Encrypt)
```bash
certbot --nginx -d example.com -d www.example.com
# Auto-renewal: certbot renew --dry-run
```

### Step 4: Deploy Frontend
```bash
npm run build
scp -r dist/* root@<vps>:/var/www/myapp/
```

### Step 5: Start Backend (PM2)
```bash
npm install -g pm2
pm2 start dist/server.js --name api
pm2 save && pm2 startup
```

## Option C: Docker (see react-pipeline:docker-setup)

## Key Security Checklist
- [ ] SSL enabled (HTTPS only, redirect HTTP)
- [ ] Firewall: only 22, 80, 443 open
- [ ] Environment variables in `.env`, NOT committed
- [ ] API rate limiting configured
- [ ] Security headers set (X-Frame-Options, CSP, etc.)
