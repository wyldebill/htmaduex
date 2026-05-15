# Mapme Architecture Overview

## App summary

Mapme is a Flutter mobile/web app focused on nearby-place discovery. It currently uses a screen-driven UI architecture with local in-memory data, route-based navigation, and a shared theme system. The user journey is:

1. Login
2. Onboarding wizard
3. Explore nearby places on a map or list
4. Open a place detail page

## High-level architecture

### Entry point and routing

- `lib/main.dart` initializes `MaterialApp.router` and a `GoRouter`.
- Routes:
  - `/login` → `LoginScreen`
  - `/onboarding` → `WizardScreen`
  - `/wizard` → redirect to `/onboarding` (compatibility alias)
  - `/map` → `MapScreen`
  - `/list` → `ListScreen`
  - `/business/:id` → `DetailScreen(businessId: id)`

### UI and styling system

- `lib/theme/app_theme.dart` is the central style contract:
  - `AppColors` for palette and semantic colors
  - `appTheme` for Material 3 component theming and typography
  - spacing/shadow tokens (`AppSpacing`, `AppShadows`) for consistent layout/elevation
- Screens use this theme directly instead of per-screen style systems.

### Screen-first state model

- Each screen owns its own state (`StatefulWidget`) and handles interactions locally.
- There is no repository/service/state-management layer yet.
- Demo/business data is currently embedded in screen files (`MapScreen`, `ListScreen`), and detail content is largely static UI with `businessId` as route context.

## Data flow

### Navigation-driven flow

The primary flow is route-driven:

- `LoginScreen` calls `context.go('/onboarding')`
- `WizardScreen` calls `context.go('/map')` when skipping/completing onboarding
- `MapScreen` and `ListScreen` switch tabs with `context.go('/map')` and `context.go('/list')`
- Place drill-down uses `context.push('/business/$id')`
- `DetailScreen` receives `businessId` from the path parameter parser in `main.dart`

### View-state flow inside screens

- Search/filter/sort state is local to each screen (`_category`, `_sort`, `_searchController`, `_selectedId`, `_saved`).
- Derived lists (for map/list filtering) are computed in `build()` from local state and static item collections.
- Saved/bookmark state is local per screen and not synchronized across screens yet.

### Platform/build-time secret flow (Google Maps API key)

- Source of truth is local `.env` with platform-specific keys for development:
  - `GOOGLE_MAPS_API_KEY_ANDROID=...`
  - `GOOGLE_MAPS_API_KEY_IOS=...`
- Android:
  - `android/app/build.gradle.kts` reads `.env` / environment / Gradle property
  - injects `manifestPlaceholders["GOOGLE_MAPS_API_KEY_ANDROID"]`
  - key is consumed in `AndroidManifest.xml`
- iOS:
  - `tool/sync_secrets.ps1` or `tool/sync_secrets.sh` generates `ios/Flutter/Secrets.xcconfig`
  - `Debug.xcconfig` and `Release.xcconfig` include this file
  - key is consumed via `Info.plist` (`$(GOOGLE_MAPS_API_KEY_IOS)`)

This keeps API keys out of committed constants and source code.

## Screen contracts (inputs, responsibilities, outputs)

### `LoginScreen`

- **Inputs:** none
- **Handles:** credential field input, sign-in/sign-up mode toggle, social login button taps
- **Outputs:** navigates to onboarding (`/onboarding`)

### `WizardScreen`

- **Inputs:** none
- **Handles:** page-step progression through onboarding slides
- **Outputs:** navigates to map (`/map`) on skip or completion

### `MapScreen`

- **Inputs:** none
- **Handles:**
  - category filter (`All`, `Cafes`, `Food`, etc.)
  - selected map marker/place card
  - local saved/favorite toggles
  - map/list navigation
- **Outputs:**
  - route to list (`/list`)
  - route to place detail (`/business/:id`)
- **Platform behavior:** renders `GoogleMap` only on web/Android/iOS; shows fallback panel on unsupported platforms

### `ListScreen`

- **Inputs:** none
- **Handles:**
  - search text filtering by name/tags
  - category filter and sort selection
  - local saved toggles
  - map/list navigation
- **Outputs:** route to detail (`/business/:id`) on card tap

### `DetailScreen`

- **Inputs:** `businessId` (parsed from route param)
- **Handles:** detail presentation, local bookmark toggle, back navigation fallback (`pop` or `/list`)
- **Outputs:** currently UI actions only (book/call/share/directions handlers are placeholders)

## Complex areas and implementation nuances

### 1. Map support gating by platform

`MapScreen` checks runtime platform support (`kIsWeb`, Android, iOS) before creating `GoogleMap`. This avoids unsupported-platform runtime failures and provides a fallback experience.

### 2. Route compatibility alias

`/wizard` redirects to `/onboarding`. This is a subtle compatibility path that can prevent stale links/navigation code from breaking.

### 3. Native key injection pipeline

Google Maps keys are injected at build time differently per platform (Gradle placeholders vs xcconfig include), with helper scripts and CI integration. This is the most operationally sensitive part of the app setup.

### 4. In-memory, duplicated business datasets

`MapScreen` and `ListScreen` each define local `_items`. This is simple for prototyping, but it can diverge over time because there is no shared domain model/source yet.

### 5. Navigation regression testing pattern

`test/explore_navigation_test.dart` uses a small in-test router and captures `FlutterError.onError` to detect layout assertions during route transitions. This is more robust than checking for a widget alone when UI overflow/layout regressions are possible.

## Current architectural boundaries

- Present:
  - Router-based app shell
  - Shared theme tokens
  - Screen-local interaction state
  - Widget-level tests
- Not present yet:
  - Remote API/data layer
  - Persistent local storage
  - centralized state management
  - shared domain models for places across screens
