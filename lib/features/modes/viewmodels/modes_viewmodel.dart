import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/app_database.dart';
import '../models/modes_state.dart';

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class ModesNotifier extends StateNotifier<ModesState> {
  final AppDatabase _db;

  ModesNotifier(this._db)
    : super(const ModesState(activePresetIndex: -1, presets: [])) {
    _listenToPresets();
  }

  void _listenToPresets() {
    _db.watchAllPresets().listen((dbPresets) {
      final uiPresets = dbPresets.map((e) => FocusPreset.fromDb(e)).toList();
      state = state.copyWith(presets: uiPresets);
    });
  }

  void selectPreset(int index) {
    final newIndex = state.activePresetIndex == index ? -1 : index;
    state = state.copyWith(activePresetIndex: newIndex);
  }

  Future<void> addPreset(FocusPreset preset) async {
    await _db.addPreset(
      FocusPresetsCompanion.insert(
        title: preset.title,
        rule: preset.rule,
        description: preset.description,
        focusMin: preset.focusMin,
        breakMin: preset.breakMin,
        isCustom: const Value(true),
        tag: Value(preset.tag),
      ),
    );
    // State will update automatically via stream listener
  }

  Future<void> removePreset(int index) async {
    final preset = state.presets[index];
    if (!preset.isCustom || preset.id == null) return;

    await _db.removePreset(preset.id!);

    if (state.activePresetIndex == index) {
      state = state.copyWith(activePresetIndex: -1);
    }
    // List will update via stream
  }

  void factoryReset() {
    state = const ModesState(activePresetIndex: -1, presets: []);
    // Stream listener will pick up the new (default) presets after DB reset
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final modesProvider = StateNotifierProvider<ModesNotifier, ModesState>((ref) {
  final db = ref.watch(databaseProvider);
  return ModesNotifier(db);
});
