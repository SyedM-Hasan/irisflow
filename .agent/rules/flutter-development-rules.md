---
trigger: always_on
---

# Flutter Development Rules

## General Rules

We use **GetX** for state management, routing, and dependency injection. Follow GetX official patterns. All widgets, utility classes, and helper functions must be reusable.

### No Hardcoding Policy

Nothing in pages/widgets should be hardcoded:
- **Strings**: Constants or `l10n.dart`
- **Colors**: `Theme.of(context).colorScheme.*`
- **Dimensions**: Named constants
- **Style**: Never hardcode colors like `"#4A90E2"`

> **Layout Primitives Exemption**: `Container`, `Padding`, `Row`, `Column`, `Stack`, `ListView` etc. can be used directly. Functional components (`Text`, `Button`, `Card`) must use theming.

## GetX Usage

### Controllers
- One controller per page
- Use `Get.lazyPut()` in Bindings (preferred), `Get.put()` for immediate init
- Retrieve with `Get.find()`
- Never create controllers inside `build()` methods

### Reactive Variables
```dart
final RxBool isLoading = RxBool(false);
final RxList<Data> items = <Data>[].obs;

// Workers
ever(data, (_) => saveData());
debounce(search, (_) => searchAPI(), time: Duration(seconds: 1));
```

Use `Obx()` for fine-grained updates, `GetX<Controller>` when controller instance needed.

### Bindings
```dart
class WeatherBinding extends Bindings {
  void dependencies() {
    Get.lazyPut(() => WeatherController());
  }
}
```

### Navigation
```dart
Get.toNamed('/dashboard');
Get.toNamed('/weather', arguments: {'city': 'NY'});
Get.offNamed('/home');  // Replace current
Get.offAllNamed('/login');  // Replace all
final args = Get.arguments as Map;
```

## UI Layer

### Widgets
- Prefer `StatelessWidget` with `Obx()`
- Use `const` constructors wherever possible
- Avoid `StatefulWidget` unless managing lifecycle (animations, etc.)

```dart
class DashboardPage extends StatelessWidget {
  Widget build(BuildContext) => Scaffold(
    body: Obx(() => controller.isLoading
      ? CircularProgressIndicator()
      : WeatherWidget()),
  );
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

### Separation of Concerns
- **Controllers**: Business logic, state, API calls
- **Widgets**: UI rendering, user interactions
- **Services**: Data persistence, API, platform channels
- **Models**: Data structures with serialization

### Data Flow
User action → Controller method → State update → `Obx()` rebuild

### Single Source of Truth
Reactive variables in controllers are the source of truth. Don't duplicate state. Don't mix `setState()` with GetX.

## Performance

### Rebuilds
- Use `const` constructors
- Scope `Obx()` to specific widgets that need updates
- Use `ListView.builder` for long lists

```dart
// Bad - entire page rebuilds
Obx(() => Scaffold(body: Column(children: [Header(), Text(value), Footer()])))

// Good - only Text rebuilds
Column(children: [Header(), Obx(() => Text(value)), Footer()])
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

- `get` - State management (in use)
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
