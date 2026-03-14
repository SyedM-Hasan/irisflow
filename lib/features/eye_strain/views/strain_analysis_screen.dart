import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../viewmodels/eye_strain_viewmodel.dart';

class StrainAnalysisScreen extends ConsumerStatefulWidget {
  const StrainAnalysisScreen({super.key});

  @override
  ConsumerState<StrainAnalysisScreen> createState() =>
      _StrainAnalysisScreenState();
}

class _StrainAnalysisScreenState extends ConsumerState<StrainAnalysisScreen> {
  bool _showRefreshOverlay = false;

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    final state = ref.watch(eyeStrainProvider);

    // Hide overlay once analysis finishes.
    ref.listen(
      eyeStrainProvider.select((s) => s.isAnalyzing),
      (wasAnalyzing, isAnalyzing) {
        if (wasAnalyzing == true && !isAnalyzing && _showRefreshOverlay) {
          setState(() => _showRefreshOverlay = false);
        }
      },
    );

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Eye Strain Guard', style: AppTextStyles.titleLarge),
        centerTitle: true,
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: -1),
      body: Stack(
        children: [
          _buildAdaptiveUIWrapper(
            context,
            ref,
            state,
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          ),
          if (state.isBreakOverlayVisible) _buildBreakOverlay(context, ref, c),
          if (_showRefreshOverlay)
            _AnalyzingOverlay(accentColor: c.accent),
        ],
      ),
    );
  }

  Widget _buildAdaptiveUIWrapper(
    BuildContext context,
    WidgetRef ref,
    EyeStrainState state,
    Widget child,
  ) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(state.textScaleMultiplier)),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.orange.withValues(alpha: state.warmthFilterIntensity),
          BlendMode.darken,
        ),
        child: Stack(
          children: [
            child,
            IgnorePointer(
              child: Container(
                color: Colors.black.withValues(
                  alpha: state.brightnessOverlayOpacity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakOverlay(
    BuildContext context,
    WidgetRef ref,
    AppThemeColors c,
  ) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.timer_rounded,
                  color: Colors.orangeAccent,
                  size: 64,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'TIME FOR A BREAK',
                style: AppTextStyles.titleLarge.copyWith(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your eyes show high strain levels. Follow the 20-20-20 rule now.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () =>
                    ref.read(eyeStrainProvider.notifier).dismissBreakOverlay(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("I'M BACK"),
              ),
            ],
          ),
        ),
      ),
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
                  child: const Icon(Icons.check, color: Colors.black, size: 14),
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
            state.strainLevel.label,
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
                  height: 1.5,
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
                  height: 1.5,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: state.strainLevel.badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: state.strainLevel.badgeColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  state.strainLevel.badge,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: state.strainLevel.badgeColor,
                  ),
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
                    onPressed: () async {
                      final didCalibrate =
                          await context.push<bool>(AppRoutes.calibration);
                      if ((didCalibrate ?? false) && mounted) {
                        setState(() => _showRefreshOverlay = true);
                        ref
                            .read(eyeStrainProvider.notifier)
                            .acknowledgeCalibration();
                      }
                    },
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
              Text(
                '0s',
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
              Text(
                '30s',
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
              Text(
                '60s',
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
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
                    height: 1.5,
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

// ── Post-calibration analyzing overlay ─────────────────────────────────────────

class _AnalyzingOverlay extends StatefulWidget {
  final Color accentColor;
  const _AnalyzingOverlay({required this.accentColor});

  @override
  State<_AnalyzingOverlay> createState() => _AnalyzingOverlayState();
}

class _AnalyzingOverlayState extends State<_AnalyzingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scale = Tween(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
      child: Container(
        color: Colors.black.withValues(alpha: 0.65),
        alignment: Alignment.center,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: accent.withValues(alpha: 0.35),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.12),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accent.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.remove_red_eye_rounded,
                    color: accent,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'RE-ANALYZING',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: accent,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Applying new calibration baseline\nto your eye strain profile.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.55),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                _DotsIndicator(color: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatefulWidget {
  final Color color;
  const _DotsIndicator({required this.color});

  @override
  State<_DotsIndicator> createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<_DotsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, unused) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = ((_controller.value - i / 3) % 1.0 + 1.0) % 1.0;
            final opacity = (phase < 0.5 ? phase * 2 : (1.0 - phase) * 2)
                .clamp(0.2, 1.0);
            final size = 6.0 + opacity * 4;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ── Painters ──────────────────────────────────────────────────────────────────

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
    canvas.drawCircle(
      Offset(size.width / 2 - 15, size.height / 2 - 5),
      10,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width / 2 + 15, size.height / 2 - 5),
      10,
      paint,
    );

    // Dotted guide circles
    final dashPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    _drawDashedCircle(
      canvas,
      Offset(size.width / 2, size.height / 2),
      80,
      40,
      dashPaint,
    );
    _drawDashedCircle(
      canvas,
      Offset(size.width / 2, size.height / 2),
      100,
      50,
      dashPaint,
    );

    // Highlight tracking points
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2 - 15, size.height / 2 - 5),
      3,
      fillPaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2 + 15, size.height / 2 - 5),
      3,
      fillPaint,
    );
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    int dashes,
    Paint paint,
  ) {
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

    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );
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
