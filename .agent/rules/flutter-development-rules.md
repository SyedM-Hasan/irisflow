---
trigger: always_on
---

# Flutter Development Rules

## General Rules

We use **Riverpod** for state management and dependency injection, and **GoRouter** for routing. Follow Riverpod official patterns. All widgets, utility classes, and helper functions must be reusable.

### No Hardcoding Policy

Nothing in pages/widgets should be hardcoded:
- **Strings**: Constants or `l10n.dart`
- **Colors**: `Theme.of(context).colorScheme.*`
- **Dimensions**: Named constants
- **Style**: Never hardcode colors like `"#4A90E2"`

> **Layout Primitives Exemption**: `Container`, `Padding`, `Row`, `Column`, `Stack`, `ListView` etc. can be used directly. Functional components (`Text`, `Button`, `Card`) must use theming.

## Riverpod & GoRouter Usage

### Providers
- Use `StateNotifierProvider` or `NotifierProvider` for complex state.
- Use `FutureProvider` for asynchronous operations.
- Use `Provider` for basic dependencies.
- Pass `ref` to access other providers.
- Maintain providers in the `viewmodels/` directory for each feature.

### Reactive Variables
```dart
final countProvider = StateProvider<int>((ref) => 0);
final asyncDataProvider = FutureProvider<Data>((ref) async {
  return ref.watch(apiServiceProvider).fetchData();
});
```

Use `ref.watch()` for rebuilding on changes, `ref.read()` for one-time reads (e.g., in callbacks).

### Routing
```dart
context.go('/dashboard');
context.push('/weather', extra: {'city': 'NY'});
context.pushReplacement('/home');  // Replace current
```

## UI Layer

### Widgets
- Keep screens in `features/<feature_name>/views/`
- Prefer `ConsumerWidget` with `ref.watch()` for reactive UI
- Use `const` constructors wherever possible
- Avoid `StatefulWidget` unless managing lifecycle (animations, etc.). If needed, use `ConsumerStatefulWidget`.

```dart
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    return Scaffold(
      body: isLoading
        ? const CircularProgressIndicator()
        : const WeatherWidget(),
    );
  }
}
```

### Material Design 3
```dart
Theme.of(context).colorScheme.primary
Theme.of(context).textTheme.bodyLarge
```

### Platform Considerations
- Test on both iOS and Android
- Use conditional imports: `import 'dart:io' show Platform;`
- Use `SafeArea` for notched devices

### Responsive
```dart
MediaQuery.of(context).size.width
LayoutBuilder(builder: (context, constraints) => constraints.maxWidth > 600 ? Tablet() : Mobile())
```

## State Management

### Architecture and Separation of Concerns
Following the feature-driven architecture logic:
- **`models/`**: State classes, immutable data, data structures with serialization.
- **`viewmodels/`**: Riverpod `StateNotifier` or `Notifier` subclasses handling business logic, state mutation, and interactions.
- **`views/`**: `ConsumerWidget` screens focused solely on UI rendering.
- **`shared/services/`**: Data persistence (e.g., Drift), API calls, platform channels.

### Data Flow
User action → Provider method → State update → `ref.watch()` rebuild

### Single Source of Truth
Providers are the source of truth. Don't duplicate state. Don't mix local `setState()` state with Riverpod global state. Data flows from Drift/SQLite to Providers to Widgets.

## Performance

### Rebuilds
- Use `const` constructors
- Scope `ref.watch()` to specific widgets that need updates, or use `ref.select()` to filter rebuilds.
- Use `ListView.builder` for long lists

```dart
// Bad - entire page rebuilds when any part of state changes
final state = ref.watch(complexProvider);

// Good - only rebuilds when specific property changes
final value = ref.watch(complexProvider.select((s) => s.specificValue));
```

### Memory
- Dispose resources in `onClose()` (streams, timers)
- Cancel network requests on disposal

## Permissions

```dart
final status = await Permission.location.request();
if (status.isPermanentlyDenied) await openAppSettings();
```

Add to AndroidManifest.xml (Android) and Info.plist (iOS) with usage descriptions.

## Cleanup

Always run `dart analyze` and remove unused imports/variables.

```bash
dart analyze
dart format .
dart fix --apply
```

## Error Handling

```dart
try {
  await service.getData();
} catch (e) {
  debugPrint('Error: $e');
  errorMessage.value = 'User-friendly message';
}
```

Use `SnackBar` or `AlertDialog` for user-facing errors.

## Platform Files

**Android**: `AndroidManifest.xml`, `build.gradle`
**iOS**: `Info.plist`, `Podfile` (run `pod install` after deps)

## Common Packages

- `flutter_riverpod` - State management (in use)
- `go_router` - Routing
- `dio` - HTTP client (in use)
- `connectivity_plus` - Network checks
- `get_storage` - Key-value storage (in use)
- `flutter_svg` - SVG rendering
- `cached_network_image` - Image caching
- `logger` - Better logging
- `url_launcher` - Open URLs/make calls
- `ffmpeg_kit_flutter_new` - Image processing and conversion

## Asset Management

### Icons & Images
- **Directory**: If `assets/` or its subfolders (`icons`, `images`) are missing, create them. Always use existing ones if available.
- **Format**: Prefer **SVG** for icons/illustrations. Use **PNG** for complex imagery.
- **Naming**: Use `snake_case` with prefixes: `ic_` for icons, `img_` for images.
- **Handling**: Use format-agnostic widgets (e.g., `CommonIcon`) to handle `.svg` and `.png` dynamically.
- **Theming**: Always apply colors via `colorFilter` (SVG) or `color` (PNG/Icon) using `Theme.of(context).colorScheme`.

### Conversion
- For dev-time conversion, use `ffmpeg` if available or the `ffmpeg_kit_flutter_new` package.
- Avoid large conversion packages in production unless necessary for features.

## Repository Pattern

```dart
class WeatherRepository {
  final ApiService _api = ApiService();
  final LocalStorage _storage = LocalStorage();

  Future<Weather> getWeather(String city) async {
    final cached = await _storage.getWeather(city);
    if (cached != null && !cached.isExpired) return cached;
    final weather = await _api.fetchWeather(city);
    await _storage.saveWeather(city, weather);
    return weather;
  }
}
```
