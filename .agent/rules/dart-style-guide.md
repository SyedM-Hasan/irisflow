---
trigger: glob
description: Dart and Flutter code style guidelines
globs: *.dart
---

# Dart & Flutter Style Guidelines

## Dart Configuration
- **Dart SDK**: ^3.10.8 with null safety enabled
- **Linting**: Use `flutter_lints` package
- **Code Formatter**: Use `dart format` (built-in)
- **Strong Mode**: Enabled (null safety enforced)

## Formatting Rules (dart format)

Run `dart format .` to format all files. Default formatting rules:
- **Trailing commas**: Enabled
- **Line width**: 80 characters (Flutter standard)
- **Indentation**: 2 spaces (no tabs)

## Naming Conventions

Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) conventions:

### Classes, Enums, Typedefs, Extensions
- Use **PascalCase** (also called UpperCamelCase)
- Examples: `WeatherController`, `TemperatureUnit`, `UserProfile`, `StringExtension`

### Files and Directories
- Use **snake_case** for all file and directory names
- Examples: `weather_controller.dart`, `models/weather_response.dart`
- File names should match the primary class they contain (lowercase with underscores)

### Variables, Functions, Parameters, Constants
- Use **camelCase** (also called lowerCamelCase)
- Examples: `currentWeather`, `fetchWeather()`, `userName`, `maxRetries`

### Private Members
- Prefix with underscore `_`
- Examples: `_isLoading`, `_privateMethod()`, `_internalService`

### Constants
- Use `lowerCamelCase` for package-level constants
- Examples: `const defaultTimeout = 30`, `const apiBaseUrl = '...'`
- For enum-like constants, consider using an enum instead

### GetX-Specific Conventions
- **Controllers**: PascalCase with `Controller` suffix (e.g., `WeatherController`, `LocationController`)
- **Bindings**: PascalCase with `Binding` suffix (e.g., `WeatherBinding`, `LocationBinding`)
- **Pages**: PascalCase with `Page` suffix (e.g., `DashboardPage`, `OnboardingPage`)
- **Reactive variables**: Use `.obs` on Rx types (e.g., `final RxBool isLoading = RxBool(false)`)
- **Getters**: camelCase for computed properties (e.g., `get currentTemperature => ...`)

## Import Organization

Organize imports in the following order, with each group separated by a blank line:

```dart
// 1. Dart SDK imports
import 'dart:async';
import 'dart:io';

// 2. Flutter framework imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports (alphabetical)
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';

// 4. Project imports (relative, grouped by feature)
import '../models/weather_response.dart';
import '../services/weather_provider.dart';
import '../controllers/weather_controller.dart';
```

## Code Structure Conventions

### Controllers (GetX)
- Extend `GetxController`
- Use `onInit()` for initialization logic
- Use `onClose()` for cleanup (cancel timers, close streams)
- Keep controllers focused on one feature/area

```dart
class WeatherController extends GetxController {
  // Dependencies
  final WeatherProvider _weatherProvider = WeatherProvider();

  // Reactive state variables
  final Rx<WeatherResponse?> _currentWeather = Rx<WeatherResponse?>(null);
  final RxBool _isLoading = RxBool(false);
  final RxString _errorMessage = RxString('');

  // Getters for computed properties
  WeatherResponse? get currentWeather => _currentWeather.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    // Initialization logic
  }

  @override
  void onClose() {
    // Cleanup logic
    super.onClose();
  }
}
```

### Pages/Widgets
- Prefer `StatelessWidget` with `Obx`/`GetX` for reactive UI
- Use `const` constructors wherever possible
- Keep build methods under 200 lines
- Extract complex widgets into separate files

```dart
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Obx(() => _buildBody()),
    );
  }

  Widget _buildBody() {
    final controller = Get.find<WeatherController>();
    // ...
  }
}
```

### Services
- Use singleton pattern for services
- Async methods should return `Future<T>`
- Handle errors gracefully and return typed results

```dart
class WeatherProvider {
  // Singleton instance (optional, or use GetX dependency injection)
  static final WeatherProvider instance = WeatherProvider._internal();
  factory WeatherProvider() => instance;
  WeatherProvider._internal();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
    timeout: Duration(seconds: 30),
  ));

  Future<WeatherResponse> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get('/weather', queryParameters: {
        'lat': latitude,
        'lon': longitude,
      });
      return WeatherResponse.fromJson(response.data);
    } catch (e) {
      throw WeatherException('Failed to fetch weather: $e');
    }
  }
}
```

### Models
- Use `fromJson` and `toJson` for serialization
- Consider using `json_serializable` or `freezed` packages for code generation
- Keep models immutable where possible

```dart
class WeatherResponse {
  final double latitude;
  final double longitude;
  final CurrentWeather current;
  final List<DailyWeather> daily;

  WeatherResponse({
    required this.latitude,
    required this.longitude,
    required this.current,
    required this.daily,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      current: CurrentWeather.fromJson(json['current']),
      daily: (json['daily'] as List)
          .map((e) => DailyWeather.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'current': current.toJson(),
      'daily': daily.map((e) => e.toJson()).toList(),
    };
  }
}
```

## Error Handling

- Use try-catch blocks with proper error messages
- Provide user-friendly error messages in the UI
- Use `debugPrint()` for logging (not `print()` or `console.log()`)
- Consider using a logging package like `logger` for better debugging

```dart
Future<void> fetchData() async {
  try {
    _isLoading.value = true;
    final result = await _service.getData();
    _data.value = result;
  } catch (e) {
    _errorMessage.value = 'Failed to load data: ${e.toString()}';
    debugPrint('Error fetching data: $e');
  } finally {
    _isLoading.value = false;
  }
}
```

## Documentation

- Use Dart doc comments (`///`) for public APIs
- Document complex business logic
- Comment non-obvious code
- Document parameters and return values for public methods

```dart
/// Fetches the current weather data for the specified coordinates.
///
/// Throws a [WeatherException] if the API request fails.
/// Returns [WeatherResponse] containing current and forecast data.
Future<WeatherResponse> getCurrentWeather({
  required double latitude,
  required double longitude,
}) async {
  // ...
}
```

## Code Quality

### Type Safety
- **Enable strong mode** (null safety) - already enabled in Dart 2.12+
- **Avoid `dynamic` types** when possible - use specific types or `Object?`
- **Use `?` for nullable types** explicitly
- **Prefer `final` over `var`** when the variable doesn't need to be reassigned

### Performance
- **Use `const` constructors** to reduce widget rebuilds
- **Use `ListView.builder`** instead of `ListView` for long lists
- **Avoid excessive rebuilds** by wrapping only the specific subtree in `Obx`
- **Implement lazy loading** for images and lists

### Code Organization
- **Keep files under 300 lines** - split into multiple files if needed
- **Keep classes under 200 lines** - extract smaller classes if needed
- **Keep methods under 50 lines** - extract helper methods if needed
- **Use barrel files** (`index.dart`) to clean up imports

```dart
// lib/core/index.dart
export 'controllers/index.dart';
export 'models/index.dart';
export 'services/index.dart';
export 'themes/app_theme.dart';
```

## Linting Rules

The project uses `flutter_lints`. Additional rules can be configured in `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Consider enabling additional rules:
    - prefer_single_quotes
    - avoid_print
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - prefer_final_fields
    - unnecessary_const
    - unnecessary_new
```

## Common Patterns to Avoid

### ❌ Bad Practices
```dart
// Using setState with GetX
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

// Creating controllers in build methods
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeatherController()); // BAD!
    return ...
  }
}

// Using print() instead of debugPrint()
print('Debug message'); // BAD!

// Hardcoded strings and colors
Text('Hello', style: TextStyle(color: Color(0xFF4A90E2))); // BAD!
```

### ✅ Good Practices
```dart
// Using StatelessWidget with Obx
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.value));
  }
}

// Creating controllers in bindings or onInit
class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeatherController());
  }
}

// Using debugPrint()
debugPrint('Debug message'); // GOOD!

// Using theme and constants
Text(
  AppStrings.hello,
  style: AppTextStyles.body.copyWith(color: AppColors.primary),
); // GOOD!
```
