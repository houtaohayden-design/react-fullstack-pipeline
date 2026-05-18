# Drizzle ORM Backend Architecture Patterns

> Source: https://github.com/drizzle-team/drizzle-orm
> Category: database | Stars: 25k+
> Last trained: 2026-05-18

## Connection Management

### Connection Pooling (PostgreSQL with pg)

```typescript
import { Pool } from 'pg';
import { drizzle } from 'drizzle-orm/node-postgres';

const pool = new Pool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  max: 20,                        // Maximum connections in pool
  idleTimeoutMillis: 30000,       // Close idle clients after 30s
  connectionTimeoutMillis: 5000,  // Fail after 5s if can't connect
  maxUses: 7500,                  // Close and replace after 7500 uses
});

export const db = drizzle(pool);

// Graceful shutdown
async function shutdown() {
  await pool.end();
}
process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);
```

### Connection Pool Sizing

```text
Rule of thumb for PostgreSQL pool size:
  max_connections = (number_of_CPU_cores * 2) + (number_of_SSD_disks)

Typical values:
  - Dev machine:           max: 10
  - Single server (2 CPU): max: 20
  - Production (4 CPU):    max: 40
  - Serverless function:   max: 1 per function instance

Avoid setting pool max higher than the DB's max_connections / number_of_app_instances.
```

### Connection Pool + Schema Singleton

```typescript
// db/index.ts -- Single module that creates and exports the DB instance
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema';

let pool: Pool;
let db: ReturnType<typeof drizzle<typeof schema>>;

function getDb() {
  if (!db) {
    pool = new Pool({ connectionString: process.env.DATABASE_URL, max: 20 });
    db = drizzle(pool, { schema });
  }
  return db;
}

export { getDb as db, pool };
export type DB = ReturnType<typeof getDb>;
```

### SQLite WAL Mode (Concurrent Reads)

```typescript
import Database from 'better-sqlite3';
import { drizzle } from 'drizzle-orm/better-sqlite3';

const sqlite = new Database('data.db');

// Enable WAL mode for concurrent reads
sqlite.pragma('journal_mode = WAL');
sqlite.pragma('busy_timeout = 5000');
sqlite.pragma('cache_size = -20000');    // 20MB cache
sqlite.pragma('foreign_keys = ON');
sqlite.pragma('synchronous = NORMAL');    // Safe with WAL mode

export const db = drizzle(sqlite);
```

### Serverless Connection Patterns

```typescript
// Neon Serverless (HTTP-based PostgreSQL)
import { neon } from '@neondatabase/serverless';
import { drizzle } from 'drizzle-orm/neon-http';

const sql = neon(process.env.DATABASE_URL!);
export const db = drizzle(sql);

// PlanetScale (HTTP-based MySQL)
import { connect } from '@planetscale/database';
import { drizzle } from 'drizzle-orm/planetscale-serverless';

const connection = connect({ url: process.env.DATABASE_URL });
export const db = drizzle(connection);

// Cloudflare D1 (per-request instantiation)
import { drizzle } from 'drizzle-orm/d1';
export function getDb(d1: D1Database) {
  return drizzle(d1, { schema });
}
```

---

## Migration Strategies

### Push vs Generate Strategy Comparison

| Strategy | Command | When to Use | SQL Files |
|----------|---------|------------|-----------|
| **Push** | `drizzle-kit push` | Local dev, prototyping, rapid iteration | No |
| **Generate + Migrate** | `drizzle-kit generate` + `drizzle-kit migrate` | Production, team environments, CI/CD | Yes |

```bash
# Push: direct schema sync (dev only)
npx drizzle-kit push
# Pros: fast, no files to manage
# Cons: no review, no rollback, no audit trail

# Generate + Migrate: SQL file workflow (production)
npx drizzle-kit generate   # Creates ./drizzle/0001_xxx.sql
npx drizzle-kit migrate    # Applies pending SQL files
# Pros: reviewable SQL, version controlled, reproducible
# Cons: extra step, merge conflicts on migration files
```

### Migration Naming Convention

```text
drizzle/
  0000_fat_olivia.sql              # Auto-generated name
  0001_add_user_avatar.sql         # --name flag
  0002_add_post_tags.sql
  0003_add_subscription_tier.sql
```

### Zero-Downtime Migration Patterns

```text
For PostgreSQL, avoid locks during migrations:

1. ADD COLUMN (nullable, with default) -- Safe, instant in PG 11+
2. ADD COLUMN (NOT NULL with default) -- Rewrites entire table! Avoid.
   Instead: ADD COLUMN (nullable), backfill in batches, then SET NOT NULL
3. CREATE INDEX -- Use CONCURRENTLY to avoid table locks
4. DROP COLUMN -- Safe, instant (just marks column as invisible)
5. RENAME COLUMN -- Safe, instant (just updates catalog)

Pattern for safe migrations:
  1. Add nullable column (no default)
  2. Deploy app that writes to both old and new column
  3. Backfill existing rows in batches
  4. Deploy app that reads from new column only
  5. Set column NOT NULL + drop old column (next migration)
```

### Migration Rollback Strategy

Drizzle does not have built-in rollback. Strategies:

```typescript
// Option 1: Generate down migration manually
// After drizzle-kit generate, create a sibling file:
// 0001_up_add_avatar.sql      -- generated by drizzle-kit
// 0001_down_drop_avatar.sql   -- manual: ALTER TABLE users DROP COLUMN avatar;

// Option 2: Git-based rollback
// git revert <migration-commit> then drizzle-kit generate then migrate
// This re-generates the reverse SQL.

// Option 3: Expand-contract pattern (preferred)
// Never drop columns/tables in the same release that stops using them.
// Deploy code that ignores the old column, then drop in a separate PR.
```

### Multiple Migration Folders

```typescript
// Separate migrations for different schemas/tenants
await migrate(db, { migrationsFolder: './drizzle/public' });
await migrate(tenantDb, { migrationsFolder: './drizzle/tenant' });
```

---

## Seed Data Patterns

### Idempotent Seed Script

```typescript
// db/seed.ts -- Safe to run multiple times
import { db } from './index';
import { users, roles } from './schema';
import { eq } from 'drizzle-orm';

async function seed() {
  // Check if already seeded
  const existing = await db.select().from(users)
    .where(eq(users.email, 'admin@system.local'));
  if (existing.length > 0) {
    console.log('Already seeded, skipping.');
    return;
  }

  await db.transaction(async (tx) => {
    await tx.insert(roles).values([
      { name: 'admin', permissions: ['*'] },
      { name: 'user', permissions: ['read', 'write'] },
    ]);

    await tx.insert(users).values({
      email: 'admin@system.local',
      name: 'System Admin',
      role: 'admin',
    });
  });

  console.log('Seed complete.');
}

seed().catch(console.error);
```

### Environment-Specific Seeds

```typescript
// db/seed.ts
async function seed() {
  if (process.env.NODE_ENV === 'production') {
    await seedReferenceData();       // Essential reference data only
  } else if (process.env.NODE_ENV === 'test') {
    await seedTestFixtures();        // Known test data
  } else {
    await seedDemoData();            // Rich demo data for development
  }
}
```

### Factory Pattern for Seed Data

```typescript
// db/factories.ts
import { faker } from '@faker-js/faker';
import { db } from './index';
import { users, posts, type NewUser, type NewPost } from './schema';

export async function createUser(overrides: Partial<NewUser> = {}): Promise<User> {
  const [user] = await db.insert(users).values({
    email: faker.internet.email(),
    name: faker.person.fullName(),
    ...overrides,
  }).returning();
  return user;
}

export async function createPost(authorId: number, overrides: Partial<NewPost> = {}): Promise<Post> {
  const [post] = await db.insert(posts).values({
    title: faker.lorem.sentence(),
    content: faker.lorem.paragraphs(3),
    authorId,
    published: true,
    ...overrides,
  }).returning();
  return post;
}

// Usage
const admin = await createUser({ role: 'admin' });
for (let i = 0; i < 50; i++) {
  await createPost(admin.id, { published: Math.random() > 0.3 });
}
```

---

## Error Handling Patterns

### Constraint Violations

```typescript
import { db } from './db';
import { users } from './schema';

async function createUser(data: NewUser) {
  try {
    const [user] = await db.insert(users).values(data).returning();
    return { success: true, user };
  } catch (error: unknown) {
    if (error instanceof Error && 'code' in error) {
      const pgError = error as { code: string; constraint?: string };
      switch (pgError.code) {
        case '23505': // unique_violation
          if (pgError.constraint === 'users_email_unique') {
            return { success: false, error: 'Email already taken' };
          }
          return { success: false, error: 'Duplicate entry' };
        case '23503': // foreign_key_violation
          return { success: false, error: 'Referenced record does not exist' };
        case '23502': // not_null_violation
          return { success: false, error: 'Required field is missing' };
        case '23514': // check_violation
          return { success: false, error: 'Value does not satisfy constraint' };
        default:
          throw error;
      }
    }
    throw error;
  }
}
```

### Transaction Error Handling

```typescript
class AppError extends Error {
  constructor(message: string, public status: number) { super(message); }
}

async function transferFunds(fromId: number, toId: number, amount: number) {
  try {
    return await db.transaction(async (tx) => {
      const [fromAccount] = await tx.select()
        .from(accounts)
        .where(eq(accounts.id, fromId))
        .for('update');

      if (!fromAccount) throw new AppError('Source account not found', 404);
      if (fromAccount.balance < amount) throw new AppError('Insufficient funds', 400);

      await tx.update(accounts)
        .set({ balance: sql`${accounts.balance} - ${amount}` })
        .where(eq(accounts.id, fromId));

      await tx.update(accounts)
        .set({ balance: sql`${accounts.balance} + ${amount}` })
        .where(eq(accounts.id, toId));

      return { success: true };
    });
  } catch (error) {
    if (error instanceof AppError) {
      return { success: false, error: error.message, status: error.status };
    }
    // Transaction was rolled back automatically
    console.error('Transfer failed:', error);
    return { success: false, error: 'Internal error' };
  }
}
```

### Connection Error Handling & Retry

```typescript
import { Pool } from 'pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

pool.on('error', (err) => {
  console.error('Unexpected error on idle client:', err);
  // The pool will automatically create a new client for the next query
});

// Retry logic for transient failures
async function withRetry<T>(fn: () => Promise<T>, retries = 3): Promise<T> {
  for (let i = 0; i < retries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === retries - 1) throw error;
      // Exponential backoff: 100ms, 200ms, 400ms
      const delay = Math.pow(2, i) * 100;
      await new Promise((r) => setTimeout(r, delay));
    }
  }
  throw new Error('Unreachable');
}
```

### SQLite-Specific Error Handling

```typescript
import Database from 'better-sqlite3';

const sqlite = new Database('data.db');

// SQLite error codes
// 19 = CONSTRAINT (UNIQUE, NOT NULL, CHECK, FK)
// 1  = Generic error
// 5  = BUSY (database locked)
// 8  = READONLY

try {
  await db.insert(users).values({ email: 'exists@test.com', name: 'Dup' });
} catch (error: unknown) {
  if (error instanceof Error) {
    // SQLite wraps errors with errno/code
    const sqliteError = error as Error & { code?: string; errno?: number };
    if (sqliteError.errno === 19 || sqliteError.code === 'SQLITE_CONSTRAINT') {
      // Handle constraint violation
    }
  }
}
```

---

## Repository Pattern with Drizzle

### Generic Base Repository

```typescript
import { PgTable } from 'drizzle-orm/pg-core';
import { db } from '../db';
import { eq, SQL, asc, desc } from 'drizzle-orm';

export type RepositoryConfig<T> = {
  defaultOrderBy?: { field: keyof T & string; direction: 'asc' | 'desc' };
};

export abstract class BaseRepository<
  TTable extends PgTable,
  TRow extends Record<string, any>,
  TInsert extends Record<string, any>,
> {
  constructor(
    protected readonly table: TTable,
    protected readonly config: RepositoryConfig<TRow> = {},
  ) {}

  async findAll(): Promise<TRow[]> {
    let query = db.select().from(this.table);
    if (this.config.defaultOrderBy) {
      const col = (this.table as any)[this.config.defaultOrderBy.field];
      const dirFn = this.config.defaultOrderBy.direction === 'desc' ? desc : asc;
      query = query.orderBy(dirFn(col));
    }
    return query as any;
  }

  async findById(id: number | string): Promise<TRow | undefined> {
    const results = await db.select()
      .from(this.table)
      .where(eq((this.table as any).id, id));
    return results[0] as any;
  }

  async create(data: TInsert): Promise<TRow> {
    const results = await db.insert(this.table)
      .values(data as any)
      .returning();
    return results[0] as any;
  }

  async update(id: number | string, data: Partial<TInsert>): Promise<TRow> {
    const results = await db.update(this.table)
      .set(data as any)
      .where(eq((this.table as any).id, id))
      .returning();
    return results[0] as any;
  }

  async delete(id: number | string): Promise<void> {
    await db.delete(this.table).where(eq((this.table as any).id, id));
  }

  async exists(id: number | string): Promise<boolean> {
    const count = await db.$count(this.table, eq((this.table as any).id, id));
    return count > 0;
  }
}
```

### Specialized Repository

```typescript
// repositories/post.repository.ts
import { db } from '../db';
import { posts, users, comments } from '../db/schema';
import { eq, and, like, desc, count, inArray } from 'drizzle-orm';
import { BaseRepository } from './base';

export class PostRepository extends BaseRepository<typeof posts, Post, NewPost> {
  constructor() {
    super(posts, { defaultOrderBy: { field: 'createdAt', direction: 'desc' } });
  }

  async findBySlug(slug: string) {
    return db.query.posts.findFirst({
      where: eq(posts.slug, slug),
      with: {
        author: true,
        comments: { with: { author: true }, orderBy: desc(comments.createdAt) },
      },
    });
  }

  async searchPublished(query: string, page = 1, limit = 20) {
    const where = and(eq(posts.published, true), like(posts.title, `%${query}%`));
    return this.paginate(where, page, limit);
  }

  async findByIds(ids: number[]) {
    if (ids.length === 0) return [];
    return db.select().from(posts).where(inArray(posts.id, ids));
  }

  async softDelete(id: number) {
    const [post] = await db.update(posts)
      .set({ deletedAt: new Date() } as any)
      .where(eq(posts.id, id))
      .returning();
    return post;
  }

  private async paginate(where: SQL | undefined, page: number, limit: number) {
    const offset = (page - 1) * limit;
    const [items, [{ cnt }]] = await Promise.all([
      db.select().from(posts).where(where).limit(limit).offset(offset),
      db.select({ cnt: count() }).from(posts).where(where),
    ]);
    return { items, total: Number(cnt), page, limit };
  }
}
```

---

## N+1 Prevention Strategies

### Problem: The N+1 Query Anti-Pattern

```typescript
// BAD: N+1 -- one query for users, then one query per user for posts
const users = await db.select().from(users);         // 1 query
for (const user of users) {
  user.posts = await db.select().from(posts)          // N queries
    .where(eq(posts.authorId, user.id));
}
// Total: N+1 queries for 100 users = 101 queries
```

### Solution 1: Relational Query API (Best)

```typescript
// GOOD: Relational API -- Drizzle auto-generates optimal JOINs
const usersWithPosts = await db.query.users.findMany({
  with: { posts: true },
});
// Total: 1 query (uses LEFT JOIN LATERAL or JSON aggregation)
```

### Solution 2: Batch Fetch with inArray

```typescript
// GOOD: Two queries, batch fetch
const users = await db.select().from(users);                 // 1 query
const userIds = users.map((u) => u.id);
const allPosts = await db.select().from(posts)                // 1 query
  .where(inArray(posts.authorId, userIds));

// Group in memory
const postsByUser = Map.groupBy(allPosts, (p) => p.authorId);
for (const user of users) {
  user.posts = postsByUser.get(user.id) ?? [];
}
// Total: 2 queries regardless of user count
```

### Solution 3: Single Join Query (SQL-like API)

```typescript
// GOOD: single query with explicit join
const rows = await db.select({
  userId: users.id, userName: users.name,
  postId: posts.id, postTitle: posts.title,
}).from(users)
  .leftJoin(posts, eq(users.id, posts.authorId))
  .where(inArray(users.id, userIds));

// Then group results in application code
```

---

## Batch Operations

```typescript
// Batch insert
await db.insert(users).values([
  { email: 'a@test.com', name: 'A' },
  { email: 'b@test.com', name: 'B' },
  { email: 'c@test.com', name: 'C' },
]);

// Batch update by IDs
await db.update(users)
  .set({ isActive: false })
  .where(inArray(users.id, [1, 2, 3]));

// Batch delete old records
await db.delete(logs)
  .where(lt(logs.createdAt, thirtyDaysAgo));

// Conditional batch update (price increase)
await db.update(products)
  .set({ price: sql`${products.price} * 1.1` })
  .where(eq(products.category, 'electronics'));
```

---

## Read Replicas

```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { withReplicas } from 'drizzle-orm/pg-core';

const primary = drizzle(primaryPool, { schema });
const replica1 = drizzle(replicaPool1, { schema });
const replica2 = drizzle(replicaPool2, { schema });

// Distributed read across replicas
const db = withReplicas(primary, [replica1, replica2]);

// Transparent usage:
// SELECT -> round-robin across replicas
// INSERT/UPDATE/DELETE -> always to primary
const users = await db.select().from(schema.users);       // replica
await db.insert(schema.users).values({ name: 'Alice' });   // primary

// Explicit primary use
const primaryDb = db.primary();
const user = await primaryDb.query.users.findFirst({...}); // force read from primary
```

---

## Multi-Tenant Patterns

### Schema-Per-Tenant (PostgreSQL)

```typescript
import { pgSchema } from 'drizzle-orm/pg-core';

function createTenantSchema(tenantId: string) {
  const schema = pgSchema(`tenant_${tenantId}`);
  return {
    users: schema.table('users', {
      id: serial('id').primaryKey(),
      email: varchar('email', { length: 255 }).notNull(),
    }),
    posts: schema.table('posts', {
      id: serial('id').primaryKey(),
      title: text('title').notNull(),
    }),
  };
}

// At request time, resolve the tenant
async function getTenantDb(tenantId: string) {
  const tenantPool = new Pool({
    connectionString: process.env.DATABASE_URL,
    options: `-c search_path=tenant_${tenantId}`,
  });
  return drizzle(tenantPool);
}
```

### Discriminator Column (Single-Table Multi-Tenant)

```typescript
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  tenantId: integer('tenant_id').notNull(),
  email: varchar('email', { length: 255 }).notNull(),
});

// Always include tenantId in every query
export function tenantFilter(tenantId: number) {
  return eq(users.tenantId, tenantId);
}

// RLS can enforce this at the DB level
// CREATE POLICY tenant_isolation ON users
//   USING (tenant_id = current_setting('app.tenant_id')::integer);
```

### Connection Per Tenant (SQLite/Turso)

```typescript
import { createClient } from '@libsql/client';

const tenantDbs = new Map<string, ReturnType<typeof drizzle>>();

export function getTenantDb(tenantId: string) {
  if (!tenantDbs.has(tenantId)) {
    const client = createClient({
      url: `${process.env.TURSO_BASE_URL}/tenant-${tenantId}`,
      authToken: process.env.TURSO_TOKEN,
    });
    tenantDbs.set(tenantId, drizzle(client, { schema }));
  }
  return tenantDbs.get(tenantId)!;
}
```

---

## Caching Strategy (Upstash Redis)

```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { upstash } from 'drizzle-orm/cache/upstash';
import { Redis } from '@upstash/redis';

const redis = new Redis({ url: process.env.REDIS_URL, token: process.env.REDIS_TOKEN });
const db = drizzle(pool);
const cachedDb = upstash(db, redis);

// Cache expensive queries
const dashboard = await cachedDb.query.posts.findMany({
  where: eq(posts.published, true),
  orderBy: desc(posts.views),
  limit: 10,
  cache: { ttl: 300, key: 'dashboard:popular' }, // 5-min cache
});

// Invalidate on write
await db.insert(posts).values({ title: 'New Post', ... });
await redis.del('dashboard:popular');  // Manual invalidation
```

---

## Health Check Pattern

```typescript
import { sql } from 'drizzle-orm';
import { db } from './index';

export async function healthCheck() {
  try {
    const start = Date.now();
    await db.execute(sql`SELECT 1`);
    const latency = Date.now() - start;

    return {
      status: 'healthy' as const,
      latency,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    return {
      status: 'unhealthy' as const,
      error: error instanceof Error ? error.message : 'Unknown error',
      timestamp: new Date().toISOString(),
    };
  }
}
```

---

## Logging & Observability

```typescript
import { drizzle } from 'drizzle-orm/node-postgres';

const db = drizzle(pool, {
  logger: {
    logQuery(query, params) {
      // Structured logging for query analysis
      console.log(JSON.stringify({
        type: 'db_query',
        query,
        params,
        timestamp: new Date().toISOString(),
      }));
    },
  },
});

// Or use with pino
import { pino } from 'pino';
const logger = pino();

const db = drizzle(pool, {
  logger: {
    logQuery(query, params) {
      logger.debug({ query, params }, 'DB query executed');
    },
  },
});
```
