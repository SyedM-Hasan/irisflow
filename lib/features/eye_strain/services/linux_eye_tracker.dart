import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/eye_strain_state.dart';
import 'eye_tracker_interface.dart';

/// Linux implementation of [EyeTracker] using OpenCV and TFLite.
class LinuxEyeTracker implements EyeTracker {
  LinuxEyeTracker._();

  static final LinuxEyeTracker instance = LinuxEyeTracker._();

  @override
  bool get isSupported => Platform.isLinux;

  cv.VideoCapture? _videoCapture;
  Interpreter? _interpreter;

  final _controller = StreamController<EarSample>.broadcast();
  bool _isRunning = false;
  bool _isInitialized = false;
  Timer? _processingTimer;

  @override
  bool get isRunning => _isRunning;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Stream<EarSample> get earStream => _controller.stream;

  @override
  Future<void> initialize() async {
    if (!isSupported) return;
    if (_isInitialized) return;

    try {
      _videoCapture = cv.VideoCapture.fromDevice(0); // Open default camera
      
      // Load TFLite model
      // Note: Model needs to be in assets
      _interpreter = await Interpreter.fromAsset('assets/models/face_landmark.tflite');
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('LinuxEyeTracker.initialize error: $e');
    }
  }

  @override
  void startDetection() {
    if (!isSupported || !_isInitialized || _isRunning) return;

    _isRunning = true;
    _processingTimer = Timer.periodic(const Duration(milliseconds: 500), (_) => _processFrame());
  }

  @override
  Future<void> stopDetection() async {
    _processingTimer?.cancel();
    _isRunning = false;
  }

  @override
  Future<void> dispose() async {
    await stopDetection();
    _videoCapture?.release();
    _interpreter?.close();
    if (!_controller.isClosed) await _controller.close();
    _isInitialized = false;
  }

  Future<void> _processFrame() async {
    if (!_isRunning || _videoCapture == null || _interpreter == null) return;

    final (success, frame) = _videoCapture!.read();
    if (!success || frame.isEmpty) return;

    try {
      // 1. Pre-process frame for TFLite (resize, normalize)
      // 2. Run inference
      // 3. Calculate EAR from landmarks
      // 4. emit EarSample
      
      // Placeholder for actual EAR calculation
      final ear = 0.85; // Simulated
      
      if (!_controller.isClosed) {
        _controller.add(
          EarSample(
            leftEyeOpen: ear,
            rightEyeOpen: ear,
            timestamp: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      debugPrint('LinuxEyeTracker._processFrame error: $e');
    }
  }
}
