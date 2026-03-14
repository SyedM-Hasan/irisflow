import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Size;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../models/eye_strain_state.dart';

import 'eye_tracker_interface.dart';

/// Streams real-time [EarSample]s by processing front-camera frames with
/// ML Kit face detection. Uses the eye-open probability values (0 = closed,
/// 1 = fully open) as a normalized proxy for the classical EAR metric.
///
/// This implementation is for mobile platforms (Android/iOS).
class EarDetectionService implements EyeTracker {
  EarDetectionService._();

  static final EarDetectionService instance = EarDetectionService._();

  /// True only on platforms where camera + ML Kit are available (Android/iOS).
  @override
  bool get isSupported => Platform.isAndroid || Platform.isIOS;

  CameraController? _cameraController;
  FaceDetector? _faceDetector;

  final _controller = StreamController<EarSample>.broadcast();

  /// Emits one [EarSample] per detected face, at ~2 Hz.
  @override
  Stream<EarSample> get earStream => _controller.stream;

  bool _isProcessing = false;
  int _frameIndex = 0;

  /// Set to false immediately when [stopDetection] is called so that any
  /// in-flight [_onFrame] callbacks exit before touching the detector.
  bool _isActive = false;

  // Process every 15th frame (~2 Hz at 30 fps) to avoid UI jank.
  static const int _frameSkip = 15;

  @override
  bool get isRunning =>
      _cameraController != null && _cameraController!.value.isStreamingImages;

  @override
  bool get isInitialized => _cameraController?.value.isInitialized ?? false;

  /// Exposed so the UI can render a [CameraPreview] overlay.
  CameraController? get cameraController => _cameraController;

  @override
  Future<void> initialize() async {
    if (!isSupported) return;
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true, // gives eye-open probabilities
        performanceMode: FaceDetectorMode.fast,
      ),
    );

    _cameraController = CameraController(
      front,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();
  }

  @override
  void startDetection() {
    if (!isSupported) return;
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    // Guard against double-starting: CameraX registers a new Analyzer each
    // time startImageStream is called; calling it twice without stopping first
    // leaves the old Analyzer dangling and triggers the pigeon channel error.
    if (_cameraController!.value.isStreamingImages) return;

    _isActive = true;
    _isProcessing = false;
    _frameIndex = 0;
    _cameraController!.startImageStream(_onFrame);
  }

  /// Stops the image stream and immediately gates [_onFrame] via [_isActive]
  /// so any callbacks already queued on the platform thread are dropped.
  @override
  Future<void> stopDetection() async {
    if (!isSupported) return;
    _isActive = false; // gate further _onFrame processing immediately
    if (_cameraController?.value.isStreamingImages == true) {
      try {
        await _cameraController!.stopImageStream();
      } catch (e) {
        debugPrint('EarDetectionService.stopDetection: $e');
      }
    }
  }

  @override
  Future<void> dispose() async {
    if (!isSupported) return;
    await stopDetection();
    // Small delay so the CameraX native thread drains any buffered frames
    // before the controller is torn down — prevents the pigeon channel error.
    await Future.delayed(const Duration(milliseconds: 100));
    await _cameraController?.dispose();
    await _faceDetector?.close();
    if (!_controller.isClosed) await _controller.close();
    _cameraController = null;
    _faceDetector = null;
  }

  // ---------------------------------------------------------------------------

  void _onFrame(CameraImage image) {
    if (!_isActive) return; // dropped after stopDetection()
    _frameIndex++;
    if (_frameIndex % _frameSkip != 0) return;
    if (_isProcessing) return;

    _isProcessing = true;
    _processImage(image).whenComplete(() => _isProcessing = false);
  }

  Future<void> _processImage(CameraImage image) async {
    if (!_isActive) return; // re-check after the async gap
    try {
      final inputImage = _toInputImage(image);
      if (inputImage == null) return;

      final faces = await _faceDetector!.processImage(inputImage);
      if (!_isActive) return; // re-check after ML Kit await

      if (faces.isEmpty) return;

      final face = faces.first;
      final left = face.leftEyeOpenProbability;
      final right = face.rightEyeOpenProbability;

      if (left == null || right == null) return;

      if (!_controller.isClosed) {
        _controller.add(
          EarSample(
            leftEyeOpen: left,
            rightEyeOpen: right,
            timestamp: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      // Swallow CameraX Analyzer channel errors that fire when the native
      // Analyzer is torn down while a frame is still in flight.
      debugPrint('EarDetectionService._processImage: $e');
    }
  }

  InputImage? _toInputImage(CameraImage image) {
    final camera = _cameraController?.description;
    if (camera == null) return null;

    final rotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    // Single-plane (iOS BGRA / Android NV21 after concatenation)
    final Uint8List bytes;
    if (image.planes.length == 1) {
      bytes = image.planes.first.bytes;
    } else {
      final buffer = BytesBuilder();
      for (final plane in image.planes) {
        buffer.add(plane.bytes);
      }
      bytes = buffer.toBytes();
    }

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }
}
