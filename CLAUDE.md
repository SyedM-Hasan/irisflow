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

**Feature structure** under `lib/features/`: `home/`, `modes/`, `analytics/`, `profile/`, `settings/`. Each feature follows the pattern:
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
- `routes/router.dart` — GoRouter with 5 routes: `/`, `/analytics`, `/modes`, `/profile`, `/settings`
- `theme/` — Three dark themes (Sage Green, Ocean Blue, Sunset) via `AppTheme.fromName()`; theme colors exposed as `AppThemeColors` ThemeExtension

**Main providers:**
- `databaseProvider` — AppDatabase singleton
- `homeProvider` — Timer + session state (StateNotifier)
- `settingsProvider`, `modesProvider`, `profileProvider`, `analyticsProvider`

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
