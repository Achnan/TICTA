import 'dart:math';
import 'dart:ui';
import 'evaluator_base.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class ShoulderShrugEvaluator extends PoseEvaluator {
  @override
  String get name => 'Shoulder Shrug';

  @override
  String get feedback => 'ยกไหล่ให้สูงสุด';

  @override
  bool evaluate(Map<PoseLandmarkType, Offset> points) {
    if (!(points.containsKey(PoseLandmarkType.leftShoulder) &&
          points.containsKey(PoseLandmarkType.leftEar))) return false;

    final shoulderY = points[PoseLandmarkType.leftShoulder]!.dy;
    final earY = points[PoseLandmarkType.leftEar]!.dy;

    return shoulderY < earY; // ไหล่สูงกว่าแนวปกติ

  }

double calculateAngle(Offset a, Offset b, Offset c) {
  final ab = a - b;
  final cb = c - b;
  final dot = ab.dx * cb.dx + ab.dy * cb.dy;
  final abLen = ab.distance;
  final cbLen = cb.distance;
  return acos(dot / (abLen * cbLen)) * (180 / pi);
}

}
