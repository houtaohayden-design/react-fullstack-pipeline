# Zod Backend Patterns

> Source: [colinhacks/zod](https://github.com/colinhacks/zod) — 34K+ stars
> Backend-focused validation patterns: route input validation, middleware integration, error response formatting, database write validation, auth, rate limiting, and file uploads.

## 1. Route Input Validation (Body, Query, Params)

### Define Input Schemas for Each Route

```ts
import { z } from 'zod'

// POST /api/users — create user
const CreateUserBody = z.object({
  email: z.string().email('Invalid email'),
  name: z.string().min(1, 'Name is required').max(100),
  role: z.enum(['user', 'admin']).default('user'),
})

// GET /api/users — list users with query params
const ListUsersQuery = z.object({
  page: z.coerce.number().int().positive().default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().optional(),
  sort: z.enum(['name', 'email', 'createdAt']).default('createdAt'),
  order: z.enum(['asc', 'desc']).default('asc'),
})

// GET /api/users/:id — get single user
const GetUserParams = z.object({
  id: z.string().uuid('Invalid user ID'),
})

// PUT /api/users/:id — update user
const UpdateUserBody = z.object({
  name: z.string().min(1).max(100).optional(),
  email: z.string().email().optional(),
  role: z.enum(['user', 'admin']).optional(),
}).refine((data) => Object.keys(data).length > 0, {
  message: 'At least one field must be provided',
})
```

### Generic Route Input Validator

```ts
type RouteSchemas = {
  body?: z.ZodTypeAny
  query?: z.ZodTypeAny
  params?: z.ZodTypeAny
}

function validateInput<T extends RouteSchemas>(data: {
  body: unknown
  query: unknown
  params: unknown
}, schemas: T): {
  body: T['body'] extends z.ZodTypeAny ? z.infer<T['body']> : undefined
  query: T['query'] extends z.ZodTypeAny ? z.infer<T['query']> : undefined
  params: T['params'] extends z.ZodTypeAny ? z.infer<T['params']> : undefined
} {
  const result = {
    body: schemas.body?.parse(data.body),
    query: schemas.query?.parse(data.query),
    params: schemas.params?.parse(data.params),
  }
  return result as any
}
```

## 2. Middleware Integration

### Hono zValidator

Hono has first-class Zod support via `@hono/zod-validator`:

```ts
import { Hono } from 'hono'
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'

const app = new Hono()

const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
})

// Middleware validates and sets typed context
app.post('/api/users',
  zValidator('json', createUserSchema),
  async (c) => {
    const data = c.req.valid('json')  // fully typed
    const user = await db.users.create(data)
    return c.json(user, 201)
  }
)

// Query validation
const searchSchema = z.object({
  q: z.string().min(1),
  page: z.coerce.number().int().positive().default(1),
})

app.get('/api/search',
  zValidator('query', searchSchema),
  (c) => {
    const { q, page } = c.req.valid('query')
    // validated and typed
  }
)

// Param validation
app.get('/api/users/:id',
  zValidator('param', z.object({ id: z.string().uuid() })),
  (c) => {
    const { id } = c.req.valid('param')
  }
)

// Custom error handling
app.onError((err, c) => {
  if (err instanceof z.ZodError) {
    return c.json({
      success: false,
      error: {
        message: 'Validation failed',
        details: err.issues,
      },
    }, 422)
  }
  // ... other error handlers
  return c.json({ success: false, error: 'Internal error' }, 500)
})
```

### Express Middleware

```ts
import { Request, Response, NextFunction } from 'express'
import { z, ZodError } from 'zod'

function validate<T extends z.ZodTypeAny>(
  schema: T,
  source: 'body' | 'query' | 'params' = 'body'
) {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      const data = schema.parse(req[source])
      req[source] = data  // replace with validated data
      next()
    } catch (err) {
      if (err instanceof ZodError) {
        res.status(422).json({
          success: false,
          error: {
            message: 'Validation failed',
            details: err.flatten().fieldErrors,
          },
        })
      } else {
        next(err)
      }
    }
  }
}

// Usage
app.post('/api/users', validate(CreateUserSchema), (req, res) => {
  const data = req.body  // fully typed and validated
  // ...
})

// Combined validators
app.get('/api/users',
  validate(ListUsersQuery, 'query'),
  (req, res) => {
    const { page, limit } = req.query  // typed
    // ...
  }
)
```

### Fastify + Zod

```ts
import Fastify from 'fastify'
import { z } from 'zod'

const fastify = Fastify()

fastify.post('/api/users', {
  schema: {
    body: CreateUserSchema,  // Fastify + Zod integration
    response: {
      201: UserResponseSchema,
    },
  },
}, async (request, reply) => {
  const user = await createUser(request.body)
  reply.status(201).send(user)
})
```

### Generic Zod Middleware Factory

```ts
function zodMiddleware<
  B extends z.ZodTypeAny,
  Q extends z.ZodTypeAny,
  P extends z.ZodTypeAny
>(schemas: {
  body?: B
  query?: Q
  params?: P
}) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const validated: any = {}
      if (schemas.body) validated.body = schemas.body.parse(req.body)
      if (schemas.query) validated.query = schemas.query.parse(req.query)
      if (schemas.params) validated.params = schemas.params.parse(req.params)

      Object.assign(req, validated)
      next()
    } catch (err) {
      if (err instanceof z.ZodError) {
        res.status(422).json(formatZodError(err))
      } else {
        next(err)
      }
    }
  }
}

// Usage
app.post('/api/posts/:categoryId',
  zodMiddleware({
    body: CreatePostSchema,
    params: z.object({ categoryId: z.string().uuid() }),
  }),
  handler
)
```

## 3. Error Response Formatting from ZodError

### Structured Validation Error Response

```ts
import { z } from 'zod'

interface ValidationErrorResponse {
  success: false
  error: {
    type: 'validation_error'
    message: string
    details: Array<{
      field: string
      code: string
      message: string
      params?: Record<string, any>
    }>
  }
}

function formatZodErrorResponse(error: z.ZodError): ValidationErrorResponse {
  return {
    success: false,
    error: {
      type: 'validation_error',
      message: 'Request validation failed',
      details: error.issues.map((issue) => ({
        field: issue.path.join('.'),
        code: issue.code,
        message: issue.message,
        params: extractIssueParams(issue),
      })),
    },
  }
}

function extractIssueParams(issue: z.ZodIssue): Record<string, any> | undefined {
  const { code, message, path, ...rest } = issue
  return Object.keys(rest).length > 0 ? rest : undefined
}
```

### Field-Level vs Form-Level Errors

```ts
function splitErrors(error: z.ZodError) {
  const fieldErrors = error.issues.filter((i) => i.path.length > 0)
  const formErrors = error.issues.filter((i) => i.path.length === 0)

  return {
    fieldErrors: fieldErrors.map((i) => ({
      field: i.path.join('.'),
      message: i.message,
    })),
    formErrors: formErrors.map((i) => i.message),
  }
}
```

### Error Middleware with Logging

```ts
function zodErrorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  if (err instanceof z.ZodError) {
    logger.warn('Validation failed', {
      path: req.path,
      method: req.method,
      issues: err.issues.length,
    })

    return res.status(422).json({
      success: false,
      error: {
        type: 'VALIDATION_ERROR',
        message: 'Invalid request data',
        details: err.issues.map((issue) => ({
          path: issue.path,
          code: issue.code,
          message: issue.message,
        })),
      },
    })
  }
  next(err)
}
```

## 4. Database Write Validation

### Insert Record Validation

```ts
const InsertUserSchema = z.object({
  email: z.string().email().max(255),
  name: z.string().min(1).max(100),
  passwordHash: z.string().length(60),  // bcrypt hash
  role: z.enum(['user', 'admin', 'moderator']).default('user'),
  metadata: z.record(z.unknown()).default({}),
})

async function createUser(input: unknown) {
  const data = InsertUserSchema.parse(input)

  // data is now guaranteed to match DB constraints
  const [user] = await db.insert(users).values(data).returning()
  return user
}
```

### Batch Insert Validation

```ts
const InsertUsersBatchSchema = z.array(InsertUserSchema).min(1).max(1000)

async function batchCreateUsers(input: unknown) {
  const users = InsertUsersBatchSchema.parse(input)
  return db.insert(usersTable).values(users).returning()
}
```

### Update Record Validation (partial)

```ts
const UpdateUserSchema = z.object({
  email: z.string().email().max(255).optional(),
  name: z.string().min(1).max(100).optional(),
  role: z.enum(['user', 'admin', 'moderator']).optional(),
}).refine(
  (data) => Object.keys(data).length > 0,
  { message: 'At least one field required for update' }
)
```

### Write-After-Read Validation

```ts
// Validate that read data matches expected schema before processing
const UserRecordSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  name: z.string(),
  role: z.enum(['user', 'admin']),
  createdAt: z.date(),
})

async function processUser(userId: string) {
  const raw = await db.select().from(users).where(eq(users.id, userId)).get()
  const user = UserRecordSchema.parse(raw)  // validate DB output

  // user is now fully typed
  return processUserLogic(user)
}
```

## 5. Auth Token Format Validation

### JWT Payload Validation

```ts
const JWTPayloadSchema = z.object({
  sub: z.string().uuid(),       // user ID
  email: z.string().email(),
  role: z.enum(['user', 'admin']),
  iat: z.number().int().positive(),
  exp: z.number().int().positive(),
})

function verifyToken(token: string): z.infer<typeof JWTPayloadSchema> {
  const decoded = jwt.verify(token, secret)
  return JWTPayloadSchema.parse(decoded)
}
```

### API Key Validation

```ts
const APIKeySchema = z.string().min(32).max(128).regex(/^[a-zA-Z0-9_-]+$/)

function validateApiKey(key: unknown): string {
  return APIKeySchema.parse(key)
}
```

### Auth Header Format

```ts
const AuthorizationHeader = z.string()
  .refine((val) => val.startsWith('Bearer '), {
    message: 'Authorization header must use Bearer scheme',
  })
  .transform((val) => val.slice(7))
  .pipe(z.string().min(1))

// Usage in middleware
const token = AuthorizationHeader.parse(req.headers.authorization)
```

### Session/Request Context Schema

```ts
const RequestContextSchema = z.object({
  userId: z.string().uuid(),
  email: z.string().email(),
  role: z.enum(['user', 'admin']),
  sessionId: z.string().uuid(),
  permissions: z.array(z.string()),
})

type RequestContext = z.infer<typeof RequestContextSchema>
```

## 6. Rate Limit Config Validation

```ts
const RateLimitConfigSchema = z.object({
  windowMs: z.number().int().positive(),          // time window in ms
  max: z.number().int().positive(),                // max requests per window
  standardHeaders: z.boolean().default(true),
  legacyHeaders: z.boolean().default(false),
  keyGenerator: z.function().optional(),
  handler: z.function().optional(),
})

const RateLimitRuleSchema = z.object({
  endpoint: z.string(),
  method: z.enum(['GET', 'POST', 'PUT', 'DELETE', 'PATCH']),
  windowMs: z.number().int().positive(),
  max: z.number().int().positive(),
})

const RateLimitConfig = z.array(RateLimitRuleSchema).min(1)
```

## 7. File Upload Validation

### File Metadata Schema

```ts
const FileUploadSchema = z.object({
  fieldname: z.string(),
  originalname: z.string().min(1),
  encoding: z.string(),
  mimetype: z.string().refine(
    (type) => [
      'image/jpeg',
      'image/png',
      'image/webp',
      'image/gif',
      'application/pdf',
      'text/plain',
    ].includes(type),
    { message: 'Unsupported file type' }
  ),
  size: z.number().int().positive().max(10 * 1024 * 1024, 'File too large (max 10MB)'),
  buffer: z.instanceof(Buffer),
})

// Image-specific schema
const ImageUploadSchema = FileUploadSchema.extend({
  mimetype: z.enum([
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
  ]),
  size: z.number().max(5 * 1024 * 1024, 'Image too large (max 5MB)'),
})

// Multiple files
const MultiFileUploadSchema = z.array(FileUploadSchema).min(1).max(10)
```

### Image Dimensions Validation (requires image-size)

```ts
import sizeOf from 'image-size'

const ImageDimensionsSchema = z.object({
  width: z.number().int().positive().max(4096),
  height: z.number().int().positive().max(4096),
})

function validateImageDimensions(file: Buffer, maxWidth: number, maxHeight: number) {
  const dimensions = sizeOf(file)
  return ImageDimensionsSchema.parse(dimensions)
}
```

### CSV Upload Validation

```ts
const CSVUploadSchema = z.object({
  fieldname: z.string(),
  originalname: z.string().endsWith('.csv', 'Must be a CSV file'),
  mimetype: z.literal('text/csv'),
  size: z.number().max(50 * 1024 * 1024, 'CSV too large (max 50MB)'),
})

// Validate CSV row schema
const CSVRowSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
  amount: z.coerce.number().positive(),
})

async function processCSV(file: Buffer) {
  const rows = parse(file.toString())
  return z.array(CSVRowSchema).parse(rows)
}
```

## 8. Webhook Payload Validation

```ts
const StripeWebhookSchema = z.object({
  id: z.string(),
  type: z.string(),
  data: z.object({
    object: z.record(z.unknown()),
  }),
  created: z.number(),
  api_version: z.string().nullable().optional(),
})

function handleStripeWebhook(rawBody: string, signature: string) {
  // 1. Verify signature
  const event = stripe.webhooks.constructEvent(rawBody, signature, webhookSecret)

  // 2. Validate event shape
  const validated = StripeWebhookSchema.parse(event)

  // 3. Route to handler based on event type
  switch (validated.type) {
    case 'payment_intent.succeeded':
      return handlePaymentSuccess(validated.data.object)
    // ...
  }
}
```

## 9. Message Queue / Event Validation

```ts
const OrderCreatedEvent = z.object({
  type: z.literal('order.created'),
  payload: z.object({
    orderId: z.string().uuid(),
    userId: z.string().uuid(),
    amount: z.number().positive(),
    items: z.array(z.object({
      productId: z.string().uuid(),
      quantity: z.number().int().positive(),
      price: z.number().positive(),
    })),
  }),
  metadata: z.object({
    timestamp: z.string().datetime(),
    correlationId: z.string().uuid(),
  }),
})

// Validate in message handler
async function handleMessage(raw: unknown) {
  const event = OrderCreatedEvent.parse(raw)
  // event is fully typed
  await processOrder(event.payload)
}
```

## 10. Configuration/AWS Secrets Validation

```ts
const ServiceConfigSchema = z.object({
  redis: z.string().url(),
  postgres: z.string().url(),
  openaiApiKey: z.string().startsWith('sk-'),
  stripeSecretKey: z.string().startsWith('sk_live_').or(z.string().startsWith('sk_test_')),
  maxWorkers: z.coerce.number().int().positive().default(4),
})

// Parse config at service startup
async function loadConfig() {
  const secrets = await loadSecretsFromAWS()
  return ServiceConfigSchema.parse(secrets)
}
```
