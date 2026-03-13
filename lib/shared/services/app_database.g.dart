// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _focusDurationMeta = const VerificationMeta(
    'focusDuration',
  );
  @override
  late final GeneratedColumn<int> focusDuration = GeneratedColumn<int>(
    'focus_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _restDurationMeta = const VerificationMeta(
    'restDuration',
  );
  @override
  late final GeneratedColumn<int> restDuration = GeneratedColumn<int>(
    'rest_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _soundAlertsMeta = const VerificationMeta(
    'soundAlerts',
  );
  @override
  late final GeneratedColumn<bool> soundAlerts = GeneratedColumn<bool>(
    'sound_alerts',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_alerts" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _gentleDimmingMeta = const VerificationMeta(
    'gentleDimming',
  );
  @override
  late final GeneratedColumn<bool> gentleDimming = GeneratedColumn<bool>(
    'gentle_dimming',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("gentle_dimming" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _restRemindersMeta = const VerificationMeta(
    'restReminders',
  );
  @override
  late final GeneratedColumn<bool> restReminders = GeneratedColumn<bool>(
    'rest_reminders',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rest_reminders" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _readyTimerEnabledMeta = const VerificationMeta(
    'readyTimerEnabled',
  );
  @override
  late final GeneratedColumn<bool> readyTimerEnabled = GeneratedColumn<bool>(
    'ready_timer_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ready_timer_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _readyDurationMeta = const VerificationMeta(
    'readyDuration',
  );
  @override
  late final GeneratedColumn<int> readyDuration = GeneratedColumn<int>(
    'ready_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _selectedThemeMeta = const VerificationMeta(
    'selectedTheme',
  );
  @override
  late final GeneratedColumn<String> selectedTheme = GeneratedColumn<String>(
    'selected_theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Sage Dark'),
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1.0.0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    focusDuration,
    restDuration,
    soundAlerts,
    gentleDimming,
    restReminders,
    readyTimerEnabled,
    readyDuration,
    selectedTheme,
    appVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('focus_duration')) {
      context.handle(
        _focusDurationMeta,
        focusDuration.isAcceptableOrUnknown(
          data['focus_duration']!,
          _focusDurationMeta,
        ),
      );
    }
    if (data.containsKey('rest_duration')) {
      context.handle(
        _restDurationMeta,
        restDuration.isAcceptableOrUnknown(
          data['rest_duration']!,
          _restDurationMeta,
        ),
      );
    }
    if (data.containsKey('sound_alerts')) {
      context.handle(
        _soundAlertsMeta,
        soundAlerts.isAcceptableOrUnknown(
          data['sound_alerts']!,
          _soundAlertsMeta,
        ),
      );
    }
    if (data.containsKey('gentle_dimming')) {
      context.handle(
        _gentleDimmingMeta,
        gentleDimming.isAcceptableOrUnknown(
          data['gentle_dimming']!,
          _gentleDimmingMeta,
        ),
      );
    }
    if (data.containsKey('rest_reminders')) {
      context.handle(
        _restRemindersMeta,
        restReminders.isAcceptableOrUnknown(
          data['rest_reminders']!,
          _restRemindersMeta,
        ),
      );
    }
    if (data.containsKey('ready_timer_enabled')) {
      context.handle(
        _readyTimerEnabledMeta,
        readyTimerEnabled.isAcceptableOrUnknown(
          data['ready_timer_enabled']!,
          _readyTimerEnabledMeta,
        ),
      );
    }
    if (data.containsKey('ready_duration')) {
      context.handle(
        _readyDurationMeta,
        readyDuration.isAcceptableOrUnknown(
          data['ready_duration']!,
          _readyDurationMeta,
        ),
      );
    }
    if (data.containsKey('selected_theme')) {
      context.handle(
        _selectedThemeMeta,
        selectedTheme.isAcceptableOrUnknown(
          data['selected_theme']!,
          _selectedThemeMeta,
        ),
      );
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      focusDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_duration'],
      )!,
      restDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_duration'],
      )!,
      soundAlerts: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_alerts'],
      )!,
      gentleDimming: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}gentle_dimming'],
      )!,
      restReminders: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rest_reminders'],
      )!,
      readyTimerEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ready_timer_enabled'],
      )!,
      readyDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ready_duration'],
      )!,
      selectedTheme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_theme'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final int focusDuration;
  final int restDuration;
  final bool soundAlerts;
  final bool gentleDimming;
  final bool restReminders;
  final bool readyTimerEnabled;
  final int readyDuration;
  final String selectedTheme;
  final String appVersion;
  const AppSetting({
    required this.id,
    required this.focusDuration,
    required this.restDuration,
    required this.soundAlerts,
    required this.gentleDimming,
    required this.restReminders,
    required this.readyTimerEnabled,
    required this.readyDuration,
    required this.selectedTheme,
    required this.appVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['focus_duration'] = Variable<int>(focusDuration);
    map['rest_duration'] = Variable<int>(restDuration);
    map['sound_alerts'] = Variable<bool>(soundAlerts);
    map['gentle_dimming'] = Variable<bool>(gentleDimming);
    map['rest_reminders'] = Variable<bool>(restReminders);
    map['ready_timer_enabled'] = Variable<bool>(readyTimerEnabled);
    map['ready_duration'] = Variable<int>(readyDuration);
    map['selected_theme'] = Variable<String>(selectedTheme);
    map['app_version'] = Variable<String>(appVersion);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      focusDuration: Value(focusDuration),
      restDuration: Value(restDuration),
      soundAlerts: Value(soundAlerts),
      gentleDimming: Value(gentleDimming),
      restReminders: Value(restReminders),
      readyTimerEnabled: Value(readyTimerEnabled),
      readyDuration: Value(readyDuration),
      selectedTheme: Value(selectedTheme),
      appVersion: Value(appVersion),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      focusDuration: serializer.fromJson<int>(json['focusDuration']),
      restDuration: serializer.fromJson<int>(json['restDuration']),
      soundAlerts: serializer.fromJson<bool>(json['soundAlerts']),
      gentleDimming: serializer.fromJson<bool>(json['gentleDimming']),
      restReminders: serializer.fromJson<bool>(json['restReminders']),
      readyTimerEnabled: serializer.fromJson<bool>(json['readyTimerEnabled']),
      readyDuration: serializer.fromJson<int>(json['readyDuration']),
      selectedTheme: serializer.fromJson<String>(json['selectedTheme']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'focusDuration': serializer.toJson<int>(focusDuration),
      'restDuration': serializer.toJson<int>(restDuration),
      'soundAlerts': serializer.toJson<bool>(soundAlerts),
      'gentleDimming': serializer.toJson<bool>(gentleDimming),
      'restReminders': serializer.toJson<bool>(restReminders),
      'readyTimerEnabled': serializer.toJson<bool>(readyTimerEnabled),
      'readyDuration': serializer.toJson<int>(readyDuration),
      'selectedTheme': serializer.toJson<String>(selectedTheme),
      'appVersion': serializer.toJson<String>(appVersion),
    };
  }

  AppSetting copyWith({
    int? id,
    int? focusDuration,
    int? restDuration,
    bool? soundAlerts,
    bool? gentleDimming,
    bool? restReminders,
    bool? readyTimerEnabled,
    int? readyDuration,
    String? selectedTheme,
    String? appVersion,
  }) => AppSetting(
    id: id ?? this.id,
    focusDuration: focusDuration ?? this.focusDuration,
    restDuration: restDuration ?? this.restDuration,
    soundAlerts: soundAlerts ?? this.soundAlerts,
    gentleDimming: gentleDimming ?? this.gentleDimming,
    restReminders: restReminders ?? this.restReminders,
    readyTimerEnabled: readyTimerEnabled ?? this.readyTimerEnabled,
    readyDuration: readyDuration ?? this.readyDuration,
    selectedTheme: selectedTheme ?? this.selectedTheme,
    appVersion: appVersion ?? this.appVersion,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      focusDuration: data.focusDuration.present
          ? data.focusDuration.value
          : this.focusDuration,
      restDuration: data.restDuration.present
          ? data.restDuration.value
          : this.restDuration,
      soundAlerts: data.soundAlerts.present
          ? data.soundAlerts.value
          : this.soundAlerts,
      gentleDimming: data.gentleDimming.present
          ? data.gentleDimming.value
          : this.gentleDimming,
      restReminders: data.restReminders.present
          ? data.restReminders.value
          : this.restReminders,
      readyTimerEnabled: data.readyTimerEnabled.present
          ? data.readyTimerEnabled.value
          : this.readyTimerEnabled,
      readyDuration: data.readyDuration.present
          ? data.readyDuration.value
          : this.readyDuration,
      selectedTheme: data.selectedTheme.present
          ? data.selectedTheme.value
          : this.selectedTheme,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('focusDuration: $focusDuration, ')
          ..write('restDuration: $restDuration, ')
          ..write('soundAlerts: $soundAlerts, ')
          ..write('gentleDimming: $gentleDimming, ')
          ..write('restReminders: $restReminders, ')
          ..write('readyTimerEnabled: $readyTimerEnabled, ')
          ..write('readyDuration: $readyDuration, ')
          ..write('selectedTheme: $selectedTheme, ')
          ..write('appVersion: $appVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    focusDuration,
    restDuration,
    soundAlerts,
    gentleDimming,
    restReminders,
    readyTimerEnabled,
    readyDuration,
    selectedTheme,
    appVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.focusDuration == this.focusDuration &&
          other.restDuration == this.restDuration &&
          other.soundAlerts == this.soundAlerts &&
          other.gentleDimming == this.gentleDimming &&
          other.restReminders == this.restReminders &&
          other.readyTimerEnabled == this.readyTimerEnabled &&
          other.readyDuration == this.readyDuration &&
          other.selectedTheme == this.selectedTheme &&
          other.appVersion == this.appVersion);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<int> focusDuration;
  final Value<int> restDuration;
  final Value<bool> soundAlerts;
  final Value<bool> gentleDimming;
  final Value<bool> restReminders;
  final Value<bool> readyTimerEnabled;
  final Value<int> readyDuration;
  final Value<String> selectedTheme;
  final Value<String> appVersion;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.focusDuration = const Value.absent(),
    this.restDuration = const Value.absent(),
    this.soundAlerts = const Value.absent(),
    this.gentleDimming = const Value.absent(),
    this.restReminders = const Value.absent(),
    this.readyTimerEnabled = const Value.absent(),
    this.readyDuration = const Value.absent(),
    this.selectedTheme = const Value.absent(),
    this.appVersion = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.focusDuration = const Value.absent(),
    this.restDuration = const Value.absent(),
    this.soundAlerts = const Value.absent(),
    this.gentleDimming = const Value.absent(),
    this.restReminders = const Value.absent(),
    this.readyTimerEnabled = const Value.absent(),
    this.readyDuration = const Value.absent(),
    this.selectedTheme = const Value.absent(),
    this.appVersion = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<int>? focusDuration,
    Expression<int>? restDuration,
    Expression<bool>? soundAlerts,
    Expression<bool>? gentleDimming,
    Expression<bool>? restReminders,
    Expression<bool>? readyTimerEnabled,
    Expression<int>? readyDuration,
    Expression<String>? selectedTheme,
    Expression<String>? appVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (focusDuration != null) 'focus_duration': focusDuration,
      if (restDuration != null) 'rest_duration': restDuration,
      if (soundAlerts != null) 'sound_alerts': soundAlerts,
      if (gentleDimming != null) 'gentle_dimming': gentleDimming,
      if (restReminders != null) 'rest_reminders': restReminders,
      if (readyTimerEnabled != null) 'ready_timer_enabled': readyTimerEnabled,
      if (readyDuration != null) 'ready_duration': readyDuration,
      if (selectedTheme != null) 'selected_theme': selectedTheme,
      if (appVersion != null) 'app_version': appVersion,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? focusDuration,
    Value<int>? restDuration,
    Value<bool>? soundAlerts,
    Value<bool>? gentleDimming,
    Value<bool>? restReminders,
    Value<bool>? readyTimerEnabled,
    Value<int>? readyDuration,
    Value<String>? selectedTheme,
    Value<String>? appVersion,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      focusDuration: focusDuration ?? this.focusDuration,
      restDuration: restDuration ?? this.restDuration,
      soundAlerts: soundAlerts ?? this.soundAlerts,
      gentleDimming: gentleDimming ?? this.gentleDimming,
      restReminders: restReminders ?? this.restReminders,
      readyTimerEnabled: readyTimerEnabled ?? this.readyTimerEnabled,
      readyDuration: readyDuration ?? this.readyDuration,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (focusDuration.present) {
      map['focus_duration'] = Variable<int>(focusDuration.value);
    }
    if (restDuration.present) {
      map['rest_duration'] = Variable<int>(restDuration.value);
    }
    if (soundAlerts.present) {
      map['sound_alerts'] = Variable<bool>(soundAlerts.value);
    }
    if (gentleDimming.present) {
      map['gentle_dimming'] = Variable<bool>(gentleDimming.value);
    }
    if (restReminders.present) {
      map['rest_reminders'] = Variable<bool>(restReminders.value);
    }
    if (readyTimerEnabled.present) {
      map['ready_timer_enabled'] = Variable<bool>(readyTimerEnabled.value);
    }
    if (readyDuration.present) {
      map['ready_duration'] = Variable<int>(readyDuration.value);
    }
    if (selectedTheme.present) {
      map['selected_theme'] = Variable<String>(selectedTheme.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('focusDuration: $focusDuration, ')
          ..write('restDuration: $restDuration, ')
          ..write('soundAlerts: $soundAlerts, ')
          ..write('gentleDimming: $gentleDimming, ')
          ..write('restReminders: $restReminders, ')
          ..write('readyTimerEnabled: $readyTimerEnabled, ')
          ..write('readyDuration: $readyDuration, ')
          ..write('selectedTheme: $selectedTheme, ')
          ..write('appVersion: $appVersion')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, AppProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Alex Rivera'),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('alex.rivera@flow.com'),
  );
  static const VerificationMeta _memberSinceMeta = const VerificationMeta(
    'memberSince',
  );
  @override
  late final GeneratedColumn<String> memberSince = GeneratedColumn<String>(
    'member_since',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('January 2024'),
  );
  static const VerificationMeta _eyeHealthScoreMeta = const VerificationMeta(
    'eyeHealthScore',
  );
  @override
  late final GeneratedColumn<int> eyeHealthScore = GeneratedColumn<int>(
    'eye_health_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(84),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    memberSince,
    eyeHealthScore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('member_since')) {
      context.handle(
        _memberSinceMeta,
        memberSince.isAcceptableOrUnknown(
          data['member_since']!,
          _memberSinceMeta,
        ),
      );
    }
    if (data.containsKey('eye_health_score')) {
      context.handle(
        _eyeHealthScoreMeta,
        eyeHealthScore.isAcceptableOrUnknown(
          data['eye_health_score']!,
          _eyeHealthScoreMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      memberSince: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_since'],
      )!,
      eyeHealthScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eye_health_score'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class AppProfile extends DataClass implements Insertable<AppProfile> {
  final int id;
  final String name;
  final String email;
  final String memberSince;
  final int eyeHealthScore;
  const AppProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.memberSince,
    required this.eyeHealthScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['member_since'] = Variable<String>(memberSince);
    map['eye_health_score'] = Variable<int>(eyeHealthScore);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      memberSince: Value(memberSince),
      eyeHealthScore: Value(eyeHealthScore),
    );
  }

  factory AppProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      memberSince: serializer.fromJson<String>(json['memberSince']),
      eyeHealthScore: serializer.fromJson<int>(json['eyeHealthScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'memberSince': serializer.toJson<String>(memberSince),
      'eyeHealthScore': serializer.toJson<int>(eyeHealthScore),
    };
  }

  AppProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? memberSince,
    int? eyeHealthScore,
  }) => AppProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    memberSince: memberSince ?? this.memberSince,
    eyeHealthScore: eyeHealthScore ?? this.eyeHealthScore,
  );
  AppProfile copyWithCompanion(UserProfilesCompanion data) {
    return AppProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      memberSince: data.memberSince.present
          ? data.memberSince.value
          : this.memberSince,
      eyeHealthScore: data.eyeHealthScore.present
          ? data.eyeHealthScore.value
          : this.eyeHealthScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('memberSince: $memberSince, ')
          ..write('eyeHealthScore: $eyeHealthScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, memberSince, eyeHealthScore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.memberSince == this.memberSince &&
          other.eyeHealthScore == this.eyeHealthScore);
}

class UserProfilesCompanion extends UpdateCompanion<AppProfile> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> memberSince;
  final Value<int> eyeHealthScore;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.memberSince = const Value.absent(),
    this.eyeHealthScore = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.memberSince = const Value.absent(),
    this.eyeHealthScore = const Value.absent(),
  });
  static Insertable<AppProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? memberSince,
    Expression<int>? eyeHealthScore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (memberSince != null) 'member_since': memberSince,
      if (eyeHealthScore != null) 'eye_health_score': eyeHealthScore,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? memberSince,
    Value<int>? eyeHealthScore,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      memberSince: memberSince ?? this.memberSince,
      eyeHealthScore: eyeHealthScore ?? this.eyeHealthScore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (memberSince.present) {
      map['member_since'] = Variable<String>(memberSince.value);
    }
    if (eyeHealthScore.present) {
      map['eye_health_score'] = Variable<int>(eyeHealthScore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('memberSince: $memberSince, ')
          ..write('eyeHealthScore: $eyeHealthScore')
          ..write(')'))
        .toString();
  }
}

class $FocusPresetsTable extends FocusPresets
    with TableInfo<$FocusPresetsTable, AppFocusPreset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusPresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ruleMeta = const VerificationMeta('rule');
  @override
  late final GeneratedColumn<String> rule = GeneratedColumn<String>(
    'rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusMinMeta = const VerificationMeta(
    'focusMin',
  );
  @override
  late final GeneratedColumn<int> focusMin = GeneratedColumn<int>(
    'focus_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breakMinMeta = const VerificationMeta(
    'breakMin',
  );
  @override
  late final GeneratedColumn<int> breakMin = GeneratedColumn<int>(
    'break_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    rule,
    description,
    focusMin,
    breakMin,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppFocusPreset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('rule')) {
      context.handle(
        _ruleMeta,
        rule.isAcceptableOrUnknown(data['rule']!, _ruleMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('focus_min')) {
      context.handle(
        _focusMinMeta,
        focusMin.isAcceptableOrUnknown(data['focus_min']!, _focusMinMeta),
      );
    } else if (isInserting) {
      context.missing(_focusMinMeta);
    }
    if (data.containsKey('break_min')) {
      context.handle(
        _breakMinMeta,
        breakMin.isAcceptableOrUnknown(data['break_min']!, _breakMinMeta),
      );
    } else if (isInserting) {
      context.missing(_breakMinMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppFocusPreset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppFocusPreset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      rule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      focusMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_min'],
      )!,
      breakMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_min'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $FocusPresetsTable createAlias(String alias) {
    return $FocusPresetsTable(attachedDatabase, alias);
  }
}

class AppFocusPreset extends DataClass implements Insertable<AppFocusPreset> {
  final int id;
  final String title;
  final String rule;
  final String description;
  final int focusMin;
  final int breakMin;
  final bool isCustom;
  const AppFocusPreset({
    required this.id,
    required this.title,
    required this.rule,
    required this.description,
    required this.focusMin,
    required this.breakMin,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['rule'] = Variable<String>(rule);
    map['description'] = Variable<String>(description);
    map['focus_min'] = Variable<int>(focusMin);
    map['break_min'] = Variable<int>(breakMin);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  FocusPresetsCompanion toCompanion(bool nullToAbsent) {
    return FocusPresetsCompanion(
      id: Value(id),
      title: Value(title),
      rule: Value(rule),
      description: Value(description),
      focusMin: Value(focusMin),
      breakMin: Value(breakMin),
      isCustom: Value(isCustom),
    );
  }

  factory AppFocusPreset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppFocusPreset(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      rule: serializer.fromJson<String>(json['rule']),
      description: serializer.fromJson<String>(json['description']),
      focusMin: serializer.fromJson<int>(json['focusMin']),
      breakMin: serializer.fromJson<int>(json['breakMin']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'rule': serializer.toJson<String>(rule),
      'description': serializer.toJson<String>(description),
      'focusMin': serializer.toJson<int>(focusMin),
      'breakMin': serializer.toJson<int>(breakMin),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  AppFocusPreset copyWith({
    int? id,
    String? title,
    String? rule,
    String? description,
    int? focusMin,
    int? breakMin,
    bool? isCustom,
  }) => AppFocusPreset(
    id: id ?? this.id,
    title: title ?? this.title,
    rule: rule ?? this.rule,
    description: description ?? this.description,
    focusMin: focusMin ?? this.focusMin,
    breakMin: breakMin ?? this.breakMin,
    isCustom: isCustom ?? this.isCustom,
  );
  AppFocusPreset copyWithCompanion(FocusPresetsCompanion data) {
    return AppFocusPreset(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      rule: data.rule.present ? data.rule.value : this.rule,
      description: data.description.present
          ? data.description.value
          : this.description,
      focusMin: data.focusMin.present ? data.focusMin.value : this.focusMin,
      breakMin: data.breakMin.present ? data.breakMin.value : this.breakMin,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppFocusPreset(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('rule: $rule, ')
          ..write('description: $description, ')
          ..write('focusMin: $focusMin, ')
          ..write('breakMin: $breakMin, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, rule, description, focusMin, breakMin, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppFocusPreset &&
          other.id == this.id &&
          other.title == this.title &&
          other.rule == this.rule &&
          other.description == this.description &&
          other.focusMin == this.focusMin &&
          other.breakMin == this.breakMin &&
          other.isCustom == this.isCustom);
}

class FocusPresetsCompanion extends UpdateCompanion<AppFocusPreset> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> rule;
  final Value<String> description;
  final Value<int> focusMin;
  final Value<int> breakMin;
  final Value<bool> isCustom;
  const FocusPresetsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.rule = const Value.absent(),
    this.description = const Value.absent(),
    this.focusMin = const Value.absent(),
    this.breakMin = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  FocusPresetsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String rule,
    required String description,
    required int focusMin,
    required int breakMin,
    this.isCustom = const Value.absent(),
  }) : title = Value(title),
       rule = Value(rule),
       description = Value(description),
       focusMin = Value(focusMin),
       breakMin = Value(breakMin);
  static Insertable<AppFocusPreset> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? rule,
    Expression<String>? description,
    Expression<int>? focusMin,
    Expression<int>? breakMin,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (rule != null) 'rule': rule,
      if (description != null) 'description': description,
      if (focusMin != null) 'focus_min': focusMin,
      if (breakMin != null) 'break_min': breakMin,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  FocusPresetsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? rule,
    Value<String>? description,
    Value<int>? focusMin,
    Value<int>? breakMin,
    Value<bool>? isCustom,
  }) {
    return FocusPresetsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      rule: rule ?? this.rule,
      description: description ?? this.description,
      focusMin: focusMin ?? this.focusMin,
      breakMin: breakMin ?? this.breakMin,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rule.present) {
      map['rule'] = Variable<String>(rule.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (focusMin.present) {
      map['focus_min'] = Variable<int>(focusMin.value);
    }
    if (breakMin.present) {
      map['break_min'] = Variable<int>(breakMin.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusPresetsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('rule: $rule, ')
          ..write('description: $description, ')
          ..write('focusMin: $focusMin, ')
          ..write('breakMin: $breakMin, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $FocusStatsTable extends FocusStats
    with TableInfo<$FocusStatsTable, AppStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionsCompletedMeta = const VerificationMeta(
    'sessionsCompleted',
  );
  @override
  late final GeneratedColumn<int> sessionsCompleted = GeneratedColumn<int>(
    'sessions_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalFocusHoursMeta = const VerificationMeta(
    'totalFocusHours',
  );
  @override
  late final GeneratedColumn<double> totalFocusHours = GeneratedColumn<double>(
    'total_focus_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _streakDaysMeta = const VerificationMeta(
    'streakDays',
  );
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
    'streak_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionsCompleted,
    totalFocusHours,
    streakDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sessions_completed')) {
      context.handle(
        _sessionsCompletedMeta,
        sessionsCompleted.isAcceptableOrUnknown(
          data['sessions_completed']!,
          _sessionsCompletedMeta,
        ),
      );
    }
    if (data.containsKey('total_focus_hours')) {
      context.handle(
        _totalFocusHoursMeta,
        totalFocusHours.isAcceptableOrUnknown(
          data['total_focus_hours']!,
          _totalFocusHoursMeta,
        ),
      );
    }
    if (data.containsKey('streak_days')) {
      context.handle(
        _streakDaysMeta,
        streakDays.isAcceptableOrUnknown(data['streak_days']!, _streakDaysMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionsCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sessions_completed'],
      )!,
      totalFocusHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_focus_hours'],
      )!,
      streakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_days'],
      )!,
    );
  }

  @override
  $FocusStatsTable createAlias(String alias) {
    return $FocusStatsTable(attachedDatabase, alias);
  }
}

class AppStat extends DataClass implements Insertable<AppStat> {
  final int id;
  final int sessionsCompleted;
  final double totalFocusHours;
  final int streakDays;
  const AppStat({
    required this.id,
    required this.sessionsCompleted,
    required this.totalFocusHours,
    required this.streakDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sessions_completed'] = Variable<int>(sessionsCompleted);
    map['total_focus_hours'] = Variable<double>(totalFocusHours);
    map['streak_days'] = Variable<int>(streakDays);
    return map;
  }

  FocusStatsCompanion toCompanion(bool nullToAbsent) {
    return FocusStatsCompanion(
      id: Value(id),
      sessionsCompleted: Value(sessionsCompleted),
      totalFocusHours: Value(totalFocusHours),
      streakDays: Value(streakDays),
    );
  }

  factory AppStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppStat(
      id: serializer.fromJson<int>(json['id']),
      sessionsCompleted: serializer.fromJson<int>(json['sessionsCompleted']),
      totalFocusHours: serializer.fromJson<double>(json['totalFocusHours']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionsCompleted': serializer.toJson<int>(sessionsCompleted),
      'totalFocusHours': serializer.toJson<double>(totalFocusHours),
      'streakDays': serializer.toJson<int>(streakDays),
    };
  }

  AppStat copyWith({
    int? id,
    int? sessionsCompleted,
    double? totalFocusHours,
    int? streakDays,
  }) => AppStat(
    id: id ?? this.id,
    sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
    totalFocusHours: totalFocusHours ?? this.totalFocusHours,
    streakDays: streakDays ?? this.streakDays,
  );
  AppStat copyWithCompanion(FocusStatsCompanion data) {
    return AppStat(
      id: data.id.present ? data.id.value : this.id,
      sessionsCompleted: data.sessionsCompleted.present
          ? data.sessionsCompleted.value
          : this.sessionsCompleted,
      totalFocusHours: data.totalFocusHours.present
          ? data.totalFocusHours.value
          : this.totalFocusHours,
      streakDays: data.streakDays.present
          ? data.streakDays.value
          : this.streakDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppStat(')
          ..write('id: $id, ')
          ..write('sessionsCompleted: $sessionsCompleted, ')
          ..write('totalFocusHours: $totalFocusHours, ')
          ..write('streakDays: $streakDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionsCompleted, totalFocusHours, streakDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppStat &&
          other.id == this.id &&
          other.sessionsCompleted == this.sessionsCompleted &&
          other.totalFocusHours == this.totalFocusHours &&
          other.streakDays == this.streakDays);
}

class FocusStatsCompanion extends UpdateCompanion<AppStat> {
  final Value<int> id;
  final Value<int> sessionsCompleted;
  final Value<double> totalFocusHours;
  final Value<int> streakDays;
  const FocusStatsCompanion({
    this.id = const Value.absent(),
    this.sessionsCompleted = const Value.absent(),
    this.totalFocusHours = const Value.absent(),
    this.streakDays = const Value.absent(),
  });
  FocusStatsCompanion.insert({
    this.id = const Value.absent(),
    this.sessionsCompleted = const Value.absent(),
    this.totalFocusHours = const Value.absent(),
    this.streakDays = const Value.absent(),
  });
  static Insertable<AppStat> custom({
    Expression<int>? id,
    Expression<int>? sessionsCompleted,
    Expression<double>? totalFocusHours,
    Expression<int>? streakDays,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionsCompleted != null) 'sessions_completed': sessionsCompleted,
      if (totalFocusHours != null) 'total_focus_hours': totalFocusHours,
      if (streakDays != null) 'streak_days': streakDays,
    });
  }

  FocusStatsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionsCompleted,
    Value<double>? totalFocusHours,
    Value<int>? streakDays,
  }) {
    return FocusStatsCompanion(
      id: id ?? this.id,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      totalFocusHours: totalFocusHours ?? this.totalFocusHours,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionsCompleted.present) {
      map['sessions_completed'] = Variable<int>(sessionsCompleted.value);
    }
    if (totalFocusHours.present) {
      map['total_focus_hours'] = Variable<double>(totalFocusHours.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusStatsCompanion(')
          ..write('id: $id, ')
          ..write('sessionsCompleted: $sessionsCompleted, ')
          ..write('totalFocusHours: $totalFocusHours, ')
          ..write('streakDays: $streakDays')
          ..write(')'))
        .toString();
  }
}

class $AnalyticsEntriesTable extends AnalyticsEntries
    with TableInfo<$AnalyticsEntriesTable, AppAnalytics> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalyticsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  @override
  late final GeneratedColumn<double> hours = GeneratedColumn<double>(
    'hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, day, hours];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analytics_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppAnalytics> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('hours')) {
      context.handle(
        _hoursMeta,
        hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta),
      );
    } else if (isInserting) {
      context.missing(_hoursMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppAnalytics map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppAnalytics(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      hours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hours'],
      )!,
    );
  }

  @override
  $AnalyticsEntriesTable createAlias(String alias) {
    return $AnalyticsEntriesTable(attachedDatabase, alias);
  }
}

class AppAnalytics extends DataClass implements Insertable<AppAnalytics> {
  final int id;
  final String day;
  final double hours;
  const AppAnalytics({
    required this.id,
    required this.day,
    required this.hours,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<String>(day);
    map['hours'] = Variable<double>(hours);
    return map;
  }

  AnalyticsEntriesCompanion toCompanion(bool nullToAbsent) {
    return AnalyticsEntriesCompanion(
      id: Value(id),
      day: Value(day),
      hours: Value(hours),
    );
  }

  factory AppAnalytics.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppAnalytics(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<String>(json['day']),
      hours: serializer.fromJson<double>(json['hours']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<String>(day),
      'hours': serializer.toJson<double>(hours),
    };
  }

  AppAnalytics copyWith({int? id, String? day, double? hours}) => AppAnalytics(
    id: id ?? this.id,
    day: day ?? this.day,
    hours: hours ?? this.hours,
  );
  AppAnalytics copyWithCompanion(AnalyticsEntriesCompanion data) {
    return AppAnalytics(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      hours: data.hours.present ? data.hours.value : this.hours,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppAnalytics(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('hours: $hours')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, day, hours);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppAnalytics &&
          other.id == this.id &&
          other.day == this.day &&
          other.hours == this.hours);
}

class AnalyticsEntriesCompanion extends UpdateCompanion<AppAnalytics> {
  final Value<int> id;
  final Value<String> day;
  final Value<double> hours;
  const AnalyticsEntriesCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.hours = const Value.absent(),
  });
  AnalyticsEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String day,
    required double hours,
  }) : day = Value(day),
       hours = Value(hours);
  static Insertable<AppAnalytics> custom({
    Expression<int>? id,
    Expression<String>? day,
    Expression<double>? hours,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (hours != null) 'hours': hours,
    });
  }

  AnalyticsEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? day,
    Value<double>? hours,
  }) {
    return AnalyticsEntriesCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      hours: hours ?? this.hours,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (hours.present) {
      map['hours'] = Variable<double>(hours.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalyticsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('hours: $hours')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $FocusPresetsTable focusPresets = $FocusPresetsTable(this);
  late final $FocusStatsTable focusStats = $FocusStatsTable(this);
  late final $AnalyticsEntriesTable analyticsEntries = $AnalyticsEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    userProfiles,
    focusPresets,
    focusStats,
    analyticsEntries,
  ];
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> focusDuration,
      Value<int> restDuration,
      Value<bool> soundAlerts,
      Value<bool> gentleDimming,
      Value<bool> restReminders,
      Value<bool> readyTimerEnabled,
      Value<int> readyDuration,
      Value<String> selectedTheme,
      Value<String> appVersion,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> focusDuration,
      Value<int> restDuration,
      Value<bool> soundAlerts,
      Value<bool> gentleDimming,
      Value<bool> restReminders,
      Value<bool> readyTimerEnabled,
      Value<int> readyDuration,
      Value<String> selectedTheme,
      Value<String> appVersion,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusDuration => $composableBuilder(
    column: $table.focusDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restDuration => $composableBuilder(
    column: $table.restDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundAlerts => $composableBuilder(
    column: $table.soundAlerts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get gentleDimming => $composableBuilder(
    column: $table.gentleDimming,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get restReminders => $composableBuilder(
    column: $table.restReminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get readyTimerEnabled => $composableBuilder(
    column: $table.readyTimerEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get readyDuration => $composableBuilder(
    column: $table.readyDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedTheme => $composableBuilder(
    column: $table.selectedTheme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusDuration => $composableBuilder(
    column: $table.focusDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restDuration => $composableBuilder(
    column: $table.restDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundAlerts => $composableBuilder(
    column: $table.soundAlerts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get gentleDimming => $composableBuilder(
    column: $table.gentleDimming,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get restReminders => $composableBuilder(
    column: $table.restReminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get readyTimerEnabled => $composableBuilder(
    column: $table.readyTimerEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get readyDuration => $composableBuilder(
    column: $table.readyDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedTheme => $composableBuilder(
    column: $table.selectedTheme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get focusDuration => $composableBuilder(
    column: $table.focusDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restDuration => $composableBuilder(
    column: $table.restDuration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get soundAlerts => $composableBuilder(
    column: $table.soundAlerts,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get gentleDimming => $composableBuilder(
    column: $table.gentleDimming,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get restReminders => $composableBuilder(
    column: $table.restReminders,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get readyTimerEnabled => $composableBuilder(
    column: $table.readyTimerEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get readyDuration => $composableBuilder(
    column: $table.readyDuration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedTheme => $composableBuilder(
    column: $table.selectedTheme,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> focusDuration = const Value.absent(),
                Value<int> restDuration = const Value.absent(),
                Value<bool> soundAlerts = const Value.absent(),
                Value<bool> gentleDimming = const Value.absent(),
                Value<bool> restReminders = const Value.absent(),
                Value<bool> readyTimerEnabled = const Value.absent(),
                Value<int> readyDuration = const Value.absent(),
                Value<String> selectedTheme = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                focusDuration: focusDuration,
                restDuration: restDuration,
                soundAlerts: soundAlerts,
                gentleDimming: gentleDimming,
                restReminders: restReminders,
                readyTimerEnabled: readyTimerEnabled,
                readyDuration: readyDuration,
                selectedTheme: selectedTheme,
                appVersion: appVersion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> focusDuration = const Value.absent(),
                Value<int> restDuration = const Value.absent(),
                Value<bool> soundAlerts = const Value.absent(),
                Value<bool> gentleDimming = const Value.absent(),
                Value<bool> restReminders = const Value.absent(),
                Value<bool> readyTimerEnabled = const Value.absent(),
                Value<int> readyDuration = const Value.absent(),
                Value<String> selectedTheme = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                focusDuration: focusDuration,
                restDuration: restDuration,
                soundAlerts: soundAlerts,
                gentleDimming: gentleDimming,
                restReminders: restReminders,
                readyTimerEnabled: readyTimerEnabled,
                readyDuration: readyDuration,
                selectedTheme: selectedTheme,
                appVersion: appVersion,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> email,
      Value<String> memberSince,
      Value<int> eyeHealthScore,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> email,
      Value<String> memberSince,
      Value<int> eyeHealthScore,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberSince => $composableBuilder(
    column: $table.memberSince,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eyeHealthScore => $composableBuilder(
    column: $table.eyeHealthScore,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberSince => $composableBuilder(
    column: $table.memberSince,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eyeHealthScore => $composableBuilder(
    column: $table.eyeHealthScore,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get memberSince => $composableBuilder(
    column: $table.memberSince,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eyeHealthScore => $composableBuilder(
    column: $table.eyeHealthScore,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          AppProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            AppProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, AppProfile>,
          ),
          AppProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> memberSince = const Value.absent(),
                Value<int> eyeHealthScore = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                name: name,
                email: email,
                memberSince: memberSince,
                eyeHealthScore: eyeHealthScore,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> memberSince = const Value.absent(),
                Value<int> eyeHealthScore = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                name: name,
                email: email,
                memberSince: memberSince,
                eyeHealthScore: eyeHealthScore,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      AppProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        AppProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, AppProfile>,
      ),
      AppProfile,
      PrefetchHooks Function()
    >;
typedef $$FocusPresetsTableCreateCompanionBuilder =
    FocusPresetsCompanion Function({
      Value<int> id,
      required String title,
      required String rule,
      required String description,
      required int focusMin,
      required int breakMin,
      Value<bool> isCustom,
    });
typedef $$FocusPresetsTableUpdateCompanionBuilder =
    FocusPresetsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> rule,
      Value<String> description,
      Value<int> focusMin,
      Value<int> breakMin,
      Value<bool> isCustom,
    });

class $$FocusPresetsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusPresetsTable> {
  $$FocusPresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rule => $composableBuilder(
    column: $table.rule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusMin => $composableBuilder(
    column: $table.focusMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakMin => $composableBuilder(
    column: $table.breakMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusPresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusPresetsTable> {
  $$FocusPresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rule => $composableBuilder(
    column: $table.rule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusMin => $composableBuilder(
    column: $table.focusMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakMin => $composableBuilder(
    column: $table.breakMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusPresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusPresetsTable> {
  $$FocusPresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get rule =>
      $composableBuilder(column: $table.rule, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusMin =>
      $composableBuilder(column: $table.focusMin, builder: (column) => column);

  GeneratedColumn<int> get breakMin =>
      $composableBuilder(column: $table.breakMin, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);
}

class $$FocusPresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusPresetsTable,
          AppFocusPreset,
          $$FocusPresetsTableFilterComposer,
          $$FocusPresetsTableOrderingComposer,
          $$FocusPresetsTableAnnotationComposer,
          $$FocusPresetsTableCreateCompanionBuilder,
          $$FocusPresetsTableUpdateCompanionBuilder,
          (
            AppFocusPreset,
            BaseReferences<_$AppDatabase, $FocusPresetsTable, AppFocusPreset>,
          ),
          AppFocusPreset,
          PrefetchHooks Function()
        > {
  $$FocusPresetsTableTableManager(_$AppDatabase db, $FocusPresetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusPresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusPresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusPresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> rule = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> focusMin = const Value.absent(),
                Value<int> breakMin = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => FocusPresetsCompanion(
                id: id,
                title: title,
                rule: rule,
                description: description,
                focusMin: focusMin,
                breakMin: breakMin,
                isCustom: isCustom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String rule,
                required String description,
                required int focusMin,
                required int breakMin,
                Value<bool> isCustom = const Value.absent(),
              }) => FocusPresetsCompanion.insert(
                id: id,
                title: title,
                rule: rule,
                description: description,
                focusMin: focusMin,
                breakMin: breakMin,
                isCustom: isCustom,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusPresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusPresetsTable,
      AppFocusPreset,
      $$FocusPresetsTableFilterComposer,
      $$FocusPresetsTableOrderingComposer,
      $$FocusPresetsTableAnnotationComposer,
      $$FocusPresetsTableCreateCompanionBuilder,
      $$FocusPresetsTableUpdateCompanionBuilder,
      (
        AppFocusPreset,
        BaseReferences<_$AppDatabase, $FocusPresetsTable, AppFocusPreset>,
      ),
      AppFocusPreset,
      PrefetchHooks Function()
    >;
typedef $$FocusStatsTableCreateCompanionBuilder =
    FocusStatsCompanion Function({
      Value<int> id,
      Value<int> sessionsCompleted,
      Value<double> totalFocusHours,
      Value<int> streakDays,
    });
typedef $$FocusStatsTableUpdateCompanionBuilder =
    FocusStatsCompanion Function({
      Value<int> id,
      Value<int> sessionsCompleted,
      Value<double> totalFocusHours,
      Value<int> streakDays,
    });

class $$FocusStatsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusStatsTable> {
  $$FocusStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionsCompleted => $composableBuilder(
    column: $table.sessionsCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalFocusHours => $composableBuilder(
    column: $table.totalFocusHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusStatsTable> {
  $$FocusStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionsCompleted => $composableBuilder(
    column: $table.sessionsCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalFocusHours => $composableBuilder(
    column: $table.totalFocusHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusStatsTable> {
  $$FocusStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionsCompleted => $composableBuilder(
    column: $table.sessionsCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalFocusHours => $composableBuilder(
    column: $table.totalFocusHours,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => column,
  );
}

class $$FocusStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusStatsTable,
          AppStat,
          $$FocusStatsTableFilterComposer,
          $$FocusStatsTableOrderingComposer,
          $$FocusStatsTableAnnotationComposer,
          $$FocusStatsTableCreateCompanionBuilder,
          $$FocusStatsTableUpdateCompanionBuilder,
          (AppStat, BaseReferences<_$AppDatabase, $FocusStatsTable, AppStat>),
          AppStat,
          PrefetchHooks Function()
        > {
  $$FocusStatsTableTableManager(_$AppDatabase db, $FocusStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionsCompleted = const Value.absent(),
                Value<double> totalFocusHours = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
              }) => FocusStatsCompanion(
                id: id,
                sessionsCompleted: sessionsCompleted,
                totalFocusHours: totalFocusHours,
                streakDays: streakDays,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionsCompleted = const Value.absent(),
                Value<double> totalFocusHours = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
              }) => FocusStatsCompanion.insert(
                id: id,
                sessionsCompleted: sessionsCompleted,
                totalFocusHours: totalFocusHours,
                streakDays: streakDays,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusStatsTable,
      AppStat,
      $$FocusStatsTableFilterComposer,
      $$FocusStatsTableOrderingComposer,
      $$FocusStatsTableAnnotationComposer,
      $$FocusStatsTableCreateCompanionBuilder,
      $$FocusStatsTableUpdateCompanionBuilder,
      (AppStat, BaseReferences<_$AppDatabase, $FocusStatsTable, AppStat>),
      AppStat,
      PrefetchHooks Function()
    >;
typedef $$AnalyticsEntriesTableCreateCompanionBuilder =
    AnalyticsEntriesCompanion Function({
      Value<int> id,
      required String day,
      required double hours,
    });
typedef $$AnalyticsEntriesTableUpdateCompanionBuilder =
    AnalyticsEntriesCompanion Function({
      Value<int> id,
      Value<String> day,
      Value<double> hours,
    });

class $$AnalyticsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AnalyticsEntriesTable> {
  $$AnalyticsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnalyticsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalyticsEntriesTable> {
  $$AnalyticsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnalyticsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalyticsEntriesTable> {
  $$AnalyticsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<double> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => column);
}

class $$AnalyticsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalyticsEntriesTable,
          AppAnalytics,
          $$AnalyticsEntriesTableFilterComposer,
          $$AnalyticsEntriesTableOrderingComposer,
          $$AnalyticsEntriesTableAnnotationComposer,
          $$AnalyticsEntriesTableCreateCompanionBuilder,
          $$AnalyticsEntriesTableUpdateCompanionBuilder,
          (
            AppAnalytics,
            BaseReferences<_$AppDatabase, $AnalyticsEntriesTable, AppAnalytics>,
          ),
          AppAnalytics,
          PrefetchHooks Function()
        > {
  $$AnalyticsEntriesTableTableManager(
    _$AppDatabase db,
    $AnalyticsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalyticsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalyticsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalyticsEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<double> hours = const Value.absent(),
              }) => AnalyticsEntriesCompanion(id: id, day: day, hours: hours),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String day,
                required double hours,
              }) => AnalyticsEntriesCompanion.insert(
                id: id,
                day: day,
                hours: hours,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnalyticsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalyticsEntriesTable,
      AppAnalytics,
      $$AnalyticsEntriesTableFilterComposer,
      $$AnalyticsEntriesTableOrderingComposer,
      $$AnalyticsEntriesTableAnnotationComposer,
      $$AnalyticsEntriesTableCreateCompanionBuilder,
      $$AnalyticsEntriesTableUpdateCompanionBuilder,
      (
        AppAnalytics,
        BaseReferences<_$AppDatabase, $AnalyticsEntriesTable, AppAnalytics>,
      ),
      AppAnalytics,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$FocusPresetsTableTableManager get focusPresets =>
      $$FocusPresetsTableTableManager(_db, _db.focusPresets);
  $$FocusStatsTableTableManager get focusStats =>
      $$FocusStatsTableTableManager(_db, _db.focusStats);
  $$AnalyticsEntriesTableTableManager get analyticsEntries =>
      $$AnalyticsEntriesTableTableManager(_db, _db.analyticsEntries);
}
