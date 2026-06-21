# Backend

JWT 인증 게시판 프로젝트의 NestJS 백엔드입니다. 구현 범위는 다음과 같습니다.

- NestJS + Prisma/SQLite 프로젝트 기반
- JWT 인증 구조 (Strategy, Guard)
- 회원가입/로그인 API + JWT Access Token 발급
- 게시글 목록 조회·작성 API (`GET /posts` 공개, `POST /posts` JWT 보호)
- Global ValidationPipe, 일관된 Exception 응답, E2E 테스트

로컬 실행 방법(Env, migration)은 [루트 README](../README.md#1-로컬-실행-방법)를 참고하세요.

---

## API 엔드포인트 — 인증

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
| `400` | DTO 검증 실패 (이메일 형식, 필드 누락, 비밀번호 8자 미만) |

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

---

## API 엔드포인트 — 게시글

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
| `401` | JWT 없음 / 유효하지 않음 / 만료 / 위조 / Bearer 형식 아님 (`JwtAuthGuard`) |
| `400` | DTO 검증 실패 (`title`, `content` 누락 또는 빈 문자열) |

- `authorId`는 JWT payload의 `sub` → `req.user.userId`에서 추출 (body에 포함하지 않음)
- `@UseGuards(JwtAuthGuard)` 적용

---

## Validation 및 Exception Handling

명세서의 모든 실패 시나리오에 대해 적절한 HTTP 상태 코드와 에러 메시지를 반환합니다. Custom Exception Filter는 사용하지 않고, NestJS 기본 `HttpException` 응답 구조를 유지합니다.

### 에러 응답 공통 형식

```json
{
  "statusCode": 400,
  "message": "에러 설명 (문자열 또는 문자열 배열)",
  "error": "Bad Request"
}
```

| HTTP | `error` 필드 (예) | `message` 출처 |
|------|-------------------|----------------|
| `400` | `Bad Request` | `ValidationPipe` + class-validator |
| `401` | `Unauthorized` | `AuthService` 또는 Passport `JwtAuthGuard` |
| `409` | `Conflict` | `AuthService` (`ConflictException`) |
| `404` | `Not Found` | NestJS 기본 (등록되지 않은 Route) |

### API별 에러 메시지 요약

#### Auth

| API | HTTP | 조건 | `message` |
|-----|------|------|-----------|
| `POST /auth/signup` | `400` | DTO 검증 실패 | class-validator 배열 (예: `"email must be an email"`, `"password should not be empty"`) |
| `POST /auth/signup` | `409` | 이메일 중복 | `"Email already exists"` |
| `POST /auth/login` | `400` | DTO 검증 실패 | class-validator 배열 (SignupDto와 동일 규칙) |
| `POST /auth/login` | `401` | 사용자 없음 / 비밀번호 불일치 | `"Invalid credentials"` |

#### Posts

| API | HTTP | 조건 | `message` |
|-----|------|------|-----------|
| `POST /posts` | `401` | JWT 없음 / 만료 / 위조 / Bearer 형식 아님 | `"Unauthorized"` |
| `POST /posts` | `400` | `title` / `content` 누락 또는 빈 문자열 | class-validator 배열 (예: `"title should not be empty"`) |
| `GET /posts` | `400` | `page` / `limit` 형식 오류 | class-validator 배열 (예: `"page must be an integer number"`) |
| (전체) | `404` | 존재하지 않는 Route | `"Cannot GET /path"` / `"Cannot POST /path"` |

> **401 메시지 구분:** 로그인 실패는 `"Invalid credentials"`, JWT 인증 실패는 Passport 기본 `"Unauthorized"`. 역할이 다르므로 의도적으로 구분했습니다.

> **400 `message` 타입:** validation 실패 시 `message`는 **문자열 배열**일 수 있습니다. 프론트엔드에서는 `statusCode`로 분기하고, 사용자 UI 문구는 앱에서 별도 정의하는 것을 권장합니다.

### Validation 계층

```
HTTP 요청
  → Global ValidationPipe (main.ts, transform: true)
      → DTO class-validator 검증 실패 → 400
  → JwtAuthGuard (POST /posts)
      → JWT 검증 실패 → 401
  → AuthService
      → 중복 이메일 → 409
      → 로그인 실패 → 401
  → NestJS Router
      → 매칭 Route 없음 → 404
```

### E2E 테스트 (`test/`)

실패 시나리오를 `supertest`로 자동 검증합니다.

| 파일 | 검증 범위 |
|------|-----------|
| `auth.e2e-spec.ts` | signup/login 400·401·409, password 응답 제외 |
| `jwt-auth.e2e-spec.ts` | JWT 없음·Bearer 형식·invalid·expired·forged → 401 |
| `posts-create.e2e-spec.ts` | title/content 누락·빈 문자열 → 400 |
| `posts-query.e2e-spec.ts` | page/limit invalid → 400, 기본값·pagination |
| `route-not-found.e2e-spec.ts` | 없는 Route → 404 |
| `jest-e2e.json` | `maxWorkers: 1` — SQLite 공유 환경에서 E2E 직렬 실행 |

```bash
npm run test:e2e    # E2E 24 tests (6 suites)
```

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
│   ├── posts/               # 게시글 모듈
│   │   └── dto/             # CreatePostDto, FindPostsQueryDto
│   ├── prisma/              # Prisma NestJS 모듈
│   ├── app.module.ts        # 루트 모듈
│   ├── app.controller.ts    # 기본 HTTP 컨트롤러
│   ├── app.service.ts       # 기본 서비스
│   └── main.ts              # 앱 진입점 (ValidationPipe 전역 등록)
├── test/                    # E2E 테스트 (validation 시나리오 포함)
├── .env                     # 로컬 환경 변수 (git 제외)
├── .env.example             # 환경 변수 템플릿
└── package.json
```

---

## 아키텍처

`Controller → Service → PrismaService`. Controller에서 Prisma를 직접 접근하지 않습니다.  
`GET /posts`는 공개, `POST /posts`는 `JwtAuthGuard` + `JwtStrategy`로 Bearer JWT를 검증합니다. `authorId`는 JWT payload `sub`에서 추출합니다.

---

## 구현 시 고민한 사항과 해결

### 1. Prisma 7 vs Prisma 6

**고민:** `npm install prisma` 시 최신 Prisma 7이 설치되었고, `schema.prisma`에 `url = env("DATABASE_URL")`을 넣을 수 없는 에러가 발생했습니다.

**해결:** Prisma 7은 datasource URL을 `prisma.config.ts`로 분리하는 새 구조를 사용합니다. 과제 명세와 `@prisma/client` import 방식에 맞추기 위해 **Prisma 6.19.3**을 사용했습니다.

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

**해결:** `const { password: _, ...result } = user` destructuring으로 `password`를 제외한 후 응답하게 했습니다. signup·validateUser 모두 동일 패턴 적용했습니다.

### 6. 로그인 실패 시 동일한 에러 메시지

**고민:** "사용자 없음"과 "비밀번호 불일치"를 구분하면 email 존재 여부가 노출될 수 있습니다.

**해결:** 두 경우 모두 `UnauthorizedException('Invalid credentials')`로 통일하여 **401** 반환했습니다.

### 7. query parameter 타입 변환

**고민:** URL query는 항상 string으로 들어와 `page=abc` 같은 입력이 Controller까지 전달되거나, `Number()` 변환 시 `NaN`이 발생할 수 있습니다.

**해결:** `FindPostsQueryDto`에 `@Type(() => Number)`, `@IsInt()`, `@Min(1)` 적용. Global `ValidationPipe({ transform: true })`로 query → number 변환 후 검증, 실패 시 **400** 반환했습니다.

### 8. Auth DTO 필드 누락 검증

**고민:** `@IsEmail()`, `@MinLength(8)`만 있으면 필드가 **누락**(`undefined`)될 때 class-validator가 검증을 건너뛸 수 있어 400이 보장되지 않습니다.

**해결:** `SignupDto`, `LoginDto`에 `@IsNotEmpty()` 추가하고 필드 누락·빈 문자열 모두 ValidationPipe에서 **400** 처리했습니다.

### 9. E2E 테스트 SQLite 병렬 실행 충돌

**고민:** `npm run test:e2e` 전체 실행 시 Jest가 test 파일을 병렬로 돌리면, 모든 suite가 같은 `dev.db`를 공유해 user 생성/삭제가 충돌합니다.

**해결:** `jest-e2e.json`에 `"maxWorkers": 1` 설정하여 E2E suite를 직렬 실행해 테스트 안정성을 확보했습니다.

---

## DB 스키마 요약

```
User (1) ──────< Post (N)
```

| 모델 | 주요 필드 | 제약 |
|------|-----------|------|
| **User** | `id`, `email`, `password`, `createdAt` | `email` unique, `password`는 bcrypt 해시 저장 |
| **Post** | `id`, `title`, `content`, `authorId`, `createdAt` | `authorId` → `User.id` FK |
