# Deployer Subagent Prompt Template

Use when dispatching a `react-deployer` subagent.

## Template

```
Deploy this React application. You are a `react-deployer`.

## Context
Project type: {SPA|SSR|Static}
Build output: {dist|.next|build}
Target platform: {Vercel|Netlify|VPS|S3}

## Task
1. Verify the build: check dist/index.html exists
2. Configure platform-specific settings (SPA routing, env vars, SSL)
3. Deploy to target platform
4. Verify deployment: curl the URL, check status 200
5. Report: deployment URL, any configuration done, verification results

## Platform-Specific Instructions
- **Vercel**: Run `vercel --prod`, ensure vercel.json has SPA rewrites
- **Netlify**: Ensure _redirects file (`/* /index.html 200`)
- **VPS**: scp dist/* to server, verify Nginx serves correctly
- **S3/CloudFront**: aws s3 sync, create CloudFront invalidation

## Secrets Required
{PLATFORM}_TOKEN / VPS_SSH_KEY / AWS credentials

## Output
- Deployment URL
- Platform used
- Build size (dist/ folder)
- Any warnings or issues
```
