import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../shared/widgets/app_card.dart';
import '../../modes/viewmodels/modes_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('IrisFlow', style: AppTextStyles.displayMedium),
                      Text(
                        'Ready to begin your flow?',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: c.card,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 20),
                    _TimerCard(),
                    SizedBox(height: 24),
                    _TodayStats(),
                    SizedBox(height: 24),
                    _PresetsSection(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

// ---------------------------------------------------------------------------
// Timer Card
// ---------------------------------------------------------------------------

class _TimerCard extends ConsumerWidget {
  const _TimerCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    final modes = ref.watch(modesProvider);
    if (modes.presets.isEmpty) return const SizedBox.shrink();
    final presetIndex = state.selectedPresetIndex;
    final preset = (presetIndex >= 0 && presetIndex < modes.presets.length)
        ? modes.presets[presetIndex]
        : modes.presets[0];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.card, c.cardLight],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.accentGlow, width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(preset.title, style: AppTextStyles.headlineSmall),
                  Text(preset.rule, style: AppTextStyles.bodySmall),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: c.accentSubtle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: c.accentGlow),
                ),
                child: Text(
                  _badgeLabel(state),
                  style: AppTextStyles.labelLarge.copyWith(
                    color: c.accent,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 200,
            height: 200,
            child: CustomPaint(
              painter: _TimerPainter(
                progress: notifier.progress,
                accent: c.accent,
                track: c.cardLight,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      notifier.timeDisplay,
                      style: AppTextStyles.timerDisplay,
                    ),
                    Text(_timerSubtitle(state), style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.timerState != TimerState.idle)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: notifier.stopTimer,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: c.cardLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.stop_rounded,
                        color: AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: notifier.toggleTimer,
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: c.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: c.accentGlow,
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    state.timerState == TimerState.running
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.black,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: notifier.toggleAutoMode,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: state.isAutoMode ? c.accentSubtle : c.cardLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: state.isAutoMode ? c.accentGlow : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.repeat_rounded,
                    size: 16,
                    color: state.isAutoMode
                        ? c.accent
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Auto Cycle',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: state.isAutoMode
                          ? c.accent
                          : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _badgeLabel(HomeState state) {
    if (state.timerState == TimerState.idle &&
        state.timerPhase == TimerPhase.focus) {
      return 'READY';
    }
    switch (state.timerPhase) {
      case TimerPhase.focus:
        return 'FOCUS';
      case TimerPhase.ready:
        return 'PREP';
      case TimerPhase.rest:
        return 'REST';
    }
  }

  String _timerSubtitle(HomeState state) {
    if (state.timerState == TimerState.idle &&
        state.timerPhase == TimerPhase.focus) {
      return 'Ready';
    }
    switch (state.timerPhase) {
      case TimerPhase.focus:
        return 'Focus Time';
      case TimerPhase.ready:
        return 'Get Ready...';
      case TimerPhase.rest:
        return 'Rest Time';
    }
  }
}

class _TimerPainter extends CustomPainter {
  final double progress;
  final Color accent;
  final Color track;

  _TimerPainter({
    required this.progress,
    required this.accent,
    required this.track,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 6;
    const startAngle = -math.pi / 2;
    const sweepAngle = 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    if (progress > 0) {
      final lighter = Color.lerp(accent, Colors.white, 0.35) ?? accent;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweepAngle * progress,
        false,
        Paint()
          ..shader =
              SweepGradient(
                startAngle: startAngle,
                endAngle: startAngle + sweepAngle,
                colors: [accent, lighter],
                stops: const [0, 1],
                transform: const GradientRotation(-math.pi / 2),
              ).createShader(
                Rect.fromCircle(center: Offset(cx, cy), radius: radius),
              )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_TimerPainter old) =>
      old.progress != progress || old.accent != accent || old.track != track;
}

// ---------------------------------------------------------------------------
// Today's Stats
// ---------------------------------------------------------------------------

class _TodayStats extends ConsumerWidget {
  const _TodayStats();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    final state = ref.watch(homeProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Stats", style: AppTextStyles.titleMedium),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatBadge(
                icon: Icons.access_time_rounded,
                value: state.focusHours < 1
                    ? '${(state.focusHours * 60).round()}min'
                    : '${state.focusHours.toStringAsFixed(1)}h',
                label: 'Focus Time',
              ),
              Container(width: 1, height: 40, color: c.divider),
              StatBadge(
                icon: Icons.check_circle_outline_rounded,
                value: '${state.sessionsCompleted}',
                label: 'Sessions',
              ),
              Container(width: 1, height: 40, color: c.divider),
              StatBadge(
                icon: Icons.local_fire_department_rounded,
                value: '${state.streakDays}',
                label: 'Day Streak',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Presets Section
// ---------------------------------------------------------------------------

class _PresetsSection extends ConsumerWidget {
  const _PresetsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    final modes = ref.watch(modesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Focus Presets', trailing: 'See all'),
        ...List.generate(modes.presets.length, (i) {
          final preset = modes.presets[i];
          final isSelected = state.selectedPresetIndex == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              hasBorder: isSelected,
              onTap: () => notifier.selectPreset(i),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: isSelected ? c.accentSubtle : c.cardLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      i == 0
                          ? Icons.psychology_rounded
                          : i == 1
                          ? Icons.brush_rounded
                          : Icons.bolt_rounded,
                      color: isSelected ? c.accent : AppColors.textSecondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(preset.title, style: AppTextStyles.titleMedium),
                        Text(
                          preset.description,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? c.accent : c.cardLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      preset.rule,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isSelected ? Colors.black : AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
