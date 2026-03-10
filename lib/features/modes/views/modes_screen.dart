import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../models/modes_state.dart';
import '../viewmodels/modes_viewmodel.dart';

class ModesScreen extends ConsumerWidget {
  const ModesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Text('Focus Modes', style: AppTextStyles.displayMedium),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 20),
                    _ActiveModeBanner(),
                    _PresetsSection(),
                    SizedBox(height: 4),
                    _CreatePresetButton(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}

// ---------------------------------------------------------------------------
// Active Mode Banner
// ---------------------------------------------------------------------------

class _ActiveModeBanner extends ConsumerWidget {
  const _ActiveModeBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    final state = ref.watch(modesProvider);
    final notifier = ref.read(modesProvider.notifier);
    final active = state.activePreset;

    if (active == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [c.card, c.cardLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.accent, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c.accentSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.play_circle_outline, color: c.accent, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Mode', style: AppTextStyles.bodySmall),
                  Text(active.title, style: AppTextStyles.titleLarge),
                  Text(active.description, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => notifier.selectPreset(state.activePresetIndex),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Presets List
// ---------------------------------------------------------------------------

class _PresetsSection extends ConsumerWidget {
  const _PresetsSection();

  IconData _iconFor(int i, bool isCustom) {
    if (isCustom) return Icons.tune_rounded;
    return i == 0
        ? Icons.psychology_rounded
        : i == 1
        ? Icons.brush_rounded
        : Icons.bolt_rounded;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    final state = ref.watch(modesProvider);
    final notifier = ref.read(modesProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Focus Presets', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 6),
        Text(
          'Choose a rhythm that fits your current task',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 16),
        ...List.generate(state.presets.length, (i) {
          final p = state.presets[i];
          final active = state.isActive(i);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => notifier.selectPreset(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: active ? c.accent : c.divider,
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    colors: active ? [c.card, c.cardLight] : [c.card, c.card],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: active ? c.accentSubtle : c.cardLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _iconFor(i, p.isCustom),
                          color: active ? c.accent : AppColors.textSecondary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    p.title,
                                    style: AppTextStyles.headlineSmall,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: active ? c.accent : c.cardLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    p.rule,
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: active
                                          ? Colors.black
                                          : AppColors.textMuted,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(p.description, style: AppTextStyles.bodySmall),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _MiniStatChip(
                                  label: 'Focus',
                                  value: '${p.focusMin}m',
                                  active: active,
                                ),
                                const SizedBox(width: 8),
                                _MiniStatChip(
                                  label: 'Break',
                                  value: '${p.breakMin}m',
                                  active: false,
                                ),
                                if (p.isCustom) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => notifier.removePreset(i),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppColors.error,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        active
                            ? Icons.check_circle_rounded
                            : Icons.chevron_right_rounded,
                        color: active ? c.accent : c.navInactive,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _MiniStatChip extends StatelessWidget {
  final String label, value;
  final bool active;
  const _MiniStatChip({
    required this.label,
    required this.value,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? c.accentSubtle : c.cardLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
          ),
          Text(
            value,
            style: AppTextStyles.labelLarge.copyWith(
              color: active ? c.accent : AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Create Preset Button
// ---------------------------------------------------------------------------

class _CreatePresetButton extends StatelessWidget {
  const _CreatePresetButton();

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    return OutlinedButton.icon(
      onPressed: () => _showCreateSheet(context),
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text('Create Custom Preset'),
      style: OutlinedButton.styleFrom(
        foregroundColor: c.accent,
        side: BorderSide(color: c.accentGlow),
        backgroundColor: c.accentSubtle,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreatePresetSheet(),
    );
  }
}

// ---------------------------------------------------------------------------
// Create Preset Bottom Sheet
// ---------------------------------------------------------------------------

class _CreatePresetSheet extends ConsumerStatefulWidget {
  const _CreatePresetSheet();

  @override
  ConsumerState<_CreatePresetSheet> createState() => _CreatePresetSheetState();
}

class _CreatePresetSheetState extends ConsumerState<_CreatePresetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  int _focusMin = 25;
  int _breakMin = 5;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleCtrl.text.trim();
    final rule = '$_focusMin/$_breakMin rule';
    final desc = '$_focusMin mins focus, $_breakMin mins break';
    ref
        .read(modesProvider.notifier)
        .addPreset(
          FocusPreset(
            title: title,
            rule: rule,
            description: desc,
            focusMin: _focusMin,
            breakMin: _breakMin,
            isCustom: true,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    final mq = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------- Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.navInactive,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ----------- Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.accentSubtle,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.tune_rounded, color: c.accent, size: 22),
                ),
                const SizedBox(width: 12),
                Text('New Custom Preset', style: AppTextStyles.headlineMedium),
              ],
            ),
            const SizedBox(height: 24),

            // ----------- Preset Name
            Text('Preset Name', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleCtrl,
              autofocus: true,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: 'e.g. Deep Focus',
                hintStyle: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: c.cardLight,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: c.accent, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 1.5,
                  ),
                ),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 24),

            // ----------- Focus Duration slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Focus Duration', style: AppTextStyles.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: c.accentSubtle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_focusMin min',
                    style: AppTextStyles.labelLarge.copyWith(color: c.accent),
                  ),
                ),
              ],
            ),
            Slider(
              value: _focusMin.toDouble(),
              min: 5,
              max: 90,
              divisions: 17,
              label: '$_focusMin min',
              onChanged: (v) => setState(() => _focusMin = v.round()),
            ),
            const SizedBox(height: 8),

            // ----------- Break Duration slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Break Duration', style: AppTextStyles.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: c.cardLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_breakMin min',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _breakMin.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: '$_breakMin min',
              onChanged: (v) => setState(() => _breakMin = v.round()),
            ),
            const SizedBox(height: 24),

            // ----------- Preview chip
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: c.cardLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.divider),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.preview_rounded,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$_focusMin mins focus · $_breakMin mins break',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ----------- Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(color: c.divider),
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text('Save Preset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.accent,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
