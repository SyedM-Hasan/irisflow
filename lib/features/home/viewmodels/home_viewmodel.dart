import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/app_database.dart';
import '../../../shared/services/notification_service.dart';
import '../../modes/viewmodels/modes_viewmodel.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum TimerState { idle, running, paused }

enum TimerPhase { focus, ready, rest }

class HomeState {
  final int seconds;
  final int readyTotalSeconds; // used for progress during ready phase
  final TimerState timerState;
  final TimerPhase timerPhase;
  final bool isAutoMode;
  final int selectedPresetIndex;
  final double focusHours;
  final int sessionsCompleted;
  final int streakDays;

  const HomeState({
    required this.seconds,
    required this.readyTotalSeconds,
    required this.timerState,
    required this.timerPhase,
    required this.isAutoMode,
    required this.selectedPresetIndex,
    required this.focusHours,
    required this.sessionsCompleted,
    required this.streakDays,
  });

  HomeState copyWith({
    int? seconds,
    int? readyTotalSeconds,
    TimerState? timerState,
    TimerPhase? timerPhase,
    bool? isAutoMode,
    int? selectedPresetIndex,
    double? focusHours,
    int? sessionsCompleted,
    int? streakDays,
  }) {
    return HomeState(
      seconds: seconds ?? this.seconds,
      readyTotalSeconds: readyTotalSeconds ?? this.readyTotalSeconds,
      timerState: timerState ?? this.timerState,
      timerPhase: timerPhase ?? this.timerPhase,
      isAutoMode: isAutoMode ?? this.isAutoMode,
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
  // Tracks which phase follows the current ready countdown
  TimerPhase _nextPhaseAfterReady = TimerPhase.rest;

  HomeNotifier(this._db, this._ref)
    : super(
        const HomeState(
          seconds: 25 * 60,
          readyTotalSeconds: 0,
          timerState: TimerState.idle,
          timerPhase: TimerPhase.focus,
          isAutoMode: false,
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
        timerPhase: TimerPhase.focus,
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
    if (state.timerPhase == TimerPhase.ready) {
      final total = state.readyTotalSeconds;
      return total == 0 ? 0 : 1 - (state.seconds / total);
    }
    final modes = _ref.read(modesProvider);
    if (state.selectedPresetIndex < 0 ||
        state.selectedPresetIndex >= modes.presets.length) {
      return 0;
    }
    final preset = modes.presets[state.selectedPresetIndex];
    final total = state.timerPhase == TimerPhase.focus
        ? preset.focusMin * 60
        : preset.breakMin * 60;
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
        switch (state.timerPhase) {
          case TimerPhase.focus:
            await _onFocusComplete();
          case TimerPhase.ready:
            await _onReadyComplete();
          case TimerPhase.rest:
            await _onRestComplete();
        }
      }
    });
  }

  Future<void> _onFocusComplete() async {
    final modes = _ref.read(modesProvider);
    final preset = modes.presets[state.selectedPresetIndex];
    final additionalHours = preset.focusMin / 60.0;

    // Persist stats
    final currentStats = await _db.getStats();
    await _db.updateStats(
      FocusStatsCompanion(
        sessionsCompleted: Value(currentStats.sessionsCompleted + 1),
        totalFocusHours: Value(
          currentStats.totalFocusHours + additionalHours,
        ),
      ),
    );

    // Update eye health score
    final currentProfile = await _db.getProfile();
    final newScore = (currentProfile.eyeHealthScore + 1).clamp(0, 100);
    await _db.updateProfile(
      UserProfilesCompanion(eyeHealthScore: Value(newScore)),
    );
    await _db.addAnalyticsEntry(
      AnalyticsEntriesCompanion.insert(
        day: _getTodayName(),
        hours: additionalHours,
        category: Value(preset.tag),
        createdAt: Value(DateTime.now()),
      ),
    );

    await NotificationService.instance.showFocusComplete();

    if (!state.isAutoMode) {
      state = state.copyWith(
        timerState: TimerState.idle,
        timerPhase: TimerPhase.focus,
        seconds: preset.focusMin * 60,
      );
      return;
    }

    // Auto mode: ready countdown before rest (if enabled), else go straight to rest
    final settings = await _db.getSettings();
    if (settings.readyTimerEnabled) {
      _nextPhaseAfterReady = TimerPhase.rest;
      final readySecs = settings.readyDuration;
      state = state.copyWith(
        seconds: readySecs,
        readyTotalSeconds: readySecs,
        timerPhase: TimerPhase.ready,
        timerState: TimerState.idle,
      );
    } else {
      state = state.copyWith(
        seconds: preset.breakMin * 60,
        timerPhase: TimerPhase.rest,
        timerState: TimerState.idle,
      );
    }
    startTimer();
  }

  Future<void> _onReadyComplete() async {
    final modes = _ref.read(modesProvider);
    final preset = modes.presets[state.selectedPresetIndex];

    if (_nextPhaseAfterReady == TimerPhase.rest) {
      state = state.copyWith(
        seconds: preset.breakMin * 60,
        timerPhase: TimerPhase.rest,
        timerState: TimerState.idle,
      );
    } else {
      state = state.copyWith(
        seconds: preset.focusMin * 60,
        timerPhase: TimerPhase.focus,
        timerState: TimerState.idle,
      );
    }
    startTimer();
  }

  Future<void> _onRestComplete() async {
    final modes = _ref.read(modesProvider);
    final preset = modes.presets[state.selectedPresetIndex];

    await NotificationService.instance.showRestComplete();

    if (!state.isAutoMode) {
      state = state.copyWith(
        timerState: TimerState.idle,
        timerPhase: TimerPhase.focus,
        seconds: preset.focusMin * 60,
      );
      return;
    }

    // Auto mode: ready countdown before focus (if enabled), else go straight to focus
    final settings = await _db.getSettings();
    if (settings.readyTimerEnabled) {
      _nextPhaseAfterReady = TimerPhase.focus;
      final readySecs = settings.readyDuration;
      state = state.copyWith(
        seconds: readySecs,
        readyTotalSeconds: readySecs,
        timerPhase: TimerPhase.ready,
        timerState: TimerState.idle,
      );
    } else {
      state = state.copyWith(
        seconds: preset.focusMin * 60,
        timerPhase: TimerPhase.focus,
        timerState: TimerState.idle,
      );
    }
    startTimer();
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
    state = state.copyWith(
      timerState: TimerState.idle,
      timerPhase: TimerPhase.focus,
    );
    _syncWithPreset(state.selectedPresetIndex);
  }

  void toggleTimer() {
    if (state.timerState == TimerState.running) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  void toggleAutoMode() {
    state = state.copyWith(isAutoMode: !state.isAutoMode);
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
