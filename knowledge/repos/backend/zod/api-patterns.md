# Zod API Design Patterns

> Source: [colinhacks/zod](https://github.com/colinhacks/zod) — 34K+ stars
> API design with Zod: request/response schemas, OpenAPI generation, contract testing, versioned APIs, and client generation.

## 1. Request Schema Patterns

### Standard CRUD Schemas

```ts
import { z } from 'zod'

// Create — all required fields
const CreateProductSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().max(5000).optional(),
  price: z.number().positive().multipleOf(0.01),
  categories: z.array(z.string()).min(1),
  published: z.boolean().default(false),
})

// Update — all fields optional, at least one required
const UpdateProductSchema = z.object({
  name: z.string().min(1).max(200).optional(),
  description: z.string().max(5000).optional().nullable(),
  price: z.number().positive().multipleOf(0.01).optional(),
  categories: z.array(z.string()).min(1).optional(),
  published: z.boolean().optional(),
}).refine(
  (data) => Object.keys(data).length > 0,
  { message: 'At least one field required' }
)

// Query — filtering, sorting, pagination
const ListProductsQuery = z.object({
  page: z.coerce.number().int().positive().default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().optional(),
  category: z.string().optional(),
  minPrice: z.coerce.number().nonnegative().optional(),
  maxPrice: z.coerce.number().positive().optional(),
  sort: z.enum(['name', 'price', 'createdAt']).default('createdAt'),
  order: z.enum(['asc', 'desc']).default('desc'),
  published: z.enum(['true', 'false', 'all']).default('all'),
})

// Params — ID validation
const ProductParams = z.object({
  id: z.string().uuid('Invalid product ID'),
})
```

### Bulk Operations Schema

```ts
const BulkDeleteSchema = z.object({
  ids: z.array(z.string().uuid()).min(1).max(100),
})

const BulkUpdateSchema = z.object({
  ids: z.array(z.string().uuid()).min(1).max(100),
  changes: z.object({
    category: z.string().optional(),
    published: z.boolean().optional(),
    tags: z.array(z.string()).optional(),
  }),
})
```

## 2. Response Schema Patterns

### Standard Response Envelope

```ts
function ApiResponse<T extends z.ZodTypeAny>(dataSchema: T) {
  return z.object({
    success: z.literal(true),
    data: dataSchema,
  })
}

function ApiErrorResponse() {
  return z.object({
    success: z.literal(false),
    error: z.object({
      code: z.string(),
      message: z.string(),
      details: z.array(z.object({
        field: z.string().optional(),
        message: z.string(),
      })).optional(),
    }),
  })
}

// Full response type
const GetUserResponse = z.discriminatedUnion('success', [
  ApiResponse(UserSchema),
  ApiErrorResponse(),
])
```

### Paginated Response

```ts
function PaginatedResponse<T extends z.ZodTypeAny>(itemSchema: T) {
  return z.object({
    success: z.literal(true),
    data: z.array(itemSchema),
    pagination: z.object({
      page: z.number().int().positive(),
      limit: z.number().int().positive(),
      total: z.number().int().nonnegative(),
      totalPages: z.number().int().nonnegative(),
      hasNext: z.boolean(),
      hasPrev: z.boolean(),
    }),
  })
}

// Usage
const ListUsersResponse = PaginatedResponse(UserSchema)
type ListUsersResponse = z.infer<typeof ListUsersResponse>
```

### Resource Response (with links)

```ts
function ResourceResponse<T extends z.ZodTypeAny>(dataSchema: T) {
  return z.object({
    data: dataSchema,
    _links: z.object({
      self: z.string().url(),
    }).and(z.record(z.string().url())).optional(),
  })
}
```

### Nested/Expanded Response

```ts
const UserWithPostsResponse = UserSchema.extend({
  posts: z.array(PostSchema),
  _count: z.object({
    posts: z.number().int(),
    followers: z.number().int(),
  }),
})
```

## 3. Discriminated Unions for API Design

### Error Variants Pattern

```ts
const ValidationErrorResponse = z.object({
  type: z.literal('validation_error'),
  fields: z.record(z.array(z.string())),
})

const AuthenticationErrorResponse = z.object({
  type: z.literal('authentication_error'),
  message: z.string(),
})

const AuthorizationErrorResponse = z.object({
  type: z.literal('authorization_error'),
  requiredPermission: z.string(),
})

const NotFoundErrorResponse = z.object({
  type: z.literal('not_found'),
  resource: z.string(),
  id: z.string(),
})

const RateLimitErrorResponse = z.object({
  type: z.literal('rate_limit'),
  retryAfter: z.number(),
})

const ServerErrorResponse = z.object({
  type: z.literal('server_error'),
  requestId: z.string(),
})

const ErrorResponse = z.discriminatedUnion('type', [
  ValidationErrorResponse,
  AuthenticationErrorResponse,
  AuthorizationErrorResponse,
  NotFoundErrorResponse,
  RateLimitErrorResponse,
  ServerErrorResponse,
])

type ErrorResponse = z.infer<typeof ErrorResponse>

// Handle errors by type
function handleError(error: ErrorResponse) {
  switch (error.type) {
    case 'validation_error': return formatValidationError(error.fields)
    case 'authentication_error': return redirectToLogin()
    case 'authorization_error': return showForbidden(error.requiredPermission)
    case 'not_found': return showNotFound(error.resource)
    case 'rate_limit': return showRateLimit(error.retryAfter)
    case 'server_error': return showServerError(error.requestId)
  }
}
```

### API Response Status Pattern

```ts
// Union of all possible states for an async operation
const LoadingState = z.object({ status: z.literal('loading') })
const EmptyState = z.object({ status: z.literal('empty') })
const SuccessState = <T extends z.ZodTypeAny>(dataSchema: T) =>
  z.object({ status: z.literal('success'), data: dataSchema })
const ErrorState = z.object({ status: z.literal('error'), message: z.string() })

function AsyncState<T extends z.ZodTypeAny>(dataSchema: T) {
  return z.discriminatedUnion('status', [
    LoadingState,
    EmptyState,
    SuccessState(dataSchema),
    ErrorState,
  ])
}
```

## 4. OpenAPI / Swagger Generation

### zod-to-openapi Pattern (with @asteasolutions/zod-to-openapi)

```ts
import { z } from 'zod'
import { extendZodWithOpenApi } from '@asteasolutions/zod-to-openapi'

extendZodWithOpenApi(z)

// Define schemas with OpenAPI metadata
const UserSchema = z.object({
  id: z.string().uuid().openapi({ example: 'f47ac10b-58cc-4372-a567-0e02b2c3d479' }),
  email: z.string().email().openapi({ example: 'user@example.com', format: 'email' }),
  name: z.string().min(1).max(100).openapi({ example: 'John Doe' }),
  role: z.enum(['user', 'admin']).openapi({ example: 'user' }),
  createdAt: z.string().datetime().openapi({ example: '2024-01-01T00:00:00Z' }),
}).openapi({ ref: 'User' })

// Register schemas
const registry = new OpenAPIRegistry()
registry.register('User', UserSchema)

// Define route with full OpenAPI spec
registry.registerPath({
  method: 'get',
  path: '/api/users/{id}',
  description: 'Get a user by ID',
  tags: ['Users'],
  request: {
    params: z.object({ id: z.string().uuid().openapi({ param: { name: 'id', in: 'path' } }) }),
  },
  responses: {
    200: {
      description: 'User found',
      content: { 'application/json': { schema: UserSchema } },
    },
    404: {
      description: 'User not found',
      content: { 'application/json': { schema: ErrorSchema } },
    },
  },
})

// Generate OpenAPI document
const generator = new OpenApiGeneratorV3(registry.definitions)
const document = generator.generateDocument({ /* ... */ })
```

### Manual JSON Schema Comments (For Documentation)

```ts
const CreateUserSchema = z.object({
  email: z.string()
    .email()
    .describe('User email address for login and notifications'),
  name: z.string()
    .min(1)
    .max(100)
    .describe('Display name shown to other users'),
  role: z.enum(['user', 'admin'])
    .default('user')
    .describe('User permission level: "user" for normal accounts, "admin" for administrators'),
  newsletter: z.boolean()
    .default(false)
    .describe('Whether the user opted in to marketing emails'),
}).describe('Payload for creating a new user account')

// The .describe() calls become JSON Schema descriptions
const jsonSchema = CreateUserSchema.toJSONSchema()
```

## 5. Contract Testing with Zod Schemas

### Consumer-Driven Contract Testing

```ts
// Shared contract package (@myorg/api-contracts)
import { z } from 'zod'

export const UserContract = {
  create: {
    body: z.object({
      email: z.string().email(),
      name: z.string().min(1),
    }),
    response: z.object({
      id: z.string().uuid(),
      email: z.string().email(),
      name: z.string(),
      createdAt: z.string().datetime(),
    }),
  },
  getById: {
    params: z.object({ id: z.string().uuid() }),
    response: z.object({
      id: z.string().uuid(),
      email: z.string().email(),
      name: z.string(),
      role: z.enum(['user', 'admin']),
    }),
  },
}
```

### Testing the Contract (Provider Side)

```ts
import { UserContract } from '@myorg/api-contracts'
import { app } from '../app'

test('POST /api/users returns valid CreateUser response', async () => {
  const response = await app.inject({
    method: 'POST',
    url: '/api/users',
    payload: { email: 'test@example.com', name: 'Test User' },
  })

  expect(response.statusCode).toBe(201)

  const body = JSON.parse(response.payload)
  const result = UserContract.create.response.safeParse(body)
  expect(result.success).toBe(true)
})
```

### Testing the Contract (Consumer Side)

```ts
import { UserContract } from '@myorg/api-contracts'

test('API client returns valid CreateUser data', async () => {
  // Mock the network response
  mockFetch({
    id: 'abc-123',
    email: 'new@example.com',
    name: 'New User',
    createdAt: '2024-01-01T00:00:00Z',
  })

  const result = await apiClient.createUser({
    email: 'new@example.com',
    name: 'New User',
  })

  // Verify the parsed result matches the contract
  const validated = UserContract.create.response.parse(result)
  expect(validated.email).toBe('new@example.com')
})
```

### Snapshot Testing API Responses

```ts
test('GET /api/users/:id response shape', async () => {
  const response = await app.inject({
    method: 'GET',
    url: '/api/users/test-user-id',
  })

  const body = JSON.parse(response.payload)

  // Snapshot the response shape
  const shape = inferShape(body)  // { id: 'string', email: 'string', ... }
  expect(shape).toMatchSnapshot()
})

// Helper: infer the shape of an object (types, not values)
function inferShape(obj: unknown) {
  return JSON.stringify(obj, (_, value) => {
    if (value === null) return 'null'
    return Array.isArray(value) ? ['array'] : typeof value
  })
}
```

## 6. Versioned API Schemas

### Discriminated Union for API Versions

```ts
// v1 schema
const UserV1 = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  name: z.string(),
})

// v2 schema — added role and avatar
const UserV2 = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  name: z.string(),
  role: z.enum(['user', 'admin']),
  avatar: z.string().url().nullable(),
})

// v3 schema — renamed name to displayName
const UserV3 = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  displayName: z.string(),
  role: z.enum(['user', 'admin']),
  avatar: z.string().url().nullable(),
  createdAt: z.string().datetime(),
})

// Route by version
function getUserSchema(version: string) {
  switch (version) {
    case 'v1': return UserV1
    case 'v2': return UserV2
    case 'v3': return UserV3
    default: throw new Error(`Unsupported API version: ${version}`)
  }
}
```

### Versioned Response with Transform

```ts
// Internal schema (latest version)
const CurrentUserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  displayName: z.string(),
  role: z.enum(['user', 'admin']),
  avatar: z.string().url().nullable(),
  createdAt: z.date(),
})

// Transform to specific API version
function toUserV1(user: z.infer<typeof CurrentUserSchema>) {
  return {
    id: user.id,
    email: user.email,
    name: user.displayName,  // backward-compat mapping
  }
}

function toUserV2(user: z.infer<typeof CurrentUserSchema>) {
  return {
    id: user.id,
    email: user.email,
    name: user.displayName,
    role: user.role,
    avatar: user.avatar,
  }
}
```

### Version Negotiation Header

```ts
const ApiVersionSchema = z.enum(['2024-01-01', '2024-06-01', '2025-01-01'])

function parseApiVersion(headers: Record<string, string | undefined>): string {
  const version = headers['x-api-version'] || '2025-01-01'
  return ApiVersionSchema.parse(version)
}
```

## 7. Client Generation from Zod Schemas

### Type-Safe Fetch Wrapper

```ts
function createApiClient<T extends Record<string, {
  body?: z.ZodTypeAny
  query?: z.ZodTypeAny
  params?: z.ZodTypeAny
  response: z.ZodTypeAny
}>>(baseUrl: string, routes: T) {
  return {
    async call<K extends keyof T>(
      route: K,
      options: {
        body?: T[K] extends { body: z.ZodTypeAny } ? z.infer<Extract<T[K], { body: any }>['body']> : never
        query?: T[K] extends { query: z.ZodTypeAny } ? z.infer<Extract<T[K], { query: any }>['query']> : never
        params?: T[K] extends { params: z.ZodTypeAny } ? z.infer<Extract<T[K], { params: any }>['params']> : never
      }
    ): Promise<z.infer<T[K]['response']>> {
      // Build URL with params
      let url = `${baseUrl}${String(route)}`

      // Validate and send
      let body: string | undefined
      if ('body' in options) {
        const def = routes[route] as any
        body = JSON.stringify(def.body!.parse(options.body))
      }

      const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body,
      })

      const json = await response.json()
      return routes[route].response.parse(json)
    },
  }
}

// Define routes
const apiRoutes = {
  '/api/users': {
    body: CreateUserSchema,
    response: UserResponseSchema,
  },
  '/api/users/search': {
    query: UserSearchQuerySchema,
    response: UserSearchResponseSchema,
  },
}

const api = createApiClient('https://api.example.com', apiRoutes)

// Fully typed API calls
const user = await api.call('/api/users', {
  body: { email: 'a@b.com', name: 'Alice', role: 'user' },
})
// user is typed as z.infer<typeof UserResponseSchema>
```

### Zod Schema to tRPC Router

```ts
import { initTRPC } from '@trpc/server'
import { z } from 'zod'

const t = initTRPC.create()

export const userRouter = t.router({
  create: t.procedure
    .input(z.object({
      email: z.string().email(),
      name: z.string().min(1).max(100),
    }))
    .output(z.object({
      id: z.string().uuid(),
      email: z.string().email(),
      name: z.string(),
      createdAt: z.date(),
    }))
    .mutation(async ({ input }) => {
      // input is validated and typed
      return createUser(input)
    }),

  list: t.procedure
    .input(z.object({
      page: z.number().int().positive().default(1),
      limit: z.number().int().min(1).max(100).default(20),
    }))
    .output(z.object({
      data: z.array(UserSchema),
      total: z.number().int(),
    }))
    .query(async ({ input }) => {
      return listUsers(input)
    }),
})
```

## 8. Schema Testing Patterns

### Schema Behavior Tests

```ts
describe('CreateUserSchema', () => {
  test('accepts valid user input', () => {
    const result = CreateUserSchema.safeParse({
      email: 'user@example.com',
      name: 'Alice',
    })
    expect(result.success).toBe(true)
  })

  test('rejects invalid email', () => {
    const result = CreateUserSchema.safeParse({
      email: 'not-an-email',
      name: 'Alice',
    })
    expect(result.success).toBe(false)
    if (!result.success) {
      expect(result.error.issues[0].path).toEqual(['email'])
    }
  })

  test('rejects missing required fields', () => {
    const result = CreateUserSchema.safeParse({})
    expect(result.success).toBe(false)
    if (!result.success) {
      const paths = result.error.issues.map((i) => i.path[0])
      expect(paths).toContain('email')
      expect(paths).toContain('name')
    }
  })

  test('coerces string number to number', () => {
    const schema = z.object({
      age: z.coerce.number().int().positive(),
    })
    const result = schema.safeParse({ age: '25' })
    expect(result.success).toBe(true)
    expect(result.data?.age).toBe(25)
  })
})
```

### Schema Equivalence Testing

```ts
test('v1 and v2 user schemas are compatible on common fields', () => {
  // v2 should accept all valid v1 inputs
  const v1ValidInput = { id: 'uuid', email: 'a@b.com', name: 'Alice' }

  expect(UserV2.safeParse(v1ValidInput).success).toBe(true)
})
```

## 9. Schema Documentation Generation

### Auto-document schemas with .describe()

```ts
// Use .describe() everywhere for self-documenting schemas
const ProductSchema = z.object({
  id: z.string().uuid().describe('Unique product identifier'),
  sku: z.string().min(3).max(20).describe('Stock keeping unit code'),
  name: z.string().min(1).max(200).describe('Product display name'),
  price: z.number()
    .positive()
    .multipleOf(0.01)
    .describe('Product price in USD, must be positive with max 2 decimal places'),
  inventory: z.object({
    available: z.number().int().nonnegative().describe('Units available for purchase'),
    reserved: z.number().int().nonnegative().describe('Units reserved by pending orders'),
  }).describe('Real-time inventory counts'),
  attributes: z.record(z.string()).describe('Custom key-value product attributes'),
  tags: z.array(z.string().min(1).max(50)).describe('SEO and filtering tags'),
  status: z.enum(['draft', 'published', 'archived', 'discontinued'])
    .describe('Product lifecycle status'),
  createdAt: z.date().describe('When the product was first created'),
  updatedAt: z.date().describe('When the product was last modified'),
})
```

### Generate Markdown Docs from Schema

```ts
function schemaToMarkdown(schema: z.ZodObject<any>): string {
  const shape = schema.shape
  let md = '| Field | Type | Required | Description |\n'
  md += '|-------|------|----------|-------------|\n'

  for (const [key, field] of Object.entries(shape)) {
    const zodField = field as z.ZodTypeAny
    const isOptional = zodField.isOptional()
    const isNullable = zodField.isNullable()
    const desc = zodField.description || '-'
    const type = getZodTypeName(zodField)

    md += `| ${key} | ${type} | ${!isOptional ? 'Yes' : 'No'} | ${desc} |\n`
  }

  return md
}

function getZodTypeName(schema: z.ZodTypeAny): string {
  const def = (schema as any)._def
  const typeName = def.typeName

  const typeNames: Record<string, string> = {
    ZodString: 'string',
    ZodNumber: 'number',
    ZodBoolean: 'boolean',
    ZodArray: 'array',
    ZodObject: 'object',
    ZodEnum: 'enum',
    ZodDate: 'Date',
    ZodNullable: `${getZodTypeName(def.innerType)} \| null`,
    ZodOptional: `${getZodTypeName(def.innerType)}?`,
    ZodEffects: getZodTypeName(def.schema),
    ZodBranded: getZodTypeName(def.type),
  }

  return typeNames[typeName] || typeName
}
```
