import 'package:irisflow/features/home/viewmodels/home_viewmodel.dart'; // For TimerState

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
