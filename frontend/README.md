# Frontend

JWT 인증 게시판 프로젝트의 Flutter 프론트엔드입니다.  
현재 **Issue #6**(Flutter Setup), **Issue #7**(Flutter Authentication Flow), **Issue #8**(Posts List Screen)까지 완료된 상태입니다.

- Flutter 프로젝트 생성 및 필수 패키지 설치
- Riverpod + GoRouter 기본 설정
- DioClient, SecureStorageService, JWT Interceptor 인프라 구성
- JWT 로그인/회원가입, 자동 로그인, 인증 기반 라우팅
- feature 기반 폴더 구조 (Screen / Form / Actions 분리)
- 게시글 목록 API 연동, infinite scroll, pull-to-refresh, 공개 접근

> 게시글 작성 UI 및 `POST /posts` API 연동은 **Issue #9**에서 구현 예정입니다.

---

## 기술 스택

| 구분 | 기술 |
|------|------|
| Framework | Flutter |
| Language | Dart 3.5+ |
| State Management | Riverpod (`flutter_riverpod`) |
| Routing | go_router |
| HTTP Client | Dio |
| Secure Storage | flutter_secure_storage |

---

## 사용 라이브러리와 선택 이유

| 라이브러리 | 역할 | 선택 이유 |
|------------|------|-----------|
| **flutter_riverpod** | 상태 관리·DI | Provider 기반으로 테스트·의존성 주입이 쉽고, 라우터·API 클라이언트를 provider로 공유하기 좋음 |
| **go_router** | 선언적 라우팅 | URL 기반 네비게이션, 인증 redirect(guard) 적용이 자연스러움 |
| **dio** | HTTP 통신 | Interceptor로 JWT 헤더 자동 첨부, 타임아웃·에러 처리 확장이 용이함 |
| **flutter_secure_storage** | JWT 저장 | 토큰을 OS 수준 보안 저장소(Keychain/Keystore/Web Local Storage)에 보관 |

---

## 빠른 시작

### 사전 요구사항

- Flutter SDK 3.24+ (Dart 3.5+)
- 백엔드 서버 실행 (`backend/` — `http://localhost:3000`)
- Flutter Web 사용 시 백엔드 CORS 활성화 필요 (`backend/src/main.ts` — `app.enableCors()`)

### 실행

```bash
cd frontend

# 의존성 설치
flutter pub get

# 앱 실행 (연결된 디바이스 중 자동 선택)
flutter run

# 특정 타깃 지정 예시
flutter run -d edge
flutter run -d chrome
flutter run -d windows   # Visual Studio toolchain 필요
```

### 검증

```bash
flutter analyze
flutter test
```

### 수동 확인 (게시글 목록)

1. JWT 없이 앱 실행 → `/` 게시글 목록 화면 (`Posts`)
2. Create 클릭 → `/login` redirect
3. 로그인 성공 → `/` 목록 화면, JWT 저장
4. Create 클릭 (로그인 상태) → `/posts/create` placeholder
5. 스크롤 하단 → 다음 페이지 infinite scroll
6. Pull-to-refresh → page 1부터 목록 갱신
7. 게시글 0개 → Empty UI
8. 백엔드 OFF 후 앱 시작 → Error UI + 「다시 시도」
9. 1페이지 로딩 후 백엔드 OFF → 스크롤 하단 → Pagination Error (목록 유지)

### 수동 확인 (인증 플로우)

1. `/login`, `/signup` 직접 접근 가능
2. 회원가입 성공 → 로그인 화면 이동
3. 로그인 성공 → `/` 이동, JWT 저장
4. 앱 재시작 → 자동 로그인 (홈 유지)
5. `/posts/create` 비로그인 직접 접근 → `/login` redirect
6. 잘못된 로그인 → 비밀번호 필드 인라인 에러
7. 중복 이메일 회원가입 → 이메일 필드 인라인 에러

---

## API Base URL

백엔드 주소는 `lib/shared/constants/api_constants.dart`에 정의되어 있습니다.

```dart
static const baseUrl = 'http://localhost:3000';
```

| 실행 환경 | 참고 |
|-----------|------|
| Web / Windows / iOS 시뮬레이터 | `localhost:3000` |
| Android 에뮬레이터 | `10.0.2.2:3000`으로 변경 필요 |

Auth API 경로는 `lib/shared/constants/auth_api_constants.dart`에 정의합니다.

```dart
static const login = '/auth/login';
static const signup = '/auth/signup';
```

Posts API 경로는 `lib/features/posts/data/posts_api_paths.dart`에 정의합니다.

```dart
static const posts = '/posts';
```

---

## 프로젝트 구조

```text
frontend/
├─ lib/
│  ├─ main.dart
│  ├─ shared/
│  │  ├─ constants/
│  │  │  ├─ api_constants.dart          # Base URL, 타임아웃
│  │  │  ├─ auth_api_constants.dart     # /auth/login, /auth/signup
│  │  │  ├─ error_messages.dart         # 앱 공통 API 에러 메시지
│  │  │  └─ route_constants.dart        # /, /login, /signup, /posts/create
│  │  ├─ network/
│  │  │  ├─ dio_client.dart
│  │  │  ├─ dio_client_provider.dart
│  │  │  ├─ dio_error_utils.dart        # DioException 공통 파싱 (auth + posts)
│  │  │  └─ jwt_auth_interceptor.dart   # JWT 헤더 첨부, 401 logout
│  │  ├─ storage/
│  │  │  ├─ secure_storage_service.dart
│  │  │  └─ secure_storage_service_provider.dart
│  │  └─ router/
│  │     ├─ app_router.dart              # GoRouter + auth redirect
│  │     └─ router_provider.dart
│  └─ features/
│     ├─ auth/
│     │  ├─ model/                       # LoginRequest, SignupRequest, AuthResponse
│     │  ├─ data/                        # AuthRepository
│     │  ├─ provider/                    # AuthState, AuthNotifier, authProvider
│     │  └─ presentation/
│     │     ├─ constants/                # UI·검증 메시지 상수
│     │     ├─ login/                    # login_screen, login_form, login_actions
│     │     ├─ signup/                   # signup_screen, signup_form, signup_actions
│     │     ├─ utils/                    # validators, field errors, form actions
│     │     └─ widgets/                  # 공통 auth UI 위젯
│     └─ posts/
│        ├─ model/                       # PostModel, PostsMeta, PostsResponse
│        ├─ data/                        # PostsRepository, posts_api_paths
│        ├─ provider/                    # PostsState, PostsNotifier, postsProvider
│        └─ presentation/
│           ├─ constants/                # posts_ui_constants.dart
│           ├─ posts_list_screen.dart
│           ├─ posts_create_placeholder_screen.dart  # Issue #9 placeholder
│           ├─ posts_actions.dart
│           └─ widgets/                  # PostCard, 상태별 view, 버튼
└─ test/
   └─ widget_test.dart                   # 미인증 시 게시글 목록 화면 표시
```

---

## 주요 파일 설명

### 앱 진입

| 파일 | 설명 |
|------|------|
| `main.dart` | `ProviderScope`로 Riverpod 활성화, `MaterialApp.router`로 GoRouter 연결 |

### 라우팅

| 파일 | 설명 |
|------|------|
| `route_constants.dart` | `/`, `/login`, `/signup`, `/posts/create` 경로 상수 |
| `app_router.dart` | `createAppRouter(Ref)` — auth redirect, `router.refresh()` 연동 |
| `router_provider.dart` | `routerProvider` — GoRouter Riverpod 제공 |

**Redirect 규칙**

| AuthStatus | 동작 |
|------------|------|
| `initial` / `loading` | redirect 없음 |
| `authenticated` | `/login`, `/signup` → `/` |
| `unauthenticated` / `error` | `/`, `/login`, `/signup` 접근 허용 / 그 외(예: `/posts/create`) → `/login` |

> `GET /posts`는 비로그인 가능. `POST /posts` 및 `/posts/create`는 로그인 필요.

### Auth — 데이터·상태

| 파일 | 설명 |
|------|------|
| `auth_repository.dart` | `POST /auth/login`, `POST /auth/signup` |
| `auth_state.dart` | `initial`, `loading`, `authenticated`, `unauthenticated`, `error` |
| `auth_notifier.dart` | `login`, `signup`, `logout`, `restoreSession` |
| `auth_provider.dart` | `authProvider` (NotifierProvider) |

### Auth — Presentation

| 파일 | 설명 |
|------|------|
| `login_screen.dart` / `signup_screen.dart` | 상태·리스너·controller 보유, Form/Actions 연결 |
| `login_form.dart` / `signup_form.dart` | UI만 (StatelessWidget) |
| `login_actions.dart` / `signup_actions.dart` | submit, 라우팅, SnackBar fallback |
| `auth_field_errors.dart` | DioException → 이메일/비밀번호 필드 에러 매핑 |
| `auth_validators.dart` | 클라이언트 폼 검증 (이메일, 비밀번호 8자+) |
| `auth_form_actions.dart` | `submitIfValid`, `applyFieldErrors`, SnackBar |

### Posts — 데이터·상태

| 파일 | 설명 |
|------|------|
| `post_model.dart` | 단일 게시글 (`createdAt` → `DateTime`) |
| `posts_response.dart` | `{ data, meta }` 응답 래퍼 |
| `posts_repository.dart` | `GET /posts?page=&limit=` |
| `posts_state.dart` | loading, empty, error, pagination, refresh 상태 |
| `posts_notifier.dart` | `fetchInitialPosts`, `fetchNextPage`, `refreshPosts` |
| `posts_provider.dart` | `postsProvider` (NotifierProvider) |

### Posts — Presentation

| 파일 | 설명 |
|------|------|
| `posts_list_screen.dart` | 목록 Screen, ScrollController, RefreshIndicator |
| `posts_actions.dart` | fetch, refresh, Create auth 분기 (`LoginActions` 패턴) |
| `post_card.dart` | 게시글 카드 UI |
| `posts_*_view.dart` | Loading / Empty / Error / Pagination 상태별 UI |
| `posts_primary_button.dart` | 공통 primary 버튼 |
| `posts_create_button.dart` | AppBar Create 버튼 |

### Network · Storage

| 파일 | 설명 |
|------|------|
| `jwt_auth_interceptor.dart` | 요청 시 Bearer 토큰 첨부, 401 시 logout (login/signup 401 제외) |
| `dio_client_provider.dart` | 401 → `authProvider.notifier.logout()` 콜백 연결 |
| `dio_error_utils.dart` | 네트워크/서버 message 공통 파싱 |
| `secure_storage_service.dart` | JWT `saveToken` / `getToken` / `deleteToken` (key: `jwt_token`) |

### 화면

| 파일 | 경로 | 설명 |
|------|------|------|
| `posts_list_screen.dart` | `/` | 게시글 목록 (Figma 기반) |
| `posts_create_placeholder_screen.dart` | `/posts/create` | 작성 placeholder (Issue #9) |
| `login_screen.dart` | `/login` | 로그인 |
| `signup_screen.dart` | `/signup` | 회원가입 |

---

## 아키텍처 흐름

### 인증 플로우

```text
LoginScreen / SignupScreen
  └─ *Actions (submit, navigate)
       └─ authProvider (AuthNotifier)
            ├─ AuthRepository → DioClient → NestJS /auth/*
            └─ SecureStorageService → JWT 저장·삭제

DioClient
  └─ JwtAuthInterceptor
       ├─ onRequest: Authorization: Bearer {token}
       └─ onError 401: logout() (auth API 401 제외)

main.dart → routerProvider → GoRouter redirect (authProvider 기반)
```

### 게시글 목록 플로우

```text
PostsListScreen
  └─ PostsActions (fetch, refresh, create navigate)
       └─ postsProvider (PostsNotifier)
            └─ PostsRepository → DioClient → NestJS GET /posts

Infinite scroll: ScrollController → fetchNextPage()
Pull-to-refresh: RefreshIndicator → refreshPosts()
Create 버튼: authProvider 확인 → /posts/create 또는 /login
```

### Presentation 레이어 분리

```text
Screen   — controller, ref.watch/listen, ScrollController
Actions  — provider 호출, context.go, SnackBar fallback
Widgets  — 상태별 UI (Loading, Empty, Error, PostCard)
Notifier — API 호출, PostsState 변경 (BuildContext 없음)
Repository — Dio 호출, DioException → 도메인 예외 변환
```

---

## 현재 구현 범위 vs 미구현

| 구현됨 | 미구현 (이후 이슈) |
|--------|-------------------|
| 로그인/회원가입 API 연동 | 게시글 작성 UI (`POST /posts`) |
| JWT Secure Storage + 자동 로그인 | Issue #9 Create Post Screen |
| JWT Interceptor + 401 logout | JWT 만료 E2E (posts API 호출 필요) |
| GoRouter auth redirect | sessionExpired SnackBar |
| Figma 기반 login/signup UI | 환경별 Base URL (.env) |
| 클라이언트·서버 에러 인라인 표시 | |
| 게시글 목록 API 연동 (`GET /posts`) | |
| Infinite scroll + pull-to-refresh | |
| 게시글 목록 공개 접근 (`/` redirect) | |
| Create 버튼 auth UX | |
| Figma 기반 posts list UI | |

---

## 구현하면서 고민했던 부분과 해결방법

### 1. JWT를 AuthState에 넣을지, SecureStorage만 쓸지

**고민:** JWT를 Riverpod 상태에 같이 들고 있으면 접근이 편하지만, 앱 재시작 시 복원·보안 측면에서 저장소와 이중 관리가 됩니다.

**해결:** JWT는 `SecureStorageService`에만 저장하고, `AuthState`는 `authenticated` / `unauthenticated` 같은 **인증 여부**만 표현합니다. 앱 시작 시 `restoreSession()`이 storage에서 토큰 존재 여부만 확인해 상태를 복원합니다.

---

### 2. GoRouter와 Riverpod을 어떻게 연결할지

**고민:** `authProvider`를 `watch`하면 상태 변경마다 GoRouter가 **새로 생성**되어 `initialLocation: /`부터 다시 시작합니다. API 에러(`error` 상태) 시 회원가입 화면이 로그인으로 튕기고 SnackBar/필드 에러도 사라지는 문제가 있었습니다.

**해결:** GoRouter는 **한 번만 생성**하고, `ref.listen(authProvider, …)`에서 `router.refresh()`만 호출해 redirect를 재실행합니다. redirect 내부에서는 `ref.read(authProvider)`로 최신 상태를 읽습니다.

---

### 3. 로그인/회원가입 401과 보호 API 401을 구분할지

**고민:** Interceptor에서 모든 401에 `logout()`을 호출하면, **틀린 비밀번호 로그인**도 logout → redirect가 발생합니다.

**해결:** `JwtAuthInterceptor`에서 요청 path가 `/auth/login`, `/auth/signup`이면 401 logout을 **스킵**합니다. 보호된 API(예: `POST /posts`) 401만 logout 처리합니다.

---

### 4. API 에러를 SnackBar vs 폼 필드 에러 중 어디에 보여줄지

**고민:** 초기에는 SnackBar로 통일했지만, 클라이언트 검증(비밀번호 8자 미만)은 필드 아래 인라인 에러라 **UX가 맞지 않았습니다**. SnackBar만 쓰면 GoRouter 재생성 버그와 겹쳐 에러가 안 보이는 경우도 있었습니다.

**해결:**

- `AuthFieldErrors`로 status code별 **이메일/비밀번호 필드**에 매핑 (409 → email, 401 login → password 등)
- `AuthEmailPasswordFields` validator에서 `emailError ?? AuthValidators.email()` 형태로 서버·클라이언트 에러 통합
- 필드에 매핑되지 않는 에러만 SnackBar fallback

---

### 5. Flutter Web에서 auth API CORS

**고민:** Web에서 `POST /auth/login` 시 브라우저 CORS 정책으로 요청이 차단됩니다.

**해결:** 백엔드 `main.ts`에 `app.enableCors()` 추가. (프론트 단독으로는 해결 불가)

---

### 6. Screen / Form / Actions 분리 vs login·signup 중복

**고민:** UI와 기능 분리 원칙을 지키려면 Screen(연결), Form(UI), Actions(기능)로 나누는 게 맞지만, login/signup이 구조가 거의 같아 **보일러플레이트**가 생깁니다.

**해결:** 공통 위젯(`AuthEmailPasswordFields`, `AuthFormCard` 등)과 `AuthFormActions.applyFieldErrors`로 **중복을 줄이되**, Screen/Form/Actions 파일 분리는 유지했습니다. login/signup Screen·Form 통합(`AuthCredentialsForm` 등)은 이후 리팩터링 여지로 남겨 두었습니다.

---

### 7. 최초 Error vs Pagination Error를 어떻게 나눌지

**고민:** 목록 API 실패 시 항상 전체 화면을 Error로 바꾸면, 2페이지만 실패했을 때 이미 본 목록이 사라져 UX가 나빠집니다.

**해결:** `PostsState`에서 `errorMessage`(최초 실패)와 `paginationErrorMessage`(다음 페이지 실패)를 분리합니다. pagination 실패 시 기존 `posts`는 유지하고 하단에 retry UI만 표시합니다.

---

## 알려진 참고 사항

- **Flutter Web (3.24.0)** — 첫 로드 시 간헐적으로 `MaterialApp`/`Colors` 관련 런타임 오류가 날 수 있음. **페이지 새로고침(F5)** 으로 해결되는 경우가 많음.
- **Flutter Web JWT** — DevTools → Application → Local Storage에서 `jwt_token` 확인 가능 (Web은 flutter_secure_storage web 구현 사용).
- **Windows desktop** — `flutter run -d windows`는 Visual Studio C++ toolchain 설치가 필요함.
- **`.env`** — Base URL은 `api_constants.dart`에 하드코딩. 환경 변수 도입 시 `frontend/.gitignore`에 `.env` 추가 예정.
- **Pull-to-refresh** — 터치/트랙패드 환경 UX. 마우스-only 데스크톱에서는 동작이 제한적일 수 있음.
- **`/posts/create`** — placeholder 화면. 실제 작성 폼은 이후 교체 예정.
