# Zod Patterns

> Source: [colinhacks/zod](https://github.com/colinhacks/zod) — 34K+ stars
> Common patterns for using Zod across the stack — form validation, API validation, env vars, discriminated unions, error handling, i18n, and TypeScript integration.

## 1. Form Validation (react-hook-form + Zod)

The most common frontend pattern. `@hookform/resolvers` provides the Zod bridge:

```tsx
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const SignUpSchema = z.object({
  email: z.string().email('Invalid email'),
  password: z.string().min(8, 'Minimum 8 characters'),
  confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
  message: "Passwords don't match",
  path: ['confirmPassword'],
})

type SignUpForm = z.infer<typeof SignUpSchema>

function SignUp() {
  const { register, handleSubmit, formState: { errors } } = useForm<SignUpForm>({
    resolver: zodResolver(SignUpSchema),
  })

  const onSubmit = (data: SignUpForm) => {
    // data is fully typed and validated
    api.signUp(data)
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email')} />
      {errors.email && <span>{errors.email.message}</span>}
      {/* ... */}
    </form>
  )
}
```

### Form Refinement Pattern (cross-field validation)

```ts
const PasswordResetSchema = z.object({
  password: z.string().min(8),
  confirm: z.string(),
}).superRefine(({ password, confirm }, ctx) => {
  if (password !== confirm) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'Passwords do not match',
      path: ['confirm'],
    })
  }
})
```

### Multi-step Form with Zod

```ts
// Separate schemas for each step, composed into a final one
const Step1Schema = z.object({ email: z.string().email() })
const Step2Schema = z.object({ name: z.string().min(1) })
const Step3Schema = z.object({ role: z.enum(['admin', 'user']) })

const FullSchema = Step1Schema.merge(Step2Schema).merge(Step3Schema)

// Validate incrementally
async function validateStep(step: number, data: unknown) {
  const schema = [Step1Schema, Step2Schema, Step3Schema][step]
  return schema.safeParse(data)
}
```

## 2. API Request/Response Validation

### Generic API Client with Validation

```ts
import { z } from 'zod'

async function fetchValidated<T extends z.ZodTypeAny>(
  url: string,
  schema: T,
  init?: RequestInit
): Promise<z.infer<T>> {
  const response = await fetch(url, init)
  const data = await response.json()

  const result = schema.safeParse(data)
  if (!result.success) {
    console.error('API response validation failed:', result.error.flatten())
    throw new Error('Invalid API response')
  }
  return result.data
}

// Usage
const UserSchema = z.object({ id: z.string(), name: z.string() })
const user = await fetchValidated('/api/user/1', UserSchema)
// user is typed as { id: string; name: string }
```

### tRPC-style Input/Output Contracts

```ts
// Define schemas once, derive types
const CreateUserInput = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
})

const CreateUserOutput = z.object({
  id: z.string(),
  email: z.string().email(),
  createdAt: z.string().datetime(),
})

type CreateUserInput = z.infer<typeof CreateUserInput>
type CreateUserOutput = z.infer<typeof CreateUserOutput>

// Use in route handler
app.post('/api/users', async (req, res) => {
  const input = CreateUserInput.parse(req.body)
  const user = await db.users.create(input)
  res.json(CreateUserOutput.parse(user))
})
```

## 3. Environment Variable Validation

Zod is the de facto standard for validating `process.env`:

```ts
const EnvSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']),
  PORT: z.coerce.number().int().positive().default(3000),
  DATABASE_URL: z.string().url(),
  REDIS_URL: z.string().url().optional(),
  JWT_SECRET: z.string().min(32),
  API_RATE_LIMIT: z.coerce.number().int().positive().default(100),
  CORS_ORIGIN: z.string().default('http://localhost:3000'),
  LOG_LEVEL: z.enum(['debug', 'info', 'warn', 'error']).default('info'),
  SENTRY_DSN: z.string().url().optional(),
})

// Parse once at startup
const env = EnvSchema.parse(process.env)

// Type-safe env object
export { env }
```

### Env Validation Pattern with Fail-Fast

```ts
function loadEnv<T extends z.ZodTypeAny>(schema: T): z.infer<T> {
  const result = schema.safeParse(process.env)
  if (!result.success) {
    console.error('Invalid environment variables:')
    console.error(result.error.flatten().fieldErrors)
    process.exit(1)
  }
  return result.data
}
```

### Env with Transformations

```ts
const ConfigSchema = z.object({
  FEATURE_FLAGS: z.string().transform((str) => str.split(',')),
  DATABASE_URL: z.string().url().transform((url) => {
    // Add pooling if not present
    return url.includes('?') ? url : `${url}?connection_limit=20`
  }),
})
```

## 4. Database Schema to Zod Mapping

### Drizzle ORM + Zod Pattern

```ts
import { pgTable, text, integer, timestamp } from 'drizzle-orm/pg-core'
import { createInsertSchema, createSelectSchema } from 'drizzle-zod'

// Drizzle schema
export const users = pgTable('users', {
  id: text('id').primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name').notNull(),
  age: integer('age'),
  createdAt: timestamp('created_at').notNull().defaultNow(),
})

// Auto-generated Zod schemas
export const InsertUserSchema = createInsertSchema(users)
export const SelectUserSchema = createSelectSchema(users)

// Or manually (full control):
const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  name: z.string().min(1).max(100),
  age: z.number().int().positive().nullable(),
  createdAt: z.date(),
})
```

### Prisma + Zod Pattern

```ts
import { z } from 'zod'

// Define Zod schemas aligned with Prisma models
const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  role: z.enum(['USER', 'ADMIN']).default('USER'),
})

// Use with Prisma
async function createUser(input: unknown) {
  const data = CreateUserSchema.parse(input)
  return prisma.user.create({ data })
}
```

### Knex/Objection + Zod Pattern

```ts
const UserRecordSchema = z.object({
  id: z.number().int().positive(),
  email: z.string().email(),
  name: z.string(),
  role: z.enum(['user', 'admin']),
  created_at: z.date(),
  updated_at: z.date(),
})

// Partial schema for inserts
const InsertUserSchema = UserRecordSchema.pick({
  email: true, name: true, role: true,
})

// Partial schema for updates
const UpdateUserSchema = InsertUserSchema.partial()
```

## 5. Discriminated Unions for API Responses

The quintessential Zod pattern for typed API responses:

```ts
// Define each response variant
const SuccessResponse = z.object({
  type: z.literal('success'),
  data: z.object({
    id: z.string(),
    name: z.string(),
  }),
})

const ErrorResponse = z.object({
  type: z.literal('error'),
  error: z.object({
    code: z.string(),
    message: z.string(),
  }),
})

const PendingResponse = z.object({
  type: z.literal('pending'),
  taskId: z.string(),
})

// Discriminated union on 'type' field
const ApiResponse = z.discriminatedUnion('type', [
  SuccessResponse,
  ErrorResponse,
  PendingResponse,
])

type ApiResponse = z.infer<typeof ApiResponse>

// Type-safe handling
async function handleResponse(response: ApiResponse) {
  switch (response.type) {
    case 'success':
      console.log(response.data.name)  // fully typed
      break
    case 'error':
      console.error(response.error.code)
      break
    case 'pending':
      pollTask(response.taskId)
      break
  }
}
```

### Event/Message Pattern

```ts
const UserCreated = z.object({ event: z.literal('user.created'), id: z.string(), email: z.string() })
const UserDeleted = z.object({ event: z.literal('user.deleted'), id: z.string() })
const UserUpdated = z.object({ event: z.literal('user.updated'), id: z.string(), changes: z.record(z.unknown()) })

const UserEvent = z.discriminatedUnion('event', [UserCreated, UserDeleted, UserUpdated])
type UserEvent = z.infer<typeof UserEvent>
```

## 6. Error Formatting & i18n

### Custom Error Map for i18n

```ts
import { z } from 'zod'

// Global error map with i18n
const i18nErrorMap: z.ZodErrorMap = (issue, ctx) => {
  switch (issue.code) {
    case z.ZodIssueCode.invalid_type:
      return { message: `Expected ${issue.expected}, received ${issue.received}` }
    case z.ZodIssueCode.too_small:
      if (issue.type === 'string') {
        return { message: `Must be at least ${issue.minimum} characters` }
      }
      return { message: `Must be greater than or equal to ${issue.minimum}` }
    case z.ZodIssueCode.too_big:
      return { message: `Must be less than or equal to ${issue.maximum}` }
    case z.ZodIssueCode.custom:
      return { message: issue.message ?? 'Invalid input' }
    default:
      return { message: ctx.defaultError }
  }
}

z.setErrorMap(i18nErrorMap)
```

### ZodError to Form Errors (flat format)

```ts
function zodErrorToFormErrors(error: z.ZodError): Record<string, string> {
  const flattened = error.flatten()
  const result: Record<string, string> = {}

  for (const [field, messages] of Object.entries(flattened.fieldErrors)) {
    if (messages && messages.length > 0) {
      result[field] = messages[0]  // take first error per field
    }
  }

  return result
}

// Usage in form handler
try {
  CreateUserSchema.parse(req.body)
} catch (err) {
  if (err instanceof z.ZodError) {
    return res.status(422).json({ errors: zodErrorToFormErrors(err) })
  }
}
```

### Locale Support (Built-in)

Zod v4 includes built-in locale translations for 50+ languages:

```ts
import { z } from 'zod'
import { en } from 'zod/locales/en'
import { es } from 'zod/locales/es'
import { zhCN } from 'zod/locales/zh-CN'

// Use per-parse
z.string().email().safeParse(data, { locale: es })

// Or globally
z.setLocale(es)
```

### Structured Error Response (API)

```ts
function formatZodError(error: z.ZodError) {
  return {
    success: false as const,
    error: {
      message: 'Validation failed',
      details: error.issues.map((issue) => ({
        field: issue.path.join('.'),
        code: issue.code,
        message: issue.message,
      })),
    },
  }
}
```

## 7. Schema Composition & Reuse

### Extract Shared Fields (Base Schemas)

```ts
// Base schema with shared fields
const TimestampMixin = z.object({
  createdAt: z.date(),
  updatedAt: z.date(),
})

const SoftDeleteMixin = z.object({
  deletedAt: z.date().nullable(),
})

// Compose into domain schemas
const User = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  name: z.string(),
}).merge(TimestampMixin).merge(SoftDeleteMixin)

const Product = z.object({
  id: z.string().uuid(),
  sku: z.string(),
  price: z.number().positive(),
}).merge(TimestampMixin)
```

### Schema Factory Pattern

```ts
// Reusable parameterized schemas
function PaginatedSchema<T extends z.ZodTypeAny>(itemSchema: T) {
  return z.object({
    data: z.array(itemSchema),
    meta: z.object({
      total: z.number().int().nonnegative(),
      page: z.number().int().positive(),
      limit: z.number().int().positive(),
      totalPages: z.number().int().nonnegative(),
    }),
  })
}

const User = z.object({ id: z.string(), name: z.string() })
const PaginatedUsers = PaginatedSchema(User)
type PaginatedUsers = z.infer<typeof PaginatedUsers>
```

### Conditional Schema with Union

```ts
// Different schemas based on user role
const AdminCreateUser = z.object({
  role: z.literal('admin'),
  email: z.string().email(),
  permissions: z.array(z.string()),
})

const RegularCreateUser = z.object({
  role: z.literal('user'),
  email: z.string().email(),
  name: z.string(),
})

const CreateUserSchema = z.discriminatedUnion('role', [
  AdminCreateUser,
  RegularCreateUser,
])
```

### Schema Inheritance (intersection)

```ts
const Entity = z.object({ id: z.string(), createdAt: z.date() })
const WithOwner = z.object({ ownerId: z.string() })

const Document = Entity.and(WithOwner).and(
  z.object({ title: z.string(), content: z.string() })
)
```

## 8. TypeScript Integration Patterns

### Single Source of Truth (Schema = Types)

```ts
// Define schema once — types are derived
const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  profile: z.object({
    name: z.string(),
    avatar: z.string().url().nullable(),
  }),
})

type User = z.infer<typeof UserSchema>
type UserProfile = z.infer<typeof UserSchema.shape.profile>

// Use everywhere
function getUser(id: string): Promise<User> { /* ... */ }
function updateProfile(id: string, profile: Partial<UserProfile>) { /* ... */ }
```

### Type Guards from Schemas

```ts
const UserSchema = z.object({ id: z.string(), email: z.string().email() })

function isUser(data: unknown): data is z.infer<typeof UserSchema> {
  return UserSchema.safeParse(data).success
}

// Usage
if (isUser(payload)) {
  // payload is typed as User
  console.log(payload.email)
}
```

### Runtime Type Checking

```ts
// Validate at runtime boundaries
function processEvent(event: unknown) {
  const validated = EventSchema.parse(event)
  handleEvent(validated)  // fully typed
}
```

### Zod Schema as type validator for unknown data

```ts
async function handleWebhook(payload: unknown) {
  const result = WebhookPayloadSchema.safeParse(payload)
  if (!result.success) {
    logger.error('Invalid webhook payload', result.error.flatten())
    return { status: 400 }
  }
  // result.data is fully typed
  await processPayment(result.data)
}
```

## 9. Lazy/Recursive Schemas

### Tree Structures

```ts
interface Category {
  name: string
  children?: Category[]
}

const CategorySchema: z.ZodType<Category> = z.lazy(() =>
  z.object({
    name: z.string(),
    children: z.array(CategorySchema).optional(),
  })
)
```

### JSON Schema (v4)

```ts
const JsonSchema: z.ZodType = z.lazy(() =>
  z.union([
    z.string(),
    z.number(),
    z.boolean(),
    z.null(),
    z.array(JsonSchema),
    z.record(JsonSchema),
  ])
)
type Json = z.infer<typeof JsonSchema>
```

## 10. .superRefine for Complex Validation

```ts
const SignUpSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  username: z.string().min(3),
  couponCode: z.string().optional(),
}).superRefine(async ({ email, username, couponCode }, ctx) => {
  // Check email uniqueness
  if (await userExistsByEmail(email)) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'Email already registered',
      path: ['email'],
    })
  }

  // Check username uniqueness
  if (await userExistsByUsername(username)) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'Username taken',
      path: ['username'],
    })
  }

  // Validate coupon code if provided
  if (couponCode && !(await isValidCoupon(couponCode))) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'Invalid coupon code',
      path: ['couponCode'],
    })
  }
})

// Must use parseAsync for async refinements
const result = await SignUpSchema.safeParseAsync(formData)
```
