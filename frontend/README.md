# Frontend

JWT 인증 게시판 프로젝트의 Flutter 프론트엔드입니다. 구현 범위는 다음과 같습니다.

- Flutter 프로젝트 생성 및 필수 패키지 설치
- Riverpod + GoRouter 기본 설정
- DioClient, SecureStorageService, JWT Interceptor 인프라 구성
- JWT 로그인/회원가입, 자동 로그인, 인증 기반 라우팅
- feature 기반 폴더 구조 (Screen / Form / Actions 분리)
- 게시글 목록 API 연동, infinite scroll, pull-to-refresh, 공개 접근
- 게시글 작성 UI, `POST /posts` API 연동, validation, 401 session expired UX
- **코드 품질 리팩터링** — 공통 위젯·상수·타입 분리, 에러 처리 표준화, 익명 게시판 UX, 홈 AppBar 로그인/로그아웃
- **반응형 홈 AppBar** — 좁은 viewport에서 제목 전체 표시, compact 버튼

로컬 실행 방법은 [루트 README](../README.md#1-로컬-실행-방법)를, Riverpod 선정 이유는 [루트 README §2](../README.md#2-상태-관리-라이브러리-및-선정-이유)를 참고하세요.

---

## API Base URL

백엔드 주소는 `lib/shared/constants/api_constants.dart`에 정의되어 있습니다.

```dart
static const baseUrl = 'http://localhost:3000';
```

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
│  ├─ main.dart
│  ├─ shared/              # constants, network(Dio·Interceptor), storage, router, widgets
│  └─ features/
│     ├─ auth/             # model, data(Repository), provider(Notifier), presentation
│     └─ posts/            # model, data(Repository), provider(Notifier), presentation
└─ test/
```

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
       └─ onError 401: await logout() (auth API 401 제외)

main.dart → routerProvider → GoRouter redirect (authProvider 변경 시 router.go)
```

**GoRouter redirect**

| AuthStatus | 동작 |
|------------|------|
| `initial` / `loading` | redirect 없음 |
| `authenticated` | `/login`, `/signup` → `/` |
| `unauthenticated` / `error` | `/`, `/login`, `/signup` 허용 / 그 외(예: `/posts/create`) → `/login` |

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
         (480px 미만: 제목 FittedBox + 작성 아이콘 버튼)
```

### 게시글 작성 플로우

```text
CreatePostScreen
  └─ CreatePostActions (submit, success navigate, goBack)
       └─ AuthFormActions.submitIfValid
            └─ createPostProvider (CreatePostNotifier)
                 └─ PostsRepository.createPost() → POST /posts

성공: SnackBar → refreshPosts() → context.go('/')
401: await logout() → sessionExpired SnackBar → router.go('/login')
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

## 구현하면서 고민했던 부분과 해결방법

### 1. JWT를 AuthState에 넣을지, SecureStorage만 쓸지

**고민:** JWT를 Riverpod 상태에 같이 들고 있으면 접근이 편하지만, 앱 재시작 시 복원·보안 측면에서 저장소와 이중 관리가 됩니다.

**해결:** JWT는 `SecureStorageService`에만 저장하고, `AuthState`는 `authenticated` / `unauthenticated` 같은 **인증 여부**만 표현합니다. 앱 시작 시 `restoreSession()`이 storage에서 토큰 존재 여부만 확인해 상태를 복원합니다.

---

### 2. GoRouter와 Riverpod을 어떻게 연결할지

**고민:** `authProvider`를 `watch`하면 상태 변경마다 GoRouter가 **새로 생성**되어 `initialLocation: /`부터 다시 시작합니다. API 에러(`error` 상태) 시 회원가입 화면이 로그인으로 튕기는 문제가 있었습니다.

**해결:** GoRouter는 **한 번만 생성**하고, `ref.listen(authProvider, …)`에서 `_redirect()` 결과가 현재 경로와 다르면 `router.go(target)`으로 이동합니다. `router.refresh()`만으로는 `push`된 보호 경로에서 `/login` redirect가 누락될 수 있어 `go`로 보완했습니다. redirect 내부에서는 `ref.read(authProvider)`로 최신 상태를 읽습니다.

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

**고민:** 작성 성공 후 `context.go('/')`만 하면 목록이 갱신될까? 홈으로 `push` 진입 시 `PostsListScreen`이 dispose되지 않아 `initState`의 `fetchInitialPosts()`가 **재실행되지 않습니다**. 반면 성공 직전 `refreshPosts()` 후 `go`하면, 이론상 `initState`와 중복 호출될 수 있다고 우려했습니다.

**해결:** `CreatePostActions`에서 `refreshPosts()`로 1페이지 목록을 재조회한 뒤 `context.go('/')`합니다. `push` + `go` 조합에서는 `initState`가 다시 돌지 않으므로 중복 GET은 발생하지 않습니다.

---

### 9. 작성 API 401 UX를 UI·Interceptor 중 어디서 처리할지

**고민:** 401 시 토큰 삭제와 사용자 안내를 여러 레이어에 나누면 책임이 겹칩니다.

**해결:**

- **토큰 삭제** — `JwtAuthInterceptor`(await) + `AuthNotifier.logout()`
- **401 메시지** — `DioExceptionMapper.toUserMessage()` → `ErrorMessages.sessionExpired`
- **UI 피드백** — `CreatePostActions` SnackBar
- **로그인 이동** — Actions에서 직접 `go('/login')`하지 않고, logout 후 `router.go(target)` redirect에 위임

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

### 13. 반응형 홈 AppBar 제목 잘림

**고민:** Chrome 반응형(좁은 viewport)에서 AppBar 제목 `JWT 익명 게시판`이 오른쪽 액션 버튼에 밀려 말줄임표로 잘렸습니다.

**해결:**

- `PostsAppBar` 제목에 `FittedBox(fit: BoxFit.scaleDown)` 적용
- `PostsUiConstants.appBarCompactBreakpoint`(480px) 미만에서 `PostsCreateButton`을 아이콘+툴팁으로, `PostsAuthButton` 크기를 축소

**결과:** 좁은 화면에서도 제목 전체가 보이고, 넓은 화면에서는 기존 텍스트 버튼 UX를 유지합니다.

