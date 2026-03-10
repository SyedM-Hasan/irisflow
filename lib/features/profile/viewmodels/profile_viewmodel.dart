import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/services/app_database.dart';
import '../models/profile_state.dart';

// ---------------------------------------------------------------------------
// Persistence Providers
// ---------------------------------------------------------------------------

/// Provider for SharedPreferences instance.
/// This must be overridden in the ProviderScope with the actual instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class ProfileNotifier extends StateNotifier<ProfileState> {
  final AppDatabase _db;

  ProfileNotifier(this._db)
    : super(
        const ProfileState(
          userName: 'Alex Rivera',
          email: 'alex.rivera@flow.com',
          phone: '+1 (555) 012-3456',
          bio: 'Productivity enthusiast & deep-work practitioner.',
          location: 'San Francisco, CA',
          memberSince: 'January 2024',
          eyeHealthScore: 84,
          isPro: true,
          gentleDimming: false,
          restReminders: true,
          soundAlerts: true,
          accountSettings: [
            {'label': 'Personal Information'},
            {'label': 'Security & Privacy'},
            {'label': 'Subscription Plan'},
          ],
        ),
      ) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _db.getProfile();
    final settings = await _db.getSettings();
    state = state.copyWith(
      userName: profile.name,
      email: profile.email,
      gentleDimming: settings.gentleDimming,
      restReminders: settings.restReminders,
      soundAlerts: settings.soundAlerts,
    );
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

  void toggleSoundAlerts() {
    final newValue = !state.soundAlerts;
    state = state.copyWith(soundAlerts: newValue);
    _db.updateSettings(AppSettingsCompanion(soundAlerts: Value(newValue)));
  }

  /// Saves edits from the Personal Information sheet.
  void savePersonalInfo({
    required String name,
    required String email,
    required String phone,
    required String bio,
    required String location,
  }) {
    state = state.copyWith(
      userName: name,
      email: email,
      phone: phone,
      bio: bio,
      location: location,
    );
    _db.updateProfile(
      UserProfilesCompanion(name: Value(name), email: Value(email)),
    );
    // Note: phone, bio, location could be added to table if needed,
    // but schema has name/email/memberSince/score currently.
  }

  void factoryReset() => _loadProfile();
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return ProfileNotifier(db);
});
