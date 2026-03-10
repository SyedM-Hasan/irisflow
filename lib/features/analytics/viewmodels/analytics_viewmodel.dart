import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/app_database.dart';
import '../models/analytics_state.dart';

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final AppDatabase _db;

  AnalyticsNotifier(this._db)
    : super(
        const AnalyticsState(
          selectedPeriod: 'Week',
          weeklyData: [],
          focusDistribution: [
            {
              'label': 'Development',
              'time': '2h 45m today',
              'percent': 0.6,
              'colorKey': 'dev',
            },
            {
              'label': 'Design Work',
              'time': '1h 12m today',
              'percent': 0.25,
              'colorKey': 'design',
            },
            {
              'label': 'Email & Admin',
              'time': '15m today',
              'percent': 0.10,
              'colorKey': 'email',
            },
            {
              'label': 'Meetings',
              'time': '30m today',
              'percent': 0.05,
              'colorKey': 'meeting',
            },
          ],
        ),
      ) {
    _listenToAnalytics();
  }

  void _listenToAnalytics() {
    _db.watchRecentAnalytics().listen((entries) {
      final uiData = entries
          .map((e) => {'day': e.day, 'hours': e.hours})
          .toList();
      state = state.copyWith(weeklyData: uiData);
    });
  }

  static const List<String> periods = ['Week', 'Month', 'Year'];

  double get totalHoursThisWeek => state.weeklyData.fold(
    0.0,
    (sum, d) => sum + (d['hours'] as num).toDouble(),
  );
  double get dailyAverage =>
      totalHoursThisWeek /
      (state.weeklyData.isEmpty ? 1 : state.weeklyData.length);

  void selectPeriod(String period) {
    state = state.copyWith(selectedPeriod: period);
  }

  /// Reset to initial state (factory reset)
  void factoryReset() {
    // DB watch will handle reloading defaults after factory reset
    state = state.copyWith(selectedPeriod: 'Week');
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
      final db = ref.watch(databaseProvider);
      return AnalyticsNotifier(db);
    });
