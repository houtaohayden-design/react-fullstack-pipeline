---
name: react-pipeline:ci-cd
description: Use when setting up CI/CD pipelines for a React project — GitHub Actions workflows for lint, test, build, and deploy.
---

# CI/CD for React Projects

## Core Principle
Automate everything that happens between push and production: lint → test → build → deploy. Every PR gets a preview. Every merge to main deploys.

## Standard Workflow

```yaml
# .github/workflows/ci.yml
name: CI/CD
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: ['20.x', '22.x']
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck
      - run: npm run build
      - run: npm test
      - run: npm run test:e2e --if-present

  deploy:
    needs: quality
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22.x'
          cache: 'npm'
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/
      # Platform-specific deploy step follows
```

## Platform-Specific Deploy Steps

### Vercel
```yaml
- run: npx vercel --prod --token=${{ secrets.VERCEL_TOKEN }}
```

### S3 + CloudFront
```yaml
- uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1
- run: aws s3 sync dist/ s3://${{ secrets.S3_BUCKET }} --delete
- run: aws cloudfront create-invalidation --distribution-id ${{ secrets.CF_DISTRIBUTION }} --paths "/*"
```

### VPS (scp via SSH)
```yaml
- uses: appleboy/scp-action@v0
  with:
    host: ${{ secrets.VPS_HOST }}
    username: ${{ secrets.VPS_USER }}
    key: ${{ secrets.VPS_SSH_KEY }}
    source: "dist/*"
    target: "/var/www/myapp/"
```

## Preview Deploys (Per PR)

```yaml
preview:
  if: github.event_name == 'pull_request'
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4
      with: { node-version: '22.x', cache: 'npm' }
    - run: npm ci && npm run build
    - run: npx netlify deploy --dir=dist --alias="pr-${{ github.event.number }}"
```

## Required GitHub Secrets

```
VERCEL_TOKEN / NETLIFY_AUTH_TOKEN / AWS keys / VPS_SSH_KEY
DB_PASSWORD / API_KEYS
```

See `workflow-templates/` for reusable workflow `.yml` examples.
