import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../shared/widgets/app_card.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: c.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('Settings', style: AppTextStyles.displayMedium),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const _TimerPrefsSection(),
                    const SizedBox(height: 20),
                    const _NotificationsSection(),
                    const SizedBox(height: 20),
                    const _AppearanceSection(),
                    const SizedBox(height: 20),
                    const _AboutSection(),
                    const SizedBox(height: 20),
                    const _DangerZoneSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}

// ---------------------------------------------------------------------------
// Timer Preferences
// ---------------------------------------------------------------------------

class _TimerPrefsSection extends ConsumerWidget {
  const _TimerPrefsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Timer Preferences'),
        AppCard(
          child: Column(
            children: [
              _DurationControl(
                label: 'Focus Duration',
                value: state.focusDuration,
                unit: 'minutes',
                onInc: notifier.incrementFocus,
                onDec: notifier.decrementFocus,
              ),
              const Divider(height: 24),
              _DurationControl(
                label: 'Rest Duration',
                value: state.restDuration,
                unit: 'minutes',
                onInc: notifier.incrementRest,
                onDec: notifier.decrementRest,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Notifications
// ---------------------------------------------------------------------------

class _NotificationsSection extends ConsumerWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Notifications'),
        AppCard(
          child: Column(
            children: [
              _SwitchRow(
                icon: Icons.volume_up_outlined,
                title: 'Sound Alerts',
                value: state.soundAlerts,
                onChanged: (_) => notifier.toggleSoundAlerts(),
              ),
              const Divider(height: 24),
              _SwitchRow(
                icon: Icons.brightness_4_rounded,
                title: 'Gentle Dimming',
                subtitle: 'Screen fades as timer ends',
                value: state.gentleDimming,
                onChanged: (_) => notifier.toggleGentleDimming(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Appearance
// ---------------------------------------------------------------------------

class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  Color _themeColor(String name, AppThemeColors palette) {
    if (name.contains('Sage')) return palette.accent;
    if (name.contains('Ocean')) return const Color(0xFF4A90E2);
    if (name.contains('Sunset')) return const Color(0xFFF5A623);
    return palette.accent;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final c = context.themeColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Appearance'),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: c.cardLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.palette_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('Theme Selection', style: AppTextStyles.titleMedium),
                ],
              ),
              const SizedBox(height: 14),
              ...state.themes.map((t) {
                final selected = state.selectedTheme == t;
                final tColor = _themeColor(t, c);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => notifier.selectTheme(t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? c.accentSubtle : c.cardLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected ? c.accent : c.divider,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: tColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(t, style: AppTextStyles.bodyLarge),
                          const Spacer(),
                          if (selected)
                            Icon(
                              Icons.check_rounded,
                              color: c.accent,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// About
// ---------------------------------------------------------------------------

class _AboutSection extends ConsumerWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'About'),
        AppCard(
          child: Column(
            children: [
              _InfoRow(title: 'Version', trailing: state.appVersion),
              const Divider(height: 20),
              const _InfoRow(
                title: 'Privacy Policy',
                trailing: null,
                hasChevron: true,
              ),
              const Divider(height: 20),
              const _InfoRow(
                title: 'Terms of Service',
                trailing: null,
                hasChevron: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared sub-widgets
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: AppTextStyles.headlineSmall),
    );
  }
}

class _DurationControl extends StatelessWidget {
  final String label, unit;
  final int value;
  final VoidCallback onInc, onDec;

  const _DurationControl({
    required this.label,
    required this.value,
    required this.unit,
    required this.onInc,
    required this.onDec,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.titleMedium),
            Text('$value $unit', style: AppTextStyles.bodySmall),
          ],
        ),
        Row(
          children: [
            _StepButton(icon: Icons.remove, onTap: onDec),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                '$value',
                style: AppTextStyles.headlineMedium.copyWith(color: c.accent),
              ),
            ),
            _StepButton(icon: Icons.add, onTap: onInc),
          ],
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: c.cardLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.divider),
        ),
        child: Icon(icon, color: c.accent, size: 20),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: c.cardLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              if (subtitle != null)
                Text(subtitle!, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String? trailing;
  final bool hasChevron;

  const _InfoRow({required this.title, this.trailing, this.hasChevron = false});

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        Row(
          children: [
            if (trailing != null)
              Text(trailing!, style: AppTextStyles.bodySmall),
            if (hasChevron)
              Icon(Icons.chevron_right_rounded, color: c.navInactive, size: 22),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Danger Zone
// ---------------------------------------------------------------------------

class _DangerZoneSection extends ConsumerWidget {
  const _DangerZoneSection();

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.themeColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reset All Data?', style: AppTextStyles.headlineSmall),
        content: Text(
          'This will permanently delete all your custom presets, focus history, and personal information. This action cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: () async {
                await ref.read(settingsProvider.notifier).resetAllData();
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('App data has been reset.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Reset Everything'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Danger Zone'),
        AppCard(
          child: ListTile(
            onTap: () => _showResetDialog(context, ref),
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: AppColors.error,
                size: 22,
              ),
            ),
            title: Text(
              'Reset App Data',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.error),
            ),
            subtitle: Text(
              'Clear all history and custom presets',
              style: AppTextStyles.bodySmall,
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: c.navInactive,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
