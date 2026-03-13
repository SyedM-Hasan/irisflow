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

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Calibration', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text('Neutral Eye Mapping', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 48),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(
                      value: ref.watch(
                        eyeStrainProvider.select((s) => s.calibrationProgress),
                      ),
                      strokeWidth: 4,
                      backgroundColor: c.accent.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(c.accent),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(ref.watch(eyeStrainProvider.select((s) => s.calibrationProgress)) * 100).toInt()}%',
                        style: AppTextStyles.displayMedium,
                      ),
                      Text(
                        'System tracking active',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white.withValues(alpha: 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: c.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.remove_red_eye_rounded,
                      color: c.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Follow the Dot',
                      style: AppTextStyles.labelLarge.copyWith(color: c.accent),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text('Keep Head Still', style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              Text(
                'Relax your facial muscles and follow the moving green dot with your eyes only.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                'Stay still for ${ref.watch(eyeStrainProvider.select((s) => s.remainingSeconds))} more seconds',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textDisabled,
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
