import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'eye_tracker_interface.dart';
export 'eye_tracker_interface.dart';
import 'ear_detection_service.dart';
import 'linux_eye_tracker.dart';

final eyeTrackerProvider = Provider<EyeTracker>((ref) {
  if (Platform.isLinux) {
    return LinuxEyeTracker.instance;
  }
  return EarDetectionService.instance;
});
