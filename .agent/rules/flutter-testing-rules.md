---
trigger: always_on
description: Flutter testing guidelines and best practices
---

# Flutter Testing Rules

## Overview

Three test types: **Unit** (logic), **Widget** (UI), **Integration** (flows).

## Test Organization

```
test/
├── unit/          # Controllers, services, models
├── widget/        # Pages, custom widgets
└── integration/   # End-to-end flows
```

## Unit Tests

Test business logic in isolation. Mock dependencies with `mocktail` or `mockito`.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late WeatherController controller;
  late MockApiService mockApi;

  setUp(() {
    mockApi = MockApiService();
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('WeatherController', () {
    test('should update weather on successful fetch', () async {
      when(() => mockApi.getWeather()).thenAnswer((_) async => mockData);
      controller = WeatherController(mockApi);
      await controller.fetchWeather();

      expect(controller.currentWeather, equals(mockData));
      expect(controller.isLoading, isFalse);
    });

    test('should set error on API failure', () async {
      when(() => mockApi.getWeather()).thenThrow(Exception('Network error'));
      controller = WeatherController(mockApi);
      await controller.fetchWeather();

      expect(controller.errorMessage, contains('Failed'));
    });
  });
}
```

### Key Points
- Test state changes, error handling, reactive variables (`Rx<T>`)
- Use `setUp()`/`tearDown()` for test lifecycle
- Use descriptive test names: `should return celsius when unit is celsius`
- Group related tests with `group()`

## Widget Tests

Test UI rendering and interactions with `testWidgets`.

```dart
void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(WeatherController());
  });

  tearDown(() {
    Get.reset();
  });

  group('DashboardPage', () {
    testWidgets('should show loading indicator', (tester) async {
      Get.find<WeatherController>().isLoading.value = true;
      await tester.pumpWidget(GetMaterialApp(home: DashboardPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should navigate on button tap', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: DashboardPage()));
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => Get.find<WeatherController>().refresh()).called(1);
    });
  });
}
```

### Key Points
- Use `pumpWidget()` to render
- Use `pumpAndSettle()` after async operations
- Use widget keys: `key: Key('refresh_button')` → `find.byKey(Key('refresh_button'))`
- Finders: `find.text()`, `find.byType()`, `find.byIcon()`

## Integration Tests

Test complete user flows on real devices/emulators. Place in `integration_test/`.

```dart
import 'package:integration_test/integration_test.dart';
import 'package:aero_sense/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding Flow', () {
    testWidgets('should complete onboarding', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Welcome to AeroSense'), findsOneWidget);
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
```

## Running Tests

```bash
# All tests
flutter test

# Specific file
flutter test test/unit/weather_controller_test.dart

# With coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Integration tests
flutter test integration_test/
```

## Best Practices

### AAA Pattern
```dart
test('should do something', () {
  // Arrange - Set up
  final controller = MyController();

  // Act - Execute
  controller.doSomething();

  // Assert - Verify
  expect(controller.value, equals(expected));
});
```

### Mocking
```dart
class MockService extends Mock implements ApiService {}
when(() => mock.getData()).thenAnswer((_) async => data);
```

### Reactive Variables
```dart
expect(controller.isLoading, isFalse);
controller.isLoading.value = true;
expect(controller.isLoading, isTrue);
```

### Async Tests
```dart
await expectLater(controller.fetchData(), completion(isNotNull));
```

## Coverage Targets

- Business Logic: >80%
- Models: 100%
- Widgets: >70%
- Integration: All critical flows

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Timeout | Add: `testWidgets('...', (tester) async {}, timeout: Timeout(Duration(minutes: 2)))` |
| Not updating | Use `await tester.pumpAndSettle()` after async ops |
| CI failures | Mock platform channels, avoid device-specific code |

## Packages

- `mocktail` - Mocking (no code generation)
- `integration_test` - Flutter integration tests
- `golden_toolkit` - Screenshot testing
- `patrol` - Advanced integration with native permissions
