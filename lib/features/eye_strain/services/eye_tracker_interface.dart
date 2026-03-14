import '../models/eye_strain_state.dart';

/// Interface for eye tracking services.
abstract class EyeTracker {
  /// Whether the tracker is supported on the current platform.
  bool get isSupported;

  /// Whether the tracker is currently running.
  bool get isRunning;

  /// Whether the tracker is initialized.
  bool get isInitialized;

  /// Stream of [EarSample]s emitted during tracking.
  Stream<EarSample> get earStream;

  /// Initializes the tracker (e.g., camera, ML models).
  Future<void> initialize();

  /// Starts the tracking process.
  void startDetection();

  /// Stops the tracking process.
  Future<void> stopDetection();

  /// Disposes of the tracker resources.
  Future<void> dispose();
}
