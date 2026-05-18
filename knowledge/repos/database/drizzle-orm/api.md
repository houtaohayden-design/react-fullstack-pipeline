# Drizzle ORM API Reference

> Source: https://github.com/drizzle-team/drizzle-orm (v0.45.3)
> Category: database | Stars: 25k+
> Last trained: 2026-05-18

## Overview

Drizzle ORM is a headless, TypeScript-first SQL ORM at ~7.4kb minified+gzipped with zero dependencies. Supports PostgreSQL, MySQL/MariaDB, SQLite, SingleStore, and Gel. Works across Node.js, Bun, Deno, Cloudflare Workers, and Edge runtimes.

---

## Installation & Setup

```bash
npm install drizzle-orm
npm install -D drizzle-kit

# Driver packages (pick one per DB)
npm install pg                          # PostgreSQL: node-postgres
npm install postgres                    # PostgreSQL: Postgres.js
npm install @vercel/postgres            # PostgreSQL: Vercel
npm install @neondatabase/serverless    # PostgreSQL: Neon
npm install mysql2                      # MySQL
npm install @planetscale/database       # MySQL: PlanetScale
npm install better-sqlite3              # SQLite
npm install @libsql/client              # SQLite: Turso/LibSQL
npm install sql.js                      # SQLite: In-browser WASM
```

### Basic Connection

```typescript
// PostgreSQL (node-postgres)
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle({ client: pool });

// PostgreSQL (Postgres.js)
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
const client = postgres(process.env.DATABASE_URL);
const db = drizzle({ client });

// MySQL
import { drizzle } from 'drizzle-orm/mysql2';
import mysql from 'mysql2/promise';
const connection = await mysql.createConnection(process.env.DATABASE_URL);
const db = drizzle({ client: connection });

// SQLite (better-sqlite3)
import { drizzle } from 'drizzle-orm/better-sqlite3';
import Database from 'better-sqlite3';
const sqlite = new Database('local.db');
const db = drizzle({ client: sqlite });

// Turso / LibSQL
import { drizzle } from 'drizzle-orm/libsql';
import { createClient } from '@libsql/client';
const client = createClient({ url: process.env.TURSO_URL, authToken: process.env.TURSO_TOKEN });
const db = drizzle({ client });

// Cloudflare D1 (no extra driver)
import { drizzle } from 'drizzle-orm/d1';
const db = drizzle(env.DB);

// Bun SQLite
import { drizzle } from 'drizzle-orm/bun-sqlite';
import { Database } from 'bun:sqlite';
const db = drizzle(new Database('local.db'));

// PGlite (in-process PostgreSQL)
import { drizzle } from 'drizzle-orm/pglite';
import { PGlite } from '@electric-sql/pglite';
const client = new PGlite('id://my-db');
const db = drizzle({ client });
```

### drizzle.config.ts

```typescript
import { defineConfig } from 'drizzle-kit';
export default defineConfig({
  schema: './src/db/schema.ts',
  out: './drizzle',
  dialect: 'postgresql', // 'postgresql' | 'mysql' | 'sqlite' | 'singlestore'
  dbCredentials: { url: process.env.DATABASE_URL! },
  verbose: true,
  strict: true,
});
```

---

## Schema Definition

### PostgreSQL Table

```typescript
import {
  pgTable, serial, text, varchar, integer, boolean, timestamp,
  json, jsonb, uuid, real, doublePrecision, decimal, date, time,
  interval, bigint, bigserial, smallint, smallserial, char, cidr,
  inet, macaddr, macaddr8, point, line, geometry,
  vector, halfvec, sparsevec, bit,
  pgEnum, customType, unique, uniqueIndex, index,
  foreignKey, primaryKey, check
} from 'drizzle-orm/pg-core';

// Enum
export const roleEnum = pgEnum('role', ['admin', 'user', 'moderator']);

// Table
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  name: text('name').notNull(),
  role: roleEnum('role').default('user'),
  metadata: jsonb('metadata'),
  avatar: text('avatar').default('https://example.com/default.png'),
  isActive: boolean('is_active').default(true),
  score: decimal('score', { precision: 10, scale: 2 }),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').$onUpdate(() => new Date()),
}, (table) => ({
  emailIdx: index('email_idx').on(table.email),
  nameRoleIdx: index('name_role_idx').on(table.name, table.role),
  uniqueEmail: unique('unique_email').on(table.email),
}));
```

### MySQL Table

```typescript
import {
  mysqlTable, serial, varchar, text, int, boolean, timestamp,
  mysqlEnum, json, decimal, float, double, tinyint, mediumint,
  bigint, binary, varbinary, char, year, datetime, date, time,
  unique, index, foreignKey, primaryKey
} from 'drizzle-orm/mysql-core';

export const users = mysqlTable('users', {
  id: serial('id').primaryKey(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  name: text('name').notNull(),
  profile: json('profile'),
  score: decimal('score', { precision: 10, scale: 2 }),
  createdAt: timestamp('created_at').defaultNow().notNull(),
}, (table) => ({
  emailIdx: index('email_idx').on(table.email),
}));
```

### SQLite Table

```typescript
import {
  sqliteTable, integer, text, real, blob, numeric,
  uniqueIndex, index, foreignKey, primaryKey, check
} from 'drizzle-orm/sqlite-core';

export const users = sqliteTable('users', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  email: text('email').notNull().unique(),
  name: text('name').notNull(),
  settings: text('settings', { mode: 'json' }).$type<Settings>(),
  score: real('score').default(0),
  createdAt: text('created_at').default(sql`(current_timestamp)`),
}, (table) => ({
  emailIdx: index('email_idx').on(table.email),
}));
```

### Column Types Matrix

| Data Type | PostgreSQL | MySQL | SQLite |
|-----------|-----------|-------|--------|
| Auto-inc PK | `serial()`, `bigserial()`, `smallserial()` | `serial()` | `integer().primaryKey({ autoIncrement: true })` |
| Integer | `integer()`, `smallint()`, `bigint()` | `int()`, `tinyint()`, `smallint()`, `mediumint()`, `bigint()` | `integer()` |
| Text | `text()`, `varchar(n)`, `char(n)` | `text()`, `varchar(n)`, `char(n)` | `text()` |
| Boolean | `boolean()` | `boolean()` | `integer({ mode: 'boolean' })` |
| Timestamp | `timestamp()` | `timestamp()`, `datetime()` | `text()` for ISO strings |
| Date | `date()` | `date()` | `text()` |
| Time | `time()` | `time()` | `text()` |
| Interval | `interval()` | -- | -- |
| Float | `real()`, `doublePrecision()` | `float()`, `double()` | `real()` |
| Decimal | `decimal(precision, scale)` | `decimal(precision, scale)` | -- (use `real()`) |
| JSON | `json()`, `jsonb()` | `json()` | `text({ mode: 'json' })` |
| UUID | `uuid()` | `varchar(36)` | `text()` |
| Enum | `pgEnum()` | `mysqlEnum()` | `text()` + check |
| Blob/Binary | `customType<Buffer>()` | `binary()`, `varbinary()` | `blob()` |
| Year | -- | `year()` | -- |
| Special PG | `inet()`, `cidr()`, `macaddr()`, `macaddr8()`, `point()`, `line()`, `geometry()` | -- | -- |
| Vectors | `vector(n)`, `halfvec(n)`, `sparsevec(n)`, `bit(n)` | -- | -- |

### Column Builder Methods

```typescript
integer('id')
  .primaryKey()              // PRIMARY KEY (also sets NOT NULL)
  .notNull()                 // NOT NULL
  .unique()                  // UNIQUE constraint
  .default(value)            // DEFAULT <value>
  .defaultNow()              // DEFAULT NOW() / CURRENT_TIMESTAMP
  .$defaultFn(() => ...)     // Runtime dynamic default
  .$onUpdateFn(() => ...)    // ON UPDATE trigger
  .$type<BrandedType>()      // Brand/type-narrow the column data type
  .generatedAlwaysAs(expr)   // GENERATED ALWAYS AS (computed column)
  .references(() => ...)     // Foreign key reference
```

---

## Relations

### Exports

```typescript
import { relations, one, many } from 'drizzle-orm';
// The `relations()` function creates a Relations object attached to a table
// `one` and `many` are exposed via the helpers callback
```

### One-to-Many

```typescript
export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
}));

export const postsRelations = relations(posts, ({ one }) => ({
  author: one(users, {
    fields: [posts.authorId],
    references: [users.id],
  }),
}));
```

### Many-to-Many (Junction Table)

```typescript
export const usersToGroups = pgTable('users_to_groups', {
  userId: integer('user_id').notNull().references(() => users.id),
  groupId: integer('group_id').notNull().references(() => groups.id),
}, (t) => ({
  pk: primaryKey({ columns: [t.userId, t.groupId] }),
}));

export const usersRelations = relations(users, ({ many }) => ({
  usersToGroups: many(usersToGroups),
}));

export const groupsRelations = relations(groups, ({ many }) => ({
  usersToGroups: many(usersToGroups),
}));

export const usersToGroupsRelations = relations(usersToGroups, ({ one }) => ({
  user: one(users, { fields: [usersToGroups.userId], references: [users.id] }),
  group: one(groups, { fields: [usersToGroups.groupId], references: [groups.id] }),
}));
```

### One-to-One

```typescript
export const profiles = pgTable('profiles', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').notNull().unique().references(() => users.id),
  bio: text('bio'),
});

export const profilesRelations = relations(profiles, ({ one }) => ({
  user: one(users, { fields: [profiles.userId], references: [users.id] }),
}));
```

### Self-Referencing Relations

```typescript
export const categories = pgTable('categories', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  parentId: integer('parent_id'),
});

export const categoriesRelations = relations(categories, ({ one, many }) => ({
  parent: one(categories, {
    fields: [categories.parentId],
    references: [categories.id],
    relationName: 'parent_child',
  }),
  children: many(categories, { relationName: 'parent_child' }),
}));
```

---

## Queries

### SQL-Like API (db.select / db.insert / db.update / db.delete)

```typescript
// Full table select
const allUsers = await db.select().from(users);

// Partial column select
const result = await db.select({
  id: users.id,
  email: users.email,
}).from(users);

// Select distinct
await db.selectDistinct().from(users);
// or with specific columns
await db.selectDistinctOn([users.role]).from(users);
```

### Relational Query API (db.query)

When schema is provided to `drizzle(client, { schema })`, the relational API is available:

```typescript
// findMany
const posts = await db.query.posts.findMany({
  with: { author: true },
  where: eq(posts.published, true),
  orderBy: desc(posts.createdAt),
  limit: 10,
  offset: 0,
});

// findFirst (returns single record or undefined)
const user = await db.query.users.findFirst({
  where: eq(users.email, email),
  with: { posts: { with: { comments: true } } },
});

// Nested relations for findFirst (returns object, not array, for `one`)
const user = await db.query.users.findFirst({
  where: eq(users.id, 1),
  with: {
    profile: true,           // One-to-one -> object or null
    posts: {                 // One-to-many -> array
      orderBy: desc(posts.createdAt),
      limit: 5,
      with: {
        comments: true,       // Nested one-to-many
      },
    },
  },
});
```

### Select with Where / Filtering

```typescript
import {
  eq, ne, gt, gte, lt, lte, and, or, not,
  like, ilike, notLike, notIlike,
  inArray, notInArray, between, notBetween,
  isNull, isNotNull, exists, notExists,
  arrayContains, arrayContained, arrayOverlaps
} from 'drizzle-orm';

// Combined conditions
await db.select().from(users).where(and(
  eq(users.isActive, true),
  gt(users.age, 18),
  like(users.name, '%Smith%'),
));

// IN clause
await db.select().from(users).where(inArray(users.role, ['admin', 'moderator']));

// BETWEEN
await db.select().from(users).where(between(users.createdAt, startDate, endDate));

// Case-insensitive LIKE (PostgreSQL)
await db.select().from(posts).where(ilike(posts.title, '%drizzle%'));

// NULL checks
await db.select().from(users).where(isNull(users.deletedAt));

// NOT
await db.select().from(users).where(not(eq(users.role, 'banned')));

// EXISTS subquery
await db.select().from(users).where(exists(
  db.select().from(posts).where(eq(posts.authorId, users.id))
));

// Array operators (PostgreSQL)
await db.select().from(posts).where(arrayContains(posts.tags, ['typescript']));
await db.select().from(posts).where(arrayOverlaps(posts.tags, ['orm', 'database']));
```

### Joins (SQL-like API)

```typescript
// Inner join
await db.select({
  userName: users.name,
  postTitle: posts.title,
})
.from(users)
.innerJoin(posts, eq(users.id, posts.authorId));

// Left join
await db.select().from(users).leftJoin(posts, eq(users.id, posts.authorId));

// Full join
await db.select().from(users).fullJoin(profiles, eq(users.id, profiles.userId));

// Right join
await db.select().from(users).rightJoin(posts, eq(users.id, posts.authorId));

// Lateral join
await db.select().from(users).leftJoinLateral(
  db.select({ postCount: count() }).from(posts).where(eq(posts.authorId, users.id)).as('post_counts'),
  sql`true`
);
```

### Aggregation

```typescript
import { count, countDistinct, sum, avg, min, max, sql } from 'drizzle-orm';

// Count all
const [{ value }] = await db.select({ value: count() }).from(users);

// Count with group by
const roleCounts = await db.select({
  role: users.role,
  count: count(),
}).from(users).groupBy(users.role);

// Multiple aggregations
const result = await db.select({
  authorId: posts.authorId,
  postCount: count(),
  avgLikes: avg(posts.likes),
  maxLikes: max(posts.likes),
  minLikes: min(posts.likes),
  totalViews: sum(posts.views),
}).from(posts).groupBy(posts.authorId);

// Having
await db.select({
  authorId: posts.authorId,
  postCount: count(),
}).from(posts).groupBy(posts.authorId).having(gt(count(), 5));

// countDistinct
await db.select({ uniqueVisitors: countDistinct(pageViews.ip) }).from(pageViews);
```

### Order, Limit, Offset

```typescript
import { asc, desc } from 'drizzle-orm';

await db.select().from(users)
  .orderBy(desc(users.createdAt), asc(users.name))
  .limit(10)
  .offset(20);  // page 3
```

### Insert

```typescript
// Single insert
await db.insert(users).values({
  email: 'alice@example.com',
  name: 'Alice',
});

// Batch insert
await db.insert(users).values([
  { email: 'alice@example.com', name: 'Alice' },
  { email: 'bob@example.com', name: 'Bob' },
]);

// Upsert - PostgreSQL
await db.insert(users)
  .values({ email: 'alice@example.com', name: 'Alice' })
  .onConflictDoUpdate({ target: users.email, set: { name: 'Alice Updated' } });

// Upsert - MySQL
await db.insert(users)
  .values({ email: 'alice@example.com', name: 'Alice' })
  .onDuplicateKeyUpdate({ set: { name: 'Alice Updated' } });

// Upsert - SQLite (OR REPLACE / OR IGNORE)
await db.insert(users)
  .values({ email: 'alice@example.com', name: 'Alice' })
  .onConflictDoUpdate({ target: users.email, set: { name: 'Alice Updated' } });

// On conflict do nothing
await db.insert(users)
  .values({ email: 'alice@example.com', name: 'Alice' })
  .onConflictDoNothing();

// On conflict do nothing with target
await db.insert(users)
  .values({ email: 'alice@example.com', name: 'Alice' })
  .onConflictDoNothing({ target: users.email });

// Returning (PostgreSQL, SQLite)
const [newUser] = await db.insert(users)
  .values({ email: 'alice@test.com', name: 'Alice' })
  .returning();

// Insert from select
await db.insert(subscribers).select(
  db.select({ email: users.email }).from(users).where(eq(users.isActive, true))
);
```

### Update

```typescript
// Basic update
await db.update(users)
  .set({ name: 'Alice Johnson', updatedAt: new Date() })
  .where(eq(users.id, 1));

// Returning
const [updated] = await db.update(users)
  .set({ name: 'New Name' })
  .where(eq(users.id, id))
  .returning();

// Update with join (MySQL)
await db.update(users)
  .set({ role: 'vip' })
  .innerJoin(subscriptions, eq(users.id, subscriptions.userId))
  .where(eq(subscriptions.tier, 'premium'));
```

### Delete

```typescript
// Basic delete
await db.delete(users).where(eq(users.id, 1));

// Returning
const [deleted] = await db.delete(users)
  .where(eq(users.id, id))
  .returning();

// Delete with join (MySQL / SQLite)
await db.delete(users)
  .innerJoin(inactiveFlag, eq(users.id, inactiveFlag.userId))
  .where(eq(inactiveFlag.daysInactive, gt(365)));
```

---

## Transactions

```typescript
// Manual transaction
await db.transaction(async (tx) => {
  await tx.insert(users).values({ name: 'Alice', email: 'alice@test.com' });
  const [user] = await tx.select().from(users).where(eq(users.email, 'alice@test.com'));
  await tx.insert(posts).values({ title: 'Hello', authorId: user.id });
});

// With isolation level (PostgreSQL)
await db.transaction(async (tx) => {
  // operations...
}, {
  isolationLevel: 'serializable',   // 'read committed' | 'repeatable read' | 'serializable'
  accessMode: 'read write',          // 'read only' | 'read write'
  deferrable: false,
});

// Nested transactions via savepoints (PostgreSQL)
await db.transaction(async (tx) => {
  await tx.insert(users).values({ name: 'Alice', email: 'alice@test.com' });
  await tx.transaction(async (tx2) => {
    await tx2.insert(posts).values({ title: 'Hello' });
  });
});
```

---

## Migrations (drizzle-kit)

```bash
# Generate migration SQL files from schema changes
npx drizzle-kit generate

# Apply migrations to database
npx drizzle-kit migrate

# Push schema directly to DB (dev only, no SQL files)
npx drizzle-kit push

# Drop all tables and recreate (development reset)
npx drizzle-kit drop

# Introspect existing database -> generate schema.ts
npx drizzle-kit introspect

# Check for drift between schema and database
npx drizzle-kit check

# Launch Drizzle Studio (GUI browser)
npx drizzle-kit studio

# Generate migration with custom name
npx drizzle-kit generate --name=add_user_avatar
```

### Programmatic Migration Runner

```typescript
// db/migrate.ts
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle(pool);

await migrate(db, { migrationsFolder: './drizzle' });
await pool.end();
```

### Migration Config Options

```typescript
export default defineConfig({
  dialect: 'postgresql',
  schema: './src/db/schema.ts',
  out: './drizzle',
  dbCredentials: { url: process.env.DATABASE_URL! },
  verbose: true,
  strict: true,
  migrations: {
    prefix: 'timestamp',          // 'timestamp' | 'supabase' | 'index'
    table: '__drizzle_migrations__',
    schema: 'public',
  },
});
```

---

## CTEs (Common Table Expressions)

```typescript
// Define a CTE
const activeUsers = db.$with('active_users').as(
  db.select({ id: users.id, name: users.name })
    .from(users)
    .where(eq(users.isActive, true))
);

// Use in query
const result = await db.with(activeUsers)
  .select()
  .from(activeUsers)
  .where(like(activeUsers.name, 'A%'));

// Recursive CTE
const recursiveCte = db.$with('org_tree').recursive(
  db.select({ id: categories.id, name: categories.name, parentId: categories.parentId })
    .from(categories)
    .where(isNull(categories.parentId))
    .unionAll(
      db.select({ id: categories.id, name: categories.name, parentId: categories.parentId })
        .from(categories)
        .innerJoin(recursiveCte, eq(categories.parentId, recursiveCte.id))
    )
);
```

---

## Views & Materialized Views

```typescript
import { pgView, pgMaterializedView } from 'drizzle-orm/pg-core';

// Regular view
export const activeUsersView = pgView('active_users_view').as((qb) =>
  qb.select().from(users).where(eq(users.isActive, true))
);

// View with explicit columns
export const userStatsView = pgView('user_stats_view', {
  userId: integer('user_id'),
  postCount: bigint('post_count', { mode: 'number' }),
}).as((qb) =>
  qb.select({
    userId: users.id,
    postCount: count(posts.id),
  }).from(users)
    .leftJoin(posts, eq(users.id, posts.authorId))
    .groupBy(users.id)
);

// Materialized view
export const userSummaryMV = pgMaterializedView('user_summary_mv').as((qb) =>
  qb.select({
    userId: users.id,
    email: users.email,
    postTotal: count(posts.id),
  }).from(users)
    .leftJoin(posts, eq(users.id, posts.authorId))
    .groupBy(users.id, users.email)
);

// Refresh materialized view
await db.refreshMaterializedView(userSummaryMV);
// With options
await db.refreshMaterializedView(userSummaryMV).concurrently();
await db.refreshMaterializedView(userSummaryMV).withNoData();
```

---

## Indexes & Unique Constraints

```typescript
// Index (inline via second argument to pgTable)
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: varchar('email', { length: 255 }).notNull(),
  name: text('name').notNull(),
  role: roleEnum('role'),
  createdAt: timestamp('created_at').defaultNow(),
}, (table) => ({
  // Single-column index
  emailIdx: index('email_idx').on(table.email),

  // Composite index
  nameRoleIdx: index('name_role_idx').on(table.name, table.role),

  // Unique index
  uniqueEmail: uniqueIndex('unique_email_idx').on(table.email),

  // Partial index (PostgreSQL)
  activeUsersIdx: index('active_users_idx')
    .on(table.email)
    .where(eq(table.role, 'admin')),

  // Index with method (PostgreSQL)
  ginIdx: index('gin_idx').using('gin', table.metadata),

  // Unique constraint (can be on multiple columns)
  uniqueEmailRole: unique('unique_email_role').on(table.email, table.role),
}));

// Standalone index creation
import { index, uniqueIndex } from 'drizzle-orm/pg-core';
export const emailIndex = index('email_idx').on(users.email);
export const nameEmailUnique = uniqueIndex('name_email_uidx').on(users.name, users.email);

// Concurrent index creation (PostgreSQL, non-blocking)
export const myIdx = index('my_idx').on(users.email).concurrently();
```

---

## Row-Level Security (RLS)

```typescript
import { pgTable, pgPolicy, pgRole } from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';

// Define roles
export const adminRole = pgRole('admin_role');
export const userRole = pgRole('user_role');

// Enable RLS on table
export const documents = pgTable('documents', {
  id: serial('id').primaryKey(),
  title: text('title').notNull(),
  content: text('content'),
  ownerId: integer('owner_id').notNull().references(() => users.id),
}, (table) => ({
  // Enable RLS via drizzle config, then define policies as extra config
}));

// Define RLS policies
export const documentsPolicy = pgPolicy('documents_select_policy', {
  as: 'permissive',     // 'permissive' | 'restrictive'
  for: 'select',        // 'all' | 'select' | 'insert' | 'update' | 'delete'
  to: userRole,           // role or 'public' | 'current_user'
  using: sql`owner_id = current_setting('app.current_user_id')::integer`,
  withCheck: sql`owner_id = current_setting('app.current_user_id')::integer`,
});

// Create roles via drizzle-kit
// The policy is then linked to the table:
// export const documents = pgTable('documents', {...}, (table) => ({
//   enableRls: true,
//   policy: documentsPolicy,
// }));
```

---

## Schemas (PostgreSQL Namespaces)

```typescript
import { pgSchema } from 'drizzle-orm/pg-core';

// Create a schema
export const tenantSchema = pgSchema('tenant_123');

// Define tables within the schema
export const tenantUsers = tenantSchema.table('users', {
  id: serial('id').primaryKey(),
  email: varchar('email', { length: 255 }).notNull(),
});

// Enums within a schema
export const tenantRoleEnum = tenantSchema.enum('role', ['admin', 'member']);

// Sequences within a schema
export const tenantSeq = tenantSchema.sequence('order_seq', {
  startWith: 1000,
  increment: 1,
  maxValue: 99999,
});
```

---

## Custom Types

```typescript
import { customType } from 'drizzle-orm/pg-core';

// Custom scalar type
const bytea = customType<{ data: Buffer; notNull: false; default: false }>({
  dataType() { return 'bytea'; },
  toDriver(value: Buffer): string { return value.toString('hex'); },
  fromDriver(value: string): Buffer { return Buffer.from(value, 'hex'); },
});

// Usage in table
const files = pgTable('files', {
  id: serial('id').primaryKey(),
  data: bytea('data').notNull(),
});

// Custom type with config
const tsVector = customType<{ data: string; driverData: string }>({
  dataType(config) { return 'tsvector'; },
  fromDriver(value) { return value; },
  toDriver(value) { return value; },
});
```

---

## Raw SQL Escape Hatch

```typescript
import { sql } from 'drizzle-orm';

// Raw SQL expression in select
const result = await db.select({
  id: users.id,
  fullName: sql<string>`${users.firstName} || ' ' || ${users.lastName}`.as('fullName'),
  ageInYears: sql<number>`EXTRACT(YEAR FROM AGE(${users.birthDate}))`.as('age'),
}).from(users);

// Raw SQL in WHERE
await db.select().from(users).where(
  sql`${users.name} ILIKE '%' || ${searchTerm} || '%'`
);

// Direct execution
await db.execute(sql`TRUNCATE TABLE users RESTART IDENTITY CASCADE`);
await db.execute(sql`CREATE INDEX IF NOT EXISTS idx_email ON users(email)`);

// Typed raw query
const rows = await db.execute<{ id: number; email: string }>(
  sql`SELECT id, email FROM users WHERE is_active = true`
);
```

### Prepared Statements

```typescript
// Named prepared statement
const getUserByEmail = db.select()
  .from(users)
  .where(eq(users.email, sql.placeholder('email')))
  .prepare('getUserByEmail');

// Execute with different parameters
const alice = await getUserByEmail.execute({ email: 'alice@example.com' });
const bob = await getUserByEmail.execute({ email: 'bob@example.com' });

// Insert prepared statement
const createUser = db.insert(users).values({
  email: sql.placeholder('email'),
  name: sql.placeholder('name'),
}).returning().prepare('createUser');

const [user] = await createUser.execute({ email: 'new@test.com', name: 'New User' });
```

---

## $count Helper

```typescript
// Count all rows
const total = await db.$count(users);

// Count with filter
const activeCount = await db.$count(users, eq(users.isActive, true));
```

---

## Type Inference

```typescript
import type { InferSelectModel, InferInsertModel } from 'drizzle-orm';

// Infer types from table definition
type User = InferSelectModel<typeof users>;    // What SELECT returns
type NewUser = InferInsertModel<typeof users>; // What INSERT accepts

// Or via table's own helpers
type User = typeof users.$inferSelect;
type NewUser = typeof users.$inferInsert;

// The $inferInsert type respects:
// - Columns with defaults become optional
// - Auto-increment columns become optional
// - Columns with $defaultFn become optional
// - Columns with .default() become optional
// - Columns with generatedAlwaysAs are excluded entirely

// Extract table name as string literal
type TableName = typeof users.$name;         // 'users'
```

---

## Set Operations (UNION, INTERSECT, EXCEPT)

```typescript
import { union, unionAll, intersect, intersectAll, except, exceptAll } from 'drizzle-orm';

// Union
await db.select({ id: users.id, name: users.name }).from(users)
  .union(db.select({ id: admins.id, name: admins.name }).from(admins));

// Union All
await db.select({ id: users.id }).from(users)
  .unionAll(db.select({ id: archived.id }).from(archivedUsers));

// Intersect
await db.select({ email: users.email }).from(users)
  .intersect(db.select({ email: subscribers.email }).from(subscribers));

// Except
await db.select({ id: users.id }).from(users)
  .except(db.select({ userId: blocked.userId }).from(blocked));
```

---

## Aliases

```typescript
import { alias } from 'drizzle-orm';

// Table aliases
const editor = alias(users, 'editor');

await db.select({
  postTitle: posts.title,
  authorName: users.name,
  editorName: editor.name,
})
.from(posts)
.leftJoin(users, eq(posts.authorId, users.id))
.leftJoin(editor, eq(posts.editorId, editor.id));
```

---

## Read Replicas

```typescript
import { withReplicas } from 'drizzle-orm/pg-core';

const primary = drizzle(primaryPool);
const replica1 = drizzle(replicaPool1);
const replica2 = drizzle(replicaPool2);

const db = withReplicas(primary, [replica1, replica2]);
// Reads round-robin to replicas; writes go to primary

// Usage is transparent
const users = await db.select().from(schema.users);       // read -> replica
await db.insert(schema.users).values({ name: 'Alice' });   // write -> primary
```

---

## Caching (Upstash Redis)

```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { upstash } from 'drizzle-orm/cache/upstash';
import { Redis } from '@upstash/redis';

const redis = new Redis({ url: '...', token: '...' });
const db = drizzle(pool);
const cachedDb = upstash(db, redis);

// Cached query
const user = await cachedDb.query.users.findFirst({
  where: eq(users.id, 1),
  cache: { ttl: 60, key: 'user:1' }, // Cache for 60s
});
```

---

## Database Introspection (Pull Schema)

```bash
# Pull schema from existing DB into schema.ts
npx drizzle-kit introspect

# With specific output
npx drizzle-kit introspect --out=./src/db/generated.ts

# PostgreSQL with specific schema
npx drizzle-kit introspect --schema=public,app
```

---

## Supported Drivers Matrix

| Database | Drivers / Platforms |
|----------|-------------------|
| PostgreSQL | `node-postgres` (pg), `postgres-js` (postgres), `@vercel/postgres`, `@neondatabase/serverless`, `@neondatabase/http`, `@aws-sdk/client-rds-data`, `@tidbcloud/serverless`, `pglite`, `supabase`, `xata-http` |
| MySQL | `mysql2`, `@planetscale/database`, `@tidbcloud/serverless` |
| SQLite | `better-sqlite3`, `@libsql/client` (Turso/HTTP/WS), `sql.js` (WASM), `bun:sqlite`, `@cloudflare/d1`, `@op-engineering/op-sqlite`, `expo-sqlite`, `durable-sqlite` |
| SingleStore | `mysql2` |
| Gel | `gel` |
| Bridge Adapters | `knex`, `kysely`, `prisma` |

---

## Notable Ecosystem Packages

| Package | Purpose |
|---------|---------|
| `drizzle-orm` | Core ORM (~7.4kb gzip, 0 deps) |
| `drizzle-kit` | CLI: generate migrations, push, introspect, Studio, drop, check |
| `drizzle-zod` | Auto-generate Zod schemas from Drizzle tables |
| `drizzle-valibot` | Auto-generate Valibot schemas from Drizzle tables |
| `drizzle-typebox` | Auto-generate TypeBox schemas |
| `drizzle-arktype` | Auto-generate ArkType schemas |
| `drizzle-seed` | Deterministic seeding utilities |
| `eslint-plugin-drizzle` | ESLint best-practice rules |
