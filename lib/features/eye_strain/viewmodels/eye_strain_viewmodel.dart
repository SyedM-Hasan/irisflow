import 'package:flutter_riverpod/flutter_riverpod.dart';

class EyeStrainState {
  final double calibrationProgress;
  final int remainingSeconds;
  final bool isCalibrating;
  final bool isActiveTracking;
  final String vitalityStatus;
  final int blinkRate;
  final double blinkRateTrend;
  final double eyeOpenness;
  final double eyeOpennessTrend;
  final String aiRecommendation;
  final bool isAutoCorrectionEnabled;

  const EyeStrainState({
    this.calibrationProgress = 0.33,
    this.remainingSeconds = 10,
    this.isCalibrating = true,
    this.isActiveTracking = true,
    this.vitalityStatus = 'Optimal Eye Health',
    this.blinkRate = 6,
    this.blinkRateTrend = -0.15,
    this.eyeOpenness = 0.28,
    this.eyeOpennessTrend = 0.02,
    this.aiRecommendation =
        'Blink rate is low. Try the 20-20-20 rule soon. Consider increasing display contrast to reduce focal effort.',
    this.isAutoCorrectionEnabled = true,
  });

  EyeStrainState copyWith({
    double? calibrationProgress,
    int? remainingSeconds,
    bool? isCalibrating,
    bool? isActiveTracking,
    String? vitalityStatus,
    int? blinkRate,
    double? blinkRateTrend,
    double? eyeOpenness,
    double? eyeOpennessTrend,
    String? aiRecommendation,
    bool? isAutoCorrectionEnabled,
  }) {
    return EyeStrainState(
      calibrationProgress: calibrationProgress ?? this.calibrationProgress,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isCalibrating: isCalibrating ?? this.isCalibrating,
      isActiveTracking: isActiveTracking ?? this.isActiveTracking,
      vitalityStatus: vitalityStatus ?? this.vitalityStatus,
      blinkRate: blinkRate ?? this.blinkRate,
      blinkRateTrend: blinkRateTrend ?? this.blinkRateTrend,
      eyeOpenness: eyeOpenness ?? this.eyeOpenness,
      eyeOpennessTrend: eyeOpennessTrend ?? this.eyeOpennessTrend,
      aiRecommendation: aiRecommendation ?? this.aiRecommendation,
      isAutoCorrectionEnabled:
          isAutoCorrectionEnabled ?? this.isAutoCorrectionEnabled,
    );
  }
}

class EyeStrainViewModel extends Notifier<EyeStrainState> {
  @override
  EyeStrainState build() {
    return const EyeStrainState();
  }

  void toggleAutoCorrection() {
    state = state.copyWith(
      isAutoCorrectionEnabled: !state.isAutoCorrectionEnabled,
    );
  }

  void startCalibration() {
    state = state.copyWith(
      isCalibrating: true,
      calibrationProgress: 0.0,
      remainingSeconds: 10,
    );
    // Mock progress can go here
  }
}

final eyeStrainProvider = NotifierProvider<EyeStrainViewModel, EyeStrainState>(
  () {
    return EyeStrainViewModel();
  },
);
