import 'dart:io';
import 'dart:ui' show ImageFilter;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../services/ear_detection_service.dart';
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

  static const _waypoints = [
    Offset(0.5, 0.5),
    Offset(0.5, 0.18),
    Offset(0.82, 0.5),
    Offset(0.5, 0.82),
    Offset(0.18, 0.5),
    Offset(0.5, 0.5),
  ];

  @override
  void initState() {
    super.initState();
    _initDotAnimation();
    if (EarDetectionService.isSupported) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(eyeStrainProvider.notifier).startCalibration();
      });
    }
  }

  void _initDotAnimation() {
    _dotController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _dotPosition = TweenSequence<Offset>(
      List.generate(_waypoints.length - 1, (i) {
        return TweenSequenceItem(
          tween: Tween(
            begin: _waypoints[i],
            end: _waypoints[i + 1],
          ).chain(CurveTween(curve: Curves.easeInOut)),
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

    // Camera + ML Kit are unavailable on Linux/desktop — show a notice and
    // let the user navigate back instead of starting a broken calibration.
    if (!EarDetectionService.isSupported) {
      return _buildUnsupportedPlatformScreen(context, c);
    }

    final state = ref.watch(eyeStrainProvider);
    final isTracking = state.currentStep == 2 && state.isCalibrating;

    if (isTracking) {
      if (!_dotController.isAnimating) _dotController.forward(from: 0);
    } else {
      if (_dotController.isAnimating) _dotController.stop();
      if (state.currentStep != 2) _dotController.reset();
    }

    if (state.isCalibrationComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pop(true); // true signals successful completion
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
                    style: AppTextStyles.labelMedium.copyWith(color: c.accent),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // ── Camera + Radar overlay box ────────────────────────────────
              _CameraRadarBox(
                accentColor: c.accent,
                isCameraReady: state.isCameraReady,
                cameraController: EarDetectionService.instance.cameraController,
                dotPositionAnimation: _dotPosition,
                isTracking: isTracking,
                isFaceDetected: state.isFaceDetected,
                isEyeTracking: state.isEyeTracking,
                isDetectionPaused: state.isDetectionPaused,
                leftEyeOpen: state.leftEyeOpen,
                rightEyeOpen: state.rightEyeOpen,
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

  Widget _buildUnsupportedPlatformScreen(
    BuildContext context,
    AppThemeColors c,
  ) {
    final platform = Platform.isLinux
        ? 'Linux'
        : Platform.isWindows
        ? 'Windows'
        : 'this platform';

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Calibration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: c.card,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.videocam_off_rounded,
                  color: c.accent.withValues(alpha: 0.6),
                  size: 48,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Not Available on $platform',
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Eye calibration requires a front-facing camera and ML Kit '
                'face detection, which are only supported on Android and iOS.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

// ── Camera + Radar overlay ─────────────────────────────────────────────────────

class _CameraRadarBox extends StatelessWidget {
  final Color accentColor;
  final bool isCameraReady;
  final CameraController? cameraController;
  final Animation<Offset> dotPositionAnimation;
  final bool isTracking;
  final bool isFaceDetected;
  final bool isEyeTracking;
  final bool isDetectionPaused;
  final double leftEyeOpen;
  final double rightEyeOpen;

  const _CameraRadarBox({
    required this.accentColor,
    required this.isCameraReady,
    required this.cameraController,
    required this.dotPositionAnimation,
    required this.isTracking,
    required this.isFaceDetected,
    required this.isEyeTracking,
    required this.isDetectionPaused,
    required this.leftEyeOpen,
    required this.rightEyeOpen,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1 ── Camera preview or loading state
            isCameraReady && cameraController != null
                ? CameraPreview(cameraController!)
                : _buildCameraLoading(),

            // 2 ── Dark scrim for overlay readability
            Container(color: Colors.black.withValues(alpha: 0.38)),

            // 3 ── Radar concentric circles + dashed border
            CustomPaint(painter: _RadarPainter(accentColor: accentColor)),

            // 4 ── Animated dot (step 2) or static center dot
            if (isTracking)
              AnimatedBuilder(
                animation: dotPositionAnimation,
                builder: (context, _) => _TrackerDot(
                  position: dotPositionAnimation.value,
                  color: accentColor,
                ),
              )
            else
              _TrackerDot(position: const Offset(0.5, 0.5), color: accentColor),

            // 5 ── Face + eye tracking badge (top-right)
            Positioned(
              top: 12,
              right: 12,
              child: _FaceDetectedBadge(
                faceDetected: isFaceDetected,
                eyeTracking: isEyeTracking,
              ),
            ),

            // 6 ── Eye openness bars (bottom validation — only when tracking)
            if (isFaceDetected && isEyeTracking && !isDetectionPaused)
              Positioned(
                bottom: 42,
                left: 14,
                right: 14,
                child: _EyeOpenBars(
                  leftOpen: leftEyeOpen,
                  rightOpen: rightEyeOpen,
                  accentColor: accentColor,
                ),
              ),

            // 7 ── Bottom label
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  isDetectionPaused
                      ? 'MOVE CLOSER TO RESUME'
                      : (isFaceDetected && !isEyeTracking)
                      ? 'ALIGN EYES WITH CAMERA'
                      : isTracking
                      ? 'FOLLOW THE DOT'
                      : 'LOOK AT CENTER',
                  style: AppTextStyles.labelMedium.copyWith(
                    color:
                        isDetectionPaused || (isFaceDetected && !isEyeTracking)
                        ? const Color(0xFFF2C94C)
                        : accentColor,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // 8 ── Full-box paused overlay
            if (isDetectionPaused) const _PausedOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraLoading() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: accentColor,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Starting camera…',
              style: AppTextStyles.labelMedium.copyWith(
                color: accentColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Face detected badge ────────────────────────────────────────────────────────

class _FaceDetectedBadge extends StatelessWidget {
  final bool faceDetected;
  final bool eyeTracking;

  const _FaceDetectedBadge({
    required this.faceDetected,
    required this.eyeTracking,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    if (!faceDetected) {
      color = const Color(0xFFEB7070); // coral — no face
      label = 'NO FACE';
    } else if (!eyeTracking) {
      color = const Color(0xFFF2C94C); // amber — face but eyes not locked
      label = 'NO EYE LOCK';
    } else {
      color = const Color(0xFF6FCF97); // mint — face + eyes tracking
      label = 'EYES TRACKING';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.6),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Eye openness bars ──────────────────────────────────────────────────────────

class _EyeOpenBars extends StatelessWidget {
  final double leftOpen;
  final double rightOpen;
  final Color accentColor;

  const _EyeOpenBars({
    required this.leftOpen,
    required this.rightOpen,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _EyeBar(label: 'L', value: leftOpen, accentColor: accentColor),
              const SizedBox(height: 6),
              _EyeBar(label: 'R', value: rightOpen, accentColor: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _EyeBar extends StatelessWidget {
  final String label;
  final double value;
  final Color accentColor;

  const _EyeBar({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  Color _barColor() {
    if (value >= 0.6) return const Color(0xFF6FCF97); // mint — good
    if (value >= 0.3) return const Color(0xFFF2C94C); // amber — borderline
    return const Color(0xFFEB7070); // coral — blink / low
  }

  @override
  Widget build(BuildContext context) {
    final color = _barColor();
    return Row(
      children: [
        SizedBox(
          width: 14,
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 34,
          child: Text(
            value.toStringAsFixed(2),
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Animated tracker dot ───────────────────────────────────────────────────────

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
                  color: color.withValues(alpha: 0.2),
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
                        color: color.withValues(alpha: 0.7),
                        blurRadius: 18,
                        spreadRadius: 3,
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

// ── Radar painter ──────────────────────────────────────────────────────────────

class _RadarPainter extends CustomPainter {
  final Color accentColor;
  _RadarPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final circlePaint = Paint()
      ..color = accentColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (final radius in [48.0, 90.0, 132.0]) {
      canvas.drawCircle(center, radius, circlePaint);
    }

    final crossPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.1)
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
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.accentColor != accentColor;
}

// ── Paused overlay ─────────────────────────────────────────────────────────────

/// Shown when no face has been detected for [_noFaceTimeout].
/// Dims the camera box and shows a pulsing "PAUSED" banner.
class _PausedOverlay extends StatefulWidget {
  const _PausedOverlay();

  @override
  State<_PausedOverlay> createState() => _PausedOverlayState();
}

class _PausedOverlayState extends State<_PausedOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _opacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF2C94C).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFF2C94C).withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.pause_circle_outline_rounded,
                    color: Color(0xFFF2C94C),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'PAUSED — NO FACE',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: const Color(0xFFF2C94C),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
