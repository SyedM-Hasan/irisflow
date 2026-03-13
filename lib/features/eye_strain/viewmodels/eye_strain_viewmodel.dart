import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/eye_strain_state.dart';
import '../services/ear_detection_service.dart';
import '../services/gemini_analysis_service.dart';

export '../models/eye_strain_state.dart';

class EyeStrainViewModel extends Notifier<EyeStrainState> {
  static const int _bufferSize = 120;
  static const Duration _analysisInterval = Duration(minutes: 2);
  static const double _blinkThreshold = 0.35;
  static const Duration _noFaceTimeout = Duration(seconds: 3);

  // ── EAR buffer + blink state ────────────────────────────────────────────────
  final List<EarSample> _earBuffer = [];
  bool _wasBlinking = false;
  int _blinkCount = 0;
  DateTime _blinkWindowStart = DateTime.now();
  int _prevBlinkRate = 15;
  double _prevEyeOpenness = 0.85;

  // ── Pause / resume state ────────────────────────────────────────────────────
  bool _isDetectionPaused = false;
  DateTime? _pausedAt;

  // ── Calibration state ───────────────────────────────────────────────────────
  int _calibrationElapsed = 0;
  final List<double> _calibrationNeutralSamples = [];

  // ── Timers ───────────────────────────────────────────────────────────────────
  StreamSubscription<EarSample>? _earSubscription;
  Timer? _analysisTimer;
  Timer? _calibrationTimer;
  Timer? _noFaceTimer;

  @override
  EyeStrainState build() {
    GeminiAnalysisService.instance.initialize();
    ref.onDispose(() {
      _earSubscription?.cancel();
      _analysisTimer?.cancel();
      _calibrationTimer?.cancel();
      _noFaceTimer?.cancel();
      EarDetectionService.instance.dispose();
    });
    return const EyeStrainState();
  }

  // ── Public API ───────────────────────────────────────────────────────────────

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

    // Reset all calibration state
    _calibrationTimer?.cancel();
    _noFaceTimer?.cancel();
    _calibrationElapsed = 0;
    _calibrationNeutralSamples.clear();
    _isDetectionPaused = false;
    _pausedAt = null;

    state = state.copyWith(
      isCalibrating: true,
      isCalibrationComplete: false,
      isCameraReady: false,
      isFaceDetected: false,
      isDetectionPaused: false,
      calibrationProgress: 0.0,
      remainingSeconds: 30,
      currentStep: 1,
      stepName: 'Neutral Eye Mapping',
    );

    if (!EarDetectionService.instance.isRunning) {
      await EarDetectionService.instance.initialize();
    }
    state = state.copyWith(isCameraReady: true);
    EarDetectionService.instance.startDetection();

    _earSubscription?.cancel();
    _earSubscription = EarDetectionService.instance.earStream.listen((sample) {
      // Only collect neutral samples during step 1 when not paused
      if (!_isDetectionPaused && _calibrationElapsed <= 10) {
        _calibrationNeutralSamples.add(sample.average);
      }
      _onFaceDetected(sample);
    });

    _startCalibrationTimer();
  }

  void dismissBreakOverlay() {
    state = state.copyWith(isBreakOverlayVisible: false);
  }

  // ── Pause / resume ───────────────────────────────────────────────────────────

  /// Called when no face is detected for [_noFaceTimeout] — pauses all timers.
  void _pauseCalculation() {
    if (_isDetectionPaused) return;
    _isDetectionPaused = true;
    _pausedAt = DateTime.now();

    _calibrationTimer?.cancel();
    _analysisTimer?.cancel();

    state = state.copyWith(
      isDetectionPaused: true,
      isFaceDetected: false,
    );
  }

  /// Called when ML Kit detects a face after a pause — resumes all timers.
  void _resumeCalculation() {
    if (!_isDetectionPaused) return;
    _isDetectionPaused = false;

    // Shift the blink window forward by however long we were paused,
    // so paused time is excluded from blink-rate calculations.
    if (_pausedAt != null) {
      final pausedFor = DateTime.now().difference(_pausedAt!);
      _blinkWindowStart = _blinkWindowStart.add(pausedFor);
      _pausedAt = null;
    }

    state = state.copyWith(isDetectionPaused: false);

    if (state.isCalibrating) {
      _startCalibrationTimer();
    } else if (state.isActiveTracking) {
      _startAnalysisTimer();
    }
  }

  // ── Timer helpers (start / stop independently) ───────────────────────────────

  void _startCalibrationTimer() {
    _calibrationTimer?.cancel();
    _calibrationTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tickCalibration(),
    );
  }

  void _startAnalysisTimer() {
    _analysisTimer?.cancel();
    _analysisTimer = Timer.periodic(_analysisInterval, (_) => _runAnalysis());
  }

  void _tickCalibration() {
    const totalSeconds = 30;
    _calibrationElapsed++;
    final progress = _calibrationElapsed / totalSeconds;
    final remaining = totalSeconds - _calibrationElapsed;

    final int step;
    final String stepName;
    if (_calibrationElapsed <= 10) {
      step = 1;
      stepName = 'Neutral Eye Mapping';
    } else if (_calibrationElapsed <= 20) {
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

    if (_calibrationElapsed >= totalSeconds) {
      _calibrationTimer?.cancel();
      _noFaceTimer?.cancel();

      final neutral = _calibrationNeutralSamples.isNotEmpty
          ? _calibrationNeutralSamples.reduce((a, b) => a + b) /
              _calibrationNeutralSamples.length
          : 0.85;

      state = state.copyWith(
        isCalibrating: false,
        isCalibrationComplete: true,
        isDetectionPaused: false,
        calibrationProgress: 1.0,
        neutralEar: neutral.clamp(0.3, 1.0),
      );

      _earSubscription?.cancel();
      _earSubscription = null;
    }
  }

  // ── Tracking lifecycle ────────────────────────────────────────────────────────

  Future<void> _startTracking() async {
    final granted = await _requestCameraPermission();
    if (!granted) return;

    if (!EarDetectionService.instance.isRunning) {
      await EarDetectionService.instance.initialize();
    }
    state = state.copyWith(isCameraReady: true);
    EarDetectionService.instance.startDetection();

    _earBuffer.clear();
    _blinkCount = 0;
    _isDetectionPaused = false;
    _pausedAt = null;
    _prevBlinkRate = state.blinkRate;
    _prevEyeOpenness = state.eyeOpenness;
    _blinkWindowStart = DateTime.now();

    _earSubscription = EarDetectionService.instance.earStream.listen(_onSample);
    _startAnalysisTimer();

    state = state.copyWith(
      isActiveTracking: true,
      isDetectionPaused: false,
    );
  }

  void _stopTracking() {
    EarDetectionService.instance.stopDetection();
    _earSubscription?.cancel();
    _earSubscription = null;
    _analysisTimer?.cancel();
    _analysisTimer = null;
    _noFaceTimer?.cancel();
    _noFaceTimer = null;
    _isDetectionPaused = false;

    state = state.copyWith(
      isActiveTracking: false,
      isDetectionPaused: false,
      isBlinkAlertActive: false,
    );
  }

  // ── Per-sample processing ─────────────────────────────────────────────────────

  /// Handles face presence: resets no-face timer, resumes if paused.
  void _onFaceDetected(EarSample sample) {
    // Reset the no-face watchdog
    _noFaceTimer?.cancel();
    _noFaceTimer = Timer(_noFaceTimeout, _pauseCalculation);

    // Resume if we were paused
    if (_isDetectionPaused) _resumeCalculation();

    state = state.copyWith(
      isFaceDetected: true,
      leftEyeOpen: double.parse(sample.leftEyeOpen.toStringAsFixed(2)),
      rightEyeOpen: double.parse(sample.rightEyeOpen.toStringAsFixed(2)),
    );
  }

  void _onSample(EarSample sample) {
    _onFaceDetected(sample);

    // Do not accumulate data while paused
    if (_isDetectionPaused) return;

    _earBuffer.add(sample);
    if (_earBuffer.length > _bufferSize) _earBuffer.removeAt(0);

    final ear = sample.average;

    // Blink: detect closed → open rising edge
    final isBlinking = ear < _blinkThreshold;
    if (_wasBlinking && !isBlinking) _blinkCount++;
    _wasBlinking = isBlinking;

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

  // ── Gemini analysis ────────────────────────────────────────────────────────────

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

  // ── Permissions ────────────────────────────────────────────────────────────────

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  // ── Dev helper ─────────────────────────────────────────────────────────────────

  void simulateAnalysis() {
    final levels = StrainLevel.values;
    final next =
        levels[(levels.indexOf(state.strainLevel) + 1) % levels.length];
    final fakeBuffer = List.generate(
      60,
      (i) => EarSample(
        leftEyeOpen: next == StrainLevel.high
            ? 0.3 + math.Random().nextDouble() * 0.1
            : 0.8,
        rightEyeOpen: next == StrainLevel.high
            ? 0.3 + math.Random().nextDouble() * 0.1
            : 0.8,
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
