# Frontend

JWT 인증 게시판 프로젝트의 Flutter 프론트엔드입니다.  
현재 **Issue #6**(Flutter Setup)까지 완료된 상태입니다.

- Flutter 프로젝트 생성 및 필수 패키지 설치
- Riverpod + GoRouter 기본 설정
- DioClient, SecureStorageService 인프라 구성
- feature 기반 폴더 구조 및 임시 화면

> 실제 로그인/회원가입 API 연동, JWT Interceptor, 게시글 CRUD UI는 **이후 이슈**에서 구현 예정입니다.

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
| **go_router** | 선언적 라우팅 | URL 기반 네비게이션, 이후 인증 redirect(guard) 적용이 자연스러움 |
| **dio** | HTTP 통신 | Interceptor로 JWT 헤더 자동 첨부, 타임아웃·에러 처리 확장이 용이함 |
| **flutter_secure_storage** | JWT 저장 | 토큰을 OS 수준 보안 저장소(Keychain/Keystore)에 보관 |

---

## 빠른 시작

### 사전 요구사항

- Flutter SDK 3.24+ (Dart 3.5+)
- 백엔드 서버 실행 (`backend/` — `http://localhost:3000`)

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

---

## API Base URL

백엔드 주소는 `lib/shared/constants/api_constants.dart`에 정의되어 있습니다.

```dart
static const baseUrl = 'http://localhost:3000';
```

| 실행 환경 | 참고 |
|-----------|------|
| Web / Windows / iOS 시뮬레이터 | `localhost:3000` |
| Android 에뮬레이터 | `10.0.2.2:3000`으로 변경 필요 (실제 API 연동 시) |

---

## 프로젝트 구조

```text
frontend/
├─ lib/
│  ├─ main.dart                          # 앱 진입점
│  ├─ shared/                            # 기능 간 공유 레이어
│  │  ├─ constants/
│  │  │  ├─ api_constants.dart          # Base URL, 타임아웃
│  │  │  └─ route_constants.dart        # 라우트 경로 상수
│  │  ├─ network/
│  │  │  ├─ dio_client.dart             # Dio 인스턴스·기본 옵션
│  │  │  └─ dio_client_provider.dart    # DioClient Riverpod provider
│  │  ├─ storage/
│  │  │  ├─ secure_storage_service.dart # JWT save/get/delete
│  │  │  └─ secure_storage_service_provider.dart
│  │  ├─ router/
│  │  │  ├─ app_router.dart             # GoRouter 정의
│  │  │  └─ router_provider.dart        # GoRouter Riverpod provider
│  │  └─ widgets/                       # 공통 위젯 (예정)
│  └─ features/
│     ├─ auth/
│     │  ├─ presentation/               # 로그인·회원가입 UI
│     │  ├─ provider/                   # auth 상태 (예정)
│     │  ├─ data/                       # AuthRepository (예정)
│     │  └─ model/                      # DTO·엔티티 (예정)
│     └─ posts/
│        ├─ presentation/               # 게시글 UI
│        ├─ provider/                   # posts 상태 (예정)
│        ├─ data/                       # PostsRepository (예정)
│        └─ model/                      # DTO·엔티티 (예정)
└─ test/
   └─ widget_test.dart                  # 앱 기동 smoke test
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
| `route_constants.dart` | `/`, `/login`, `/signup` 경로 상수 |
| `app_router.dart` | `createAppRouter()` — 라우트 정의 및 `errorBuilder` |
| `router_provider.dart` | `routerProvider` — GoRouter를 Riverpod으로 제공 |

### API · 저장소

| 파일 | 설명 |
|------|------|
| `api_constants.dart` | `baseUrl`, `connectTimeout`, `receiveTimeout` |
| `dio_client.dart` | Dio 생성, JSON 헤더 설정, `addInterceptor()`로 확장 |
| `dio_client_provider.dart` | `dioClientProvider` |
| `secure_storage_service.dart` | `saveToken`, `getToken`, `deleteToken` |
| `secure_storage_service_provider.dart` | `secureStorageServiceProvider` |

### 임시 화면

| 파일 | 경로 | 설명 |
|------|------|------|
| `posts_placeholder_screen.dart` | `/` | 게시글 목록 자리 |
| `login_placeholder_screen.dart` | `/login` | 로그인 자리 |
| `signup_placeholder_screen.dart` | `/signup` | 회원가입 자리 |

---

## 아키텍처 흐름

### 현재

```text
main.dart
  └─ ProviderScope
       └─ App (ConsumerWidget)
            └─ routerProvider → GoRouter → 임시 화면
```

### 이후 확장 (인증·게시글 기능)

```text
Widget
  └─ Provider (Riverpod)
       └─ Repository
            ├─ DioClient        → POST /auth/login, GET /posts ...
            └─ SecureStorageService → JWT 저장·조회
```

`DioClient.addInterceptor()`에서 `SecureStorageService.getToken()`으로 JWT를 읽어 `Authorization: Bearer {token}` 헤더를 붙이는 구조로 확장할 수 있습니다.

---

## 현재 구현 범위 vs 미구현

| 구현됨 | 미구현 (이후 이슈) |
|-------------------|-------------------|
| Flutter 프로젝트·패키지·폴더 구조 | 실제 로그인/회원가입 API 호출 |
| ProviderScope, GoRouter, 임시 화면 | AuthRepository, PostsRepository |
| DioClient, SecureStorageService 골격 | Dio JWT Interceptor |
| 라우트 상수, API 상수 | 실제 폼 UI, 게시글 목록/작성 |

---

## 알려진 참고 사항

- **Flutter Web (3.24.0)** — 첫 로드 시 간헐적으로 `MaterialApp`/`Colors` 관련 런타임 오류가 날 수 있음. **페이지 새로고침(F5)** 으로 해결되는 경우가 많음.
- **Windows desktop** — `flutter run -d windows`는 Visual Studio C++ toolchain 설치가 필요함.
- **`.env`** — 현재 Base URL은 `api_constants.dart`에 하드코딩. 환경 변수 도입 시 `frontend/.gitignore`에 `.env` 추가 예정.
