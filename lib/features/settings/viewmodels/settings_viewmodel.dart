import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/app_database.dart';
import '../../analytics/viewmodels/analytics_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../modes/viewmodels/modes_viewmodel.dart';
import '../models/settings_state.dart';

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class SettingsNotifier extends StateNotifier<SettingsState> {
  final AppDatabase _db;
  final Ref _ref;

  SettingsNotifier(this._db, this._ref)
    : super(
        const SettingsState(
          focusDuration: 25,
          restDuration: 5,
          soundAlerts: true,
          gentleDimming: false,
          restReminders: true,
          selectedTheme: 'Sage Dark',
          themes: ['Sage Dark', 'Ocean Blue', 'Sunset Gold'],
          appVersion: '2.4.0-release',
        ),
      ) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _db.getSettings();
    state = state.copyWith(
      focusDuration: settings.focusDuration,
      restDuration: settings.restDuration,
      soundAlerts: settings.soundAlerts,
      gentleDimming: settings.gentleDimming,
      restReminders: settings.restReminders,
      selectedTheme: settings.selectedTheme,
    );
  }

  void incrementFocus() {
    if (state.focusDuration < 120) {
      final newValue = state.focusDuration + 5;
      state = state.copyWith(focusDuration: newValue);
      _db.updateSettings(AppSettingsCompanion(focusDuration: Value(newValue)));
    }
  }

  void decrementFocus() {
    if (state.focusDuration > 5) {
      final newValue = state.focusDuration - 5;
      state = state.copyWith(focusDuration: newValue);
      _db.updateSettings(AppSettingsCompanion(focusDuration: Value(newValue)));
    }
  }

  void incrementRest() {
    if (state.restDuration < 60) {
      final newValue = state.restDuration + 5;
      state = state.copyWith(restDuration: newValue);
      _db.updateSettings(AppSettingsCompanion(restDuration: Value(newValue)));
    }
  }

  void decrementRest() {
    if (state.restDuration > 5) {
      final newValue = state.restDuration - 5;
      state = state.copyWith(restDuration: newValue);
      _db.updateSettings(AppSettingsCompanion(restDuration: Value(newValue)));
    }
  }

  void toggleSoundAlerts() {
    final newValue = !state.soundAlerts;
    state = state.copyWith(soundAlerts: newValue);
    _db.updateSettings(AppSettingsCompanion(soundAlerts: Value(newValue)));
  }

  void toggleGentleDimming() {
    final newValue = !state.gentleDimming;
    state = state.copyWith(gentleDimming: newValue);
    _db.updateSettings(AppSettingsCompanion(gentleDimming: Value(newValue)));
  }

  void toggleRestReminders() {
    final newValue = !state.restReminders;
    state = state.copyWith(restReminders: newValue);
    _db.updateSettings(AppSettingsCompanion(restReminders: Value(newValue)));
  }

  void selectTheme(String theme) {
    state = state.copyWith(selectedTheme: theme);
    _db.updateSettings(AppSettingsCompanion(selectedTheme: Value(theme)));
  }

  /// Reset ALL app data to initial state
  Future<void> resetAllData() async {
    await _db.factoryReset();

    // Trigger factory reset in all other notifiers
    _ref.read(homeProvider.notifier).factoryReset();
    _ref.read(modesProvider.notifier).factoryReset();
    _ref.read(analyticsProvider.notifier).factoryReset();

    // Reload settings from DB (which are now default)
    await _loadSettings();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    final db = ref.watch(databaseProvider);
    return SettingsNotifier(db, ref);
  },
);
