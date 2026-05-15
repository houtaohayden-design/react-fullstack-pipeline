---
name: react-pipeline:database
description: Use when designing a database for a React app's backend — schema design, migrations, ORM selection (Prisma/Drizzle/Kysely), and query optimization.
---

# Database for React Backends

## Core Principle
SQLite for small-medium apps (zero ops), PostgreSQL when scaling or needing advanced features. Drizzle for type-safe SQL, Prisma for rapid iteration.

## ORM Selection

| ORM | Approach | Type Safety | Best For |
|-----|----------|-------------|----------|
| **Drizzle** | SQL-like, zero-runtime | Excellent | Type-safe queries, edge/serverless |
| **Prisma** | DSL schema → generated client | Good | Rapid dev, migrations, studio UI |
| **Kysely** | Expression builder | Excellent | SQL power users, complex queries |

**Default recommendation:** Drizzle — type-safe, no code generation, works everywhere.

## SQLite Setup (Drizzle)

```bash
npm install drizzle-orm better-sqlite3
npm install -D drizzle-kit
```

```ts
// db/schema.ts
import { sqliteTable, text, integer } from 'drizzle-orm/sqlite-core'

export const users = sqliteTable('users', {
  id: text('id').primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name').notNull(),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull().defaultNow()
})

export const posts = sqliteTable('posts', {
  id: text('id').primaryKey(),
  title: text('title').notNull(),
  content: text('content'),
  authorId: text('author_id').references(() => users.id),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull().defaultNow()
})
```

```ts
// db/index.ts
import { drizzle } from 'drizzle-orm/better-sqlite3'
import Database from 'better-sqlite3'

const sqlite = new Database('data.db')
sqlite.pragma('journal_mode = WAL')  // Read/write concurrency

export const db = drizzle(sqlite)
```

### Queries
```ts
// Select
const all = db.select().from(users).all()
const byId = db.select().from(users).where(eq(users.id, id)).get()

// Insert
const newUser = db.insert(users).values({ id: uuid(), email, name }).returning().get()

// Update
db.update(users).set({ name: newName }).where(eq(users.id, id)).run()

// Delete
db.delete(users).where(eq(users.id, id)).run()

// Join
const postsWithAuthor = db.select({
  postTitle: posts.title,
  authorName: users.name
}).from(posts).innerJoin(users, eq(posts.authorId, users.id)).all()
```

### Migrations
```bash
npx drizzle-kit generate   # Generate migration files
npx drizzle-kit migrate    # Apply migrations
```

## PostgreSQL Setup (Drizzle)

```bash
npm install drizzle-orm postgres
```

```ts
import { drizzle } from 'drizzle-orm/postgres-js'
import postgres from 'postgres'

const client = postgres(process.env.DATABASE_URL!)
export const db = drizzle(client)
```

## Schema Design Principles
- **UUIDs** for primary keys (not autoincrement — leaks info, can't merge)
- **Timestamps** on every table (`created_at`, `updated_at`)
- **Soft deletes** with `deleted_at` timestamp (not hard deletes)
- **Indexes** on foreign keys and frequently queried columns
- **Normalize** until there's a performance reason not to

## Production Considerations
- **SQLite**: WAL mode + Litestream for continuous backup to S3
- **PostgreSQL**: Supabase (free tier 500MB) or Neon (serverless)
- **Connection pooling**: Use `pgbouncer` or ORM's built-in pooling
