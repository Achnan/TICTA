import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:ui';

class MLPoseService {
  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      model: PoseDetectionModel.base,
    ),
  );

  Future<List<Pose>> detectPose(InputImage image) async {
    return await _poseDetector.processImage(image);
  }

  void dispose() {
    _poseDetector.close();
  }
}
