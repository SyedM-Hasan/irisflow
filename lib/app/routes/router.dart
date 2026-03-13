import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/views/analytics_screen.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/modes/views/modes_screen.dart';
import '../../features/profile/views/profile_screen.dart';
import '../../features/settings/views/settings_screen.dart';
import '../../features/eye_strain/views/strain_analysis_screen.dart';
import '../../features/eye_strain/views/calibration_screen.dart';
import 'app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.analytics,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AnalyticsScreen()),
      ),
      GoRoute(
        path: AppRoutes.modes,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ModesScreen()),
      ),
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.strainAnalysis,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: StrainAnalysisScreen()),
      ),
      GoRoute(
        path: AppRoutes.calibration,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CalibrationScreen()),
      ),
    ],
  );
});
