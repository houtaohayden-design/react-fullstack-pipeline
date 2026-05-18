# Drizzle ORM Usage Patterns

> Source: https://github.com/drizzle-team/drizzle-orm
> Category: database | Stars: 25k+
> Last trained: 2026-05-18

## Schema Organization Patterns

### Single File Schema (Small Projects)

```typescript
// db/schema.ts
import { pgTable, relations } from 'drizzle-orm/pg-core';

export const users = pgTable('users', { /* ... */ });
export const posts = pgTable('posts', { /* ... */ });
export const comments = pgTable('comments', { /* ... */ });

export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
  comments: many(comments),
}));

export const postsRelations = relations(posts, ({ one, many }) => ({
  author: one(users, { fields: [posts.authorId], references: [users.id] }),
  comments: many(comments),
}));

export const commentsRelations = relations(comments, ({ one }) => ({
  post: one(posts, { fields: [comments.postId], references: [posts.id] }),
  author: one(users, { fields: [comments.authorId], references: [users.id] }),
}));

// Schema object for Drizzle's relational query API
export const schema = { users, posts, comments,
  usersRelations, postsRelations, commentsRelations };
```

### Multi-File Schema Organization

```text
db/
  schema/
    users.ts          # users table + relations
    posts.ts          # posts table + relations
    comments.ts       # comments table + relations
    enums.ts          # pgEnum definitions
    index.ts          # Re-export all tables + schema object
  index.ts            # db connection (drizzle pool, { schema })
  migrate.ts          # Migration runner
  seed.ts             # Seed data
```

```typescript
// db/schema/index.ts
export { users, usersRelations } from './users';
export { posts, postsRelations } from './posts';
export { comments, commentsRelations } from './comments';
export { roleEnum, statusEnum } from './enums';

import { users, usersRelations } from './users';
import { posts, postsRelations } from './posts';
import { comments, commentsRelations } from './comments';

export const schema = {
  users, usersRelations,
  posts, postsRelations,
  comments, commentsRelations,
};
```

### Database Instance Singleton

```typescript
// db/index.ts
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
export const db = drizzle(pool, { schema });

// Adding { schema } enables the relational query API: db.query.users.findMany(...)
export type DB = typeof db;
```

---

## Query Patterns

### SQL-like vs Relational API

```typescript
// SQL-like: use db.select/insert/update/delete + explicit joins
const result = await db.select({
  userName: users.name,
  postTitle: posts.title,
}).from(users).innerJoin(posts, eq(users.id, posts.authorId));

// Relational: use db.query.<table>.<method> with { with: {} }
const result = await db.query.users.findMany({
  with: { posts: true },
  where: eq(users.isActive, true),
});
```

**Rule**: Use SQL-like for custom selection shapes, aggregation, and complex joins. Use relational API for loading nested relations with minimal boilerplate.

### Selecting Only Needed Columns (Performance)

```typescript
// BAD: fetches all columns (including large text/jsonb)
const users = await db.select().from(users);

// GOOD: fetch only what you need
const names = await db.select({
  id: users.id,
  name: users.name,
}).from(users).where(eq(users.isActive, true));
```

### Direct Column Access vs Selection Object

```typescript
// When you select all columns with .select(), the result is typed as table row
const allUsers = await db.select().from(users);
// allUsers: { id: number; name: string; email: string; ... }[]

// When you select specific columns, the result has only those keys
const subset = await db.select({ id: users.id, name: users.name }).from(users);
// subset: { id: number; name: string }[]
```

---

## Dynamic Filter Composition

### Builder Pattern for Search Queries

```typescript
import { SQL, and, eq, like, gt, lt, gte, lte, inArray, or } from 'drizzle-orm';

interface UserFilters {
  role?: string | string[];
  search?: string;
  minAge?: number;
  maxAge?: number;
  isActive?: boolean;
  createdAfter?: Date;
  createdBefore?: Date;
}

function buildUserWhere(filters: UserFilters): SQL | undefined {
  const conditions: SQL[] = [];

  if (filters.role) {
    conditions.push(
      Array.isArray(filters.role)
        ? inArray(users.role, filters.role)
        : eq(users.role, filters.role)
    );
  }
  if (filters.search) {
    const pattern = `%${filters.search}%`;
    conditions.push(or(
      like(users.name, pattern),
      like(users.email, pattern),
    )!);
  }
  if (filters.minAge !== undefined) conditions.push(gte(users.age, filters.minAge));
  if (filters.maxAge !== undefined) conditions.push(lte(users.age, filters.maxAge));
  if (filters.isActive !== undefined) conditions.push(eq(users.isActive, filters.isActive));
  if (filters.createdAfter) conditions.push(gte(users.createdAt, filters.createdAfter));
  if (filters.createdBefore) conditions.push(lte(users.createdAt, filters.createdBefore));

  return conditions.length > 0 ? and(...conditions) : undefined;
}

async function listUsers(filters: UserFilters, page = 1, limit = 20) {
  const where = buildUserWhere(filters);
  const offset = (page - 1) * limit;

  const [items, [{ count: total }]] = await Promise.all([
    db.select().from(users).where(where).limit(limit).offset(offset),
    db.select({ count: count() }).from(users).where(where),
  ]);

  return { items, total: Number(total), page, limit };
}
```

### Reusable Query Fragments

```typescript
// queries/fragments.ts
import { eq, desc, SQL } from 'drizzle-orm';
import { posts } from '../db/schema';

export const publishedOnly = eq(posts.published, true);
export const sortByNewest = desc(posts.createdAt);
export const notDeleted = eq(posts.deletedAt, null as any);
// Or with isNull:
// export const notDeleted = isNull(posts.deletedAt);

// Usage
await db.select().from(posts)
  .where(and(publishedOnly, eq(posts.authorId, userId)))
  .orderBy(sortByNewest);
```

---

## Pagination Patterns

### Offset Pagination

```typescript
async function paginateUsers(page: number, pageSize: number) {
  const offset = (page - 1) * pageSize;
  const items = await db.select().from(users)
    .orderBy(desc(users.createdAt))
    .limit(pageSize)
    .offset(offset);
  const total = await db.$count(users);
  return { items, total, page, pageSize, totalPages: Math.ceil(total / pageSize) };
}
```

**Limitations**: Performance degrades for large offsets (e.g., page 1000). The DB must scan all rows before the offset.

### Cursor Pagination (Keyset Pagination)

```typescript
async function cursorPaginateUsers(cursor?: number, limit = 20) {
  const conditions: SQL[] = [];
  if (cursor) {
    conditions.push(lt(users.id, cursor)); // DESC order, cursor is last seen ID
  }

  const where = conditions.length > 0 ? and(...conditions) : undefined;

  // Fetch one extra to determine if there are more results
  const items = await db.select().from(users)
    .where(where)
    .orderBy(desc(users.id))
    .limit(limit + 1);

  const hasMore = items.length > limit;
  if (hasMore) items.pop();

  const nextCursor = items.length > 0 ? items[items.length - 1].id : undefined;
  return { items, nextCursor, hasMore };
}
```

**Best for**: Infinite scroll, real-time feeds, large datasets. Requires a stable, sortable column (usually auto-increment ID or `created_at`).

---

## Soft Delete Pattern

```typescript
// Schema: add deletedAt column
export const posts = pgTable('posts', {
  id: serial('id').primaryKey(),
  title: text('title').notNull(),
  deletedAt: timestamp('deleted_at'), // NULL = not deleted
});

// Helper fragments
export const notDeleted = isNull(posts.deletedAt);

// Query: always filter out soft-deleted
const activePosts = await db.select().from(posts).where(notDeleted);

// Soft delete
await db.update(posts)
  .set({ deletedAt: new Date() })
  .where(eq(posts.id, postId));

// Hard delete (cleanup old soft-deleted)
await db.delete(posts)
  .where(lt(posts.deletedAt, thirtyDaysAgo));

// Use a helper
function softDelete(table: typeof posts, id: number) {
  return db.update(table)
    .set({ deletedAt: new Date() } as any)
    .where(eq(table.id, id));
}
```

---

## Transaction Patterns

### Create-with-Related (Unit of Work)

```typescript
async function createUserWithProfile(data: CreateUserInput) {
  return db.transaction(async (tx) => {
    const [user] = await tx.insert(users)
      .values({ email: data.email, name: data.name })
      .returning();

    await tx.insert(profiles)
      .values({ userId: user.id, bio: data.bio });

    return user;
  });
}
```

### Read-Modify-Write (Optimistic Concurrency)

```typescript
async function transferFunds(fromId: number, toId: number, amount: number) {
  return db.transaction(async (tx) => {
    // Lock row for update (PostgreSQL)
    const [fromAccount] = await tx.select()
      .from(accounts)
      .where(eq(accounts.id, fromId))
      .for('update');

    if (!fromAccount || fromAccount.balance < amount) {
      throw new Error('Insufficient funds');
    }

    await tx.update(accounts)
      .set({ balance: sql`${accounts.balance} - ${amount}` })
      .where(eq(accounts.id, fromId));

    await tx.update(accounts)
      .set({ balance: sql`${accounts.balance} + ${amount}` })
      .where(eq(accounts.id, toId));
  });
}
```

### Transaction with Rollback on Condition

```typescript
await db.transaction(async (tx) => {
  await tx.insert(orders).values({ userId, total });
  const [stock] = await tx.select().from(inventory).where(eq(inventory.productId, productId));

  if (!stock || stock.quantity < orderQuantity) {
    tx.rollback();   // Explicit rollback
    return;
  }

  await tx.update(inventory)
    .set({ quantity: stock.quantity - orderQuantity })
    .where(eq(inventory.productId, productId));
});
```

---

## Migration Workflow Patterns

### Development Workflow

```bash
# 1. Edit schema in db/schema.ts

# 2. Generate migration SQL
npx drizzle-kit generate
# -> ./drizzle/0001_add_user_avatar.sql

# 3. Push to dev DB
npx drizzle-kit migrate

# 4. Review generated SQL before committing
cat ./drizzle/0001_add_user_avatar.sql
```

### Production Migration

```typescript
// db/migrate.ts - Run as deployment step
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import 'dotenv/config';

async function main() {
  const pool = new Pool({ connectionString: process.env.DATABASE_URL });
  const db = drizzle(pool);

  console.log('Running migrations...');
  await migrate(db, { migrationsFolder: './drizzle' });
  console.log('Migrations complete.');

  await pool.end();
  process.exit(0);
}

main().catch((err) => {
  console.error('Migration failed:', err);
  process.exit(1);
});
```

### Package.json Scripts

```json
{
  "scripts": {
    "db:generate": "drizzle-kit generate",
    "db:migrate": "drizzle-kit migrate",
    "db:push": "drizzle-kit push",
    "db:studio": "drizzle-kit studio",
    "db:drop": "drizzle-kit drop",
    "db:introspect": "drizzle-kit introspect",
    "db:check": "drizzle-kit check",
    "db:seed": "tsx db/seed.ts",
    "db:reset": "drizzle-kit drop && drizzle-kit generate && drizzle-kit migrate && tsx db/seed.ts",
    "db:prod:migrate": "tsx db/migrate.ts"
  }
}
```

### CI/CD Migration Step

```yaml
# .github/workflows/deploy.yml
- name: Run DB Migrations
  run: npx tsx db/migrate.ts
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

---

## Performance Patterns

### Always Filter by Indexed Columns

```typescript
// GOOD: email has a unique index
await db.select().from(users).where(eq(users.email, 'alice@test.com'));

// BAD: no index on name for LIKE prefix queries
await db.select().from(users).where(like(users.name, '%Smith%'));
// Fix: add index, or use full-text search for text matching
```

### Batch Fetch Related Data (Avoid N+1)

```typescript
// BAD: N+1 query — one query per user for their posts
const users = await db.select().from(users);
for (const user of users) {
  user.posts = await db.select().from(posts).where(eq(posts.authorId, user.id));
}

// GOOD: use relational query API — single query with joins
const usersWithPosts = await db.query.users.findMany({
  with: { posts: true },
});

// GOOD: use inArray for batch fetch when you need the SQL-like API
const userIds = [1, 2, 3, 4, 5];
const userPosts = await db.select().from(posts)
  .where(inArray(posts.authorId, userIds));

// Then group in-memory
const postsByUser = new Map<number, Post[]>();
for (const post of userPosts) {
  const list = postsByUser.get(post.authorId) || [];
  list.push(post);
  postsByUser.set(post.authorId, list);
}
```

### Use $count Instead of .select({ count })

```typescript
// Preferred
const total = await db.$count(users);
const active = await db.$count(users, eq(users.isActive, true));

// Alternative (same result, more verbose)
const [{ value }] = await db.select({ value: count() }).from(users);
```

### Prepared Statements for Hot Queries

```typescript
// Prepare once
const getUserByEmail = db.select()
  .from(users)
  .where(eq(users.email, sql.placeholder('email')))
  .prepare('getUserByEmail');

// Execute many times
for (const email of emails) {
  const [user] = await getUserByEmail.execute({ email });
}
```

### PostgreSQL FOR UPDATE / Row Locking

```typescript
// Row-level lock
await db.select().from(users)
  .where(eq(users.id, id))
  .for('update');               // FOR UPDATE

await db.select().from(users)
  .where(eq(users.id, id))
  .for('no key update');        // FOR NO KEY UPDATE

await db.select().from(users)
  .where(eq(users.id, id))
  .for('share');                // FOR SHARE

// With NOWAIT or SKIP LOCKED
await db.select().from(users)
  .where(eq(users.id, id))
  .for('update', { nowait: true });

await db.select().from(users)
  .where(eq(users.id, id))
  .for('update', { skipLocked: true });
```

---

## Type-Safe Patterns

### Infer Types from Schema

```typescript
import type { InferSelectModel, InferInsertModel } from 'drizzle-orm';

// Export types alongside schema
export type User = InferSelectModel<typeof users>;
export type NewUser = InferInsertModel<typeof users>;
export type Post = InferSelectModel<typeof posts>;

// Or use $inferSelect / $inferInsert
export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
```

### Type-Safe Repositories

```typescript
type Table = typeof users;
type Row = typeof users.$inferSelect;
type Insert = typeof users.$inferInsert;

class UserRepository {
  async findById(id: number): Promise<Row | undefined> {
    const [user] = await db.select().from(users).where(eq(users.id, id));
    return user;
  }

  async create(data: Insert): Promise<Row> {
    const [user] = await db.insert(users).values(data).returning();
    return user;
  }

  async update(id: number, data: Partial<Insert>): Promise<Row> {
    const [user] = await db.update(users)
      .set(data)
      .where(eq(users.id, id))
      .returning();
    return user;
  }
}
```

### Schema Validation Integration

```typescript
// Zod
import { createInsertSchema, createSelectSchema } from 'drizzle-zod';

export const insertUserSchema = createInsertSchema(users, {
  email: (schema) => schema.email.email(),
  name: (schema) => schema.min(2).max(100),
}).omit({ id: true, createdAt: true, updatedAt: true });

export const updateUserSchema = insertUserSchema.partial();

// Valibot
import { createInsertSchema, createSelectSchema } from 'drizzle-valibot';
const insertUserSchema = createInsertSchema(users);
```

---

## Logging

```typescript
import { drizzle } from 'drizzle-orm/node-postgres';

const db = drizzle(pool, {
  logger: {
    logQuery(query, params) {
      console.log('SQL:', query, '| Params:', params);
    },
  },
});

// Or use built-in
const db = drizzle(pool, { logger: true });
// Outputs: SELECT "users"."id", "users"."email" FROM "users" [params: []]
```

---

## Integration Patterns

### Express

```typescript
import express from 'express';
import { db } from './db';
import { users } from './db/schema';
import { eq } from 'drizzle-orm';

const app = express();
app.use(express.json());

app.get('/api/users', async (req, res) => {
  const allUsers = await db.select().from(users);
  res.json(allUsers);
});

app.get('/api/users/:id', async (req, res) => {
  const user = await db.query.users.findFirst({
    where: eq(users.id, Number(req.params.id)),
  });
  if (!user) return res.status(404).json({ error: 'Not found' });
  res.json(user);
});

app.post('/api/users', async (req, res) => {
  const [user] = await db.insert(users).values(req.body).returning();
  res.status(201).json(user);
});
```

### Fastify

```typescript
import fastify from 'fastify';
import { db } from './db';
import { users } from './db/schema';
import { eq } from 'drizzle-orm';

const app = fastify();

app.get('/api/users', async () => {
  return db.select().from(users);
});

app.post('/api/users', async (request, reply) => {
  const [user] = await db.insert(users)
    .values(request.body as any)
    .returning();
  reply.code(201);
  return user;
});
```

### Cloudflare Workers / Hono

```typescript
import { drizzle } from 'drizzle-orm/d1';
import { Hono } from 'hono';
import { users } from './schema';
import { eq } from 'drizzle-orm';

const app = new Hono<{ Bindings: { DB: D1Database } }>();

app.get('/api/users', async (c) => {
  const db = drizzle(c.env.DB);
  const allUsers = await db.select().from(users);
  return c.json(allUsers);
});

app.post('/api/users', async (c) => {
  const db = drizzle(c.env.DB);
  const body = await c.req.json();
  const [user] = await db.insert(users).values(body).returning();
  return c.json(user, 201);
});

export default app;
```

### Next.js App Router (Server Components)

```typescript
// app/users/page.tsx
import { db } from '@/db';
import { users } from '@/db/schema';

export default async function UsersPage() {
  const allUsers = await db.select().from(users);
  return (
    <ul>
      {allUsers.map((user) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

---

## Testing Patterns

### In-Memory SQL.js for Unit Tests

```typescript
import { drizzle } from 'drizzle-orm/sql-js';
import initSqlJs from 'sql.js';
import { users, posts } from '../db/schema';

async function createTestDb() {
  const SQL = await initSqlJs();
  const sqlJsDb = new SQL.Database();
  const db = drizzle(sqlJsDb);

  // Run DDL from generated migration files or write inline
  sqlJsDb.run(`
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL
    );
    CREATE TABLE posts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      author_id INTEGER REFERENCES users(id)
    );
  `);

  return db;
}

test('inserts and retrieves user', async () => {
  const db = await createTestDb();
  await db.insert(users).values({ email: 'test@test.com', name: 'Test' });
  const all = await db.select().from(users);
  expect(all).toHaveLength(1);
  expect(all[0].email).toBe('test@test.com');
});
```

### PGlite for PostgreSQL-compatible Tests

```typescript
import { drizzle } from 'drizzle-orm/pglite';
import { PGlite } from '@electric-sql/pglite';
import { migrate } from 'drizzle-orm/pglite/migrator';

async function createTestDb() {
  const client = new PGlite();
  const db = drizzle(client);
  await migrate(db, { migrationsFolder: './drizzle' });
  return db;
}
```

### Transaction Rollback for Test Isolation

```typescript
let db: PgDatabase;
let tx: PgTransaction;

beforeEach(async () => {
  db = drizzle(pool);
  tx = await db.transaction(async (t) => t as any);
  // All tests use tx instead of db; changes roll back automatically
});

afterEach(async () => {
  await tx.rollback();
});

test('creates user', async () => {
  await tx.insert(users).values({ email: 'test@test.com', name: 'Test' });
  const [u] = await tx.select().from(users).where(eq(users.email, 'test@test.com'));
  expect(u).toBeDefined();
});
```

---

## Monorepo Patterns

### Shared Schema Package

```text
packages/
  db-schema/           # Shared Drizzle schema
    src/
      schema/
        users.ts
        posts.ts
        index.ts
      index.ts
    package.json
  api/                 # Backend API server
  web/                 # Frontend (uses types from db-schema)
```

```typescript
// packages/db-schema/src/index.ts
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema';

export * from './schema'; // Re-export all tables, relations, types
export { schema };

// Optional: export a db factory
export function createDb(url: string) {
  const pool = new Pool({ connectionString: url });
  return drizzle(pool, { schema });
}
```

```typescript
// packages/api/src/routes/users.ts
import { db } from '../db';           // initialized createDb from db-schema
import { users, type User } from '@myorg/db-schema';
// `type User` is fully type-safe, inferred from the Drizzle table
```

---

## Seeding Patterns

```typescript
// db/seed.ts
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import { users, posts, roleEnum } from './schema';
import { eq } from 'drizzle-orm';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle(pool);

async function seed() {
  // Clear existing data (order matters due to FK constraints)
  await db.delete(posts);
  await db.delete(users);

  // Insert fixtures
  const [admin] = await db.insert(users).values({
    email: 'admin@example.com',
    name: 'Admin',
    role: 'admin',
  }).returning();

  const [user] = await db.insert(users).values({
    email: 'user@example.com',
    name: 'Test User',
  }).returning();

  // Bulk insert
  await db.insert(posts).values([
    { title: 'Getting Started', content: '...', authorId: admin.id, published: true },
    { title: 'Advanced Patterns', content: '...', authorId: admin.id, published: true },
    { title: 'Draft Post', content: '...', authorId: user.id, published: false },
  ]);

  console.log(`Seeded ${2} users and ${3} posts`);
  await pool.end();
}

seed().catch((e) => { console.error(e); process.exit(1); });
```

---

## SQL Escape Hatch Patterns

### Computed / Derived Columns

```typescript
import { sql } from 'drizzle-orm';

const result = await db.select({
  id: users.id,
  displayName: sql<string>`COALESCE(${users.nickname}, ${users.name})`.as('displayName'),
  daysSinceCreation: sql<number>`EXTRACT(DAY FROM NOW() - ${users.createdAt})`.as('daysSince'),
}).from(users);
```

### Raw Execution for DDL / Admin

```typescript
await db.execute(sql`TRUNCATE TABLE logs RESTART IDENTITY CASCADE`);
await db.execute(sql`REFRESH MATERIALIZED VIEW user_summary_mv`);
await db.execute(sql`VACUUM ANALYZE`);
await db.execute(sql`CREATE EXTENSION IF NOT EXISTS "uuid-ossp"`);
```

### Conditionally Adding Clauses

```typescript
function buildQuery(filters: Filters, sort?: Sort) {
  let query = db.select().from(users).$dynamic();

  if (filters.role) {
    query = query.where(eq(users.role, filters.role));
  }
  if (sort) {
    const dir = sort.direction === 'asc' ? asc : desc;
    query = query.orderBy(dir(users[sort.field as keyof typeof users]));
  }

  return query;
}
```
