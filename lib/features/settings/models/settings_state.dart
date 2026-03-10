class SettingsState {
  final int focusDuration;
  final int restDuration;
  final bool soundAlerts;
  final bool gentleDimming;
  final bool restReminders;
  final String selectedTheme;
  final List<String> themes;
  final String appVersion;

  const SettingsState({
    required this.focusDuration,
    required this.restDuration,
    required this.soundAlerts,
    required this.gentleDimming,
    required this.restReminders,
    required this.selectedTheme,
    required this.themes,
    required this.appVersion,
  });

  SettingsState copyWith({
    int? focusDuration,
    int? restDuration,
    bool? soundAlerts,
    bool? gentleDimming,
    bool? restReminders,
    String? selectedTheme,
  }) {
    return SettingsState(
      focusDuration: focusDuration ?? this.focusDuration,
      restDuration: restDuration ?? this.restDuration,
      soundAlerts: soundAlerts ?? this.soundAlerts,
      gentleDimming: gentleDimming ?? this.gentleDimming,
      restReminders: restReminders ?? this.restReminders,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      themes: themes,
      appVersion: appVersion,
    );
  }
}
