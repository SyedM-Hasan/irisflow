import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/services/app_database.dart';
import '../models/analytics_state.dart';

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final AppDatabase _db;
  StreamSubscription<List<AppAnalytics>>? _sub;

  AnalyticsNotifier(this._db)
    : super(
        const AnalyticsState(
          selectedPeriod: 'Week',
          weeklyData: [],
          focusDistribution: [],
        ),
      ) {
    _listenToAnalytics();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _listenToAnalytics() {
    _sub?.cancel();

    final now = DateTime.now();
    DateTime start;
    if (state.selectedPeriod == 'Week') {
      start = now.subtract(Duration(days: now.weekday - 1));
      start = DateTime(start.year, start.month, start.day);
    } else if (state.selectedPeriod == 'Month') {
      start = DateTime(now.year, now.month, 1);
    } else {
      start = DateTime(now.year, 1, 1);
    }
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    _sub = _db.watchAnalyticsForPeriod(start, end).listen((entries) {
      _processEntries(entries, start, end);
    });
  }

  void _processEntries(List<AppAnalytics> entries, DateTime start, DateTime end) {
    // 1. Calculate Focus Distribution
    double totalHours = 0;
    final Map<String, double> categoryHours = {};
    for (var e in entries) {
      totalHours += e.hours;
      categoryHours[e.category] = (categoryHours[e.category] ?? 0) + e.hours;
    }

    final List<Map<String, dynamic>> distribution = [];
    
    // Define explicit tag to title mapping
    final Map<String, String> tagTitles = {
      'dev': 'Development',
      'design': 'Design Work',
      'email': 'Email & Admin',
      'general': 'General Focus',
    };

    // Define explicit tag to color mapping
    final Map<String, Color> tagColors = {
      'dev': AppColors.chartDev,
      'design': AppColors.chartDesign,
      'email': AppColors.chartEmail,
      'general': Colors.grey,
    };

    final fallbackColors = [
      AppColors.warning,
      Colors.blue,
      Colors.pink,
      Colors.purple,
    ];
    
    int colorIndex = 0;
    for (final entry in categoryHours.entries) {
      final tag = entry.key; // Initially saved as tag
      final h = entry.value;
      if (h <= 0) continue;
      
      final title = tagTitles[tag] ?? tag; // Fallback to raw tag if not mapped
      final color = tagColors[tag] ?? fallbackColors[colorIndex % fallbackColors.length];
      
      final int hrs = h.truncate();
      final int mins = ((h - hrs) * 60).round();
      final timeStr = hrs > 0 ? '${hrs}h ${mins}m' : '${mins}m';
      
      distribution.add({
        'label': title,
        'time': timeStr,
        'percent': totalHours > 0 ? h / totalHours : 0.0,
        'color': color,
      });
      
      if (!tagColors.containsKey(tag)) {
        colorIndex++;
      }
    }

    // Sort by most hours to least
    distribution.sort((a, b) => (b['percent'] as double).compareTo(a['percent'] as double));

    // 2. Calculate Chart Data
    List<Map<String, dynamic>> chartData = [];
    if (state.selectedPeriod == 'Week') {
      // 7 days of the week
      for (int i = 0; i < 7; i++) {
        final date = start.add(Duration(days: i));
        final dayStr = DateFormat('EEE').format(date);
        double dayHours = 0;
        for (var e in entries) {
          if (e.createdAt.year == date.year &&
              e.createdAt.month == date.month &&
              e.createdAt.day == date.day) {
            dayHours += e.hours;
          }
        }
        chartData.add({'day': dayStr, 'hours': dayHours, 'date': date});
      }
    } else if (state.selectedPeriod == 'Month') {
      // Group by weeks roughly
      int weekCount = 4; // Simplified monthly view
      for (int i = 0; i < weekCount; i++) {
        double wHours = 0;
        for (var e in entries) {
          final diff = e.createdAt.difference(start).inDays;
          if (diff >= i * 7 && diff < (i + 1) * 7) {
            wHours += e.hours;
          }
        }
        chartData.add({'day': 'W${i + 1}', 'hours': wHours});
      }
    } else {
      // Year view - 12 months
      for (int m = 1; m <= 12; m++) {
        double mHours = 0;
        for (var e in entries) {
          if (e.createdAt.month == m) {
            mHours += e.hours;
          }
        }
        final monthStr = DateFormat('MMM').format(DateTime(start.year, m, 1));
        chartData.add({'day': monthStr, 'hours': mHours});
      }
    }

    state = state.copyWith(
      weeklyData: chartData,
      focusDistribution: distribution,
    );
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
    if (state.selectedPeriod != period) {
      state = state.copyWith(selectedPeriod: period);
      _listenToAnalytics();
    }
  }

  /// Reset to initial state (factory reset)
  void factoryReset() {
    state = state.copyWith(selectedPeriod: 'Week');
    _listenToAnalytics();
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
