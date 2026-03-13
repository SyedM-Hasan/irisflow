import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../shared/widgets/app_card.dart';
import '../viewmodels/eye_strain_viewmodel.dart';

class StrainAnalysisScreen extends ConsumerWidget {
  const StrainAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    final state = ref.watch(eyeStrainProvider);
    final controller = ref.read(eyeStrainProvider.notifier);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Eye Strain Guard', style: AppTextStyles.titleLarge),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: state.isActiveTracking ? c.accentSubtle : c.cardLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.visibility_rounded,
                  size: 14,
                  color: state.isActiveTracking
                      ? c.accent
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  state.isActiveTracking ? 'Active' : 'Paused',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: state.isActiveTracking
                        ? c.accent
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildVitalityCard(context, state, c),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      title: 'Blink Rate',
                      value: Text(
                        '${state.blinkRate}/min',
                        style: AppTextStyles.headlineMedium,
                      ),
                      trend: _buildTrendBadge(state.blinkRateTrend, c),
                      c: c,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      title: 'Openness',
                      value: Text(
                        '${state.eyeOpenness} EAR',
                        style: AppTextStyles.headlineMedium,
                      ),
                      trend: _buildTrendBadge(state.eyeOpennessTrend, c),
                      c: c,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInsightsCard(context, state, c),
              const SizedBox(height: 24),
              _buildAutoCorrectionToggle(context, state, controller, c),
              const SizedBox(height: 40),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    context.push('/calibration');
                  },
                  icon: Icon(Icons.tune_rounded, color: c.accent),
                  label: Text(
                    'Recalibrate Neutral Eye',
                    style: AppTextStyles.labelLarge.copyWith(color: c.accent),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: c.accentSubtle),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      // Set to 2 if we mapped it into a specific index, or leave it to rely on go_router / active route.
      // AppBottomNavBar currently matches route. Since this is an overlay-type or specific tab,
      // let's pass a dummy index (-1) so no tab is highlighted, or if it replaces "Guard" tab
      bottomNavigationBar: const AppBottomNavBar(currentIndex: -1),
    );
  }

  Widget _buildVitalityCard(
    BuildContext context,
    EyeStrainState state,
    AppThemeColors c,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.card, c.cardLight],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.accentSubtle, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: c.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              state.vitalityStatus,
              style: AppTextStyles.labelLarge.copyWith(color: c.accent),
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: CircularProgressIndicator(
                  value: 0.85, // Mock high vitality
                  strokeWidth: 12,
                  backgroundColor: c.background,
                  valueColor: AlwaysStoppedAnimation<Color>(c.accent),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '85%',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text('Vitality', style: AppTextStyles.bodyMedium),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required Widget value,
    required Widget trend,
    required AppThemeColors c,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 12),
          value,
          const SizedBox(height: 12),
          trend,
        ],
      ),
    );
  }

  Widget _buildTrendBadge(double trendValue, AppThemeColors c) {
    final isPositive = trendValue >= 0;
    final color = isPositive ? c.accent : AppColors.error;
    final icon = isPositive
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;
    final text =
        '${isPositive ? '+' : ''}${(trendValue * 100).toStringAsFixed(0)}%';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.labelMedium.copyWith(color: color)),
      ],
    );
  }

  Widget _buildInsightsCard(
    BuildContext context,
    EyeStrainState state,
    AppThemeColors c,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: c.accent, size: 20),
              const SizedBox(width: 8),
              Text('AI Insights', style: AppTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Recommendation',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.aiRecommendation,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoCorrectionToggle(
    BuildContext context,
    EyeStrainState state,
    EyeStrainViewModel controller,
    AppThemeColors c,
  ) {
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Auto-Correction', style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Dynamic scaling & brightness',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: state.isAutoCorrectionEnabled,
            onChanged: (_) => controller.toggleAutoCorrection(),
            activeThumbColor: c.accent,
            activeTrackColor: c.accentSubtle,
            inactiveTrackColor: c.background,
            inactiveThumbColor: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
