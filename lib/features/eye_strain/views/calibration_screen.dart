import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../viewmodels/eye_strain_viewmodel.dart';

class CalibrationScreen extends ConsumerStatefulWidget {
  const CalibrationScreen({super.key});

  @override
  ConsumerState<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends ConsumerState<CalibrationScreen>
    with TickerProviderStateMixin {
  late AnimationController _dotController;
  late Animation<Offset> _dotPosition;

  // 6 waypoints the dot visits during step 2 (focus tracking).
  // Normalized (0,0) = top-left, (1,1) = bottom-right of the radar box.
  static const _waypoints = [
    Offset(0.5, 0.5), // center
    Offset(0.5, 0.15), // top
    Offset(0.85, 0.5), // right
    Offset(0.5, 0.85), // bottom
    Offset(0.15, 0.5), // left
    Offset(0.5, 0.5), // back to center
  ];

  @override
  void initState() {
    super.initState();
    _initDotAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eyeStrainProvider.notifier).startCalibration();
    });
  }

  void _initDotAnimation() {
    _dotController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _dotPosition = TweenSequence<Offset>(
      List.generate(_waypoints.length - 1, (i) {
        return TweenSequenceItem(
          tween: Tween(begin: _waypoints[i], end: _waypoints[i + 1])
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        );
      }),
    ).animate(_dotController);
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    final state = ref.watch(eyeStrainProvider);

    // Drive the dot animation only during step 2 (focus tracking).
    if (state.isCalibrating && state.currentStep == 2) {
      if (!_dotController.isAnimating) {
        _dotController.forward(from: 0);
      }
    } else {
      if (_dotController.isAnimating) _dotController.stop();
      if (state.currentStep != 2) _dotController.reset();
    }

    // Auto-close when calibration completes.
    if (state.isCalibrationComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pop();
      });
    }

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Calibration', style: AppTextStyles.headlineSmall),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: AppColors.textPrimary),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'STEP ${state.currentStep} OF ${state.totalSteps}',
                style: AppTextStyles.labelLarge.copyWith(
                  color: c.accent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(state.stepName, style: AppTextStyles.headlineMedium),
                  Text(
                    '${(state.calibrationProgress * 100).toInt()}%',
                    style: AppTextStyles.labelLarge.copyWith(color: c.accent),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: state.calibrationProgress,
                  minHeight: 8,
                  backgroundColor: AppColors.cardLight,
                  valueColor: AlwaysStoppedAnimation<Color>(c.accent),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.sensors, color: c.accent, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'System tracking active',
                    style:
                        AppTextStyles.labelMedium.copyWith(color: c.accent),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              EyeCalibrationRadar(
                dotPositionAnimation: _dotPosition,
                isTracking: state.currentStep == 2 && state.isCalibrating,
                accentColor: c.accent,
              ),
              const Spacer(),
              Center(
                child: Text(
                  _headingForStep(state.currentStep),
                  style: AppTextStyles.displayMedium,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _instructionForStep(state.currentStep),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: c.accent.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info, color: c.accent, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Stay still for ${state.remainingSeconds} more seconds',
                      style: AppTextStyles.labelLarge.copyWith(color: c.accent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _headingForStep(int step) => switch (step) {
        1 => 'Keep Head Still',
        2 => 'Follow The Dot',
        _ => 'Blink Naturally',
      };

  String _instructionForStep(int step) => switch (step) {
        1 =>
          'Relax your facial muscles and look directly at the center dot. '
              'We are mapping your natural eye openness.',
        2 =>
          'Follow the moving green dot with your eyes only — keep your head still. '
              'This maps your full eye range.',
        _ =>
          'Blink naturally and relax your gaze on the center dot. '
              'We are recording your relaxed eye state.',
      };

  void _showHelpDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Calibration Help'),
        content: const Text(
          'Calibration records your personal eye baseline so the AI can accurately '
          'detect fatigue for you specifically.\n\n'
          '• Step 1: Look straight ahead — neutral state\n'
          '• Step 2: Follow the moving dot — range mapping\n'
          '• Step 3: Blink normally — relaxed state\n\n'
          'Takes ~30 seconds. Sit 40–70 cm from your screen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class EyeCalibrationRadar extends StatelessWidget {
  final Animation<Offset> dotPositionAnimation;
  final bool isTracking;
  final Color accentColor;

  const EyeCalibrationRadar({
    super.key,
    required this.dotPositionAnimation,
    required this.isTracking,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Stack(
        children: [
          CustomPaint(
            painter: _RadarPainter(accentColor: accentColor),
            size: const Size(double.infinity, 300),
          ),
          // Animated dot during step 2, static center dot otherwise
          if (isTracking)
            AnimatedBuilder(
              animation: dotPositionAnimation,
              builder: (context, _) {
                return _TrackerDot(
                  position: dotPositionAnimation.value,
                  color: accentColor,
                );
              },
            )
          else
            _TrackerDot(
              position: const Offset(0.5, 0.5),
              color: accentColor,
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                isTracking ? 'FOLLOW THE DOT' : 'LOOK AT CENTER',
                style: AppTextStyles.labelMedium.copyWith(
                  color: accentColor,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dot widget positioned using fractional [Offset] inside a [LayoutBuilder].
class _TrackerDot extends StatelessWidget {
  final Offset position;
  final Color color;

  const _TrackerDot({required this.position, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const dotSize = 48.0;
        const innerSize = 18.0;
        final x = constraints.maxWidth * position.dx - dotSize / 2;
        final y = constraints.maxHeight * position.dy - dotSize / 2;

        return Stack(
          children: [
            Positioned(
              left: x,
              top: y,
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.15),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: innerSize,
                  height: innerSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.6),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Color accentColor;

  _RadarPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = accentColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (final radius in [50.0, 90.0, 130.0]) {
      canvas.drawCircle(center, radius, paint);
    }

    // Cross-hairs
    final crossPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      crossPaint,
    );
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      crossPaint,
    );

    final borderPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(24),
    );
    _drawDashedRRect(canvas, rect, borderPaint);
  }

  void _drawDashedRRect(Canvas canvas, RRect rrect, Paint paint) {
    final path = Path()..addRRect(rrect);
    final dashPath = Path();
    const double dashWidth = 8;
    const double dashSpace = 8;

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.accentColor != accentColor;
}

