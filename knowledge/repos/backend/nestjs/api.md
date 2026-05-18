# NestJS API Reference

> Source: [nestjs/nest](https://github.com/nestjs/nest) — 75K+ stars
> Progressive Node.js framework for building server-side applications with TypeScript

## Setup

```bash
npm i -g @nestjs/cli
nest new project-name
cd project-name
npm run start:dev
```

Core dependencies:
```bash
npm i @nestjs/common @nestjs/core @nestjs/platform-express reflect-metadata rxjs
```

Main entry (`src/main.ts`):
```ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}
bootstrap();
```

## Core Decorators

### Class Decorators

```ts
// src/cats/cats.module.ts
@Module({
  imports: [CommonModule],
  controllers: [CatsController],
  providers: [CatsService],
  exports: [CatsService],
})
export class CatsModule {}

// src/cats/cats.controller.ts
@Controller('cats')
export class CatsController {}

// src/cats/cats.service.ts
@Injectable()
export class CatsService {}
```

### HTTP Method Decorators

```ts
@Controller('users')
export class UsersController {
  @Get()           findAll(): User[] {}
  @Get(':id')      findOne(@Param('id') id: string): User {}
  @Post()          create(@Body() dto: CreateUserDto): User {}
  @Put(':id')      update(@Param('id') id: string, @Body() dto: UpdateUserDto): User {}
  @Patch(':id')    partialUpdate(@Param('id') id: string, @Body() dto: PartialUpdateDto): User {}
  @Delete(':id')   remove(@Param('id') id: string): void {}
  @Options(':id')  options(@Param('id') id: string): void {}
  @Head(':id')     head(@Param('id') id: string): void {}
  @All('*')        wildcard(): string {}
}
```

### Parameter Decorators

```ts
@Controller('products')
export class ProductsController {
  @Get()
  findAll(
    @Query('page') page: number,           // ?page=1
    @Query('limit') limit: number,          // ?limit=10
    @Query() allQueryParams: Record<string, any>,  // all query params
  ): Product[] {}

  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,  // /products/1
    @Param() allParams: Record<string, any>,
  ): Product {}

  @Post()
  create(
    @Body() dto: CreateProductDto,          // request body
    @Body('name') name: string,             // single body field
    @Headers('authorization') auth: string, // specific header
    @Headers() allHeaders: Record<string, string>,
    @Ip() ip: string,                       // client IP
    @Request() req,                         // full Express request
    @Response() res,                        // full Express response
    @Session() session,                     // session object
  ): Product {}

  @Post('upload')
  @UseInterceptors(FileInterceptor('file'))
  upload(
    @UploadedFile() file: Express.Multer.File,
    @UploadedFiles() files: Express.Multer.File[],
  ): { url: string } {}
}
```

### Custom Decorator Composing

```ts
// src/auth/decorators/public.decorator.ts
import { SetMetadata } from '@nestjs/common';

export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);
```

## Module System

```ts
@Module({
  imports: [
    CommonModule,
    TypeOrmModule.forFeature([User]),
    // Dynamic module
    JwtModule.register({ secret: 'secret', signOptions: { expiresIn: '60s' } }),
    // Async module
    ConfigModule.forRoot({ isGlobal: true }),
  ],
  controllers: [CatsController],
  providers: [
    CatsService,
    // Custom provider
    { provide: 'CONFIG', useValue: { host: 'localhost' } },
    { provide: AppService, useClass: AppService },
    { provide: 'ASYNC_CONNECTION', useFactory: async () => { return db }, inject: [] },
  ],
  exports: [CatsService],  // make available to importing modules
})
export class CatsModule {}

// Global module
@Global()
@Module({ exports: [CommonService], providers: [CommonService] })
export class CommonModule {}
```

## Guards (Auth / Authorization)

```ts
// src/auth/auth.guard.ts
import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private jwtService: JwtService,
    private reflector: Reflector,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    // Check if route is public
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) return true;

    const request = context.switchToHttp().getRequest();
    const token = this.extractTokenFromHeader(request);
    if (!token) throw new UnauthorizedException();
    try {
      request['user'] = await this.jwtService.verifyAsync(token);
    } catch {
      throw new UnauthorizedException();
    }
    return true;
  }

  private extractTokenFromHeader(request: Request): string | undefined {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    return type === 'Bearer' ? token : undefined;
  }
}

// Apply globally in module:
// { provide: APP_GUARD, useClass: AuthGuard }

// Apply per-controller or per-route:
@UseGuards(AuthGuard)
@Controller('admin')
export class AdminController {}
```

## Pipes (Validation / Transformation)

```ts
// Built-in pipes
@Get(':id')
findOne(@Param('id', ParseIntPipe) id: number): User {}

@Get()
findAll(@Query('ids', ParseArrayPipe) ids: number[]): User[] {}

@Get()
findByUuid(@Query('id', ParseUUIDPipe) id: string): User {}

@Get()
search(@Query('active', ParseBoolPipe) active: boolean): User[] {}

@Get('by-role')
byRole(@Query('role', new ParseEnumPipe(UserRole)) role: UserRole): User[] {}

// ValidationPipe (uses class-validator/class-transformer)
@Post()
create(@Body(new ValidationPipe()) dto: CreateUserDto): User {}
// dto class decorated with @IsString(), @IsEmail(), @MinLength(), etc.

// Global pipe
app.useGlobalPipes(new ValidationPipe({ transform: true, whitelist: true }));
```

## Interceptors

```ts
import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Observable, tap } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const now = Date.now();
    return next.handle().pipe(
      tap(() => console.log(`${request.method} ${request.url} ${Date.now() - now}ms`)),
    );
  }
}

@Injectable()
export class TransformInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(map(data => ({ data, success: true })));
  }
}

// Usage: @UseInterceptors(LoggingInterceptor)
// Global: app.useGlobalInterceptors(new TransformInterceptor());
```

## Exception Filters

```ts
import { ExceptionFilter, Catch, ArgumentsHost, HttpException } from '@nestjs/common';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const status = exception.getStatus();
    response.status(status).json({
      statusCode: status,
      message: exception.message,
      timestamp: new Date().toISOString(),
    });
  }
}

// Global: app.useGlobalFilters(new HttpExceptionFilter());
```

## Circular Dependency Resolution

```ts
import { forwardRef, Inject, Injectable } from '@nestjs/common';

@Injectable()
export class CatsService {
  constructor(@Inject(forwardRef(() => CommonService)) private commonService: CommonService) {}
}
```

## Dynamic Modules

```ts
@Module({})
export class DatabaseModule {
  static register(options: DatabaseOptions): DynamicModule {
    return {
      module: DatabaseModule,
      providers: [{ provide: 'CONNECTION', useValue: createConnection(options) }],
      exports: ['CONNECTION'],
    };
  }

  static registerAsync(options: DatabaseAsyncOptions): DynamicModule {
    return {
      module: DatabaseModule,
      imports: options.imports || [],
      providers: [
        { provide: 'CONNECTION', useFactory: options.useFactory, inject: options.inject || [] },
      ],
      exports: ['CONNECTION'],
    };
  }
}
```

## File Upload

```ts
@Post('upload')
@UseInterceptors(FileInterceptor('file'))
uploadFile(
  @UploadedFile(
    new ParseFilePipeBuilder()
      .addFileTypeValidator({ fileType: 'jpeg' })
      .addMaxSizeValidator({ maxSize: 1000 })
      .build({ fileIsRequired: false }),
  )
  file: Express.Multer.File,
) { return { url: file.path }; }
```

## SSE (Server-Sent Events)

```ts
import { Sse, MessageEvent } from '@nestjs/common';
import { interval, map, Observable } from 'rxjs';

@Sse('sse')
sse(): Observable<MessageEvent> {
  return interval(1000).pipe(map(_ => ({ data: { hello: 'world' } })));
}
```

## Queue Processing (Bull)

```ts
// Producer
@Controller('audio')
export class AudioController {
  constructor(@InjectQueue('audio') private audioQueue: Queue) {}
  @Post('transcode')
  async transcode() { await this.audioQueue.add('transcode', { file: 'audio.mp3' }); }
}

// Consumer
@Processor('audio')
export class AudioProcessor {
  @Process('transcode')
  handleTranscode(job: Job) { /* process job.data */ }
}
```

## Scheduling

```ts
@Injectable()
export class TasksService {
  @Cron('45 * * * * *')         handleCron() {}      // Cron expression
  @Interval(10000)              handleInterval() {}   // Every 10s
  @Timeout(5000)                handleTimeout() {}    // Once after 5s
}
```

## Cache

```ts
// Module
import { CacheModule } from '@nestjs/cache-manager';
@Module({ imports: [CacheModule.register({ ttl: 5, max: 100 })] })

// Controller — auto-cache GET responses
@UseInterceptors(CacheInterceptor)
@Controller('users')
export class UsersController {}

// Custom cache key interceptor
@Injectable()
export class HttpCacheInterceptor extends CacheInterceptor {
  trackBy(context: ExecutionContext): string | undefined {
    const request = context.switchToHttp().getRequest();
    if (request.method !== 'GET') return undefined;
    return request.url;
  }
}
```
