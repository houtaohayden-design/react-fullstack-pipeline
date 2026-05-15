---
name: react-pipeline:docker-setup
description: Use when containerizing a React app — Dockerfile for SPA, docker-compose for full stack, multi-stage builds, Nginx serving, and health checks.
---

# Docker for React Apps

## Core Principle
Multi-stage builds: build in Node stage, serve in Nginx stage. Final image is <50MB for SPA.

## React SPA Dockerfile

```dockerfile
# Dockerfile
# Stage 1: Build
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## Nginx Config for Docker

```nginx
# nginx.conf
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location /assets/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

## Docker Compose (Full Stack)

```yaml
# docker-compose.yml
services:
  frontend:
    build: ./frontend
    ports: ["80:80"]
    depends_on: [api]

  api:
    build: ./backend
    ports: ["3001:3001"]
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
    depends_on: [db]

  db:
    image: postgres:16-alpine
    volumes: [pgdata:/var/lib/postgresql/data]
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_DB=mydb

volumes:
  pgdata:
```

## Multi-Service Nginx (Single Domain)

```nginx
# nginx.conf — routes /api to backend, everything else to frontend
server {
    listen 80;

    location /api/ {
        proxy_pass http://api:3001/;
        proxy_set_header Host $host;
    }

    location / {
        proxy_pass http://frontend:80/;
    }
}
```

## Health Checks

```yaml
# docker-compose.yml
services:
  api:
    healthcheck:
      test: ["CMD", "wget", "--spider", "http://localhost:3001/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

## Commands

```bash
# Build & run
docker compose build
docker compose up -d
docker compose ps
docker compose logs -f

# Production
docker compose -f docker-compose.prod.yml up -d

# Cleanup
docker compose down -v
```
