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
  final int currentStep;
  final int totalSteps;
  final String stepName;
  final double eyeVitality;
  final List<double> activityData;

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
    this.currentStep = 1,
    this.totalSteps = 3,
    this.stepName = 'Neutral Eye Mapping',
    this.eyeVitality = 0.82,
    this.activityData = const [
      0.3, 0.4, 0.2, 0.5, 0.3, 0.6, 0.4, 0.8, 0.4, 0.5, 
      0.9, 0.7, 0.8, 0.3, 0.5, 0.4, 0.3, 0.6, 0.5, 0.4, 
      0.7, 0.8, 0.5, 0.4, 0.3, 0.5
    ],
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
    int? currentStep,
    int? totalSteps,
    String? stepName,
    double? eyeVitality,
    List<double>? activityData,
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
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      stepName: stepName ?? this.stepName,
      eyeVitality: eyeVitality ?? this.eyeVitality,
      activityData: activityData ?? this.activityData,
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
