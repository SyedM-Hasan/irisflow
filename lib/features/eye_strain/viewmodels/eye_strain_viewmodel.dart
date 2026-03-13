import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/eye_strain_state.dart';
import '../services/ear_detection_service.dart';
import '../services/gemini_analysis_service.dart';

export '../models/eye_strain_state.dart';

class EyeStrainViewModel extends Notifier<EyeStrainState> {
  static const int _bufferSize = 120; // ~60 seconds at 2 Hz
  static const Duration _analysisInterval = Duration(minutes: 2);
  static const double _blinkThreshold = 0.35; // EAR below this = blink

  // 60-second rolling buffer of EAR samples
  final List<EarSample> _earBuffer = [];

  // Blink counting: track rising edge (closed → open)
  bool _wasBlinking = false;
  int _blinkCount = 0;
  DateTime _blinkWindowStart = DateTime.now();

  // Previous blinkRate for trend calculation
  int _prevBlinkRate = 15;
  double _prevEyeOpenness = 0.85;

  StreamSubscription<EarSample>? _earSubscription;
  Timer? _analysisTimer;
  Timer? _calibrationTimer;

  @override
  EyeStrainState build() {
    GeminiAnalysisService.instance.initialize();

    ref.onDispose(() {
      _earSubscription?.cancel();
      _analysisTimer?.cancel();
      _calibrationTimer?.cancel();
      EarDetectionService.instance.dispose();
    });

    return const EyeStrainState();
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  void toggleAutoCorrection() {
    state = state.copyWith(
      isAutoCorrectionEnabled: !state.isAutoCorrectionEnabled,
    );
  }

  Future<void> toggleTracking() async {
    if (state.isActiveTracking) {
      _stopTracking();
    } else {
      await _startTracking();
    }
  }

  Future<void> startCalibration() async {
    final granted = await _requestCameraPermission();
    if (!granted) return;

    _calibrationTimer?.cancel();
    _earBuffer.clear();
    _blinkCount = 0;

    state = state.copyWith(
      isCalibrating: true,
      isCalibrationComplete: false,
      calibrationProgress: 0.0,
      remainingSeconds: 30,
      currentStep: 1,
      stepName: 'Neutral Eye Mapping',
    );

    // Initialize camera silently during calibration
    if (!EarDetectionService.instance.isRunning) {
      await EarDetectionService.instance.initialize();
      EarDetectionService.instance.startDetection();
    }

    // Collect neutral EAR samples during step 1 (first 10 s)
    final List<double> neutralSamples = [];
    _earSubscription?.cancel();
    _earSubscription = EarDetectionService.instance.earStream.listen((sample) {
      neutralSamples.add(sample.average);
    });

    int elapsed = 0;
    const totalSeconds = 30;

    _calibrationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsed++;
      final progress = elapsed / totalSeconds;
      final remaining = totalSeconds - elapsed;

      int step;
      String stepName;
      if (elapsed <= 10) {
        step = 1;
        stepName = 'Neutral Eye Mapping';
      } else if (elapsed <= 20) {
        step = 2;
        stepName = 'Focus Tracking';
      } else {
        step = 3;
        stepName = 'Relaxed State';
      }

      state = state.copyWith(
        calibrationProgress: progress,
        remainingSeconds: remaining,
        currentStep: step,
        stepName: stepName,
      );

      if (elapsed >= totalSeconds) {
        timer.cancel();
        final neutral = neutralSamples.isNotEmpty
            ? neutralSamples.reduce((a, b) => a + b) / neutralSamples.length
            : 0.85;

        state = state.copyWith(
          isCalibrating: false,
          isCalibrationComplete: true,
          calibrationProgress: 1.0,
          neutralEar: neutral.clamp(0.3, 1.0),
        );

        _earSubscription?.cancel();
        _earSubscription = null;
      }
    });
  }

  void dismissBreakOverlay() {
    state = state.copyWith(isBreakOverlayVisible: false);
  }

  // ---------------------------------------------------------------------------
  // Internal: tracking lifecycle
  // ---------------------------------------------------------------------------

  Future<void> _startTracking() async {
    final granted = await _requestCameraPermission();
    if (!granted) return;

    if (!EarDetectionService.instance.isRunning) {
      await EarDetectionService.instance.initialize();
    }
    EarDetectionService.instance.startDetection();

    _earBuffer.clear();
    _blinkCount = 0;
    _prevBlinkRate = state.blinkRate;
    _prevEyeOpenness = state.eyeOpenness;
    _blinkWindowStart = DateTime.now();

    _earSubscription = EarDetectionService.instance.earStream.listen(_onSample);

    _analysisTimer = Timer.periodic(_analysisInterval, (_) {
      _runAnalysis();
    });

    state = state.copyWith(isActiveTracking: true);
  }

  void _stopTracking() {
    EarDetectionService.instance.stopDetection();
    _earSubscription?.cancel();
    _earSubscription = null;
    _analysisTimer?.cancel();
    _analysisTimer = null;

    state = state.copyWith(
      isActiveTracking: false,
      isBlinkAlertActive: false,
    );
  }

  void _onSample(EarSample sample) {
    // Rolling buffer
    _earBuffer.add(sample);
    if (_earBuffer.length > _bufferSize) {
      _earBuffer.removeAt(0);
    }

    final ear = sample.average;

    // Blink detection: closed → open transition
    final isBlinking = ear < _blinkThreshold;
    if (_wasBlinking && !isBlinking) {
      _blinkCount++;
    }
    _wasBlinking = isBlinking;

    // Update live metrics
    final elapsedMin = DateTime.now()
            .difference(_blinkWindowStart)
            .inSeconds
            .clamp(1, 3600) /
        60.0;
    final currentBlinkRate = (_blinkCount / elapsedMin).round().clamp(0, 60);
    final blinkRateTrend = _prevBlinkRate > 0
        ? (currentBlinkRate - _prevBlinkRate) / _prevBlinkRate
        : 0.0;
    final opennessTrend = _prevEyeOpenness > 0
        ? (ear - _prevEyeOpenness) / _prevEyeOpenness
        : 0.0;

    // Activity data: shift buffer and append normalized EAR
    final newActivity = List<double>.from(state.activityData);
    if (newActivity.length >= 26) newActivity.removeAt(0);
    newActivity.add(ear.clamp(0.0, 1.0));

    state = state.copyWith(
      eyeOpenness: double.parse(ear.toStringAsFixed(2)),
      eyeOpennessTrend: opennessTrend,
      blinkRate: currentBlinkRate,
      blinkRateTrend: blinkRateTrend.toDouble(),
      isBlinkAlertActive: currentBlinkRate < 8,
      activityData: newActivity,
    );
  }

  Future<void> _runAnalysis() async {
    if (_earBuffer.isEmpty) return;
    state = state.copyWith(isAnalyzing: true);

    final analysis = await GeminiAnalysisService.instance.analyze(
      buffer: List.unmodifiable(_earBuffer),
      blinkCount: _blinkCount,
      neutralEar: state.neutralEar,
    );

    _prevBlinkRate = state.blinkRate;
    _prevEyeOpenness = state.eyeOpenness;
    _blinkCount = 0;
    _blinkWindowStart = DateTime.now();

    _applyAdaptiveUI(analysis.strainLevel);

    state = state.copyWith(
      strainLevel: analysis.strainLevel,
      eyeVitality: analysis.eyeVitality,
      aiRecommendation: analysis.recommendation,
      isAnalyzing: false,
    );
  }

  void _applyAdaptiveUI(StrainLevel level) {
    if (!state.isAutoCorrectionEnabled) return;

    switch (level) {
      case StrainLevel.relaxed:
        state = state.copyWith(
          brightnessOverlayOpacity: 0.0,
          warmthFilterIntensity: 0.0,
          textScaleMultiplier: 1.0,
          isBreakOverlayVisible: false,
        );
      case StrainLevel.moderate:
        state = state.copyWith(
          brightnessOverlayOpacity: 0.1,
          warmthFilterIntensity: 0.15,
          textScaleMultiplier: 1.05,
          isBreakOverlayVisible: false,
        );
      case StrainLevel.high:
        state = state.copyWith(
          brightnessOverlayOpacity: 0.2,
          warmthFilterIntensity: 0.3,
          textScaleMultiplier: 1.15,
          isBreakOverlayVisible: true,
        );
    }
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  // ---------------------------------------------------------------------------
  // Dev helper: simulate a Genkit analysis cycle (useful without a device)
  // ---------------------------------------------------------------------------

  void simulateAnalysis() {
    final levels = StrainLevel.values;
    final next =
        levels[(levels.indexOf(state.strainLevel) + 1) % levels.length];
    final fakeBuffer = List.generate(
      60,
      (i) => EarSample(
        leftEyeOpen:
            next == StrainLevel.high ? 0.3 + math.Random().nextDouble() * 0.1 : 0.8,
        rightEyeOpen:
            next == StrainLevel.high ? 0.3 + math.Random().nextDouble() * 0.1 : 0.8,
        timestamp: DateTime.now().subtract(Duration(seconds: 60 - i)),
      ),
    );

    GeminiAnalysisService.instance
        .analyze(
          buffer: fakeBuffer,
          blinkCount: next == StrainLevel.high ? 3 : 15,
          neutralEar: state.neutralEar,
        )
        .then((analysis) {
      _applyAdaptiveUI(analysis.strainLevel);
      state = state.copyWith(
        strainLevel: analysis.strainLevel,
        eyeVitality: analysis.eyeVitality,
        aiRecommendation: analysis.recommendation,
      );
    });
  }
}

final eyeStrainProvider = NotifierProvider<EyeStrainViewModel, EyeStrainState>(
  EyeStrainViewModel.new,
);
