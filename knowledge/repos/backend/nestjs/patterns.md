# NestJS Architecture Patterns

> Source: [nestjs/nest](https://github.com/nestjs/nest) — 75K+ stars, 36 sample apps
> Full MVC framework with modules, controllers, providers, DI, guards, pipes, interceptors, exception filters

## Library Positioning

NestJS is a **progressive, opinionated Node.js framework** inspired by Angular's architecture. It provides a structured, modular approach to building server-side applications using TypeScript decorators, dependency injection, and a layered architecture. It sits above Express (default) or Fastify as the HTTP adapter and adds an enterprise-grade application shell.

**When to use:** Enterprise APIs, microservices, real-time apps (WebSockets, SSE), scheduled job workers, GraphQL APIs. Not suited for simple scripts or minimal REST endpoints where Express/Hono suffice.

## Architecture Overview

```
Incoming Request
  |-> Middleware (Express/Fastify native)
  |-> Guards (Auth — canActivate)
  |-> Interceptors (Pre — transform request)
  |-> Pipes (Validation, transformation)
  |-> Controller (Route handler)
  |-> Service (Business logic)
  |-> Interceptors (Post — transform response)
  |-> Exception Filters (Error handling)
  V-> Response
```

### DI Container & Module Graph

Modules form a directed graph. The DI container resolves providers from the module hierarchy:

```
AppModule
  |-> AuthModule (global JwtModule, APP_GUARD)
  |-> UsersModule
  |     |-> TypeOrmModule.forFeature([User])
  |     |-> UsersService
  |     |-> UsersController
  |-> ProductsModule
        |-> TypeOrmModule.forFeature([Product])
        |-> ProductsService
        |-> ProductsController
```

Providers are singletons by default. Use `@Injectable({ scope: Scope.REQUEST })` for request-scoped instances (e.g., per-request logging context).

## Common Patterns

### 1. CRUD with Repository Pattern

```ts
// Entity (TypeORM)
@Entity()
export class Cat {
  @PrimaryGeneratedColumn() id: number;
  @Column() name: string;
  @Column() age: number;
  @Column() breed: string;
}

// DTO
export class CreateCatDto {
  @IsString() name: string;
  @IsInt() @Min(0) @Max(30) age: number;
  @IsString() breed: string;
}

// Service (business logic)
@Injectable()
export class CatsService {
  constructor(@InjectRepository(Cat) private repo: Repository<Cat>) {}

  create(dto: CreateCatDto): Promise<Cat> {
    return this.repo.save(this.repo.create(dto));
  }
  findAll(): Promise<Cat[]> { return this.repo.find(); }
  findOne(id: number): Promise<Cat | null> { return this.repo.findOneBy({ id }); }
  async update(id: number, dto: UpdateCatDto): Promise<Cat> {
    await this.repo.update(id, dto);
    return this.repo.findOneBy({ id });
  }
  async remove(id: number): Promise<void> { await this.repo.delete(id); }
}

// Controller (routing only, delegates to service)
@Controller('cats')
export class CatsController {
  constructor(private readonly catsService: CatsService) {}

  @Post() create(@Body(ValidationPipe) dto: CreateCatDto): Promise<Cat> { return this.catsService.create(dto); }
  @Get() findAll(): Promise<Cat[]> { return this.catsService.findAll(); }
  @Get(':id') findOne(@Param('id', ParseIntPipe) id: number): Promise<Cat> { return this.catsService.findOne(id); }
  @Patch(':id') update(@Param('id', ParseIntPipe) id: number, @Body(ValidationPipe) dto: UpdateCatDto) { return this.catsService.update(id, dto); }
  @Delete(':id') remove(@Param('id', ParseIntPipe) id: number) { return this.catsService.remove(id); }
}
```

### 2. JWT Auth Guard + Public Route Pattern

This is the most important NestJS auth pattern. Uses a global guard with metadata-based skip for public routes.

```ts
// 1. Define metadata key + decorator
export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

// 2. Guard checks metadata before enforcing auth
@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private jwtService: JwtService, private reflector: Reflector) {}
  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride(IS_PUBLIC_KEY, [
      context.getHandler(), context.getClass(),
    ]);
    if (isPublic) return true;
    const request = context.switchToHttp().getRequest();
    const token = extractBearerToken(request);
    request['user'] = await this.jwtService.verifyAsync(token);
    return true;
  }
}

// 3. Register as global guard
@Module({
  imports: [UsersModule, JwtModule.register({ global: true, secret, signOptions: { expiresIn: '60s' } })],
  providers: [AuthService, { provide: APP_GUARD, useClass: AuthGuard }],
  controllers: [AuthController],
})
export class AuthModule {}

// 4. Use @Public() on login/register routes
@Public()
@Post('login')
signIn(@Body() dto: LoginDto) { return this.authService.signIn(dto.username, dto.password); }
```

### 3. Validation with DTO + class-validator

```ts
export class CreateUserDto {
  @IsString() @MinLength(3) @MaxLength(50) name: string;
  @IsEmail() email: string;
  @IsEnum(UserRole) role: UserRole = UserRole.USER;
  @IsOptional() @IsString() bio?: string;
}

// Global pipeline (auto-validates all @Body() decorated DTOs)
app.useGlobalPipes(new ValidationPipe({
  transform: true,         // auto-transform primitives
  whitelist: true,         // strip unknown properties
  forbidNonWhitelisted: true,  // error on unknown props
  errorHttpStatusCode: HttpStatus.UNPROCESSABLE_ENTITY,
}));
```

### 4. Global Exception Filter with Standardized Error Response

```ts
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const status = exception instanceof HttpException
      ? exception.getStatus()
      : HttpStatus.INTERNAL_SERVER_ERROR;
    const message = exception instanceof HttpException ? exception.getResponse() : 'Internal server error';
    response.status(status).json({
      statusCode: status,
      message,
      timestamp: new Date().toISOString(),
      path: ctx.getRequest().url,
    });
  }
}
// app.useGlobalFilters(new AllExceptionsFilter());
```

### 5. Caching with Interceptor

```ts
@Injectable()
export class HttpCacheInterceptor extends CacheInterceptor {
  trackBy(context: ExecutionContext): string | undefined {
    const request = context.switchToHttp().getRequest();
    if (request.method !== 'GET') return undefined;  // only cache GET
    return request.url;  // key by URL
  }
}
// @UseInterceptors(HttpCacheInterceptor) on controller
```

### 6. Queue-based Background Processing

```ts
// Producer: HTTP controller enqueues jobs
@Controller('audio')
export class AudioController {
  constructor(@InjectQueue('audio') private queue: Queue) {}
  @Post('transcode')
  async transcode() { await this.queue.add('transcode', { file: 'audio.mp3' }); }
}

// Consumer: background processor
@Processor('audio')
export class AudioProcessor {
  @Process('transcode')
  async handleTranscode(job: Job) { /* process job.data */ }
}

// Module
@Module({
  imports: [BullModule.registerQueue({ name: 'audio' })],
  controllers: [AudioController],
  providers: [AudioProcessor],
})
export class AudioModule {}
```

### 7. Scheduled Tasks

```ts
@Injectable()
export class TasksService {
  @Cron('0 0 * * * *')      // every hour
  handleHourlyCleanup() {}
  @Interval(60000)           // every minute
  handleMinutelyTask() {}
  @Timeout(5000)             // once, 5s after startup
  handleInitTask() {}
}
```

### 8. File Upload with Validation

```ts
@UseInterceptors(FileInterceptor('file'))
@Post('upload')
upload(
  @UploadedFile(
    new ParseFilePipeBuilder()
      .addFileTypeValidator({ fileType: 'image/jpeg' })
      .addMaxSizeValidator({ maxSize: 1024 * 1024 * 5 })
      .build({ fileIsRequired: false }),
  )
  file?: Express.Multer.File,
) { return { url: saveFile(file) }; }
```

### 9. Dynamic Module with Async Configuration

```ts
@Module({})
export class DatabaseModule {
  static registerAsync(options: {
    imports: any[];
    useFactory: (...args: any[]) => Promise<Connection>;
    inject: any[];
  }): DynamicModule {
    return {
      module: DatabaseModule,
      imports: options.imports,
      providers: [{ provide: 'DB_CONNECTION', useFactory: options.useFactory, inject: options.inject }],
      exports: ['DB_CONNECTION'],
    };
  }
}
```

### 10. SSE Real-Time Streaming

```ts
@Sse('events')
sendEvents(): Observable<MessageEvent> {
  return interval(1000).pipe(map(count => ({ data: { count } })));
}
```

## Integration Guides

### TypeORM Integration

```bash
npm i @nestjs/typeorm typeorm pg
```

```ts
@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost', port: 5432,
      username: 'postgres', password: 'password', database: 'mydb',
      entities: [User, Product],
      synchronize: true,  // dev only! use migrations in production
    }),
  ],
})
export class AppModule {}
```

### Fastify Adapter

```ts
import { NestFactory } from '@nestjs/core';
import { FastifyAdapter, NestFastifyApplication } from '@nestjs/platform-fastify';
const app = await NestFactory.create<NestFastifyApplication>(AppModule, new FastifyAdapter());
await app.listen(3000, '0.0.0.0');
```

### GraphQL (Code-First)

```bash
npm i @nestjs/graphql @nestjs/apollo @apollo/server graphql
```

```ts
@Module({ imports: [GraphQLModule.forRoot({ autoSchemaFile: true })] })
@ObjectType()
export class User {
  @Field(type => ID) id: number;
  @Field() name: string;
}

@Resolver(of => User)
export class UsersResolver {
  constructor(private usersService: UsersService) {}
  @Query(returns => [User]) users(): Promise<User[]> { return this.usersService.findAll(); }
}
```

## Anti-Patterns

1. **Business logic in Controllers** -- Controllers should be thin; delegate to Services
2. **No validation on inputs** -- Always use ValidationPipe + DTOs with class-validator
3. **Hardcoded secrets in constants.ts** -- Use ConfigModule / environment variables
4. **Missing global exception filter** -- Unhandled exceptions leak stack traces to clients
5. **Calling new Service() instead of DI** -- Bypasses the DI container, loses interceptors/guards
6. **Using synchronize: true in production TypeORM** -- Data loss risk; use migrations
7. **Request-scoped everything** -- Default singleton scope is more performant; use request scope sparingly
8. **Forgetting to export providers** -- Imported modules can only use exported providers
9. **No consistent error response envelope** -- Use a global exception filter for uniform error format
10. **Mixing Express and Fastify APIs in shared code** -- Use the platform-agnostic abstractions when supporting both

## Testing Patterns

```ts
// Unit test with NestJS Test
import { Test, TestingModule } from '@nestjs/testing';

describe('CatsService', () => {
  let service: CatsService;
  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [CatsService, { provide: getRepositoryToken(Cat), useValue: mockRepo }],
    }).compile();
    service = module.get(CatsService);
  });
  it('should find all cats', async () => {
    mockRepo.find.mockResolvedValue([{ id: 1, name: 'Whiskers' }]);
    expect(await service.findAll()).toHaveLength(1);
  });
});

// E2E test
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';

describe('Cats (e2e)', () => {
  let app: INestApplication;
  beforeAll(async () => {
    const module = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = module.createNestApplication();
    await app.init();
  });
  it('/cats (GET)', () => request(app.getHttpServer()).get('/cats').expect(200));
  afterAll(() => app.close());
});
```
