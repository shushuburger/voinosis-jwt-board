# Frontend

JWT 인증 게시판 프로젝트의 Flutter 프론트엔드입니다.  
현재 **Issue #6**(Flutter Setup), **Issue #7**(Flutter Authentication Flow), **Issue #8**(Posts List Screen), **Issue #9**(Create Post Screen & Auth UX), **Issue #10**(Code Quality & Architecture Review)까지 완료된 상태입니다.

- Flutter 프로젝트 생성 및 필수 패키지 설치
- Riverpod + GoRouter 기본 설정
- DioClient, SecureStorageService, JWT Interceptor 인프라 구성
- JWT 로그인/회원가입, 자동 로그인, 인증 기반 라우팅
- feature 기반 폴더 구조 (Screen / Form / Actions 분리)
- 게시글 목록 API 연동, infinite scroll, pull-to-refresh, 공개 접근
- 게시글 작성 UI, `POST /posts` API 연동, validation, 401 session expired UX
- **코드 품질 리팩터링** — 공통 위젯·상수·타입 분리, 에러 처리 표준화, 익명 게시판 UX, 홈 AppBar 로그인/로그아웃

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
| **flutter_web_plugins** | Web URL 전략 | `usePathUrlStrategy()`로 Web hash URL(`/#/`) 제거 |

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
2. AppBar **로그인** 클릭 → `/login` 이동
3. 로그인 성공 → `/` 목록 화면, JWT 저장, AppBar **로그아웃** 표시
4. **글 작성하기** 클릭 (로그인 상태) → `/posts/create` 작성 화면 (`context.push`)
5. 스크롤 하단 → 다음 페이지 infinite scroll
6. Pull-to-refresh → page 1부터 목록 갱신
7. refresh 실패 → SnackBar 표시 (기존 목록 유지)
8. 게시글 0개 → Empty UI
9. 백엔드 OFF 후 앱 시작 → Error UI + 「다시 시도」
10. 1페이지 로딩 후 백엔드 OFF → 스크롤 하단 → Pagination Error (목록 유지)
11. PostCard — **작성자 미표시**, 날짜만 표시 (익명 게시판 UX)

### 수동 확인 (게시글 작성)

1. 로그인 후 `/posts/create` 접근 → 제목·본문 입력 폼 표시
2. 제목/본문 미입력 → 필드 아래 인라인 validation 에러
3. 정상 작성 → `"글이 등록되었습니다."` SnackBar → `/` 목록 복귀
4. 작성 후 새 게시글이 목록 최상단에 표시 (목록 Screen `initState` → `fetchInitialPosts()`)
5. 제출 중 버튼·입력·뒤로가기 비활성 (`PopScope`)
6. 뒤로가기 — `canPop`이면 `pop`, 아니면 `/` 이동
7. JWT 삭제(또는 만료) 후 저장 → session expired SnackBar + `router.refresh()` → `/login` redirect
8. 401 후 재로그인 → `/` 목록 이동
9. 백엔드 OFF 상태 저장 → 네트워크 오류 SnackBar

### 수동 확인 (인증 플로우)

1. `/login`, `/signup` 직접 접근 가능
2. 회원가입 성공 → 로그인 화면 이동
3. 로그인 성공 → `/` 이동, JWT 저장
4. 앱 재시작 → 자동 로그인 (홈 유지)
5. `/posts/create` 비로그인 직접 접근 → `/login` redirect
6. 잘못된 로그인 → **비밀번호 필드 인라인 에러** (SnackBar 없음)
7. 중복 이메일 회원가입 → **이메일 필드 인라인 에러**
8. 필드 수정 시 → 해당 필드 에러 클리어 + `validate()` 재실행
9. AppBar **로그아웃** → JWT 삭제, 비로그인 상태

### 수동 확인 (Flutter Web)

1. URL에 hash(`/#/`) 없이 path 기반 라우팅 (`usePathUrlStrategy`)
2. `/login` → `/` → `/posts/create` 직접 입력 시 정상 이동

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
static const posts = '/posts';  // GET (목록, 공개) / POST (작성, JWT 필요)
```

---

## 프로젝트 구조

```text
frontend/
├─ lib/
│  ├─ main.dart                          # usePathUrlStrategy() 포함
│  ├─ shared/
│  │  ├─ constants/
│  │  │  ├─ api_constants.dart          # Base URL, 타임아웃
│  │  │  ├─ app_ui_constants.dart       # 앱 공통 색상·타이포·간격
│  │  │  ├─ app_ui_text.dart            # 앱 공통 문구 (appTitle, login)
│  │  │  ├─ auth_api_constants.dart     # /auth/login, /auth/signup
│  │  │  ├─ error_messages.dart         # API 에러 메시지
│  │  │  ├─ pagination_constants.dart   # page, limit 기본값
│  │  │  ├─ route_constants.dart        # /, /login, /signup, /posts/create
│  │  │  ├─ router_ui_text.dart         # 404 등 라우터 UI 텍스트
│  │  │  └─ storage_constants.dart      # JWT storage key
│  │  ├─ exceptions/
│  │  │  └─ api_request_exception.dart  # Posts API 공통 예외
│  │  ├─ network/
│  │  │  ├─ dio_client.dart
│  │  │  ├─ dio_client_provider.dart
│  │  │  ├─ dio_error_utils.dart        # DioException 저수준 파싱
│  │  │  ├─ dio_exception_mapper.dart   # DioException → 도메인 예외/메시지
│  │  │  └─ jwt_auth_interceptor.dart   # JWT 헤더 첨부, 401 logout
│  │  ├─ storage/
│  │  │  ├─ secure_storage_service.dart
│  │  │  └─ secure_storage_service_provider.dart
│  │  ├─ utils/
│  │  │  └─ snackbar_utils.dart           # SnackBarUtils.showMessage
│  │  ├─ widgets/
│  │  │  ├─ app_primary_button.dart       # Auth/Posts 공통 primary 버튼
│  │  │  └─ labeled_text_field.dart       # Auth/Posts 공통 labeled TextField
│  │  └─ router/
│  │     ├─ app_router.dart              # GoRouter + auth redirect
│  │     └─ router_provider.dart
│  └─ features/
│     ├─ auth/
│     │  ├─ model/                       # LoginRequest, SignupRequest, AuthResponse
│     │  ├─ data/
│     │  │  ├─ auth_repository.dart
│     │  │  ├─ auth_exception.dart
│     │  │  ├─ auth_field_errors.dart
│     │  │  └─ auth_error_context.dart   # login / signup 컨텍스트 enum
│     │  ├─ provider/
│     │  │  ├─ auth_status.dart          # AuthStatus enum
│     │  │  ├─ auth_state.dart
│     │  │  ├─ auth_notifier.dart
│     │  │  └─ auth_provider.dart
│     │  └─ presentation/
│     │     ├─ constants/                # UI·검증 상수·메시지
│     │     ├─ login/                    # login_screen, login_form, login_actions
│     │     ├─ signup/                   # signup_screen, signup_form, signup_actions
│     │     ├─ utils/                    # validators, auth_form_actions
│     │     └─ widgets/                  # 공통 auth UI 위젯
│     └─ posts/
│        ├─ model/                       # PostModel, PostsMeta, PostsResponse, CreatePostRequest
│        ├─ data/                        # PostsRepository, posts_api_paths
│        ├─ provider/                    # PostsState, CreatePostState, Notifier, Provider
│        └─ presentation/
│           ├─ constants/                # posts_ui_*, create_post_ui_*, validation 메시지
│           ├─ create/                   # create_post_screen, form, actions
│           ├─ utils/                    # create_post_validators
│           ├─ posts_list_screen.dart
│           ├─ posts_actions.dart
│           └─ widgets/                  # PostCard, 상태별 view, AppBar, Auth/Create 버튼
└─ test/
   └─ widget_test.dart                   # 미인증 시 게시글 목록 화면 표시
```

---

## 주요 파일 설명

### 앱 진입

| 파일 | 설명 |
|------|------|
| `main.dart` | `ProviderScope`, `usePathUrlStrategy()`, `MaterialApp.router` |

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
| `auth_repository.dart` | `POST /auth/login`, `POST /auth/signup` → `AuthException` |
| `auth_exception.dart` | `AuthFieldErrors` 래핑 예외 |
| `auth_field_errors.dart` | 이메일/비밀번호/fallback 필드 에러 모델 |
| `auth_error_context.dart` | login/signup API 에러 매핑 컨텍스트 |
| `auth_status.dart` | `initial`, `loading`, `authenticated`, `unauthenticated`, `error` |
| `auth_state.dart` | `status`, `emailError`, `passwordError` |
| `auth_notifier.dart` | `login`, `signup`, `logout`, `restoreSession`, `clear*Error` |
| `auth_provider.dart` | `authProvider` (NotifierProvider) |

### Auth — Presentation

| 파일 | 설명 |
|------|------|
| `login_screen.dart` / `signup_screen.dart` | controller, `ref.watch/listen`, Form/Actions 연결 |
| `login_form.dart` / `signup_form.dart` | UI만 (StatelessWidget) |
| `login_actions.dart` / `signup_actions.dart` | submit, 성공 시 navigate |
| `auth_validators.dart` | 클라이언트 폼 검증 (이메일, 비밀번호 8자+) |
| `auth_form_actions.dart` | `submitIfValid`, `applyFieldErrors`, `clearFieldError` |
| `auth_email_password_fields.dart` | login/signup 공통 이메일·비밀번호 필드 |

### Posts — 데이터·상태

| 파일 | 설명 |
|------|------|
| `post_model.dart` | 단일 게시글 (`createdAt` → `DateTime`) |
| `create_post_request.dart` | 작성 요청 body (`title`, `content`, `toJson()`) |
| `posts_response.dart` | `{ data, meta }` 응답 래퍼 |
| `posts_repository.dart` | `GET /posts`, `POST /posts` → `ApiRequestException` |
| `posts_state.dart` | loading, empty, error, pagination, **refreshErrorMessage** |
| `posts_notifier.dart` | `fetchInitialPosts`, `fetchNextPage`, `refreshPosts`, `clearRefreshError` |
| `posts_provider.dart` | `postsProvider` (NotifierProvider) |
| `create_post_state.dart` | `isSubmitting`, `isSuccess`, `errorMessage` |
| `create_post_notifier.dart` | `submitPost`, `reset` (중복 제출 방지) |
| `create_post_provider.dart` | `createPostProvider` (NotifierProvider) |

### Posts — Presentation

| 파일 | 설명 |
|------|------|
| `posts_list_screen.dart` | 목록 Screen, ScrollController, RefreshIndicator, auth 버튼 |
| `posts_actions.dart` | fetch, refresh, logout |
| `create_post_screen.dart` | controller, `ref.listen`, `PopScope` |
| `create_post_form.dart` | 제목·본문 Form UI (`LabeledTextField` multiline) |
| `create_post_actions.dart` | submit, success navigate, goBack, API 에러 SnackBar |
| `create_post_validators.dart` | trim 후 제목/본문 빈 값 검증 |
| `post_card.dart` | 익명 게시글 카드 (제목·본문·날짜) |
| `posts_*_view.dart` | Loading / Empty / Error / Pagination 상태별 UI |
| `posts_app_bar.dart` | Posts 공통 AppBar (목록·작성) |
| `posts_auth_button.dart` | AppBar 로그인/로그아웃 버튼 |
| `posts_create_button.dart` | AppBar 글 작성하기 버튼 |
| `posts_centered_state_view.dart` | Empty/Error 공통 Center 레이아웃 |
| `posts_create_app_bar.dart` | 작성 화면 AppBar (뒤로가기) |
| `posts_form_page_layout.dart` | 작성·폼 공통 페이지 레이아웃 |

### Network · Storage · Error

| 파일 | 설명 |
|------|------|
| `jwt_auth_interceptor.dart` | Bearer 토큰 첨부, 보호 API 401 → logout |
| `dio_client_provider.dart` | 401 → `authProvider.notifier.logout()` 콜백 연결 |
| `dio_error_utils.dart` | 네트워크/401/서버 message 저수준 파싱 |
| `dio_exception_mapper.dart` | `toApiRequestException`, `toAuthFieldErrors` 중앙 변환 |
| `api_request_exception.dart` | Posts fetch/create 공통 사용자 메시지 예외 |
| `secure_storage_service.dart` | JWT `saveToken` / `getToken` / `deleteToken` |
| `snackbar_utils.dart` | Posts refresh/create 성공·실패 SnackBar |

### 화면

| 파일 | 경로 | 설명 |
|------|------|------|
| `posts_list_screen.dart` | `/` | JWT 익명 게시판 목록 |
| `create_post_screen.dart` | `/posts/create` | 게시글 작성 (로그인 필요) |
| `login_screen.dart` | `/login` | 로그인 |
| `signup_screen.dart` | `/signup` | 회원가입 |

---

## 아키텍처 흐름

### 인증 플로우

```text
LoginScreen / SignupScreen
  └─ *Actions (submit, navigate)
       └─ AuthFormActions.submitIfValid
            └─ authProvider (AuthNotifier)
                 ├─ AuthRepository → DioExceptionMapper.toAuthFieldErrors
                 └─ SecureStorageService → JWT 저장·삭제

DioClient
  └─ JwtAuthInterceptor
       ├─ onRequest: Authorization: Bearer {token}
       └─ onError 401: logout() (auth API 401 제외)

main.dart → routerProvider → GoRouter redirect (authProvider + router.refresh)
```

### 게시글 목록 플로우

```text
PostsListScreen
  └─ PostsActions (fetch, refresh, logout)
       └─ postsProvider (PostsNotifier)
            └─ PostsRepository → DioExceptionMapper → GET /posts

Infinite scroll: ScrollController → fetchNextPage()
Pull-to-refresh: RefreshIndicator → refreshPosts()
Refresh 실패: refreshErrorMessage → SnackBar
AppBar: PostsAuthButton (login/logout) + PostsCreateButton → push /posts/create
```

### 게시글 작성 플로우

```text
CreatePostScreen
  └─ CreatePostActions (submit, success navigate, goBack)
       └─ AuthFormActions.submitIfValid
            └─ createPostProvider (CreatePostNotifier)
                 └─ PostsRepository.createPost() → POST /posts

성공: SnackBar → context.go('/') → fetchInitialPosts()
401: Interceptor logout → sessionExpired SnackBar → router.refresh() → /login
Validation: Form + CreatePostValidators (인라인) / API·네트워크 (SnackBar)
```

### Presentation 레이어 분리

```text
Screen   — controller, ref.watch/listen, ScrollController / PopScope
Actions  — provider 호출, context.go/pop, SnackBar (posts only)
Form     — UI만 (StatelessWidget, validators 연결)
Widgets  — 상태별 UI (Loading, Empty, Error, PostCard)
Notifier — API 호출, State 변경 (BuildContext 없음)
Repository — Dio 호출, DioException → 도메인 예외 변환
```

### 에러 처리 정책

| 영역 | 클라이언트 validation | API/네트워크 실패 |
|------|----------------------|-------------------|
| Login / Signup | 필드 아래 인라인 | 필드 아래 인라인 (`AuthFieldErrors`) |
| Posts 목록 (초기) | — | Error View + retry |
| Posts pagination | — | 하단 retry (목록 유지) |
| Posts refresh | — | SnackBar |
| Create Post | 필드 아래 인라인 | SnackBar |

---

## 현재 구현 범위 vs 미구현

| 구현됨 | 미구현 (이후 이슈) |
|--------|-------------------|
| 로그인/회원가입 API 연동 | 환경별 Base URL (.env) |
| JWT Secure Storage + 자동 로그인 | 게시글 상세/수정/삭제 |
| JWT Interceptor + 401 logout | |
| GoRouter auth redirect + Web path URL | |
| Screen / Form / Actions 분리 | |
| 공통 위젯 (`AppPrimaryButton`, `LabeledTextField`) | |
| feature·shared 상수 분리 (`app_ui_constants`, `app_ui_text`) | |
| `DioExceptionMapper` 중앙 에러 변환 | |
| Auth API → 필드 인라인 에러 (SnackBar 없음) | |
| 게시글 목록 API + infinite scroll + pull-to-refresh | |
| 게시글 목록 공개 접근 + refresh SnackBar | |
| 익명 게시판 UX (PostCard 작성자 미표시) | |
| 홈 AppBar 로그인/로그아웃 + 글 작성하기 | |
| 게시글 작성 + validation + success/error UX | |
| 작성 401 → session expired + login redirect | |

---

## 구현하면서 고민했던 부분과 해결방법

### 1. JWT를 AuthState에 넣을지, SecureStorage만 쓸지

**고민:** JWT를 Riverpod 상태에 같이 들고 있으면 접근이 편하지만, 앱 재시작 시 복원·보안 측면에서 저장소와 이중 관리가 됩니다.

**해결:** JWT는 `SecureStorageService`에만 저장하고, `AuthState`는 `authenticated` / `unauthenticated` 같은 **인증 여부**만 표현합니다. 앱 시작 시 `restoreSession()`이 storage에서 토큰 존재 여부만 확인해 상태를 복원합니다.

---

### 2. GoRouter와 Riverpod을 어떻게 연결할지

**고민:** `authProvider`를 `watch`하면 상태 변경마다 GoRouter가 **새로 생성**되어 `initialLocation: /`부터 다시 시작합니다. API 에러(`error` 상태) 시 회원가입 화면이 로그인으로 튕기는 문제가 있었습니다.

**해결:** GoRouter는 **한 번만 생성**하고, `ref.listen(authProvider, …)`에서 `router.refresh()`만 호출해 redirect를 재실행합니다. redirect 내부에서는 `ref.read(authProvider)`로 최신 상태를 읽습니다.

---

### 3. 로그인/회원가입 401과 보호 API 401을 구분할지

**고민:** Interceptor에서 모든 401에 `logout()`을 호출하면, **틀린 비밀번호 로그인**도 logout → redirect가 발생합니다.

**해결:** `JwtAuthInterceptor`에서 요청 path가 `/auth/login`, `/auth/signup`이면 401 logout을 **스킵**합니다. 보호된 API(예: `POST /posts`) 401만 logout 처리합니다.

---

### 4. API 에러를 SnackBar vs 폼 필드 에러 중 어디에 보여줄지

**고민:** Auth API 실패를 SnackBar로 보여주면 GoRouter 재생성·필드 validation UX와 맞지 않았습니다.

**해결:**

- `DioExceptionMapper.toAuthFieldErrors` + `AuthFieldErrors` (data layer)로 status code별 필드 매핑
- `AuthEmailPasswordFields` validator에서 `emailError ?? AuthValidators.email()` 형태로 서버·클라이언트 에러 통합
- Auth 화면은 **SnackBar 없이 필드 인라인 에러만** 사용
- Posts/Create Post는 용도에 맞게 View 또는 SnackBar 사용

---

### 5. Flutter Web에서 auth API CORS

**고민:** Web에서 `POST /auth/login` 시 브라우저 CORS 정책으로 요청이 차단됩니다.

**해결:** 백엔드 `main.ts`에 `app.enableCors()` 추가. (프론트 단독으로는 해결 불가)

---

### 6. Screen / Form / Actions 분리 vs login·signup 중복

**고민:** UI와 기능 분리 원칙을 지키려면 Screen(연결), Form(UI), Actions(기능)로 나누는 게 맞지만, login/signup이 구조가 거의 같아 **보일러플레이트**가 생깁니다.

**해결:** 공통 위젯(`AuthEmailPasswordFields`, `AuthFormCard`, `AppPrimaryButton`, `LabeledTextField`)과 `AuthFormActions`로 중복을 줄이되, Screen/Form/Actions 파일 분리는 유지했습니다.

---

### 7. 최초 Error vs Pagination Error vs Refresh Error

**고민:** 목록 API 실패를 하나의 `errorMessage`로만 처리하면 refresh·pagination 실패 UX를 세분화하기 어렵습니다.

**해결:** `PostsState`에서 `errorMessage`(최초), `paginationErrorMessage`(다음 페이지), `refreshErrorMessage`(pull-to-refresh)를 분리합니다. refresh 실패는 SnackBar, pagination 실패는 하단 retry UI로 처리합니다.

---

### 8. 작성 성공 후 목록 갱신을 어디서 할지

**고민:** 작성 성공 직전 `refreshPosts()`를 호출하면 `context.go('/')` 후 `initState` → `fetchInitialPosts()`와 **GET /posts 중복** 호출될 수 있습니다.

**해결:** 작성 Actions에서는 navigate만 수행하고, 목록 갱신은 `PostsListScreen.initState`의 `fetchInitialPosts()`에 위임합니다.

---

### 9. 작성 API 401 UX를 UI·Interceptor 중 어디서 처리할지

**고민:** 401 시 토큰 삭제와 사용자 안내를 여러 레이어에 나누면 책임이 겹칩니다.

**해결:**

- **토큰 삭제** — `JwtAuthInterceptor` + `AuthNotifier.logout()`
- **401 메시지** — `DioExceptionMapper.toUserMessage()` → `ErrorMessages.sessionExpired`
- **UI 피드백** — `CreatePostActions` SnackBar
- **로그인 이동** — Actions에서 직접 `go('/login')`하지 않고, logout 후 `router.refresh()` redirect에 위임

---

### 10. `LabeledTextField` multiline과 `obscureText` 충돌

**고민:** `obscureText: true`와 multiline `maxLines`가 동시에 적용되면 Flutter assertion이 발생할 수 있습니다.

**해결:** `obscureText`일 때 `minLines`/`maxLines`를 1로 고정하고, 일반 필드만 multiline 옵션을 허용합니다.

---

### 11. Auth 필드 에러 클리어 시 validation이 갱신되지 않는 문제

**고민:** 사용자가 필드를 수정해도 `AuthState`의 에러만 지우고 `Form.validate()`를 다시 호출하지 않으면, 이전 서버 에러 메시지가 필드에 남습니다.

**해결:** `AuthFormActions.clearFieldError()`에서 notifier `clear*Error()` 후 `addPostFrameCallback`으로 `formKey.currentState?.validate()`를 재실행합니다.

---

### 12. Flutter Web hash URL 제거

**고민:** 기본 Flutter Web은 `/#/login` 형태 hash routing을 사용해 URL 공유·직접 입력 UX가 좋지 않습니다.

**해결:** `main.dart`에서 `usePathUrlStrategy()` 호출 (`flutter_web_plugins`). Web에서 `/login`, `/posts/create` path 기반 접근 가능.

---

## 알려진 참고 사항

- **Flutter Web (3.24.0)** — 첫 로드 시 간헐적으로 `MaterialApp`/`Colors` 관련 런타임 오류가 날 수 있음. **페이지 새로고침(F5)** 으로 해결되는 경우가 많음.
- **Flutter Web JWT** — DevTools → Application → Local Storage에서 `jwt_token` 확인 가능 (Web은 flutter_secure_storage web 구현 사용).
- **Windows desktop** — `flutter run -d windows`는 Visual Studio C++ toolchain 설치가 필요함.
- **Pull-to-refresh** — 터치/트랙패드 환경 UX. 마우스-only 데스크톱에서는 동작이 제한적일 수 있음.

