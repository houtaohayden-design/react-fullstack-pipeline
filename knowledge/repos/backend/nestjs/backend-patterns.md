# NestJS Backend Architecture Patterns

> Extracted from nestjs/nest source code and 36 sample applications

## 1. API Route Design

### REST Conventions in NestJS

NestJS enforces REST conventions through decorator-based routing. Controllers define path prefixes; method decorators define HTTP verbs and sub-paths.

```
Standard CRUD routes:
GET     /users          -> findAll()
GET     /users/:id      -> findOne(@Param('id') id)
POST    /users          -> create(@Body() dto)
PATCH   /users/:id      -> update(@Param('id') id, @Body() dto)
DELETE  /users/:id      -> remove(@Param('id') id)

Nested resources:
GET     /users/:id/posts      -> PostsController @Controller('users/:id/posts')
POST    /posts/:id/comments   -> CommentsController
```

### Route Grouping by Domain

```ts
// Feature-based module organization
src/
  users/
    users.module.ts
    users.controller.ts    // @Controller('users')
    users.service.ts
    dto/create-user.dto.ts
    entities/user.entity.ts
  auth/
    auth.module.ts
    auth.controller.ts     // @Controller('auth')
    auth.service.ts
    auth.guard.ts
    decorators/public.decorator.ts
  products/
    products.module.ts
    products.controller.ts
    products.service.ts
```

### Path Parameter Patterns

```ts
// Single param
@Get(':id')
findOne(@Param('id', ParseIntPipe) id: number): User {}

// Multiple params
@Get(':category/:slug')
findBySlug(
  @Param('category') category: string,
  @Param('slug') slug: string,
): Product {}

// Optional trailing parameter with wildcard
@Get(':id/edit')
edit(@Param('id') id: string): object {}
```

### Query Parameters for Pagination/Filter/Sort

```ts
// Standard pagination query
@Get()
findAll(
  @Query('page', new DefaultValuePipe(1), ParseIntPipe) page: number,
  @Query('limit', new DefaultValuePipe(10), ParseIntPipe) limit: number,
  @Query('sort', new DefaultValuePipe('id')) sort: string,
  @Query('order', new DefaultValuePipe('desc')) order: 'asc' | 'desc',
  @Query('search') search?: string,
): Promise<PaginatedResponse<User>> {}

// Filter with DTO
export class FindUsersDto {
  @IsOptional() @IsString() search?: string;
  @IsOptional() @IsEnum(['admin', 'user']) role?: string;
  @IsOptional() @IsBoolean() @Transform(({ value }) => value === 'true') isActive?: boolean;
  @IsOptional() @IsInt() @Min(1) @Type(() => Number) page?: number = 1;
  @IsOptional() @IsInt() @Min(1) @Max(100) @Type(() => Number) limit?: number = 10;
}
```

### Versioning

```ts
// URI versioning
@Controller({ path: 'users', version: '1' })
export class UsersV1Controller {}

@Controller({ path: 'users', version: '2' })
export class UsersV2Controller {}

// Global config
app.enableVersioning({ type: VersioningType.URI });
// Routes: /v1/users, /v2/users
```

## 2. Middleware Architecture

NestJS supports two middleware layers: Express/Fastify native middleware and Nest-specific middleware.

### Nest Middleware (class-based, supports DI)

```ts
@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
  }
}

// Apply in module
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(LoggerMiddleware, HelmetMiddleware)  // can chain multiple
      .exclude({ path: 'health', method: RequestMethod.GET })  // exclude routes
      .forRoutes(
        { path: 'users', method: RequestMethod.ALL },
        { path: 'products', method: RequestMethod.GET },
        UsersController,  // apply to entire controller
      );
  }
}
```

### Middleware Chain (Execution Order)

```
Request
  -> Global middleware (e.g. helmet, cors, compression)
  -> Module-level middleware (LoggerMiddleware)
  -> Guards (AuthGuard.canActivate)
  -> Pre-interceptors (before handle())
  -> Pipes (ValidationPipe.transform)
  -> Controller handler
  -> Post-interceptors (after handle())
  -> Exception filters (on error)
  -> Response
```

### Common Middleware Patterns

```ts
// Request ID middleware
@Injectable()
export class RequestIdMiddleware implements NestMiddleware {
  use(req: Request, _res: Response, next: NextFunction) {
    req['requestId'] = uuid();
    next();
  }
}

// Rate limiting with ThrottlerModule
@Module({ imports: [ThrottlerModule.forRoot({ throttlers: [{ ttl: 60000, limit: 10 }] })] })
@Controller('auth')
export class AuthController {
  @SkipThrottle()  // opt-out for this route
  @Post('login')
  login() {}
}
```

## 3. Guards (Auth & Authorization)

### Guard Execution Lifecycle

Guards are the first NestJS layer after middleware. They run once per request and determine if routing should continue.

```
1. Guards execute (canActivate returns boolean/Promise<boolean>)
   - Order: Global -> Controller -> Method
   - If any returns false: 403 Forbidden (by default)
2. If all return true: continues to interceptors/pipes/controller
```

### JWT Auth Guard (comprehensive)

```ts
@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private jwtService: JwtService, private reflector: Reflector) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    // 1. Check public metadata (skip auth for decorated routes)
    const isPublic = this.reflector.getAllAndOverride(IS_PUBLIC_KEY, [
      context.getHandler(), context.getClass(),
    ]);
    if (isPublic) return true;

    // 2. Extract and verify JWT
    const request = context.switchToHttp().getRequest();
    const token = this.extractToken(request);
    if (!token) throw new UnauthorizedException('No token provided');

    try {
      const payload = await this.jwtService.verifyAsync(token, {
        secret: process.env.JWT_SECRET,
      });
      request['user'] = payload;  // attach to request for downstream access
    } catch (err) {
      if (err.name === 'TokenExpiredError') throw new UnauthorizedException('Token expired');
      throw new UnauthorizedException('Invalid token');
    }
    return true;
  }

  private extractToken(request: Request): string | undefined {
    const auth = request.headers.authorization;
    if (!auth) return undefined;
    const [type, token] = auth.split(' ');
    return type === 'Bearer' ? token : undefined;
  }
}
```

### Role-Based Guard

```ts
export const Roles = (...roles: string[]) => SetMetadata('roles', roles);

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}
  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride('roles', [
      context.getHandler(), context.getClass(),
    ]);
    if (!requiredRoles) return true;
    const { user } = context.switchToHttp().getRequest();
    return requiredRoles.some(role => user.roles?.includes(role));
  }
}

// Usage
@Roles('admin')
@Controller('admin')
export class AdminController {}
```

### APP_GUARD Pattern (Global Guard via DI)

```ts
// In any module, this applies the guard globally
providers: [{ provide: APP_GUARD, useClass: AuthGuard }]
// This is the idiomatic NestJS way — guards registered this way are subject to DI
```

## 4. Pipes (Validation & Transformation)

### ValidationPipe Deep Dive

NestJS's ValidationPipe integrates `class-validator` and `class-transformer`:

```ts
// Global configuration
app.useGlobalPipes(new ValidationPipe({
  transform: true,              // auto-transform types (string -> number)
  whitelist: true,              // strip non-whitelisted properties
  forbidNonWhitelisted: true,   // throw on unknown properties
  transformOptions: { enableImplicitConversion: true },
  exceptionFactory: (errors) => {  // custom error format
    return new BadRequestException({
      errors: errors.map(e => ({
        field: e.property,
        constraints: e.constraints,
      })),
    });
  },
}));
```

### Prototype Pollution Protection

The ValidationPipe includes built-in prototype pollution defense:

```ts
// From ValidationPipe source:
// Deletes __proto__, prototype, and constructor keys recursively
// Skips built-in types: Date, RegExp, Error, Map, Set, WeakMap, WeakSet
// This runs before validation on all incoming bodies
```

### Parse Pipes for Route Params

```ts
// Safe integer parsing with error handling
@Get(':id')
findOne(@Param('id', ParseIntPipe) id: number) {}
// If 'id' is not a number: 400 Bad Request with { statusCode: 400, message: 'Validation failed (numeric string is expected)', error: 'Bad Request' }

// UUID validation
@Get(':uuid')
findByUuid(@Param('uuid', ParseUUIDPipe) uuid: string) {}

// Array parsing from query
@Get()
findByIds(@Query('ids', new ParseArrayPipe({ items: Number, separator: ',' })) ids: number[]) {}

// Custom error code
@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.NOT_ACCEPTABLE }))
```

## 5. Exception Handling

### Built-in HTTP Exception Hierarchy

```
HttpException (base)
  |-> BadRequestException (400)
  |-> UnauthorizedException (401)
  |-> ForbiddenException (403)
  |-> NotFoundException (404)
  |-> MethodNotAllowedException (405)
  |-> NotAcceptableException (406)
  |-> RequestTimeoutException (408)
  |-> ConflictException (409)
  |-> GoneException (410)
  |-> PayloadTooLargeException (413)
  |-> UnsupportedMediaTypeException (415)
  |-> UnprocessableEntityException (422)
  |-> InternalServerErrorException (500)
  |-> NotImplementedException (501)
  |-> BadGatewayException (502)
  |-> ServiceUnavailableException (503)
  |-> GatewayTimeoutException (504)
```

### Default Exception Response Shape

```json
// Unhandled HttpException:
{ "statusCode": 404, "message": "Not Found", "error": "Not Found" }

// Unhandled non-HttpException:
{ "statusCode": 500, "message": "Internal server error" }
```

### Global Exception Filter (Custom Error Envelope)

```ts
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status: number;
    let body: any;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const res = exception.getResponse();
      body = typeof res === 'string' ? { message: res } : res;
    } else {
      status = HttpStatus.INTERNAL_SERVER_ERROR;
      body = { message: 'Internal server error' };
      // Log the actual error but don't expose to client
      console.error(exception);
    }

    response.status(status).json({
      success: false,
      statusCode: status,
      ...body,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
```

## 6. Database Patterns

### Repository Pattern with TypeORM

```ts
// Entity definition
@Entity()
export class User {
  @PrimaryGeneratedColumn() id: number;
  @Column({ unique: true }) email: string;
  @Column() passwordHash: string;
  @Column({ default: true }) isActive: boolean;
  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}

// Service encapsulates data access
@Injectable()
export class UsersService {
  constructor(@InjectRepository(User) private repo: Repository<User>) {}

  async findByEmail(email: string): Promise<User | null> {
    return this.repo.findOne({ where: { email } });
  }

  async findWithPosts(userId: number): Promise<User | null> {
    return this.repo.findOne({ where: { id: userId }, relations: ['posts'] });
  }

  async create(dto: CreateUserDto): Promise<User> {
    return this.repo.save(this.repo.create(dto));
  }

  async paginate(page: number, limit: number): Promise<{ data: User[]; total: number }> {
    const [data, total] = await this.repo.findAndCount({
      skip: (page - 1) * limit,
      take: limit,
      order: { createdAt: 'DESC' },
    });
    return { data, total };
  }
}
```

### Connection Management & Pooling

Connection pooling is handled by the underlying driver (pg, mysql2, etc.), configured in TypeORM:

```ts
TypeOrmModule.forRoot({
  type: 'postgres',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT, 10),
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  poolSize: 20,              // connection pool size
  connectTimeoutMS: 10000,
  extra: {
    max: 20,                 // pg-specific pool max
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 10000,
  },
  logging: process.env.NODE_ENV === 'development',
});
```

### Transaction Patterns

```ts
// TypeORM transaction with DataSource
@Injectable()
export class TransferService {
  constructor(private dataSource: DataSource) {}

  async transferFunds(fromId: number, toId: number, amount: number) {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();
    try {
      await queryRunner.manager.decrement(User, { id: fromId }, 'balance', amount);
      await queryRunner.manager.increment(User, { id: toId }, 'balance', amount);
      await queryRunner.commitTransaction();
    } catch (err) {
      await queryRunner.rollbackTransaction();
      throw err;
    } finally {
      await queryRunner.release();
    }
  }
}

// Simpler: @Transactional() decorator (via typeorm-transactional or MikroORM)
```

### Migration Strategies

```
Recommended NestJS migration workflow:
1. Define entity changes in TypeORM entity files
2. Generate migration: npx typeorm migration:generate src/migrations/AddUserTable -d src/data-source.ts
3. Review generated SQL
4. Run: npx typeorm migration:run -d src/data-source.ts
5. Revert: npx typeorm migration:revert -d src/data-source.ts

// Never use synchronize: true in production
```

### DataSource Configuration (for CLI migrations)

```ts
// src/data-source.ts
import { DataSource } from 'typeorm';
import { User } from './users/user.entity';
import { Product } from './products/product.entity';

export default new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT, 10),
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  entities: [User, Product],
  migrations: ['src/migrations/*.ts'],
});
```

### Seeding

```ts
// src/seeds/user.seed.ts
export async function seedUsers(dataSource: DataSource) {
  const userRepo = dataSource.getRepository(User);
  const users = [
    { email: 'admin@example.com', role: 'admin' },
    { email: 'user@example.com', role: 'user' },
  ];
  for (const user of users) {
    const existing = await userRepo.findOneBy({ email: user.email });
    if (!existing) {
      await userRepo.save(userRepo.create({
        ...user,
        passwordHash: await hashPassword('password123'),
      }));
    }
  }
}

// Run via script: ts-node src/seeds/run.ts
// Or via NestJS module: onModuleInit lifecycle hook
@Injectable()
export class SeedService implements OnModuleInit {
  async onModuleInit() {
    if (process.env.NODE_ENV === 'development') {
      await seedUsers(this.dataSource);
    }
  }
}
```

## 7. Auth & Security

### JWT Access/Refresh Token Rotation

```ts
@Injectable()
export class AuthService {
  constructor(private jwtService: JwtService, private configService: ConfigService) {}

  async login(email: string, password: string) {
    const user = await this.validateUser(email, password);
    const payload = { sub: user.id, email: user.email };
    return {
      access_token: this.jwtService.sign(payload, {
        secret: this.configService.get('JWT_ACCESS_SECRET'),
        expiresIn: '15m',
      }),
      refresh_token: this.jwtService.sign(payload, {
        secret: this.configService.get('JWT_REFRESH_SECRET'),
        expiresIn: '7d',
      }),
    };
  }

  async refreshToken(token: string) {
    try {
      const payload = this.jwtService.verify(token, {
        secret: this.configService.get('JWT_REFRESH_SECRET'),
      });
      // Invalidate old refresh token in DB, issue new pair
      const newPayload = { sub: payload.sub, email: payload.email };
      return {
        access_token: this.jwtService.sign(newPayload, { secret: '...', expiresIn: '15m' }),
        refresh_token: this.jwtService.sign(newPayload, { secret: '...', expiresIn: '7d' }),
      };
    } catch {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }
}
```

### Password Hashing

```ts
import * as bcrypt from 'bcrypt';

const SALT_ROUNDS = 12;

async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS);
}

async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return bcrypt.compare(password, hash);
}
```

### Input Sanitization

```ts
// Whitelist is the primary defense — strips unknown props
app.useGlobalPipes(new ValidationPipe({
  whitelist: true,
  forbidNonWhitelisted: true,     // throws 400 on unknown fields
  forbidUnknownValues: true,      // throws on objects without DTO class
}));

// Additional: SQL injection is prevented by TypeORM's parameterized queries
// XSS is prevented by default JSON response serialization (no HTML rendering)
```

### CSRF Protection

```ts
// Use csurf or @fastify/csrf-protection middleware
// NestJS platforms provide CSRF via underlying adapter
import { csurf } from 'csurf';
app.use(csurf({ cookie: true }));
```

### Environment Variables / Secrets

```ts
// NestJS ConfigModule
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      validate: (config) => {
        // Validate required env vars at startup
        const schema = z.object({
          DATABASE_URL: z.string().url(),
          JWT_SECRET: z.string().min(32),
        });
        return schema.parse(config);
      },
    }),
  ],
})

// Never: const SECRET = 'my-secret-key'; in source files
```

## 8. Interceptors (Cross-Cutting Concerns)

### Response Transform (Standard Envelope)

```ts
@Injectable()
export class ResponseInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      map(data => ({
        success: true,
        data,
        timestamp: new Date().toISOString(),
      })),
    );
  }
}
```

### Timeout Interceptor

```ts
@Injectable()
export class TimeoutInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(timeout(5000));
  }
}
```

## 9. Performance Patterns

### Caching Strategies

```
Level 1: In-memory cache (cache-manager) — fastest, per-process
Level 2: Redis cache — distributed, shared across instances
Level 3: HTTP caching (Cache-Control headers) — client-side/edge
```

```ts
// Cache GET /users responses for 60 seconds
@UseInterceptors(CacheInterceptor)
@CacheTTL(60)
@Get()
findAll(): Promise<User[]> {}

// Custom cache key (include query params)
@Injectable()
export class QueryAwareCacheInterceptor extends CacheInterceptor {
  trackBy(context: ExecutionContext): string | undefined {
    const request = context.switchToHttp().getRequest();
    if (request.method !== 'GET') return undefined;
    return `${request.url}?${JSON.stringify(request.query)}`;
  }
}
```

### Background Jobs / Queues

```ts
// Module setup
@Module({
  imports: [
    BullModule.forRoot({ redis: { host: 'localhost', port: 6379 } }),
    BullModule.registerQueue({ name: 'email' }),
  ],
  providers: [EmailProcessor],
})
export class AppModule {}

@Processor('email')
export class EmailProcessor {
  @Process('welcome')
  async sendWelcome(job: Job<{ email: string; name: string }>) {
    await emailService.send(job.data.email, `Welcome ${job.data.name}!`);
  }
}

// Enqueue from any service
this.emailQueue.add('welcome', { email: user.email, name: user.name });
```

### Connection Pooling Best Practices

```
PostgreSQL:
  - Pool size = (max_connections - 5) / number_of_app_instances
  - Use connectionTimeOut: 10000ms
  - Set statement_timeout in postgresql.conf
  - Monitor: pg_stat_activity, pg_stat_database

TypeORM:
  - Set extra.max (pg) or connectionLimit (mysql) 
  - Enable logging only in dev/staging
  - Use findAndCount() for paginated queries (single query with count)
```

### Graceful Shutdown

```ts
async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable shutdown hooks
  app.enableShutdownHooks();

  await app.listen(3000);

  // Cleanup on SIGTERM/SIGINT
  const signals = ['SIGTERM', 'SIGINT'];
  for (const signal of signals) {
    process.on(signal, async () => {
      console.log(`Received ${signal}, closing...`);
      await app.close();
      process.exit(0);
    });
  }
}
```

### Health Checks

```ts
// Using @nestjs/terminus
@Controller('health')
export class HealthController {
  constructor(private health: HealthCheckService, private db: TypeOrmHealthIndicator) {}

  @Get()
  @HealthCheck()
  check() {
    return this.health.check([
      () => this.db.pingCheck('database', { timeout: 300 }),
      // Custom checks
      async () => ({ redis: { status: await redis.ping() ? 'up' : 'down' } }),
    ]);
  }
}
```

### CORS Configuration

```ts
const app = await NestFactory.create(AppModule);
app.enableCors({
  origin: ['https://my-frontend.com'],
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  credentials: true,
  maxAge: 3600,
});
```

## 10. Logging & Request Tracing

```ts
// NestJS built-in logger
import { Logger } from '@nestjs/common';

@Injectable()
export class UsersService {
  private readonly logger = new Logger(UsersService.name);

  async findOne(id: number) {
    this.logger.log(`Finding user with id: ${id}`);
    return this.repo.findOneBy({ id });
  }
}

// Custom logger implementation
const app = await NestFactory.create(AppModule, {
  logger: ['error', 'warn', 'log', 'debug', 'verbose'],
});
app.useLogger(app.get(MyLoggerService));
```
