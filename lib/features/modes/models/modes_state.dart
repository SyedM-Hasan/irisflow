import '../../../shared/services/app_database.dart';

class FocusPreset {
  final int? id;
  final String title;
  final String rule;
  final String description;
  final int focusMin;
  final int breakMin;
  final bool isCustom;
  final String tag;

  const FocusPreset({
    this.id,
    required this.title,
    required this.rule,
    required this.description,
    required this.focusMin,
    required this.breakMin,
    this.isCustom = false,
    this.tag = 'general',
  });

  factory FocusPreset.fromDb(AppFocusPreset db) => FocusPreset(
    id: db.id,
    title: db.title,
    rule: db.rule,
    description: db.description,
    focusMin: db.focusMin,
    breakMin: db.breakMin,
    isCustom: db.isCustom,
    tag: db.tag,
  );
}

class ModesState {
  final int activePresetIndex;
  final List<FocusPreset> presets;

  const ModesState({required this.activePresetIndex, required this.presets});

  ModesState copyWith({int? activePresetIndex, List<FocusPreset>? presets}) {
    return ModesState(
      activePresetIndex: activePresetIndex ?? this.activePresetIndex,
      presets: presets ?? this.presets,
    );
  }

  FocusPreset? get activePreset =>
      activePresetIndex < 0 || activePresetIndex >= presets.length
      ? null
      : presets[activePresetIndex];

  bool isActive(int index) => activePresetIndex == index;
}
