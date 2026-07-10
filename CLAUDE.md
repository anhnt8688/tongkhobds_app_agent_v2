# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**TongkhoBDS Agent (v2)** — a Flutter mobile app for real-estate (BĐS) agents. UI strings and domain language are Vietnamese; keep user-facing text in Vietnamese. This is a rewrite of a v1 app, and many endpoints/behaviors are matched to v1 (noted in code comments). Not a git repository.

## Commands

```bash
flutter pub get                         # install deps
dart run build_runner build --delete-conflicting-outputs   # regenerate *.freezed.dart / *.g.dart
dart run build_runner watch --delete-conflicting-outputs   # auto-regen during model work
flutter analyze                         # lint / static analysis (run before considering work done)
flutter run                             # run on a connected device/emulator
flutter test                            # run all tests
flutter test test/widget_test.dart      # run a single test file
flutter build apk / flutter build ios   # release builds
```

After editing any class annotated with `@freezed` or `@JsonSerializable`, you **must** re-run `build_runner` — the `.freezed.dart` / `.g.dart` files are generated and not hand-edited. Generated files are excluded from analysis (see `analysis_options.yaml`).

## Architecture

**Stack:** Riverpod (state/DI) · Dio (HTTP) · go_router (routing) · Freezed + json_serializable (models) · flutter_secure_storage (tokens).

**Feature-first layout.** Each feature under `lib/features/<name>/` splits into:
- `data/` — `*_api.dart` (Dio calls), `data/models/` (Freezed models)
- `presentation/` — screens, `presentation/controllers/` (Riverpod notifiers), `presentation/widgets/`

Shared infra lives in `lib/core/` (`network/`, `router/`, `storage/`, `theme/`, `config/`, `widgets/`, `utils/`).

### Networking — the request pipeline matters
A single `dioProvider` (`lib/core/network/dio_client.dart`) is shared by all `*Api` classes. Each feature exposes a provider like `realEstateApiProvider = Provider((ref) => RealEstateApi(ref.watch(dioProvider)))`. Interceptors run in order:

1. **AuthInterceptor** — injects `Authorization: Bearer <token>`. Public endpoints (login/OTP/register/forgot) opt out via `Options(extra: {AuthInterceptor.skipAuthKey: true})`.
2. **EnvelopeInterceptor** — the backend wraps everything as `{status, message, data}`. On success it **replaces `response.data` with the inner `data`**, so API methods receive the unwrapped payload directly. `status == 0` becomes a typed `ApiException`. Opt out of unwrapping with `Options(extra: {'rawEnvelope': true})` when the real payload is in `message` (e.g. referral APIs).
3. **LoggingInterceptor**, then an error handler that bumps `sessionExpiredProvider` on 401 (only when a token existed) → `AuthController` force-logout → router redirects to `/login`.

The backend is a loosely-typed Web2py API: numbers arrive as int/double/string interchangeably, and some endpoints return JSON with a `text/html` content-type. **Always parse defensively** using helpers in `lib/core/utils/json_parse.dart` (`asInt`, `asDoubleOrNull`, etc.) rather than direct casts.

**API namespaces** (`AppConfig`, appended to `baseUrl`): `/api_agent`, `/api_customer`, `/api_common`, `/api`. The same logical feature may live under different namespaces (e.g. search uses `/api_customer`, my-listings uses `/api_agent`) — match v1 when unsure.

**Domain switching:** `baseUrl` is runtime-mutable via an in-app domain switcher (`domainProvider`). Changing it rebuilds `dioProvider`. The saved domain is restored in `AuthController.bootstrap()` **before** any API client is used.

### Routing & auth gating
`routerProvider` (`lib/core/router/app_router.dart`) holds all routes and a `redirect` that gates on `AuthState`:
- `AuthStatus.unknown` → hold on `/splash` until session resolves.
- Not logged in → `/onboarding` (first launch) or `/login`.
- Bottom-nav tabs (`/home`, `/search`, `/post`, `/notifications`, `/profile`) live in a `StatefulShellRoute.indexedStack` (`MainShell`). All other screens are pushed on `_rootKey` (full-screen, above the shell).

`AuthController` (`auth_controller.dart`) owns the session: token persistence via `TokenStorage` (secure storage), `bootstrap()` at startup, login/OTP/biometric flows, and force-logout on session-expiry signal. Use `currentUserProvider` to read the current `User`.

### Conventions
- New screen = add route in `app_router.dart` + screen widget under the feature's `presentation/`.
- New endpoint = method on the feature's `*Api` class using `AppConfig` namespace constants; return parsed models, never raw maps.
- Reuse shared UI from `lib/core/widgets/` (`AppButton`, `AppTextField`, `AppToast`, `AsyncView`, `StatusPill`, `AppNetworkImage`) and theme tokens from `lib/core/theme/` (`AppColors`, `AppSpacing`, `AppTypography`).
- Resolve relative image paths with `AppConfig.imageUrl(...)`.
- Keep files focused (~200 lines); split large screens into `presentation/widgets/`.

## Docs

`docs/SCREENS_FOR_TEST.md` is the canonical screen/route inventory (Vietnamese), mapping every screen to its route, entry point, and test focus — useful for locating features. `docs/TestPlan_TongkhoBDS_v2.xlsx` is the QA test plan.
