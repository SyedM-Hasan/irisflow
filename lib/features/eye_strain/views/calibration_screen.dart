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

class _CalibrationScreenState extends ConsumerState<CalibrationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eyeStrainProvider.notifier).startCalibration();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    final state = ref.watch(eyeStrainProvider);

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
        title: Text(
          'Calibration',
          style: AppTextStyles.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: AppColors.textPrimary),
            onPressed: () {},
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
              // Step counter
              Text(
                'STEP ${state.currentStep} OF ${state.totalSteps}',
                style: AppTextStyles.labelLarge.copyWith(
                  color: c.accent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              // Title and percentage row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.stepName,
                    style: AppTextStyles.headlineMedium,
                  ),
                  Text(
                    '${(state.calibrationProgress * 100).toInt()}%',
                    style: AppTextStyles.labelLarge.copyWith(color: c.accent),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Linear Progress Bar
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
              // Status row
              Row(
                children: [
                  Icon(Icons.sensors, color: c.accent, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'System tracking active',
                    style: AppTextStyles.labelMedium.copyWith(color: c.accent),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Radar Calibration Box
              const EyeCalibrationRadar(),
              const Spacer(),
              // Bottom Instruction
              Center(
                child: Text(
                  'Keep Head Still',
                  style: AppTextStyles.displayMedium,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Relax your facial muscles and follow the moving green dot with your eyes only.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Time bar
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
}

class EyeCalibrationRadar extends StatelessWidget {
  const EyeCalibrationRadar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    return Container(
      height: 320,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _RadarPainter(accentColor: c.accent),
            size: const Size(double.infinity, 320),
          ),
          // Center dot with glow
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.accent.withValues(alpha: 0.1),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.accent,
                boxShadow: [
                  BoxShadow(
                    color: c.accent.withValues(alpha: 0.6),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            child: Text(
              'FOLLOW THE DOT',
              style: AppTextStyles.labelMedium.copyWith(
                color: c.accent,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
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

    // Draw concentric circles
    final radii = [50.0, 90.0, 130.0];
    for (var radius in radii) {
      canvas.drawCircle(center, radius, paint);
    }

    // Draw dashed rounded border
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
    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();
    const double dashWidth = 8;
    const double dashSpace = 8;
    
    for (final PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

