import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/router.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/app_theme_colors.dart';
import 'features/eye_strain/viewmodels/eye_strain_viewmodel.dart';
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

    // Sync device system bars (status bar + nav bar) to the active theme.
    final theme = AppTheme.fromName(themeName);
    final colors = theme.extension<AppThemeColors>()!;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // iOS
        systemNavigationBarColor: colors.navBackground,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: colors.navBorder,
      ),
    );

    // Eye-protection adaptive UI — applied globally so the warmth/dimming
    // effect covers the entire app, not just the eye strain screen.
    final warmth = ref.watch(
      eyeStrainProvider.select((s) => s.warmthFilterIntensity),
    );
    final brightness = ref.watch(
      eyeStrainProvider.select((s) => s.brightnessOverlayOpacity),
    );
    final textScale = ref.watch(
      eyeStrainProvider.select((s) => s.textScaleMultiplier),
    );

    return MaterialApp.router(
      title: 'IrisFlow',
      debugShowCheckedModeBanner: false,
      theme: theme,
      themeAnimationDuration: const Duration(milliseconds: 500),
      themeAnimationCurve: Curves.easeInOut,
      routerConfig: router,
      builder: (context, child) => _EyeProtectionWrapper(
        warmth: warmth,
        brightness: brightness,
        textScale: textScale,
        child: child!,
      ),
    );
  }
}

/// Applies eye-protection overlays (warmth tint, brightness dim, text scale)
/// app-wide based on the current [EyeStrainState]. When all values are at
/// their defaults (warmth=0, brightness=0, textScale=1) this is a zero-cost
/// pass-through.
class _EyeProtectionWrapper extends StatelessWidget {
  final double warmth;
  final double brightness;
  final double textScale;
  final Widget child;

  const _EyeProtectionWrapper({
    required this.warmth,
    required this.brightness,
    required this.textScale,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    // Stack a semi-transparent black layer for dimming.
    if (brightness > 0) {
      result = Stack(
        children: [
          result,
          IgnorePointer(
            child: Container(
              color: Colors.black.withValues(alpha: brightness),
            ),
          ),
        ],
      );
    }

    // Apply a warm color tint to reduce blue-light exposure.
    if (warmth > 0) {
      result = ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.orange.withValues(alpha: warmth),
          BlendMode.darken,
        ),
        child: result,
      );
    }

    // Scale up text when strain is high to reduce reading effort.
    if (textScale != 1.0) {
      result = MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
        ),
        child: result,
      );
    }

    return result;
  }
}
