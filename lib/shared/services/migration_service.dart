import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_database.dart';

class MigrationService {
  static const _kMigrated = 'drift_migrated_v1';

  static Future<void> migrateIfNeeded(
    SharedPreferences prefs,
    AppDatabase db,
  ) async {
    final isMigrated = prefs.getBool(_kMigrated) ?? false;
    if (isMigrated) return;

    // Check if there's actually data to migrate by checking the name key
    if (!prefs.containsKey('profile_name')) {
      // No legacy data, just initialize defaults and mark as migrated
      await _initializeDefaults(db);
      await prefs.setBool(_kMigrated, true);
      return;
    }

    try {
      await db.transaction(() async {
        // 1. Migrate settings
        await db
            .into(db.appSettings)
            .insert(
              AppSettingsCompanion(
                focusDuration: Value(
                  prefs.getInt('settings_focus_duration') ?? 25,
                ),
                restDuration: Value(
                  prefs.getInt('settings_rest_duration') ?? 5,
                ),
                soundAlerts: Value(
                  prefs.getBool('settings_sound_alerts') ?? true,
                ),
                gentleDimming: Value(
                  prefs.getBool('settings_gentle_dimming') ?? false,
                ),
                restReminders: Value(
                  prefs.getBool('profile_rest_reminders') ?? true,
                ),
                selectedTheme: Value(
                  prefs.getString('settings_theme') ?? 'Sage Dark',
                ),
              ),
            );

        // 2. Migrate profile
        await db
            .into(db.userProfiles)
            .insert(
              UserProfilesCompanion(
                name: Value(prefs.getString('profile_name') ?? 'Alex Rivera'),
                email: Value(
                  prefs.getString('profile_email') ?? 'alex.rivera@flow.com',
                ),
                memberSince: const Value('January 2024'),
                eyeHealthScore: const Value(84),
              ),
            );

        // 3. Migrate Stats
        await db
            .into(db.focusStats)
            .insert(
              FocusStatsCompanion(
                sessionsCompleted: Value(
                  prefs.getInt('stats_sessions_completed') ?? 0,
                ),
                totalFocusHours: Value(
                  prefs.getDouble('stats_focus_hours') ?? 0.0,
                ),
                streakDays: Value(prefs.getInt('stats_streak_days') ?? 0),
              ),
            );

        // 4. Migrate Presets
        final presetsJson = prefs.getString('data_custom_presets');
        if (presetsJson != null) {
          final List<dynamic> list = jsonDecode(presetsJson);
          for (final item in list) {
            await db
                .into(db.focusPresets)
                .insert(
                  FocusPresetsCompanion.insert(
                    title: item['title'] as String,
                    rule: item['rule'] as String,
                    description: item['description'] as String,
                    focusMin: item['focusMin'] as int,
                    breakMin: item['breakMin'] as int,
                    isCustom: const Value(true),
                  ),
                );
          }
        }

        // 5. Migrate Analytics
        final analyticsJson = prefs.getString('data_analytics_weekly');
        if (analyticsJson != null) {
          final List<dynamic> list = jsonDecode(analyticsJson);
          for (final item in list) {
            await db
                .into(db.analyticsEntries)
                .insert(
                  AnalyticsEntriesCompanion.insert(
                    day: item['day'] as String,
                    hours: (item['hours'] as num).toDouble(),
                  ),
                );
          }
        }
      });

      await prefs.setBool(_kMigrated, true);
    } catch (e) {
      // If migration fails, we'll try again next time or log it
      // Migration error handled silently or with proper logging in the future
    }
  }

  static Future<void> _initializeDefaults(AppDatabase db) async {
    await db.transaction(() async {
      await db.into(db.appSettings).insert(const AppSettingsCompanion());
      await db.into(db.userProfiles).insert(const UserProfilesCompanion());
      await db.into(db.focusStats).insert(const FocusStatsCompanion());

      // Default presets
      final defaults = [
        ['Deep Work', '20/20 rule', '20 mins focus, 20 mins break', 20, 20],
        ['Creative Flow', '50/5 rule', '50 mins focus, 5 mins break', 50, 5],
        ['Quick Study', '15/5 rule', '15 mins focus, 5 mins break', 15, 5],
      ];
      for (final d in defaults) {
        await db
            .into(db.focusPresets)
            .insert(
              FocusPresetsCompanion.insert(
                title: d[0] as String,
                rule: d[1] as String,
                description: d[2] as String,
                focusMin: d[3] as int,
                breakMin: d[4] as int,
              ),
            );
      }
    });
  }
}
