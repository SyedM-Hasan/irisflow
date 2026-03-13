import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/router.dart';
import 'app/theme/app_theme.dart';
import 'features/profile/viewmodels/profile_viewmodel.dart';
import 'features/settings/viewmodels/settings_viewmodel.dart';
import 'shared/services/app_database.dart';
import 'shared/services/migration_service.dart';
import 'shared/services/notification_service.dart';

Future<void> main() async {
  // Required for plugin initialization if main is async
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences (for migration check)
  final sharedPrefs = await SharedPreferences.getInstance();

  // Initialize Drift Database
  final database = AppDatabase();

  // Run migration if needed
  await MigrationService.migrateIfNeeded(sharedPrefs, database);

  // Initialize notifications
  await NotificationService.instance.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Provide the instances to the Riverpod graph
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        databaseProvider.overrideWithValue(database),
      ],
      child: const IrisFlowApp(),
    ),
  );
}

class IrisFlowApp extends ConsumerWidget {
  const IrisFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // Watch only the theme name to avoid unnecessary rebuilds.
    final themeName = ref.watch(
      settingsProvider.select((s) => s.selectedTheme),
    );

    return MaterialApp.router(
      title: 'IrisFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fromName(themeName),
      themeAnimationDuration: const Duration(milliseconds: 500),
      themeAnimationCurve: Curves.easeInOut,
      routerConfig: router,
    );
  }
}
