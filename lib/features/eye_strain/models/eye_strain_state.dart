import 'package:flutter/material.dart';

enum StrainLevel { relaxed, moderate, high }

extension StrainLevelExt on StrainLevel {
  String get label => switch (this) {
        StrainLevel.relaxed => 'Optimal Eye Health',
        StrainLevel.moderate => 'Moderate Eye Strain',
        StrainLevel.high => 'High Eye Strain Detected',
      };

  String get badge => switch (this) {
        StrainLevel.relaxed => 'RELAXED',
        StrainLevel.moderate => 'MODERATE STRAIN',
        StrainLevel.high => 'HIGH STRAIN',
      };

  Color get badgeColor => switch (this) {
        StrainLevel.relaxed => const Color(0xFF6FCF97),
        StrainLevel.moderate => const Color(0xFFF2C94C),
        StrainLevel.high => const Color(0xFFEB7070),
      };
}

class EarSample {
  final double leftEyeOpen;
  final double rightEyeOpen;
  final DateTime timestamp;

  const EarSample({
    required this.leftEyeOpen,
    required this.rightEyeOpen,
    required this.timestamp,
  });

  double get average => (leftEyeOpen + rightEyeOpen) / 2.0;
}

class EyeStrainState {
  final double calibrationProgress;
  final int remainingSeconds;
  final bool isCalibrating;
  final bool isCalibrationComplete;
  final double neutralEar;
  final bool isActiveTracking;
  final bool isBlinkAlertActive;
  final bool isBreakOverlayVisible;
  final StrainLevel strainLevel;
  final int blinkRate;
  final double blinkRateTrend;
  final double eyeOpenness;
  final double eyeOpennessTrend;
  final String aiRecommendation;
  final bool isAutoCorrectionEnabled;
  final bool isAnalyzing;
  final int currentStep;
  final int totalSteps;
  final String stepName;
  final double eyeVitality;
  final List<double> activityData;

  // Adaptive UI properties
  final double brightnessOverlayOpacity;
  final double warmthFilterIntensity;
  final double textScaleMultiplier;

  const EyeStrainState({
    this.calibrationProgress = 0.0,
    this.remainingSeconds = 30,
    this.isCalibrating = false,
    this.isCalibrationComplete = false,
    this.neutralEar = 0.85,
    this.isActiveTracking = false,
    this.isBlinkAlertActive = false,
    this.isBreakOverlayVisible = false,
    this.strainLevel = StrainLevel.relaxed,
    this.blinkRate = 15,
    this.blinkRateTrend = 0.0,
    this.eyeOpenness = 0.85,
    this.eyeOpennessTrend = 0.0,
    this.aiRecommendation =
        'Start tracking to receive AI-powered eye health insights.',
    this.isAutoCorrectionEnabled = true,
    this.isAnalyzing = false,
    this.currentStep = 1,
    this.totalSteps = 3,
    this.stepName = 'Neutral Eye Mapping',
    this.eyeVitality = 1.0,
    this.activityData = const [
      0.3, 0.4, 0.2, 0.5, 0.3, 0.6, 0.4, 0.8, 0.4, 0.5,
      0.9, 0.7, 0.8, 0.3, 0.5, 0.4, 0.3, 0.6, 0.5, 0.4,
      0.7, 0.8, 0.5, 0.4, 0.3, 0.5,
    ],
    this.brightnessOverlayOpacity = 0.0,
    this.warmthFilterIntensity = 0.0,
    this.textScaleMultiplier = 1.0,
  });

  EyeStrainState copyWith({
    double? calibrationProgress,
    int? remainingSeconds,
    bool? isCalibrating,
    bool? isCalibrationComplete,
    double? neutralEar,
    bool? isActiveTracking,
    bool? isBlinkAlertActive,
    bool? isBreakOverlayVisible,
    StrainLevel? strainLevel,
    int? blinkRate,
    double? blinkRateTrend,
    double? eyeOpenness,
    double? eyeOpennessTrend,
    String? aiRecommendation,
    bool? isAutoCorrectionEnabled,
    bool? isAnalyzing,
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
      isCalibrationComplete:
          isCalibrationComplete ?? this.isCalibrationComplete,
      neutralEar: neutralEar ?? this.neutralEar,
      isActiveTracking: isActiveTracking ?? this.isActiveTracking,
      isBlinkAlertActive: isBlinkAlertActive ?? this.isBlinkAlertActive,
      isBreakOverlayVisible:
          isBreakOverlayVisible ?? this.isBreakOverlayVisible,
      strainLevel: strainLevel ?? this.strainLevel,
      blinkRate: blinkRate ?? this.blinkRate,
      blinkRateTrend: blinkRateTrend ?? this.blinkRateTrend,
      eyeOpenness: eyeOpenness ?? this.eyeOpenness,
      eyeOpennessTrend: eyeOpennessTrend ?? this.eyeOpennessTrend,
      aiRecommendation: aiRecommendation ?? this.aiRecommendation,
      isAutoCorrectionEnabled:
          isAutoCorrectionEnabled ?? this.isAutoCorrectionEnabled,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
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
