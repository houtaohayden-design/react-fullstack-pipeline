# NestJS API Design Patterns

> API design conventions and patterns extracted from NestJS source and samples

## 1. Route Conventions

### URL Structure

```
/api/v1/users                 # Resource collection (plural noun)
/api/v1/users/:id             # Single resource
/api/v1/users/:id/posts       # Nested resource
/api/v1/users/:id/posts/:pid  # Deep nested (max 1 level recommended)
/api/v1/auth/login            # Auth action
/api/v1/health                # Non-CRUD endpoint

# Path conventions:
# - Use kebab-case for multi-word segments: /order-items
# - Use plural nouns for collections
# - Use :param for dynamic segments (Express-style)
# - Version prefix: /v1/ or via host-based versioning
```

### HTTP Method Usage

```ts
@Get()          // Retrieve resource(s) — idempotent, safe
@Get(':id')     // Retrieve single resource
@Post()         // Create new resource — non-idempotent
@Put(':id')     // Full replacement (send all fields) — idempotent
@Patch(':id')   // Partial update (send changed fields only) — not always idempotent
@Delete(':id')  // Remove resource — idempotent
@Options()      // CORS preflight / allowed methods
@Head()         // Like GET but response body-less (check existence)
```

### Status Codes NestJS Uses

```ts
import { HttpStatus } from '@nestjs/common';

@Post()
@HttpCode(HttpStatus.CREATED)          // 201 — resource created
create() {}

@Post('login')
@HttpCode(HttpStatus.OK)               // 200 — successful login (not 201)
login() {}

@Patch(':id')
@HttpCode(HttpStatus.OK)               // 200 — update success
update() {}

@Delete(':id')
@HttpCode(HttpStatus.NO_CONTENT)       // 204 — deletion success, no body
remove() {}

// Default status codes (no @HttpCode needed):
// GET: 200, POST: 201, PUT/PATCH: 200, DELETE: 200
```

### Redirect

```ts
@Get('old-url')
@Redirect('/new-url', 301)              // permanent redirect
oldEndpoint() {}

@Get('dynamic-redirect')
@Redirect()
dynamicRedirect(@Query('to') to: string) {
  return { url: to, statusCode: 302 };  // temporary redirect
}
```

## 2. Request/Response Formats

### Success Response Envelope (Recommended)

```ts
// Recommended pattern: use a response interceptor
@Injectable()
export class TransformInterceptor implements NestInterceptor {
  intercept(_context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      map(data => ({
        success: true,
        data,
        timestamp: new Date().toISOString(),
      })),
    );
  }
}

// Output:
// Single resource: { success: true, data: { id: 1, name: "John" }, timestamp: "..." }
// Collection:     { success: true, data: [...], timestamp: "..." }
```

### Error Response Envelope

```ts
// Standard NestJS error response:
{
  "statusCode": 400,
  "message": ["name must be a string", "email must be an email"],
  "error": "Bad Request"
}

// Enhanced error envelope (via global exception filter):
{
  "success": false,
  "statusCode": 400,
  "message": "Validation failed",
  "errors": [
    { "field": "name", "constraints": { "isString": "name must be a string" } },
    { "field": "email", "constraints": { "isEmail": "email must be an email" } }
  ],
  "timestamp": "2024-01-15T10:30:00.000Z",
  "path": "/api/v1/users"
}
```

### Pagination Response Metadata

```ts
interface PaginatedResponse<T> {
  success: true;
  data: T[];
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
    hasNextPage: boolean;
    hasPreviousPage: boolean;
  };
  timestamp: string;
}

// Implementation in service
async findAll(page: number, limit: number): Promise<PaginatedResponse<User>> {
  const [data, total] = await this.repo.findAndCount({
    skip: (page - 1) * limit,
    take: limit,
    order: { createdAt: 'DESC' },
  });
  return {
    success: true,
    data,
    meta: {
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      hasNextPage: page * limit < total,
      hasPreviousPage: page > 1,
    },
    timestamp: new Date().toISOString(),
  };
}
```

## 3. Error Handling Patterns

### Error Code Convention

```ts
// NestJS built-in exceptions map to HTTP status codes
// Extension pattern for application-specific codes:

export class BusinessException extends HttpException {
  constructor(code: string, message: string, status: HttpStatus) {
    super({ code, message }, status);
  }
}

// Usage:
throw new BusinessException('USER_NOT_FOUND', 'User with given ID does not exist', HttpStatus.NOT_FOUND);
throw new BusinessException('INSUFFICIENT_BALANCE', 'Not enough funds', HttpStatus.CONFLICT);
throw new BusinessException('EMAIL_TAKEN', 'Email already registered', HttpStatus.CONFLICT);

// Response:
{ "code": "USER_NOT_FOUND", "message": "User with given ID does not exist" }
```

### Validation Error Format

```ts
// class-validator errors -> NestJS ValidationPipe
// Flattened to array of constraint messages:

// Input: { name: "", email: "invalid" }
// Output:
{
  "statusCode": 400,
  "message": [
    "name should not be empty",
    "email must be an email"
  ],
  "error": "Bad Request"
}

// Custom validation error factory:
exceptionFactory: (errors) => {
  return new BadRequestException({
    code: 'VALIDATION_ERROR',
    errors: errors.map(e => ({
      field: e.property,
      messages: Object.values(e.constraints || {}),
    })),
  });
}
```

### Server Error Handling

```ts
// Catch-all filter: logs full error, returns safe message to client
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = 'Internal server error';

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      message = exception.message;
    } else {
      // Log the actual error for debugging
      this.logger.error('Unhandled exception', exception instanceof Error ? exception.stack : exception);
    }

    response.status(status).json({
      success: false,
      statusCode: status,
      message,
      timestamp: new Date().toISOString(),
    });
  }
}
```

## 4. Pagination Patterns

### Offset-Based Pagination

```ts
@Get()
findAll(
  @Query('page', new DefaultValuePipe(1), ParseIntPipe) page: number,
  @Query('limit', new DefaultValuePipe(20), ParseIntPipe) limit: number,
) {
  // page=1, limit=20 -> skip: 0, take: 20
  // page=2, limit=20 -> skip: 20, take: 20
  return this.service.paginate(page, limit);
}

// Service implementation
async paginate(page: number, limit: number) {
  const [data, total] = await this.repo.findAndCount({
    skip: (page - 1) * limit,
    take: limit,
  });
  return generatePaginatedResponse(data, total, page, limit);
}
```

### Cursor-Based Pagination (for large/real-time datasets)

```ts
@Get()
findAll(@Query('cursor') cursor?: string, @Query('limit', ParseIntPipe) limit: number = 20) {
  return this.service.paginateCursor(cursor, limit);
}

async paginateCursor(cursor?: string, limit: number = 20) {
  const query = this.repo.createQueryBuilder('user').orderBy('user.id', 'ASC').take(limit + 1);
  if (cursor) query.andWhere('user.id > :cursor', { cursor });
  const items = await query.getMany();
  const hasMore = items.length > limit;
  const data = hasMore ? items.slice(0, limit) : items;
  return {
    data,
    meta: {
      nextCursor: hasMore ? data[data.length - 1].id.toString() : null,
      hasMore,
    },
  };
}
```

## 5. File Upload Patterns

### Single File

```ts
@UseInterceptors(FileInterceptor('file'))
@Post('upload')
uploadFile(@UploadedFile() file: Express.Multer.File) {
  return { filename: file.originalname, size: file.size };
}
```

### Multiple Files

```ts
@UseInterceptors(FilesInterceptor('files', 5))
@Post('uploads')
uploadFiles(@UploadedFiles() files: Express.Multer.File[]) {
  return files.map(f => ({ name: f.originalname, size: f.size }));
}
```

### File Upload with Validation

```ts
@UseInterceptors(FileInterceptor('avatar'))
@Post('avatar')
uploadAvatar(
  @UploadedFile(
    new ParseFilePipeBuilder()
      .addFileTypeValidator({ fileType: /^image\/(jpeg|png)$/ })
      .addMaxSizeValidator({ maxSize: 5 * 1024 * 1024 })  // 5MB
      .build({ fileIsRequired: true }),
  )
  file: Express.Multer.File,
) {}
```

### File Storage Config

```ts
import { MulterModule } from '@nestjs/platform-express';
import { diskStorage } from 'multer';

@Module({
  imports: [
    MulterModule.register({
      storage: diskStorage({
        destination: './uploads',
        filename: (_req, file, cb) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
        },
      }),
      limits: { fileSize: 10 * 1024 * 1024 },  // 10MB
    }),
  ],
})
```

## 6. WebSocket / SSE Patterns

### Server-Sent Events (SSE)

```ts
// Endpoint: GET /events
@Sse('events')
sendEvents(): Observable<MessageEvent> {
  return this.eventService.subscribe().pipe(
    map(event => ({ data: event } as MessageEvent)),
  );
}

// Event service with keep-alive
@Injectable()
export class EventService {
  private events = new Subject<any>();
  emit(data: any) { this.events.next(data); }
  subscribe(): Observable<any> {
    // Send keep-alive comment every 15s to prevent connection close
    return merge(
      this.events.asObservable(),
      interval(15000).pipe(map(() => ({ comment: 'keep-alive' }))),
    );
  }
}
```

### WebSocket Gateways

```ts
@WebSocketGateway({ cors: true })
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: Server;

  handleConnection(client: Socket) {
    console.log(`Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    console.log(`Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('message')
  handleMessage(@MessageBody() data: string, @ConnectedSocket() client: Socket) {
    // Broadcast to all clients
    this.server.emit('message', { sender: client.id, text: data });
  }

  @SubscribeMessage('join')
  handleJoin(@MessageBody() room: string, @ConnectedSocket() client: Socket) {
    client.join(room);
    this.server.to(room).emit('message', { text: `${client.id} joined ${room}` });
  }
}
```

## 7. Testing Patterns

### Unit Tests (Service)

```ts
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';

describe('CatsService', () => {
  let service: CatsService;
  let repo: jest.Mocked<Repository<Cat>>;

  const mockRepo = {
    find: jest.fn(),
    findOneBy: jest.fn(),
    save: jest.fn(),
    delete: jest.fn(),
    findAndCount: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CatsService,
        { provide: getRepositoryToken(Cat), useValue: mockRepo },
      ],
    }).compile();
    service = module.get(CatsService);
  });

  it('should return all cats', async () => {
    const cats = [{ id: 1, name: 'Whiskers', age: 2, breed: 'Siamese' }];
    mockRepo.find.mockResolvedValue(cats);
    expect(await service.findAll()).toEqual(cats);
  });

  it('should create a cat', async () => {
    const dto = { name: 'Mittens', age: 3, breed: 'Persian' };
    mockRepo.save.mockResolvedValue({ id: 1, ...dto });
    const result = await service.create(dto);
    expect(result.name).toBe('Mittens');
  });
});
```

### E2E Tests (Controller)

```ts
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Cats (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
    await app.init();
  });

  it('POST /cats — should create a cat', () => {
    return request(app.getHttpServer())
      .post('/cats')
      .send({ name: 'Whiskers', age: 2, breed: 'Siamese' })
      .expect(201)
      .expect(res => {
        expect(res.body.name).toBe('Whiskers');
        expect(res.body.id).toBeDefined();
      });
  });

  it('POST /cats — should reject invalid body', () => {
    return request(app.getHttpServer())
      .post('/cats')
      .send({ name: '' })
      .expect(400);
  });

  it('GET /cats — should return paginated list', () => {
    return request(app.getHttpServer())
      .get('/cats?page=1&limit=10')
      .expect(200)
      .expect(res => {
        expect(Array.isArray(res.body.data)).toBe(true);
      });
  });

  afterAll(async () => {
    await app.close();
  });
});
```

### Controller Unit Tests

```ts
describe('CatsController', () => {
  let controller: CatsController;
  let service: CatsService;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      controllers: [CatsController],
      providers: [{ provide: CatsService, useValue: { findAll: jest.fn(), create: jest.fn() } }],
    }).compile();
    controller = module.get(CatsController);
    service = module.get(CatsService);
  });

  it('should return all cats', async () => {
    jest.spyOn(service, 'findAll').mockResolvedValue([{ id: 1, name: 'Kitty' }]);
    expect(await controller.findAll()).toEqual([{ id: 1, name: 'Kitty' }]);
  });
});
```

## 8. API Documentation (OpenAPI/Swagger)

```ts
import { ApiTags, ApiOperation, ApiResponse, ApiQuery } from '@nestjs/swagger';

@ApiTags('users')
@Controller('users')
export class UsersController {
  @ApiOperation({ summary: 'Get all users', description: 'Returns paginated user list' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'Paginated user list', type: [User] })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @Get()
  findAll(@Query() query: FindUsersDto) {}
}

// Bootstrap
const config = new DocumentBuilder()
  .setTitle('Cats API')
  .setDescription('The cats API description')
  .setVersion('1.0')
  .addBearerAuth()
  .build();
const document = SwaggerModule.createDocument(app, config);
SwaggerModule.setup('api', app, document);
```

## 9. Rate Limiting

```ts
// Using @nestjs/throttler
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';

@Module({
  imports: [ThrottlerModule.forRoot({
    throttlers: [{ ttl: 60000, limit: 10 }],  // 10 req/min
  })],
  providers: [{ provide: APP_GUARD, useClass: ThrottlerGuard }],
})

// Skip rate limit for specific routes
@SkipThrottle()
@Get('health')
health() {}

// Override limit per route
@Throttle({ default: { limit: 3, ttl: 60000 } })  // 3 req/min
@Post('login')
login() {}
```

## 10. Request Lifecycle (Complete)

```
1. Incoming request
2. Globally bound middleware
3. Module bound middleware
4. Global guards
5. Controller guards
6. Route guards
7. Global interceptors (pre-controller)
8. Controller interceptors (pre-controller)
9. Route interceptors (pre-controller)
10. Global pipes
11. Controller pipes
12. Route pipes
13. Route parameter pipes
14. Controller (method handler)
15. Service (if injected)
16. Route interceptors (post-request)
17. Controller interceptors (post-request)
18. Global interceptors (post-request)
19. Exception filters (route, controller, global) — on any error above
20. Server response
```

This execution order is critical: **guards fire before pipes**, so authentication happens before validation. **Post-interceptors** can transform the response before it reaches the client. **Exception filters** catch errors from any earlier stage.
