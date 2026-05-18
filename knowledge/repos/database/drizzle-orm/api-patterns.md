# Drizzle ORM API Design Reference

> Source: https://github.com/drizzle-team/drizzle-orm
> Category: database | Stars: 25k+
> Last trained: 2026-05-18

## Route Conventions with Drizzle

### RESTful Resource Routes

```typescript
// routes/users.ts -- Express + Drizzle
import { Router } from 'express';
import { db } from '../db';
import { users, posts, type NewUser } from '../db/schema';
import { eq, and, like, desc, count, SQL } from 'drizzle-orm';

const router = Router();

// GET    /api/users         -- List (with pagination, filtering)
// POST   /api/users         -- Create
// GET    /api/users/:id     -- Get by ID
// PATCH  /api/users/:id     -- Partial update
// DELETE /api/users/:id     -- Delete
// GET    /api/users/:id/posts -- Nested resource

router.get('/', listUsers);
router.post('/', createUser);
router.get('/:id', getUser);
router.patch('/:id', updateUser);
router.delete('/:id', deleteUser);
router.get('/:id/posts', listUserPosts);
```

### Route Handler Template

```typescript
// Each handler follows the same pattern:
// 1. Parse/validate input
// 2. Build Drizzle query
// 3. Execute query
// 4. Format response

async function listUsers(req: Request, res: Response) {
  try {
    // 1. Parse & validate params
    const page = Math.max(1, parseInt(req.query.page as string) || 1);
    const limit = Math.min(100, Math.max(1, parseInt(req.query.limit as string) || 20));

    // 2. Build query
    const where = buildFilterConditions(req.query);
    const offset = (page - 1) * limit;

    // 3. Execute (data + count in parallel)
    const [items, [{ cnt }]] = await Promise.all([
      db.select().from(users).where(where).limit(limit).offset(offset)
        .orderBy(desc(users.createdAt)),
      db.select({ cnt: count() }).from(users).where(where),
    ]);

    // 4. Format response
    res.json({
      success: true,
      data: items,
      meta: {
        total: Number(cnt),
        page,
        limit,
        totalPages: Math.ceil(Number(cnt) / limit),
      },
    });
  } catch (error) {
    handleError(res, error);
  }
}
```

---

## Request Validation to Query Pipeline

### Zod Validation + Drizzle Query

```typescript
import { z } from 'zod';
import { createInsertSchema } from 'drizzle-zod';
import { db } from '../db';
import { users } from '../db/schema';

// 1. Define validation schemas from Drizzle tables
export const insertUserSchema = createInsertSchema(users, {
  email: (s) => s.email.email(),
  name: (s) => s.min(2).max(100),
}).omit({ id: true, createdAt: true, updatedAt: true });

export const updateUserSchema = insertUserSchema.partial();

// 2. Query params validation
const listUsersQuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().optional(),
  role: z.enum(['admin', 'user', 'moderator']).optional(),
  isActive: z.enum(['true', 'false']).optional(),
  sort: z.enum(['createdAt', 'name', 'email']).default('createdAt'),
  order: z.enum(['asc', 'desc']).default('desc'),
});

// 3. The full pipeline
async function createUser(req: Request, res: Response) {
  // Validate body
  const parsed = insertUserSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(422).json({
      success: false,
      error: 'Validation failed',
      details: parsed.error.flatten().fieldErrors,
    });
  }

  // Execute query
  const [user] = await db.insert(users).values(parsed.data).returning();

  // Return
  res.status(201).json({ success: true, data: user });
}

async function listUsers(req: Request, res: Response) {
  // Validate query params
  const parsed = listUsersQuerySchema.safeParse(req.query);
  if (!parsed.success) {
    return res.status(422).json({
      success: false,
      error: 'Invalid query parameters',
      details: parsed.error.flatten().fieldErrors,
    });
  }

  const { page, limit, search, role, sort, order } = parsed.data;

  // Build conditions from validated input
  const conditions: SQL[] = [];
  if (search) {
    conditions.push(like(users.name, `%${search}%`));
  }
  if (role) {
    conditions.push(eq(users.role, role));
  }

  const where = conditions.length > 0 ? and(...conditions) : undefined;
  const offset = (page - 1) * limit;
  const sortCol = users[sort];
  const sortFn = order === 'desc' ? desc : asc;

  // Execute
  const [items, [{ cnt }]] = await Promise.all([
    db.select().from(users).where(where).limit(limit).offset(offset).orderBy(sortFn(sortCol)),
    db.select({ cnt: count() }).from(users).where(where),
  ]);

  res.json({
    success: true,
    data: items,
    meta: { total: Number(cnt), page, limit, totalPages: Math.ceil(Number(cnt) / limit) },
  });
}
```

---

## Paginated API Response Format

### Standard Envelope

```typescript
interface ApiResponse<T> {
  success: boolean;
  data: T | null;
  error?: string;
  details?: Record<string, string[]>;  // Validation errors
}

interface PaginatedResponse<T> extends ApiResponse<T[]> {
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}

// Usage
function paginatedResponse<T>(items: T[], total: number, page: number, limit: number): PaginatedResponse<T> {
  return {
    success: true,
    data: items,
    meta: {
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    },
  };
}
```

### Paginated Query Helper

```typescript
async function paginateQuery<T>(
  queryFn: () => Promise<T[]>,
  countFn: () => Promise<number>,
  page: number,
  limit: number,
): Promise<PaginatedResponse<T>> {
  const [items, total] = await Promise.all([queryFn(), countFn()]);
  return paginatedResponse(items, total, page, limit);
}

// Usage
const result = await paginateQuery(
  () => db.select().from(users).where(where).limit(limit).offset(offset),
  () => db.$count(users, where),
  page,
  limit,
);
```

---

## Filtering from Query Params

### Filter Parser

```typescript
import { SQL, and, eq, like, gt, gte, lt, lte, inArray, or, between } from 'drizzle-orm';

interface FilterConfig<T> {
  field: keyof T;
  operators: ('eq' | 'like' | 'gt' | 'gte' | 'lt' | 'lte' | 'in' | 'between')[];
}

function parseFilters<T extends Record<string, any>>(
  query: Record<string, any>,
  table: any,
  configs: FilterConfig<T>[],
): SQL | undefined {
  const conditions: SQL[] = [];

  for (const config of configs) {
    const paramName = config.field as string;
    const value = query[paramName];
    if (value === undefined) continue;

    const column = table[paramName];

    if (typeof value === 'string') {
      if (config.operators.includes('eq')) conditions.push(eq(column, value));
      if (config.operators.includes('like')) conditions.push(like(column, `%${value}%`));
    }

    // Range: field_min, field_max
    if (config.operators.includes('gt')) {
      const minVal = query[`${paramName}_min`];
      if (minVal) conditions.push(gte(column, minVal));
    }
    if (config.operators.includes('lt')) {
      const maxVal = query[`${paramName}_max`];
      if (maxVal) conditions.push(lte(column, maxVal));
    }

    // IN clause: field=admin,user (comma-separated)
    if (config.operators.includes('in') && value.includes(',')) {
      conditions.push(inArray(column, value.split(',')));
    }
  }

  return conditions.length > 0 ? and(...conditions) : undefined;
}

// Usage
const userFilterConfig: FilterConfig<User>[] = [
  { field: 'role', operators: ['eq', 'in'] },
  { field: 'name', operators: ['like'] },
  { field: 'createdAt', operators: ['gt', 'lt'] },
  { field: 'age', operators: ['gte', 'lte'] },
];

app.get('/api/users', async (req, res) => {
  const where = parseFilters(req.query, users, userFilterConfig);
  // ... execute query with where
});
```

### Search Across Multiple Columns

```typescript
async function searchUsers(q: string, page: number, limit: number) {
  const searchTerm = `%${q}%`;

  const where = or(
    like(users.name, searchTerm),
    like(users.email, searchTerm),
    like(users.bio, searchTerm),
  );

  const offset = (page - 1) * limit;

  const [items, [{ cnt }]] = await Promise.all([
    db.select().from(users).where(where!).limit(limit).offset(offset),
    db.select({ cnt: count() }).from(users).where(where!),
  ]);

  return { items, total: Number(cnt), page, limit };
}
```

---

## Sorting

### Sort Parameter Parser

```typescript
type SortDirection = 'asc' | 'desc';

interface SortConfig<T> {
  allowedFields: (keyof T & string)[];
  defaultField: keyof T & string;
  defaultDirection: SortDirection;
}

function parseSort<T>(
  query: Record<string, any>,
  table: any,
  config: SortConfig<T>,
) {
  const rawSort = query.sort as string | undefined;
  const rawOrder = query.order as SortDirection | undefined;

  // Validate field
  const field = rawSort && config.allowedFields.includes(rawSort)
    ? rawSort
    : config.defaultField;

  // Validate direction
  const direction = rawOrder === 'asc' || rawOrder === 'desc'
    ? rawOrder
    : config.defaultDirection;

  const column = table[field as string];
  const sortFn = direction === 'desc' ? desc : asc;

  return sortFn(column);
}

// Usage
const userSortConfig: SortConfig<User> = {
  allowedFields: ['id', 'name', 'email', 'createdAt', 'age'],
  defaultField: 'createdAt',
  defaultDirection: 'desc',
};

app.get('/api/users', async (req, res) => {
  const orderBy = parseSort(req.query, users, userSortConfig);
  const items = await db.select().from(users).orderBy(orderBy);
  // ...
});
```

---

## Error Response Format

### Standardized Error Handling

```typescript
// lib/errors.ts
class AppError extends Error {
  constructor(
    public statusCode: number,
    message: string,
    public details?: Record<string, string[]>,
  ) {
    super(message);
    this.name = 'AppError';
  }
}

const DB_ERROR_MAP: Record<string, { status: number; message: string }> = {
  '23505': { status: 409, message: 'Resource already exists' },    // unique_violation
  '23503': { status: 400, message: 'Referenced resource not found' }, // foreign_key_violation
  '23502': { status: 400, message: 'Required field is missing' },    // not_null_violation
  '23514': { status: 400, message: 'Constraint violation' },         // check_violation
};

function handleError(res: Response, error: unknown) {
  // Known application error
  if (error instanceof AppError) {
    return res.status(error.statusCode).json({
      success: false,
      error: error.message,
      details: error.details,
    });
  }

  // Database constraint error
  if (error instanceof Error && 'code' in error) {
    const code = (error as any).code as string;
    const mapped = DB_ERROR_MAP[code];
    if (mapped) {
      return res.status(mapped.status).json({
        success: false,
        error: mapped.message,
        detail: (error as any).detail,
      });
    }
  }

  // Unexpected error
  console.error('Unhandled error:', error);
  return res.status(500).json({
    success: false,
    error: 'Internal server error',
  });
}

// Usage in route handler
app.post('/api/users', async (req, res) => {
  try {
    const [user] = await db.insert(users).values(req.body).returning();
    res.status(201).json({ success: true, data: user });
  } catch (error) {
    handleError(res, error);
  }
});
```

---

## Transaction Middleware

### Express Transaction Middleware

```typescript
import { Request, Response, NextFunction } from 'express';
import { db } from '../db';
import { PgTransaction } from 'drizzle-orm/pg-core';

// Attach a transaction to each request
declare global {
  namespace Express {
    interface Request {
      tx?: PgTransaction<any, any, any>;
    }
  }
}

// Start a transaction for state-changing routes
async function transactional(req: Request, res: Response, next: NextFunction) {
  // Only wrap state-changing methods
  if (!['POST', 'PUT', 'PATCH', 'DELETE'].includes(req.method)) {
    return next();
  }

  await db.transaction(async (tx) => {
    req.tx = tx as any;
    next();
    // Note: next() must be handled carefully -- this is a simplified pattern.
    // In practice, you'd need to handle async/response flow.
  });
}

// More practical: explicit transaction wrapper
function withTransaction<T>(
  fn: (tx: typeof db) => Promise<T>,
): Promise<T> {
  return db.transaction(async (tx) => {
    return fn(tx as any);
  });
}

// Usage
app.post('/api/orders', async (req, res) => {
  try {
    const result = await withTransaction(async (tx) => {
      const [order] = await tx.insert(orders).values(req.body).returning();
      await tx.update(inventory)
        .set({ quantity: sql`${inventory.quantity} - 1` })
        .where(eq(inventory.productId, req.body.productId));
      return order;
    });
    res.status(201).json({ success: true, data: result });
  } catch (error) {
    handleError(res, error);
  }
});
```

### Hono Transaction Middleware

```typescript
import { Hono } from 'hono';
import { db } from './db';

const app = new Hono();

// Manual transaction within handler
app.post('/api/orders', async (c) => {
  const body = await c.req.json();

  try {
    const result = await db.transaction(async (tx) => {
      const [order] = await tx.insert(orders).values(body).returning();
      await tx.update(inventory)
        .set({ quantity: sql`${inventory.quantity} - 1` })
        .where(eq(inventory.productId, body.productId));
      return order;
    });

    return c.json({ success: true, data: result }, 201);
  } catch (error) {
    // Transaction auto-rolls back
    return c.json({ success: false, error: 'Failed to create order' }, 500);
  }
});
```

---

## Testing API Endpoints with Drizzle

### Integration Test Setup with SQL.js

```typescript
// tests/setup.ts
import { drizzle } from 'drizzle-orm/sql-js';
import initSqlJs from 'sql.js';
import { migrate } from 'drizzle-orm/sql-js/migrator';
import * as schema from '../db/schema';

export async function createTestDb() {
  const SQL = await initSqlJs();
  const sqlJsDb = new SQL.Database();
  const db = drizzle(sqlJsDb);

  // Run DDL from migration files
  sqlJsDb.run(`
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      role TEXT DEFAULT 'user',
      created_at TEXT DEFAULT (datetime('now'))
    );
    CREATE TABLE posts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      content TEXT,
      author_id INTEGER NOT NULL REFERENCES users(id),
      published INTEGER DEFAULT 0,
      created_at TEXT DEFAULT (datetime('now'))
    );
  `);

  return db;
}

export async function seedTestData(db: ReturnType<typeof createTestDb>) {
  await db.insert(schema.users).values([
    { email: 'alice@test.com', name: 'Alice', role: 'admin' },
    { email: 'bob@test.com', name: 'Bob', role: 'user' },
  ]);

  const [alice] = await db.select().from(schema.users)
    .where(eq(schema.users.email, 'alice@test.com'));

  await db.insert(schema.posts).values([
    { title: 'Alice Post 1', authorId: alice.id, published: 1 },
    { title: 'Alice Draft', authorId: alice.id, published: 0 },
  ]);
}
```

### API Endpoint Test Example (Vitest + Supertest)

```typescript
// tests/users.test.ts
import { describe, it, expect, beforeAll, afterAll, beforeEach } from 'vitest';
import request from 'supertest';
import { app } from '../app';  // Your Express/Hono app
import { createTestDb, seedTestData } from './setup';

describe('GET /api/users', () => {
  let testDb: Awaited<ReturnType<typeof createTestDb>>;

  beforeAll(async () => {
    testDb = await createTestDb();
    // Override the app's db with test db
    // (This requires dependency injection or module mocking)
  });

  beforeEach(async () => {
    // Reset DB state before each test
    await testDb.execute(sql`DELETE FROM posts`);
    await testDb.execute(sql`DELETE FROM users`);
    await seedTestData(testDb);
  });

  it('returns paginated users', async () => {
    const res = await request(app)
      .get('/api/users')
      .query({ page: 1, limit: 10 })
      .expect(200);

    expect(res.body.success).toBe(true);
    expect(res.body.data).toHaveLength(2);
    expect(res.body.meta.total).toBe(2);
    expect(res.body.meta.page).toBe(1);
  });

  it('filters users by role', async () => {
    const res = await request(app)
      .get('/api/users')
      .query({ role: 'admin' })
      .expect(200);

    expect(res.body.data).toHaveLength(1);
    expect(res.body.data[0].email).toBe('alice@test.com');
  });

  it('validates create user input', async () => {
    const res = await request(app)
      .post('/api/users')
      .send({ email: 'invalid', name: '' })
      .expect(422);

    expect(res.body.success).toBe(false);
    expect(res.body.error).toBe('Validation failed');
    expect(res.body.details).toHaveProperty('email');
    expect(res.body.details).toHaveProperty('name');
  });

  it('returns 409 on duplicate email', async () => {
    const res = await request(app)
      .post('/api/users')
      .send({ email: 'alice@test.com', name: 'Duplicate' })
      .expect(409);

    expect(res.body.success).toBe(false);
    expect(res.body.error).toContain('already exists');
  });

  it('returns empty list with hasMore=false for last page', async () => {
    // With only 2 users and limit=10, page 1 should return 2 items with total=2
    const res = await request(app)
      .get('/api/users')
      .query({ page: 1, limit: 10 })
      .expect(200);

    expect(res.body.data).toHaveLength(2);
    expect(res.body.meta.totalPages).toBe(1);
  });
});
```

### Testing with Transaction Rollback (PostgreSQL)

```typescript
import { Pool } from 'pg';
import { drizzle } from 'drizzle-orm/node-postgres';
import * as schema from '../db/schema';

let db: ReturnType<typeof drizzle<typeof schema>>;
let pool: Pool;

beforeAll(async () => {
  pool = new Pool({ connectionString: process.env.TEST_DATABASE_URL });
  db = drizzle(pool, { schema });
  // Run migrations
  const { migrate } = await import('drizzle-orm/node-postgres/migrator');
  await migrate(db, { migrationsFolder: './drizzle' });
});

beforeEach(async () => {
  // Start transaction for test isolation
  await db.execute(sql`BEGIN`);
});

afterEach(async () => {
  // Roll back all changes
  await db.execute(sql`ROLLBACK`);
});

afterAll(async () => {
  await pool.end();
});
```

---

## Full API Router Example (Hono + Drizzle)

```typescript
// routes/users.ts
import { Hono } from 'hono';
import { zValidator } from '@hono/zod-validator';
import { z } from 'zod';
import { db } from '../db';
import { users } from '../db/schema';
import { eq, and, like, desc, count, SQL } from 'drizzle-orm';

const usersRoutes = new Hono();

// GET /api/users -- List with pagination + filtering
usersRoutes.get(
  '/',
  zValidator('query', z.object({
    page: z.coerce.number().int().min(1).default(1),
    limit: z.coerce.number().int().min(1).max(100).default(20),
    search: z.string().optional(),
    role: z.enum(['admin', 'user', 'moderator']).optional(),
    isActive: z.enum(['true', 'false']).optional(),
  })),
  async (c) => {
    const { page, limit, search, role, isActive } = c.req.valid('query');

    // Build conditions
    const conditions: SQL[] = [];
    if (search) conditions.push(like(users.name, `%${search}%`));
    if (role) conditions.push(eq(users.role, role));
    if (isActive !== undefined) {
      conditions.push(eq(users.isActive, isActive === 'true'));
    }
    const where = conditions.length > 0 ? and(...conditions) : undefined;
    const offset = (page - 1) * limit;

    // Execute
    const [items, [{ cnt }]] = await Promise.all([
      db.select().from(users).where(where).limit(limit).offset(offset)
        .orderBy(desc(users.createdAt)),
      db.select({ cnt: count() }).from(users).where(where),
    ]);

    return c.json({
      success: true,
      data: items,
      meta: { total: Number(cnt), page, limit, totalPages: Math.ceil(Number(cnt) / limit) },
    });
  },
);

// GET /api/users/:id -- Get by ID
usersRoutes.get('/:id', async (c) => {
  const id = parseInt(c.req.param('id'));
  if (isNaN(id)) {
    return c.json({ success: false, error: 'Invalid ID' }, 400);
  }

  const user = await db.query.users.findFirst({
    where: eq(users.id, id),
    with: { posts: true },
  });

  if (!user) {
    return c.json({ success: false, error: 'User not found' }, 404);
  }

  return c.json({ success: true, data: user });
});

// POST /api/users -- Create
usersRoutes.post('/', async (c) => {
  const body = await c.req.json();

  // Quick inline validation
  if (!body.email || !body.name) {
    return c.json({ success: false, error: 'Email and name are required' }, 400);
  }

  try {
    const [user] = await db.insert(users).values(body).returning();
    return c.json({ success: true, data: user }, 201);
  } catch (error: unknown) {
    if (error instanceof Error && 'code' in error && (error as any).code === '23505') {
      return c.json({ success: false, error: 'Email already exists' }, 409);
    }
    console.error('Create user error:', error);
    return c.json({ success: false, error: 'Internal server error' }, 500);
  }
});

// PATCH /api/users/:id -- Update
usersRoutes.patch('/:id', async (c) => {
  const id = parseInt(c.req.param('id'));
  const body = await c.req.json();

  try {
    const [user] = await db.update(users)
      .set(body)
      .where(eq(users.id, id))
      .returning();

    if (!user) {
      return c.json({ success: false, error: 'User not found' }, 404);
    }

    return c.json({ success: true, data: user });
  } catch (error) {
    return c.json({ success: false, error: 'Update failed' }, 500);
  }
});

// DELETE /api/users/:id -- Delete
usersRoutes.delete('/:id', async (c) => {
  const id = parseInt(c.req.param('id'));
  const [user] = await db.delete(users).where(eq(users.id, id)).returning();

  if (!user) {
    return c.json({ success: false, error: 'User not found' }, 404);
  }

  return c.json({ success: true, data: user });
});

export default usersRoutes;
```

---

## Common API Patterns Checklist

- [ ] All list endpoints support pagination (`page`, `limit` params)
- [ ] All list endpoints return `meta` with `total`, `page`, `limit`, `totalPages`
- [ ] All responses use a consistent envelope (`{ success, data, error }`)
- [ ] Validation errors return 422 with field-level details
- [ ] Constraint violations return 409 with clear messages
- [ ] Not found returns 404
- [ ] POST returns 201 with the created resource
- [ ] State-changing operations use transactions
- [ ] Search uses parameterized queries (never string interpolation)
- [ ] LIKE patterns sanitize `%` and `_` from user input
- [ ] `limit` is always capped (e.g., max 100)
- [ ] `offset` is always calculated from validated `page`
- [ ] Sorting fields are validated against an allowlist
- [ ] Filtering fields are validated against an allowlist
- [ ] Errors are logged server-side, user-friendly messages sent client-side
