import 'dart:ui';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class PoseEvaluator {
  bool evaluate(Map<PoseLandmarkType, Offset> points);
  String get feedback;
  String get name;
}
