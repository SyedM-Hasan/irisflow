import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../viewmodels/eye_strain_viewmodel.dart';

class StrainAnalysisScreen extends ConsumerWidget {
  const StrainAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    final state = ref.watch(eyeStrainProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: Text(
          'Eye Strain Guard',
          style: AppTextStyles.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: -1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTrackingOverview(context, state, c),
              const SizedBox(height: 24),
              _buildVitalitySection(context, state, c),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      'Blink Rate',
                      '${state.blinkRate}',
                      '/min',
                      state.blinkRateTrend,
                      Icons.waves_rounded,
                      c,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      'Openness',
                      '${state.eyeOpenness}',
                      'EAR',
                      state.eyeOpennessTrend,
                      Icons.visibility_rounded,
                      c,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildAIInsights(context, state, c),
              const SizedBox(height: 24),
              _buildActivityLevel(context, state, c),
              const SizedBox(height: 24),
              _buildAutoCorrection(context, state, ref, c),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Dimming',
                      Icons.light_mode_rounded,
                      c,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Font Size',
                      Icons.text_fields_rounded,
                      c,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingOverview(
    BuildContext context,
    EyeStrainState state,
    AppThemeColors c,
  ) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A90E2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ACTIVE TRACKING',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: CustomPaint(
              size: const Size(120, 100),
              painter: _FaceTrackingPainter(c.accent),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              children: [
                _buildCircleIconButton(Icons.fact_check_rounded, c),
                const SizedBox(width: 12),
                _buildCircleIconButton(Icons.visibility_rounded, c),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIconButton(IconData icon, AppThemeColors c) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _buildVitalitySection(
    BuildContext context,
    EyeStrainState state,
    AppThemeColors c,
  ) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 220,
                width: 220,
                child: CustomPaint(
                  painter: _VitalityRadialPainter(
                    progress: state.eyeVitality,
                    color: c.accent,
                    backgroundColor: c.accent.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.eco_rounded, color: c.accent, size: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${(state.eyeVitality * 100).toInt()}',
                        style: AppTextStyles.displayMedium.copyWith(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, left: 2),
                        child: Text(
                          '%',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'EYE VITALITY',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 30,
                right: 30,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: c.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: c.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: c.accent.withValues(alpha: 0.2)),
          ),
          child: Text(
            state.vitalityStatus,
            style: AppTextStyles.labelLarge.copyWith(color: c.accent),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    String unit,
    double trend,
    IconData icon,
    AppThemeColors c,
  ) {
    final isNegative = trend < 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: c.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isNegative
                    ? Icons.trending_down_rounded
                    : Icons.trending_up_rounded,
                color: isNegative ? Colors.orange : c.accent,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '${trend > 0 ? '+' : ''}${(trend * 100).toInt()}%',
                style: AppTextStyles.labelMedium.copyWith(
                  color: isNegative ? Colors.orange : c.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsights(
    BuildContext context,
    EyeStrainState state,
    AppThemeColors c,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: c.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('AI Insights', style: AppTextStyles.titleMedium),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
                ),
                child: Text(
                  'MODERATE STRAIN',
                  style: AppTextStyles.labelMedium.copyWith(color: Colors.orange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RECOMMENDATION',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.4),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.aiRecommendation,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push(AppRoutes.calibration),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('RE-CALIBRATE NOW'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevel(
    BuildContext context,
    EyeStrainState state,
    AppThemeColors c,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '60-second Buffer',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  Text('Activity Level', style: AppTextStyles.titleMedium),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4A90E2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'LIVE',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: const Color(0xFF4A90E2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: state.activityData.map((val) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 100 * val,
                    decoration: BoxDecoration(
                      color: c.accent.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0s', style: AppTextStyles.labelMedium.copyWith(color: Colors.white.withValues(alpha: 0.4))),
              Text('30s', style: AppTextStyles.labelMedium.copyWith(color: Colors.white.withValues(alpha: 0.4))),
              Text('60s', style: AppTextStyles.labelMedium.copyWith(color: Colors.white.withValues(alpha: 0.4))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAutoCorrection(
    BuildContext context,
    EyeStrainState state,
    WidgetRef ref,
    AppThemeColors c,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.sync_rounded, color: c.accent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Auto-Correction', style: AppTextStyles.titleMedium),
                Text(
                  'Dynamic scaling & brightness',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: state.isAutoCorrectionEnabled,
              onChanged: (_) =>
                  ref.read(eyeStrainProvider.notifier).toggleAutoCorrection(),
              activeThumbColor: c.accent,
              activeTrackColor: c.accent.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    AppThemeColors c,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(icon, color: c.accent, size: 28),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}

class _FaceTrackingPainter extends CustomPainter {
  final Color color;
  _FaceTrackingPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Face outline
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2 + 10),
        width: 60,
        height: 70,
      ),
      paint,
    );

    // Eyes
    canvas.drawCircle(Offset(size.width / 2 - 15, size.height / 2 - 5), 10, paint);
    canvas.drawCircle(Offset(size.width / 2 + 15, size.height / 2 - 5), 10, paint);

    // Dotted guide circles
    final dashPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    _drawDashedCircle(canvas, Offset(size.width / 2, size.height / 2), 80, 40, dashPaint);
    _drawDashedCircle(canvas, Offset(size.width / 2, size.height / 2), 100, 50, dashPaint);

    // Highlight tracking points
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width / 2 - 15, size.height / 2 - 5), 3, fillPaint);
    canvas.drawCircle(Offset(size.width / 2 + 15, size.height / 2 - 5), 3, fillPaint);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, int dashes, Paint paint) {
    for (int i = 0; i < dashes; i++) {
      final double startAngle = (2 * math.pi / dashes) * i;
      final double endAngle = startAngle + (math.pi / dashes);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VitalityRadialPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _VitalityRadialPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 12.0;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Add a glow effect
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _VitalityRadialPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
