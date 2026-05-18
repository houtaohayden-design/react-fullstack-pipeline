# Zod API Reference

> Source: [colinhacks/zod](https://github.com/colinhacks/zod) — 34K+ stars
> TypeScript-first schema validation with static type inference. Zero dependencies, ~2KB gzipped core.

## Installation

```bash
npm install zod
```

```ts
import { z } from 'zod'
```

## Core Concepts

### Parsing Data

```ts
// .parse() — throws ZodError on failure
const result = schema.parse(data)

// .safeParse() — returns { success, data } | { success, error }
const result = schema.safeParse(data)
if (result.success) {
  // result.data is typed
} else {
  // result.error is ZodError
}

// Async variants (use when schema has async refinements/transforms)
const result = await schema.parseAsync(data)
const result = await schema.safeParseAsync(data)
```

### Type Inference

```ts
const User = z.object({ name: z.string(), age: z.number() })

type User = z.infer<typeof User>       // { name: string; age: number }
type UserIn = z.input<typeof User>     // input type (before transforms)
type UserOut = z.output<typeof User>   // output type (after transforms)
```

## Primitive Schemas

### String

```ts
z.string()
z.string().min(1, 'Required')
z.string().max(100)
z.string().length(10)
z.string().email()
z.string().url()
z.string().emoji()
z.string().uuid()
z.string().nanoid()
z.string().cuid()
z.string().cuid2()
z.string().ulid()
z.string().regex(/^\d+$/)
z.string().includes('hello')
z.string().startsWith('GET ')
z.string().endsWith('.com')
z.string().datetime({ offset: true })
z.string().ip({ version: 'v4' })
z.string().cidr({ version: 'v6' })
z.string().base64()
z.string().base64url()
z.string().jwt()
z.string().trim()
z.string().toLowerCase()
z.string().toUpperCase()
z.string().date()
z.string().time()
z.string().duration()
```

### Number

```ts
z.number()
z.number().int()
z.number().positive()
z.number().nonnegative()
z.number().negative()
z.number().nonpositive()
z.number().min(0)
z.number().max(100)
z.number().multipleOf(5)
z.number().finite()
z.number().safe()        // validates ints between MIN_SAFE_INTEGER and MAX_SAFE_INTEGER
```

### Boolean

```ts
z.boolean()
```

### BigInt

```ts
z.bigint()
z.bigint().positive()
z.bigint().min(0n)
z.bigint().max(100n)
z.bigint().multipleOf(5n)
```

### Date

```ts
z.date()
z.date().min(new Date('2020-01-01'))
z.date().max(new Date('2030-01-01'))
```

### Symbol

```ts
z.symbol()
```

### Undefined

```ts
z.undefined()
```

### Null

```ts
z.null()
```

### Literals

```ts
z.literal('hello')
z.literal(42)
z.literal(true)
```

### Enum (Native TypeScript enums)

```ts
enum Color { Red, Green, Blue }
z.nativeEnum(Color)

// String enums also supported
enum Status { Active = 'active', Inactive = 'inactive' }
z.nativeEnum(Status)
```

### Enum (Zod enum — string union)

```ts
z.enum(['apple', 'banana', 'cherry'])
```

### Void

```ts
z.void()  // accepts undefined
```

### Any

```ts
z.any()   // accepts any value, no validation
```

### Unknown

```ts
z.unknown()  // accepts any value, typed as unknown
```

### Never

```ts
z.never()  // value that never occurs
```

### NaN

```ts
z.nan()  // accepts only NaN
```

## Complex Schemas

### Object

```ts
z.object({
  name: z.string(),
  age: z.number().optional(),
  email: z.string().email().nullable(),
})

// Strict — throws on unrecognized keys
z.strictObject({ name: z.string() })

// Loose — ignores unrecognized keys
z.looseObject({ name: z.string() })

// Passthrough — keeps unrecognized keys (typed as unknown)
z.passthroughObject({ name: z.string() })

// Object modifiers
schema.pick({ name: true })       // { name: string }
schema.omit({ age: true })        // omit age field
schema.partial()                   // all fields optional
schema.deepPartial()               // all nested fields optional
schema.required()                  // all fields required (flip optional)
schema.extend({ extra: z.string() })
schema.merge(otherSchema)
schema.setKey('newKey', z.string())
schema.keyof()                     // ZodEnum of literal keys
schema.shape                       // access the raw shape object
schema.passthrough()               // allow unrecognized keys
schema.strict()                    // throw on unrecognized keys
schema.catchall(z.string())        // type for unrecognized keys
```

### Array

```ts
z.array(z.string())
z.string().array()
z.string().array().min(1)
z.string().array().max(10)
z.string().array().length(3)
z.string().array().nonempty()

// Element-level validation
z.array(z.string().email())
```

### Tuple

```ts
z.tuple([z.string(), z.number(), z.boolean()])
z.tuple([z.string()]).rest(z.number())  // first string, rest numbers
```

### Union

```ts
z.union([z.string(), z.number()])

// Shorthand
z.string().or(z.number())
```

### Discriminated Union

```ts
const Success = z.object({ status: z.literal('success'), data: z.string() })
const Error = z.object({ status: z.literal('error'), message: z.string() })

const Response = z.discriminatedUnion('status', [Success, Error])
```

### Intersection

```ts
const Base = z.object({ id: z.string() })
const HasTimestamps = z.object({ createdAt: z.date(), updatedAt: z.date() })

const Model = z.intersection(Base, HasTimestamps)
// or
const Model = Base.and(HasTimestamps)
```

### Record

```ts
z.record(z.string())                    // { [k: string]: string }
z.record(z.string(), z.number())        // { [k: string]: number }
z.record(z.enum(['a', 'b']), z.boolean())
```

### Map

```ts
z.map(z.string(), z.number())
```

### Set

```ts
z.set(z.string())
z.set(z.string()).min(1)
z.set(z.string()).nonempty()
```

### Function

```ts
z.function()
z.function().args(z.string(), z.number()).returns(z.boolean())
```

### Promise

```ts
z.promise(z.string())
schema.promise()  // wraps in ZodPromise
```

### Lazy (Recursive Schemas)

```ts
const Category = z.lazy(() => z.object({
  name: z.string(),
  subcategories: z.array(Category).optional(),
}))
```

### Template Literals

```ts
z.string().startsWith('prefix')
z.string().endsWith('.com')

// Template literal type (v4):
// z.templateLiteral`${z.literal('hello-')}${z.string()}`
```

### Custom Schema

```ts
z.custom<MyType>((val) => val instanceof MyType)
```

### Schema from JSON Schema

```ts
// v4:
// z.fromJSONSchema({ type: 'string', minLength: 1 })
```

## Schema Modifiers

### Optional

```ts
z.string().optional()      // string | undefined
```

### Nullable

```ts
z.string().nullable()      // string | null
```

### Nullish

```ts
z.string().nullish()       // string | null | undefined
```

### Default

```ts
z.string().default('hello')
z.string().default(() => generateDefault())
```

### Catch (fallback on error)

```ts
z.string().catch('fallback')
z.string().catch((ctx) => {
  // ctx.error: ZodError
  // ctx.input: original input
  return 'fallback'
})
```

### Readonly

```ts
z.string().readonly()
z.object({ name: z.string() }).readonly()  // deep readonly
```

### Brand (opaque/nominal types)

```ts
const UserId = z.string().brand<'UserId'>()
type UserId = z.infer<typeof UserId>  // string & { __brand: 'UserId' }
```

## Transformations & Refinements

### Transform

```ts
z.string().transform((val) => val.length)
// Input: string, Output: number

z.string().transform((val, ctx) => {
  // ctx.addIssue({ code: z.ZodIssueCode.custom, message: 'nope' })
  return val.trim()
})
```

### Pipe

```ts
z.string()
  .transform((val) => val.length)
  .pipe(
    z.number().min(1)
  )
```

### Refine

```ts
z.string().refine((val) => val.length >= 8, {
  message: 'Must be at least 8 characters',
})

z.string().refine(
  async (val) => await checkAvailability(val),
  { message: 'Username taken' }
)
```

### SuperRefine (multi-issue)

```ts
z.string().superRefine((val, ctx) => {
  if (val.length < 8) {
    ctx.addIssue({ code: z.ZodIssueCode.custom, message: 'Too short' })
  }
  if (!/[A-Z]/.test(val)) {
    ctx.addIssue({ code: z.ZodIssueCode.custom, message: 'Need uppercase' })
  }
})
```

### Preprocess (coercion / normalization)

```ts
z.preprocess((val) => String(val).trim(), z.string().email())

// Common: coerce string to number
z.preprocess((val) => {
  const n = Number(val)
  return isNaN(n) ? val : n
}, z.number())

// Coercion schemas (built-in)
z.coerce.string()   // String() coercion
z.coerce.number()   // Number() coercion
z.coerce.boolean()  // Boolean() coercion
z.coerce.bigint()   // BigInt() coercion
z.coerce.date()     // new Date() coercion
```

## Effects (Pipeline)

`z.Effects` wraps a schema with a chain of refinements and transforms:

```ts
const schema = z.string().refine(...).transform(...).refine(...)
// Internally: ZodEffects<ZodEffects<ZodString>>
```

## Validation Methods (shared)

All schema types support these methods:

| Method | Description |
|--------|-------------|
| `.parse(data)` | Validates, returns typed data or throws ZodError |
| `.safeParse(data)` | Returns `{ success, data }` or `{ success, error }` |
| `.parseAsync(data)` | Async version |
| `.safeParseAsync(data)` | Async version |
| `.optional()` | Makes schema optional |
| `.nullable()` | Makes schema nullable |
| `.nullish()` | Makes schema optional + nullable |
| `.default(value)` | Fallback default value |
| `.catch(value)` | Fallback value on validation error |
| `.transform(fn)` | Transform output type |
| `.refine(fn, opts)` | Add refinement check |
| `.superRefine(fn)` | Multi-issue refinement |
| `.pipe(schema)` | Chain schemas (output -> input) |
| `.brand(name)` | Nominal type branding |
| `.describe(text)` | Add description metadata |
| `.array()` | Wraps in ZodArray |
| `.promise()` | Wraps in ZodPromise |
| `.or(schema)` | Union with another schema |
| `.and(schema)` | Intersection with another schema |
| `.readonly()` | Deep readonly |
| `.isOptional()` | Returns boolean |
| `.isNullable()` | Returns boolean |

## Error Handling

### ZodError Structure

```ts
try {
  schema.parse(data)
} catch (err) {
  if (err instanceof z.ZodError) {
    err.issues  // ZodIssue[]
    err.message // JSON string of issues
    err.isEmpty // boolean
  }
}
```

### ZodIssue Shape

```ts
interface ZodIssue {
  code: string       // e.g. 'invalid_type', 'too_small', 'custom'
  path: (string | number)[]
  message: string
  fatal?: boolean
  // code-specific fields:
  expected?: string
  received?: string
  validation?: string
  minimum?: number
  maximum?: number
  inclusive?: boolean
  options?: string[]
  unionErrors?: ZodError[]
  params?: Record<string, any>
}
```

### Issue Codes

| Code | Description |
|------|-------------|
| `invalid_type` | Wrong primitive type |
| `invalid_literal` | Literal value mismatch |
| `custom` | Custom refinement failure |
| `invalid_union` | No union variant matched |
| `invalid_union_discriminator` | Invalid discriminator value |
| `invalid_enum_value` | Value not in enum |
| `unrecognized_keys` | Excess keys in strict object |
| `invalid_arguments` | Function argument validation failure |
| `invalid_return_type` | Function return validation failure |
| `invalid_date` | Invalid date |
| `invalid_string` | String format validation failure |
| `too_small` | Below minimum |
| `too_big` | Above maximum |
| `not_multiple_of` | Not a multiple of |
| `not_finite` | Infinite/non-finite number |
| `invalid_intersection_types` | Intersection type mismatch |

### Error Formatting

```ts
// .format() — nested tree with _errors arrays
const formatted = error.format()
// {
//   name: { _errors: ['Required'] },
//   age: { _errors: ['Expected number, received string'] },
//   _errors: []
// }

// .flatten() — flat fieldErrors + formErrors
const flat = error.flatten()
// {
//   formErrors: [],
//   fieldErrors: {
//     name: ['Required'],
//     age: ['Expected number, received string']
//   }
// }

// .flatten(mapperFn) — custom error messages
const flat = error.flatten((issue) => issue.code)
```

### Custom Error Maps

```ts
const customErrorMap: z.ZodErrorMap = (issue, ctx) => {
  if (issue.code === z.ZodIssueCode.invalid_type) {
    return { message: `Field ${issue.path.join('.')} is invalid` }
  }
  return { message: ctx.defaultError }
}

z.setErrorMap(customErrorMap)

// Per-schema error map
z.string({ errorMap: customErrorMap })
```

### Error-Level Custom Messages

```ts
// Type-level messages
z.string({ required_error: 'Required', invalid_type_error: 'Must be a string' })

// Method-level messages
z.string().min(1, 'Required')
z.string().email('Invalid email format')
z.string().refine(fn, { message: 'Custom error' })
```

## JSON Schema Conversion

```ts
// Convert Zod schema to JSON Schema (v4)
const jsonSchema = schema.toJSONSchema()
```

## Standard Schema Interface

Zod v4 implements the [Standard Schema](https://github.com/standard-schema/standard-schema) specification:

```ts
schema['~standard']  // StandardSchemaV1.Props
schema['~validate'](data)  // StandardSchemaV1.Result
```

This enables interoperability with any library that consumes standard schemas.

## First-Party Schema Kind (typeName)

```ts
const category = {
  ZodString: 'ZodString',
  ZodNumber: 'ZodNumber',
  ZodObject: 'ZodObject',
  ZodArray: 'ZodArray',
  ZodUnion: 'ZodUnion',
  ZodDiscriminatedUnion: 'ZodDiscriminatedUnion',
  ZodIntersection: 'ZodIntersection',
  ZodTuple: 'ZodTuple',
  ZodRecord: 'ZodRecord',
  ZodMap: 'ZodMap',
  ZodSet: 'ZodSet',
  ZodFunction: 'ZodFunction',
  ZodLazy: 'ZodLazy',
  ZodLiteral: 'ZodLiteral',
  ZodEnum: 'ZodEnum',
  ZodNativeEnum: 'ZodNativeEnum',
  ZodEffects: 'ZodEffects',
  ZodOptional: 'ZodOptional',
  ZodNullable: 'ZodNullable',
  ZodDefault: 'ZodDefault',
  ZodCatch: 'ZodCatch',
  ZodPromise: 'ZodPromise',
  ZodBranded: 'ZodBranded',
  ZodPipeline: 'ZodPipeline',
  ZodNever: 'ZodNever',
  ZodAny: 'ZodAny',
  ZodUnknown: 'ZodUnknown',
  ZodVoid: 'ZodVoid',
  ZodDate: 'ZodDate',
  ZodBigInt: 'ZodBigInt',
  ZodSymbol: 'ZodSymbol',
  ZodNaN: 'ZodNaN',
}
```

## Coercion Schemas (v4)

```ts
z.coerce.string()          // String() coercion
z.coerce.number()          // Number() coercion
z.coerce.boolean()         // Boolean() coercion
z.coerce.bigint()          // BigInt() coercion
z.coerce.date()            // new Date() coercion
```

## Zod Type Utilities

```ts
type Inferred = z.infer<typeof schema>    // output type
type Input = z.input<typeof schema>       // input type (before transforms)
type Output = z.output<typeof schema>     // output type (after transforms)

// Type guards
const isMyType = (val: unknown): val is MyType => schema.safeParse(val).success

// Schema type
type SchemaType = z.infer<typeof schema>  // preferred way
type SchemaType = TypeOf<typeof schema>   // alias (deprecated, use z.infer)
```

## Mini & v4-mini Exports

For bundle-size-conscious usage, Zod provides trimmed bundles:

```ts
// v3 mini (no locale, datetime, refinement, etc.)
import { z } from 'zod/mini'

// v4 mini (core primitives only)
import { z } from 'zod/v4-mini'
```

## Error-Level Customization Pattern

```ts
// Define schemas with descriptive error messages at definition time
const Email = z.string().email('Please enter a valid email address')
const Password = z.string().min(8, 'Password must be at least 8 characters')
const Age = z.number().int().min(13, 'Must be at least 13 years old')

const SignUpForm = z.object({
  email: Email,
  password: Password,
  age: Age,
})
```
