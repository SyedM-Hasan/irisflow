import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/app_database.dart';
import '../../modes/viewmodels/modes_viewmodel.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum TimerState { idle, running, paused }

class HomeState {
  final int seconds;
  final TimerState timerState;
  final int selectedPresetIndex;
  final double focusHours;
  final int sessionsCompleted;
  final int streakDays;

  const HomeState({
    required this.seconds,
    required this.timerState,
    required this.selectedPresetIndex,
    required this.focusHours,
    required this.sessionsCompleted,
    required this.streakDays,
  });

  HomeState copyWith({
    int? seconds,
    TimerState? timerState,
    int? selectedPresetIndex,
    double? focusHours,
    int? sessionsCompleted,
    int? streakDays,
  }) {
    return HomeState(
      seconds: seconds ?? this.seconds,
      timerState: timerState ?? this.timerState,
      selectedPresetIndex: selectedPresetIndex ?? this.selectedPresetIndex,
      focusHours: focusHours ?? this.focusHours,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class HomeNotifier extends StateNotifier<HomeState> {
  final AppDatabase _db;
  final Ref _ref;
  Timer? _timer;

  HomeNotifier(this._db, this._ref)
    : super(
        const HomeState(
          seconds: 25 * 60,
          timerState: TimerState.idle,
          selectedPresetIndex: 0,
          focusHours: 0.0,
          sessionsCompleted: 0,
          streakDays: 0,
        ),
      ) {
    _listenToStats();
    _syncWithPreset(0);
  }

  void _listenToStats() {
    _db.watchStats().listen((stats) {
      state = state.copyWith(
        focusHours: stats.totalFocusHours,
        sessionsCompleted: stats.sessionsCompleted,
        streakDays: stats.streakDays,
      );
    });
  }

  void _syncWithPreset(int index) {
    final modes = _ref.read(modesProvider);
    if (index >= 0 && index < modes.presets.length) {
      final preset = modes.presets[index];
      state = state.copyWith(
        selectedPresetIndex: index,
        seconds: preset.focusMin * 60,
      );
    }
  }

  // ---- Timer display helpers ------------------------------------------------

  String get timeDisplay {
    final m = (state.seconds ~/ 60).toString().padLeft(2, '0');
    final s = (state.seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get progress {
    final modes = _ref.read(modesProvider);
    if (state.selectedPresetIndex < 0 ||
        state.selectedPresetIndex >= modes.presets.length) {
      return 0;
    }
    final total = modes.presets[state.selectedPresetIndex].focusMin * 60;
    return total == 0 ? 0 : 1 - (state.seconds / total);
  }

  // ---- Actions -------------------------------------------------------------

  void selectPreset(int index) {
    stopTimer();
    _syncWithPreset(index);
  }

  void startTimer() {
    state = state.copyWith(timerState: TimerState.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (state.seconds > 0) {
        state = state.copyWith(seconds: state.seconds - 1);
      } else {
        _timer?.cancel();

        // Finalize session
        final modes = _ref.read(modesProvider);
        final focusMin = modes.presets[state.selectedPresetIndex].focusMin;
        final additionalHours = focusMin / 60.0;

        final currentStats = await _db.getStats();
        await _db.updateStats(
          FocusStatsCompanion(
            sessionsCompleted: Value(currentStats.sessionsCompleted + 1),
            totalFocusHours: Value(
              currentStats.totalFocusHours + additionalHours,
            ),
          ),
        );

        // Add to analytics
        await _db.addAnalyticsEntry(
          AnalyticsEntriesCompanion.insert(
            day: _getTodayName(),
            hours: additionalHours,
          ),
        );

        state = state.copyWith(timerState: TimerState.idle);
        _syncWithPreset(state.selectedPresetIndex);
      }
    });
  }

  String _getTodayName() {
    final now = DateTime.now();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[now.weekday - 1];
  }

  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(timerState: TimerState.paused);
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(timerState: TimerState.idle);
    _syncWithPreset(state.selectedPresetIndex);
  }

  void toggleTimer() {
    if (state.timerState == TimerState.running) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  /// Reset to initial state (factory reset)
  void factoryReset() {
    _timer?.cancel();
    _syncWithPreset(0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final db = ref.watch(databaseProvider);
  final notifier = HomeNotifier(db, ref);
  ref.keepAlive();
  return notifier;
});
