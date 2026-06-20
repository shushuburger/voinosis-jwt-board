# Backend

JWT 인증 게시판 프로젝트의 NestJS 백엔드입니다.  
현재 **Issue #1**(프로젝트 기반 + Prisma/SQLite), **Issue #2**(JWT 인증 기반 구조), **Issue #3**(회원가입/로그인 API + JWT Access Token 발급), **Issue #4**(게시글 목록 조회 / 작성 API + JWT 보호)까지 완료된 상태입니다.

---

## 빠른 시작

```bash
# 의존성 설치
npm install

# 환경 변수 설정
cp .env.example .env
# .env에서 DATABASE_URL, JWT_SECRET 등을 로컬 값으로 설정

# DB migration 적용 (최초 1회)
npx prisma migrate dev

# 개발 서버 실행
npm run start:dev
```

서버 기동 후 `http://localhost:3000` 에 접속하면 `Hello World!` 응답을 확인할 수 있습니다.

### `.env` 필수 항목

| 변수 | 예시 | 설명 |
|------|------|------|
| `DATABASE_URL` | `file:./dev.db` | SQLite DB 파일 경로 |
| `JWT_SECRET` | (32자 이상 랜덤 문자열) | JWT 서명·검증용 비밀키 |
| `JWT_EXPIRES_IN` | `1d` | JWT 만료 시간 (`1d`, `1h`, `3600` 등) |

`.env`는 git에 올리지 않습니다. 템플릿은 `.env.example`을 참고하세요.

---

## API 엔드포인트 (Issue #3)

| Method | Path | 설명 | 성공 상태 코드 |
|--------|------|------|----------------|
| `POST` | `/auth/signup` | 회원가입 | `201 Created` |
| `POST` | `/auth/login` | 로그인 + JWT Access Token 발급 | `201 Created` |

### `POST /auth/signup`

**Request Body**

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**성공 Response (`201`)**

```json
{
  "id": 1,
  "email": "user@example.com",
  "createdAt": "2026-06-20T08:00:40.224Z"
}
```

| HTTP | 조건 |
|------|------|
| `201` | 회원가입 성공 |
| `409` | 이메일 중복 (`ConflictException`) |
| `400` | DTO 검증 실패 (이메일 형식, 비밀번호 8자 미만) |

- 비밀번호는 **bcrypt**로 해싱 후 DB 저장
- 응답 Body에 `password` **미포함**

### `POST /auth/login`

**Request Body**

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**성공 Response (`201`)**

```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

| HTTP | 조건 |
|------|------|
| `201` | 로그인 성공 + JWT 발급 |
| `401` | 사용자 없음 또는 비밀번호 불일치 (`UnauthorizedException`) |
| `400` | DTO 검증 실패 |

**JWT Payload 예시** (decode 시)

```json
{
  "sub": 1,
  "email": "user@example.com",
  "iat": 1781942446,
  "exp": 1782028846
}
```

### curl 예시

```bash
# 회원가입
curl -i -X POST http://localhost:3000/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'

# 로그인
curl -i -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

Postman 사용 시 Body → **raw** → **JSON** 으로 동일한 Body를 전송하면 됩니다.

---

## API 엔드포인트 (Issue #4)

| Method | Path | 설명 | 인증 | 성공 상태 코드 |
|--------|------|------|------|----------------|
| `GET` | `/posts` | 게시글 목록 조회 (페이지네이션) | 불필요 | `200 OK` |
| `POST` | `/posts` | 게시글 작성 | **JWT 필수** | `201 Created` |

### `GET /posts`

**Query Parameters**

| 파라미터 | 기본값 | 설명 |
|----------|--------|------|
| `page` | `1` | 페이지 번호 (1 이상 정수) |
| `limit` | `10` | 페이지당 게시글 수 (1 이상 정수) |

**성공 Response (`200`)**

```json
{
  "data": [
    {
      "id": 1,
      "title": "제목",
      "content": "본문",
      "authorId": 7,
      "createdAt": "2026-06-20T08:55:04.434Z"
    }
  ],
  "meta": {
    "total": 23,
    "page": 1,
    "lastPage": 3
  }
}
```

| HTTP | 조건 |
|------|------|
| `200` | 목록 조회 성공 |
| `400` | query 검증 실패 (`page=abc`, `page=0`, `limit=-1` 등) |

- `createdAt desc` 기준 **최신순** 정렬
- Prisma `findMany` + `count`를 `Promise.all`로 병렬 조회

### `POST /posts`

**Request Headers**

```http
Authorization: Bearer <accessToken>
Content-Type: application/json
```

**Request Body**

```json
{
  "title": "게시글 제목",
  "content": "게시글 본문"
}
```

**성공 Response (`201`)**

```json
{
  "id": 11,
  "title": "게시글 제목",
  "content": "게시글 본문",
  "authorId": 7,
  "createdAt": "2026-06-20T10:12:06.176Z"
}
```

| HTTP | 조건 |
|------|------|
| `201` | 작성 성공 |
| `401` | JWT 없음 / 유효하지 않음 / 만료 (`JwtAuthGuard`) |
| `400` | DTO 검증 실패 (`title`, `content` 누락 또는 빈 문자열) |

- `authorId`는 JWT payload의 `sub` → `req.user.userId`에서 추출 (body에 포함하지 않음)
- `@UseGuards(JwtAuthGuard)` 적용

### curl 예시 (Posts)

```bash
# 목록 조회 (비로그인 가능)
curl -i "http://localhost:3000/posts?page=1&limit=10"

# 로그인 후 토큰 발급
TOKEN=$(curl -s -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}' \
  | jq -r '.accessToken')

# 게시글 작성 (JWT 필수)
curl -i -X POST http://localhost:3000/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"title":"제목","content":"본문"}'
```

Postman 사용 시 `POST /posts`는 **Authorization → Bearer Token**에 login에서 받은 `accessToken`을 설정합니다.

---

## 폴더 구조

```
backend/
├── prisma/                  # DB 스키마 및 migration
├── src/                     # 애플리케이션 소스
│   ├── auth/                # 인증 모듈 (JWT, DTO, Strategy, Guard)
│   │   ├── dto/             # SignupDto, LoginDto
│   │   ├── guards/          # JwtAuthGuard
│   │   ├── strategies/      # JwtStrategy
│   │   └── types/           # JwtPayload, RequestUser
│   ├── users/               # 사용자 모듈
│   ├── posts/               # 게시글 모듈 (Issue #4)
│   │   └── dto/             # CreatePostDto, FindPostsQueryDto
│   ├── prisma/              # Prisma NestJS 모듈
│   ├── app.module.ts        # 루트 모듈
│   ├── app.controller.ts    # 기본 HTTP 컨트롤러
│   ├── app.service.ts       # 기본 서비스
│   └── main.ts              # 앱 진입점 (ValidationPipe 전역 등록)
├── test/                    # E2E 테스트
├── .env                     # 로컬 환경 변수 (git 제외)
├── .env.example             # 환경 변수 템플릿
└── package.json
```

---

## 파일별 설명

### 애플리케이션 (`src/`)

| 파일 | 역할 |
|------|------|
| `main.ts` | NestJS 앱 생성, **ValidationPipe 전역 등록** (`transform: true`), HTTP 서버 시작 (기본 포트 `3000`) |
| `app.module.ts` | 루트 모듈. `ConfigModule`(전역), `PrismaModule`, `AuthModule`, `UsersModule`, `PostsModule` 연결 |
| `app.controller.ts` | `GET /` 요청을 처리하는 기본 컨트롤러 |
| `app.service.ts` | 컨트롤러가 호출하는 기본 비즈니스 로직 (`Hello World!` 반환) |
| `app.controller.spec.ts` | `AppController` 단위 테스트 |

### 인증 (`src/auth/`)

| 파일 | 역할 |
|------|------|
| `auth.module.ts` | `UsersModule`, `PassportModule`, `JwtModule.registerAsync`, `JwtStrategy` 등록. `JwtModule`, `PassportModule` export (PostsModule Guard 연동) |
| `auth.controller.ts` | `POST /auth/signup`, `POST /auth/login` HTTP 엔드포인트 |
| `auth.service.ts` | 회원가입(`signup`), 로그인 검증(`validateUser`), JWT 발급(`generateToken`, `login`) |
| `dto/signup.dto.ts` | 회원가입 요청 DTO (`@IsEmail`, `@MinLength(8)`) |
| `dto/login.dto.ts` | 로그인 요청 DTO (`@IsEmail`, `@MinLength(8)`) |
| `strategies/jwt.strategy.ts` | Bearer JWT 검증. `JWT_SECRET`으로 서명 확인 후 `RequestUser` 반환 |
| `guards/jwt-auth.guard.ts` | `AuthGuard('jwt')`. `POST /posts` 등 보호 API에 `@UseGuards`로 적용 |
| `types/jwt-payload.type.ts` | JWT payload 타입 (`sub`: User ID, `email`) |
| `types/request-user.type.ts` | 인증 후 `req.user` 타입 (`userId`, `email`) |

### 사용자 (`src/users/`)

| 파일 | 역할 |
|------|------|
| `users.module.ts` | `PrismaModule` import, `UsersService` 등록 및 export |
| `users.service.ts` | `findByEmail()`, `createUser()` — User DB 접근 (PrismaService 사용) |

### 게시글 (`src/posts/`)

| 파일 | 역할 |
|------|------|
| `posts.module.ts` | `PrismaModule`, `AuthModule` import. `PostsController`, `PostsService` 등록 |
| `posts.controller.ts` | `GET /posts` (목록), `POST /posts` (작성 + JwtAuthGuard) |
| `posts.service.ts` | `findAll()` — 페이지네이션·최신순 조회. `create()` — Prisma `post.create()` |
| `dto/create-post.dto.ts` | 작성 요청 DTO (`@IsString`, `@IsNotEmpty`) |
| `dto/find-posts-query.dto.ts` | 목록 query DTO (`page`, `limit` — `@IsInt`, `@Min(1)`) |

### Prisma 연동 (`src/prisma/`)

| 파일 | 역할 |
|------|------|
| `prisma.module.ts` | `PrismaService`를 등록하고 `exports`로 다른 모듈에 공유 |
| `prisma.service.ts` | `PrismaClient`를 상속한 DB 접근 서비스. 앱 시작 시 `$connect()`로 DB 연결 |
| `prisma.service.spec.ts` | `PrismaService` 생성 여부를 검증하는 기본 단위 테스트 |

### 데이터베이스 (`prisma/`)

| 파일 | 역할 |
|------|------|
| `schema.prisma` | DB 종류(SQLite), 모델(User/Post), 관계(1:N)를 정의하는 설계도 |
| `migrations/` | 스키마 변경 이력. 팀원·배포 환경에서 동일한 DB 구조를 재현하기 위해 git에 포함 |
| `migrations/migration_lock.toml` | migration이 SQLite용임을 고정하는 잠금 파일 |
| `migrations/.../migration.sql` | `schema.prisma`를 SQLite가 실행할 실제 SQL로 변환한 파일 |
| `dev.db` | SQLite 실제 데이터 파일 (로컬 전용, git 제외) |

### 환경 변수

| 파일 | 역할 |
|------|------|
| `.env` | 로컬 환경 변수 (`DATABASE_URL`, `JWT_SECRET`, `JWT_EXPIRES_IN`). git에 올리지 않음 |
| `.env.example` | 필요한 환경 변수 키와 형식만 안내하는 템플릿. git에 포함 |

### 프로젝트 설정

| 파일 | 역할 |
|------|------|
| `package.json` | 의존성 및 npm 스크립트 정의 |
| `nest-cli.json` | NestJS CLI 설정 (`src/`를 소스 루트로 인식) |
| `tsconfig.json` | TypeScript 컴파일 옵션 |
| `tsconfig.build.json` | 빌드 시 테스트 파일을 제외하는 설정 |
| `eslint.config.mjs` | ESLint 린트 규칙 |
| `.prettierrc` | Prettier 코드 포맷 규칙 |
| `.gitignore` | git에서 제외할 파일 목록 (`node_modules/`, `dist/`, `.env`, `*.db` 등) |

### 테스트 (`test/`)

| 파일 | 역할 |
|------|------|
| `app.e2e-spec.ts` | HTTP 요청 기반 E2E 테스트 |
| `jest-e2e.json` | E2E 테스트용 Jest 설정 |

---

## 아키텍처

### 계층 구조

```
Controller (HTTP)
  → AuthService (인증·해싱·JWT)
    → UsersService (User DB)
      → PrismaService

Controller (HTTP) — Posts
  → PostsService (게시글 비즈니스 로직)
    → PrismaService
```

- Controller에서 Prisma **직접 접근 금지**
- bcrypt 해싱·비교, JWT 발급은 **AuthService** 책임
- User CRUD·조회는 **UsersService** 책임
- 게시글 조회·작성은 **PostsService** 책임

### 회원가입 흐름 (`POST /auth/signup`)

```
Client → AuthController → AuthService.signup()
  → UsersService.findByEmail()     # 중복 검사 (409)
  → bcrypt.hash()                  # 비밀번호 해싱
  → UsersService.createUser()      # DB 저장
  → password 제외 후 응답 (201)
```

### 로그인 + JWT 발급 흐름 (`POST /auth/login`)

```
Client → AuthController → AuthService.login()
  → AuthService.validateUser()
      → UsersService.findByEmail()
      → bcrypt.compare()           # 실패 시 401
  → AuthService.generateToken()
      → JwtPayload { sub, email }
      → JwtService.signAsync()     # JWT_SECRET, JWT_EXPIRES_IN 적용
  → { accessToken } (201)
```

### 게시글 목록 흐름 (`GET /posts`)

```
Client → PostsController.findAll()
  → FindPostsQueryDto validation (page, limit)
  → PostsService.findAll(page, limit)
      → skip = (page - 1) * limit
      → Promise.all([ findMany(orderBy desc), count() ])
  → { data, meta: { total, page, lastPage } } (200)
```

### 게시글 작성 흐름 (`POST /posts`)

```
Client (Authorization: Bearer <token>)
  → JwtAuthGuard → JwtStrategy → req.user
  → PostsController.create()
  → CreatePostDto validation
  → PostsService.create(req.user.userId, dto)
      → prisma.post.create({ title, content, authorId })
  → 생성된 Post JSON (201)
```

### JWT 검증 흐름 (Guard 적용 — Issue #2 + #3 + #4)

```
요청 (Authorization: Bearer <accessToken>)
  → JwtAuthGuard
  → JwtStrategy (JWT_SECRET으로 서명 검증)
  → validate(): JwtPayload → RequestUser
  → req.user에 사용자 정보 저장
  → Controller 실행
```

login에서 발급한 토큰과 JwtStrategy가 사용하는 `JWT_SECRET`이 동일하므로, `POST /posts` 등 보호 엔드포인트에서 Bearer 토큰 검증이 동작합니다.

---

## JWT 인증 구조 (Issue #2 + #3 + #4)

```
.env (JWT_SECRET, JWT_EXPIRES_IN)
    ↓ ConfigService
AuthModule (exports: JwtModule, PassportModule)
  ├── UsersModule             # UsersService (Prisma DB 접근)
  ├── PassportModule          # Passport 프레임워크 활성화
  ├── JwtModule.registerAsync # JwtService (토큰 발급 — login에서 사용)
  ├── JwtStrategy             # Bearer JWT 검증 → RequestUser
  └── JwtAuthGuard            # AuthGuard('jwt') — POST /posts 보호

PostsModule (imports: AuthModule)
  └── PostsController
        ├── GET  /posts        # 공개 (인증 불필요)
        └── POST /posts        # @UseGuards(JwtAuthGuard)
```

---

## 사용 라이브러리와 선택 이유

### 런타임 의존성 (`dependencies`)

| 라이브러리 | 선택 이유 |
|-----------|-----------|
| **@nestjs/common, @nestjs/core** | 모듈·컨트롤러·서비스 기반의 구조화된 백엔드 프레임워크. DI로 DB·인증 로직을 모듈 단위로 분리 |
| **@nestjs/platform-express** | NestJS의 기본 HTTP 어댑터. Express 기반 REST API |
| **@nestjs/config** | `.env` 환경 변수를 `ConfigService`로 주입. JWT Secret 하드코딩 방지 |
| **@nestjs/jwt, @nestjs/passport** | NestJS와 JWT·Passport 연동 |
| **passport, passport-jwt** | Bearer JWT 추출 및 검증 (`JwtStrategy`) |
| **bcrypt** | 회원가입 시 비밀번호 해싱, 로그인 시 `compare` 검증 |
| **class-validator, class-transformer** | DTO 입력 검증 (`SignupDto`, `LoginDto`, `CreatePostDto`, `FindPostsQueryDto`) + `ValidationPipe` |
| **@prisma/client** | `schema.prisma` 모델을 타입 안전하게 조회·생성·수정 |
| **reflect-metadata** | NestJS 데코레이터 동작에 필요 |
| **rxjs** | NestJS 내부 비동기 스트림 처리 |

### 개발 의존성 (`devDependencies`)

| 라이브러리 | 선택 이유 |
|-----------|-----------|
| **prisma** | `schema.prisma` 관리, migration, Prisma Client 생성 CLI |
| **@types/passport-jwt, @types/bcrypt** | Passport JWT·bcrypt TypeScript 타입 |
| **@nestjs/cli, @nestjs/schematics** | `nest g module` 등 코드 스캐폴딩 |
| **typescript** | 타입 안전한 백엔드 개발 |
| **jest, ts-jest, supertest** | 단위·E2E 테스트 |
| **eslint, prettier** | 코드 품질·스타일 일관성 |

### DB: SQLite를 선택한 이유

- 별도 DB 서버 설치 없이 **로컬 개발을 빠르게** 시작할 수 있음
- 파일 기반(`dev.db`)이라 설정이 단순함
- 이후 PostgreSQL 등으로 전환 시 Prisma가 migration과 모델 정의를 그대로 활용 가능

---

## 구현 시 고민한 사항과 해결

### 1. Prisma 7 vs Prisma 6

**고민:** `npm install prisma` 시 최신 Prisma 7이 설치되었고, `schema.prisma`에 `url = env("DATABASE_URL")`을 넣을 수 없는 에러가 발생했습니다.

**해결:** Prisma 7은 datasource URL을 `prisma.config.ts`로 분리하는 새 구조를 사용합니다. Issue 명세와 `@prisma/client` import 방식에 맞추기 위해 **Prisma 6.19.3**을 사용했습니다.

### 2. VARCHAR vs TEXT — 명세와 Prisma/SQLite 차이

**고민:** DB 명세에는 `email`, `password`, `title`이 `VARCHAR`, `content`가 `TEXT`로 정의되어 있으나, Prisma `String` 타입은 SQLite에서 기본적으로 `TEXT`로 변환됩니다.

**해결:**
- `schema.prisma`: Prisma 문법상 `String`만 사용하고, `/// VARCHAR`, `/// TEXT` 주석으로 명세 타입을 표기
- `migration.sql`: SQLite DDL에서 `VARCHAR(255)` / `TEXT`를 명시적으로 구분

### 3. `.env` vs `.env.example` 분리

**고민:** `.env.example`에 실제 경로·Secret을 그대로 넣으면 템플릿 역할이 불분명해집니다.

**해결:**
- `.env`: 실제 로컬 값 (DB URL, JWT Secret 등)
- `.env.example`: 플레이스홀더 (`your-jwt-secret`, `<your-db-name>`)

`.env`는 `.gitignore`로 제외하고, `.env.example`만 git에 포함합니다.

### 4. `JWT_EXPIRES_IN` TypeScript 타입

**고민:** `ConfigService.getOrThrow<string>()` 반환 타입과 `@nestjs/jwt`의 `expiresIn`(ms `StringValue`) 타입이 맞지 않아 빌드 오류가 발생했습니다.

**해결:** `configService.getOrThrow<string>('JWT_EXPIRES_IN') as StringValue`로 단언. `.env`에는 `1d` 등 유효한 시간 형식을 사용합니다.

### 5. 응답에서 password 제외

**고민:** Prisma `User` 모델에는 `password` 필드가 포함되어 있어, 그대로 반환하면 해시가 노출됩니다.

**해결:** `const { password: _, ...result } = user` destructuring으로 `password`를 제외한 후 응답. signup·validateUser 모두 동일 패턴 적용.

### 6. 로그인 실패 시 동일한 에러 메시지

**고민:** "사용자 없음"과 "비밀번호 불일치"를 구분하면 email 존재 여부가 노출될 수 있습니다.

**해결:** 두 경우 모두 `UnauthorizedException('Invalid credentials')`로 통일하여 **401** 반환.

### 7. query parameter 타입 변환

**고민:** URL query는 항상 string으로 들어와 `page=abc` 같은 입력이 Controller까지 전달되거나, `Number()` 변환 시 `NaN`이 발생할 수 있습니다.

**해결:** `FindPostsQueryDto`에 `@Type(() => Number)`, `@IsInt()`, `@Min(1)` 적용. Global `ValidationPipe({ transform: true })`로 query → number 변환 후 검증. 실패 시 **400**.

---

## DB 스키마 요약

```
User (1) ──────< Post (N)
```

| 모델 | 주요 필드 | 제약 |
|------|-----------|------|
| **User** | `id`, `email`, `password`, `createdAt` | `email` unique, `password`는 bcrypt 해시 저장 |
| **Post** | `id`, `title`, `content`, `authorId`, `createdAt` | `authorId` → `User.id` FK |

---

## 주요 명령어

```bash
npm run start:dev          # 개발 서버 (watch 모드)
npm run build              # 프로덕션 빌드
npm run start:prod         # 빌드 결과 실행

npx prisma migrate dev     # 스키마 변경 후 migration 생성·적용
npx prisma generate        # Prisma Client 재생성
npx prisma studio          # DB GUI (http://localhost:5555)

npm run test               # 단위 테스트
npm run test:e2e           # E2E 테스트
npm run lint               # ESLint
```

---

## 이후 Issue 예정 작업 (낮은 우선순위)

- 게시글 상세 조회 (`GET /posts/:id`)
- 게시글 수정 / 삭제 API
- 작성자 본인만 수정·삭제 가능하도록 권한 검증
