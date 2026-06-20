# Backend

JWT 인증 게시판 프로젝트의 NestJS 백엔드입니다.  
현재 Issue #1 범위로 **프로젝트 기반 설정**과 **Prisma + SQLite DB 구성**까지 완료된 상태입니다.

> 회원가입, 로그인, JWT, 게시글 API는 이후 Issue에서 구현 예정입니다.

---

## 빠른 시작

```bash
# 의존성 설치
npm install

# 환경 변수 설정
cp .env.example .env
# .env에서 <your-db-name>을 실제 DB 파일명으로 변경

# DB migration 적용 (최초 1회)
npx prisma migrate dev

# 개발 서버 실행
npm run start:dev
```

서버 기동 후 `http://localhost:3000` 에 접속하면 `Hello World!` 응답을 확인할 수 있습니다.

---

## 폴더 구조

```
backend/
├── prisma/                  # DB 스키마 및 migration
├── src/                     # 애플리케이션 소스
│   ├── prisma/              # Prisma NestJS 모듈
│   ├── app.module.ts        # 루트 모듈
│   ├── app.controller.ts    # 기본 HTTP 컨트롤러
│   ├── app.service.ts       # 기본 서비스
│   └── main.ts              # 앱 진입점
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
| `main.ts` | NestJS 앱을 생성하고 HTTP 서버를 시작하는 진입점. 기본 포트는 `3000` |
| `app.module.ts` | 앱의 루트 모듈. `PrismaModule`을 import하여 DB 서비스를 앱 전체에서 사용 가능하게 연결 |
| `app.controller.ts` | `GET /` 요청을 처리하는 기본 컨트롤러 |
| `app.service.ts` | 컨트롤러가 호출하는 기본 비즈니스 로직 (`Hello World!` 반환) |
| `app.controller.spec.ts` | `AppController` 단위 테스트 |

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
| `.env` | 로컬에서 사용하는 실제 환경 변수 (`DATABASE_URL`). git에 올리지 않음 |
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

## 사용 라이브러리와 선택 이유

### 런타임 의존성 (`dependencies`)

| 라이브러리 | 선택 이유 |
|-----------|-----------|
| **@nestjs/common, @nestjs/core** | 모듈·컨트롤러·서비스 기반의 구조화된 백엔드 프레임워크. DI(의존성 주입)로 DB·인증 로직을 모듈 단위로 분리하기 적합 |
| **@nestjs/platform-express** | NestJS의 기본 HTTP 어댑터. Express 기반으로 REST API 구현 |
| **@prisma/client** | `schema.prisma`에서 정의한 모델을 타입 안전하게 조회·생성·수정할 수 있는 ORM 클라이언트 |
| **reflect-metadata** | NestJS 데코레이터(`@Module`, `@Injectable` 등) 동작에 필요 |
| **rxjs** | NestJS 내부 비동기 스트림 처리에 사용 |

### 개발 의존성 (`devDependencies`)

| 라이브러리 | 선택 이유 |
|-----------|-----------|
| **prisma** | `schema.prisma` 관리, migration 생성·적용, Prisma Client 생성을 위한 CLI. 개발·빌드 시에만 필요하므로 `devDependencies` |
| **@nestjs/cli, @nestjs/schematics** | `nest g module` 등 코드 스캐폴딩 |
| **typescript** | 타입 안전한 백엔드 개발 |
| **jest, ts-jest, supertest** | 단위·E2E 테스트 |
| **eslint, prettier** | 코드 품질·스타일 일관성 유지 |

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

SQLite는 `VARCHAR`도 내부적으로 TEXT affinity로 저장하므로 **동작은 동일**하고, SQL 명세 표기만 맞춘 것입니다.

### 3. `.env` vs `.env.example` 분리

**고민:** `.env.example`에 실제 경로(`file:./dev.db`)를 그대로 넣으면 템플릿 역할이 불분명해집니다.

**해결:**
- `.env`: 실제 로컬 값 (`DATABASE_URL="file:./dev.db"`)
- `.env.example`: 플레이스홀더 (`DATABASE_URL="file:./<your-db-name>.db"`)

`.env`는 `.gitignore`로 제외하고, `.env.example`만 git에 포함합니다.

---

## DB 스키마 요약

```
User (1) ──────< Post (N)
```

| 모델 | 주요 필드 | 제약 |
|------|-----------|------|
| **User** | `id`, `email`, `password`, `createdAt` | `email` unique |
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

## 이후 Issue 예정 작업

- 회원가입 / 로그인 API
- JWT 인증 (`JWT_SECRET` 환경 변수 추가 예정)
- 게시글 CRUD API
- `password` bcrypt 해시 처리
