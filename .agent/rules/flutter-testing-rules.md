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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late ProviderContainer container;
  late MockApiService mockApi;

  setUp(() {
    mockApi = MockApiService();
    container = ProviderContainer(
      overrides: [
        apiServiceProvider.overrideWithValue(mockApi),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('WeatherProvider', () {
    test('should update weather on successful fetch', () async {
      when(() => mockApi.getWeather()).thenAnswer((_) async => mockData);
      
      final controller = container.read(weatherProvider.notifier);
      await controller.fetchWeather();

      expect(container.read(weatherProvider).currentWeather, equals(mockData));
      expect(container.read(weatherProvider).isLoading, isFalse);
    });

    test('should set error on API failure', () async {
      when(() => mockApi.getWeather()).thenThrow(Exception('Network error'));
      
      final controller = container.read(weatherProvider.notifier);
      await controller.fetchWeather();

      expect(container.read(weatherProvider).errorMessage, contains('Failed'));
    });
  });
}
```

### Key Points
- Test state changes, error handling, provider state
- Use `setUp()`/`tearDown()` for test lifecycle
- Use descriptive test names: `should return celsius when unit is celsius`
- Group related tests with `group()`

## Widget Tests

Test UI rendering and interactions with `testWidgets`.

```dart
void main() {
  group('DashboardPage', () {
    testWidgets('should show loading indicator', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherProvider.overrideWith((ref) => WeatherState(isLoading: true)),
          ],
          child: MaterialApp(home: DashboardPage()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should refresh on button tap', (tester) async {
      final mockNotifier = MockWeatherNotifier();
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherProvider.notifier.overrideWithValue(mockNotifier),
          ],
          child: MaterialApp(home: DashboardPage()),
        ),
      );
      
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => mockNotifier.refresh()).called(1);
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

### Provider State
```dart
expect(container.read(provider).isLoading, isFalse);
container.read(provider.notifier).setLoading(true);
expect(container.read(provider).isLoading, isTrue);
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
