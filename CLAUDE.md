# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Development
flutter run                          # Run app

# Code quality
flutter analyze                      # Static analysis
dart format .                        # Format code
dart fix --apply                     # Auto-fix issues

# Testing
flutter test                         # All unit/widget tests
flutter test test/path/to_test.dart  # Single test file
flutter test --coverage              # With coverage report
flutter test integration_test/       # Integration tests

# Code generation (Drift ORM)
flutter pub run build_runner build   # Generate app_database.g.dart
flutter pub run build_runner watch   # Watch mode for codegen

# Build
flutter build ios
flutter build apk
flutter build macos
```

## Architecture

**Stack:** Flutter + Riverpod (state) + Drift/SQLite (database) + GoRouter (routing) + Material Design 3

**Feature structure** under `lib/features/`: `home/`, `modes/`, `analytics/`, `profile/`, `settings/`, `eye_strain/`. Each feature follows the pattern:
```
feature/
  models/        # State classes (immutable data)
  viewmodels/    # Riverpod StateNotifier subclasses
  views/         # ConsumerWidget screens
```

**Shared layer** under `lib/shared/`:
- `services/app_database.dart` — Drift schema (AppSettings, UserProfiles, FocusPresets, FocusStats, AnalyticsEntries). The generated file is `app_database.g.dart`.
- `services/migration_service.dart` — One-time migration from SharedPreferences → Drift (guarded by `drift_migrated_v1` flag)

**App-level** under `lib/app/`:
- `routes/router.dart` — GoRouter with 7 routes: `/`, `/analytics`, `/modes`, `/profile`, `/settings`, `/strain-analysis`, `/calibration`
- `theme/` — Three dark themes (Sage Green, Ocean Blue, Sunset) via `AppTheme.fromName()`; theme colors exposed as `AppThemeColors` ThemeExtension
- `shared/widgets/app_bottom_nav_bar.dart` — Bottom nav has a floating center button (eye icon) that navigates to `/strain-analysis`

**Main providers:**
- `databaseProvider` — AppDatabase singleton
- `homeProvider` — Timer + session state (StateNotifier)
- `settingsProvider`, `modesProvider`, `profileProvider`, `analyticsProvider`
- `eyeStrainProvider` — Eye strain monitoring state (NotifierProvider)

**Eye Strain feature notes:**
- Planned architecture (see `docs/eye_strain prediction.md`): hybrid edge-cloud using `google_mlkit_face_detection` (EAR metric) + Genkit/Gemini for AI recommendations. Camera + ML packages are **not yet added** to pubspec.
- `CalibrationScreen` currently uses **GetX** (`Get.find()`/`Get.put()`) — inconsistent with the rest of the app which uses Riverpod. Should be migrated.
- `EyeStrainState` is defined inside the viewmodel file rather than a separate `models/` file — should be moved per the standard feature structure.

**Data flow:** Widget action → StateNotifier method → Drift async DB operation → `ref.watch()` triggers rebuild

## Code Style

- 2-space indentation, 80-char line width
- PascalCase classes, snake_case filenames, camelCase variables
- Import order: dart → flutter → packages → project
- Files <300 lines, classes <200 lines, methods <50 lines
- Prefer `StatelessWidget` + `ConsumerWidget`; use `const` constructors where possible
- No hardcoded colors, strings, or dimensions — use theme/constants

## Testing Targets

- Business logic: >80% coverage
- Models: 100%
- Widgets: >70%
- Use AAA pattern (Arrange, Act, Assert); mock dependencies with mocktail
