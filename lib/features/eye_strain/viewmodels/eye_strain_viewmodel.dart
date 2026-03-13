import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StrainLevel { relaxed, moderate, high }

class EyeStrainState {
  final double calibrationProgress;
  final int remainingSeconds;
  final bool isCalibrating;
  final bool isActiveTracking;
  final bool isBlinkAlertActive;
  final bool isBreakOverlayVisible;
  final StrainLevel strainLevel;
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

  // Adaptive UI Properties
  final double brightnessOverlayOpacity;
  final double warmthFilterIntensity;
  final double textScaleMultiplier;

  const EyeStrainState({
    this.calibrationProgress = 0.33,
    this.remainingSeconds = 10,
    this.isCalibrating = false,
    this.isActiveTracking = true,
    this.isBlinkAlertActive = false,
    this.isBreakOverlayVisible = false,
    this.strainLevel = StrainLevel.relaxed,
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
    this.brightnessOverlayOpacity = 0.0,
    this.warmthFilterIntensity = 0.0,
    this.textScaleMultiplier = 1.0,
  });

  EyeStrainState copyWith({
    double? calibrationProgress,
    int? remainingSeconds,
    bool? isCalibrating,
    bool? isActiveTracking,
    bool? isBlinkAlertActive,
    bool? isBreakOverlayVisible,
    StrainLevel? strainLevel,
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
    double? brightnessOverlayOpacity,
    double? warmthFilterIntensity,
    double? textScaleMultiplier,
  }) {
    return EyeStrainState(
      calibrationProgress: calibrationProgress ?? this.calibrationProgress,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isCalibrating: isCalibrating ?? this.isCalibrating,
      isActiveTracking: isActiveTracking ?? this.isActiveTracking,
      isBlinkAlertActive: isBlinkAlertActive ?? this.isBlinkAlertActive,
      isBreakOverlayVisible: isBreakOverlayVisible ?? this.isBreakOverlayVisible,
      strainLevel: strainLevel ?? this.strainLevel,
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
      brightnessOverlayOpacity:
          brightnessOverlayOpacity ?? this.brightnessOverlayOpacity,
      warmthFilterIntensity:
          warmthFilterIntensity ?? this.warmthFilterIntensity,
      textScaleMultiplier: textScaleMultiplier ?? this.textScaleMultiplier,
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

  void toggleTracking() {
    state = state.copyWith(isActiveTracking: !state.isActiveTracking);
  }

  void startCalibration() {
    state = state.copyWith(
      isCalibrating: true,
      calibrationProgress: 0.0,
      remainingSeconds: 10,
    );
  }

  void runGenkitAnalysis() {
    // Mock predictive analysis
    final newLevel = state.strainLevel == StrainLevel.relaxed
        ? StrainLevel.moderate
        : (state.strainLevel == StrainLevel.moderate
            ? StrainLevel.high
            : StrainLevel.relaxed);

    _applyAdaptiveUI(newLevel);
  }

  void _applyAdaptiveUI(StrainLevel level) {
    if (!state.isAutoCorrectionEnabled) return;

    switch (level) {
      case StrainLevel.relaxed:
        state = state.copyWith(
          strainLevel: level,
          vitalityStatus: 'Optimal Eye Health',
          brightnessOverlayOpacity: 0.0,
          warmthFilterIntensity: 0.0,
          textScaleMultiplier: 1.0,
          isBreakOverlayVisible: false,
          isBlinkAlertActive: false,
        );
        break;
      case StrainLevel.moderate:
        state = state.copyWith(
          strainLevel: level,
          vitalityStatus: 'Moderate Eye Strain',
          brightnessOverlayOpacity: 0.1,
          warmthFilterIntensity: 0.15,
          textScaleMultiplier: 1.05,
          isBreakOverlayVisible: false,
          isBlinkAlertActive: true,
        );
        break;
      case StrainLevel.high:
        state = state.copyWith(
          strainLevel: level,
          vitalityStatus: 'High Eye Strain Detected',
          brightnessOverlayOpacity: 0.2,
          warmthFilterIntensity: 0.3,
          textScaleMultiplier: 1.15,
          isBreakOverlayVisible: true,
          isBlinkAlertActive: true,
        );
        break;
    }
  }
}

final eyeStrainProvider = NotifierProvider<EyeStrainViewModel, EyeStrainState>(
  () {
    return EyeStrainViewModel();
  },
);
