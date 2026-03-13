import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

@DataClassName('AppSetting')
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get focusDuration => integer().withDefault(const Constant(25))();
  IntColumn get restDuration => integer().withDefault(const Constant(5))();
  BoolColumn get soundAlerts => boolean().withDefault(const Constant(true))();
  BoolColumn get gentleDimming =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get restReminders => boolean().withDefault(const Constant(true))();
  BoolColumn get readyTimerEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get readyDuration => integer().withDefault(const Constant(10))();
  TextColumn get selectedTheme =>
      text().withDefault(const Constant('Sage Dark'))();
  TextColumn get appVersion => text().withDefault(const Constant('1.0.0'))();
}

@DataClassName('AppProfile')
class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant('Alex Rivera'))();
  TextColumn get email =>
      text().withDefault(const Constant('alex.rivera@flow.com'))();
  TextColumn get memberSince =>
      text().withDefault(const Constant('January 2024'))();
  IntColumn get eyeHealthScore => integer().withDefault(const Constant(84))();
}

@DataClassName('AppFocusPreset')
class FocusPresets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get rule => text()();
  TextColumn get description => text()();
  IntColumn get focusMin => integer()();
  IntColumn get breakMin => integer()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

@DataClassName('AppStat')
class FocusStats extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionsCompleted => integer().withDefault(const Constant(0))();
  RealColumn get totalFocusHours => real().withDefault(const Constant(0.0))();
  IntColumn get streakDays => integer().withDefault(const Constant(0))();
}

@DataClassName('AppAnalytics')
class AnalyticsEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get day => text()(); // e.g., 'Mon', 'Tue'
  RealColumn get hours => real()();
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(
  tables: [
    AppSettings,
    UserProfiles,
    FocusPresets,
    FocusStats,
    AnalyticsEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(appSettings, appSettings.readyTimerEnabled);
        await m.addColumn(appSettings, appSettings.readyDuration);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'irisflow_db');
  }

  // ---- Helper Methods ------------------------------------------------------

  // Settings
  Future<AppSetting> getSettings() async {
    return (select(appSettings)..where((t) => t.id.equals(1))).getSingle();
  }

  Future<int> updateSettings(AppSettingsCompanion companion) {
    return (update(appSettings)..where((t) => t.id.equals(1))).write(companion);
  }

  // Profile
  Future<AppProfile> getProfile() async {
    return (select(userProfiles)..where((t) => t.id.equals(1))).getSingle();
  }

  Stream<AppProfile> watchProfile() {
    return (select(userProfiles)..where((t) => t.id.equals(1))).watchSingle();
  }

  Future<int> updateProfile(UserProfilesCompanion companion) {
    return (update(
      userProfiles,
    )..where((t) => t.id.equals(1))).write(companion);
  }

  // Presets
  Stream<List<AppFocusPreset>> watchAllPresets() =>
      select(focusPresets).watch();
  Future<int> addPreset(FocusPresetsCompanion preset) =>
      into(focusPresets).insert(preset);
  Future<void> removePreset(int id) =>
      (delete(focusPresets)..where((t) => t.id.equals(id))).go();

  // Stats
  Future<AppStat> getStats() async {
    return (select(focusStats)..where((t) => t.id.equals(1))).getSingle();
  }

  Stream<AppStat> watchStats() {
    return (select(focusStats)..where((t) => t.id.equals(1))).watchSingle();
  }

  Future<void> updateStats(FocusStatsCompanion companion) {
    return (update(focusStats)..where((t) => t.id.equals(1))).write(companion);
  }

  // Analytics
  Future<List<AppAnalytics>> getAnalytics() => select(analyticsEntries).get();

  Stream<List<AppAnalytics>> watchRecentAnalytics() {
    return (select(analyticsEntries)
          ..orderBy([
            (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
          ])
          ..limit(7))
        .watch();
  }

  Future<void> clearAnalytics() => delete(analyticsEntries).go();
  Future<int> addAnalyticsEntry(AnalyticsEntriesCompanion entry) =>
      into(analyticsEntries).insert(entry);

  Future<void> replaceAnalytics(List<AnalyticsEntriesCompanion> entries) async {
    await transaction(() async {
      await delete(analyticsEntries).go();
      for (final entry in entries) {
        await into(analyticsEntries).insert(entry);
      }
    });
  }

  // Global Reset
  Future<void> factoryReset() async {
    await transaction(() async {
      await delete(appSettings).go();
      await delete(userProfiles).go();
      await delete(focusPresets).go();
      await delete(focusStats).go();
      await delete(analyticsEntries).go();

      // Re-initialize singletons
      await into(appSettings).insert(const AppSettingsCompanion());
      await into(userProfiles).insert(const UserProfilesCompanion());
      await into(focusStats).insert(const FocusStatsCompanion());

      // Re-insert default presets
      final defaults = [
        ['Deep Work', '20/20 rule', '20 mins focus, 20 mins break', 20, 20],
        ['Creative Flow', '50/5 rule', '50 mins focus, 5 mins break', 50, 5],
        ['Quick Study', '15/5 rule', '15 mins focus, 5 mins break', 15, 5],
      ];
      for (final d in defaults) {
        await into(focusPresets).insert(
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

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
