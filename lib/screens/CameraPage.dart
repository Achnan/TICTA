import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import '../widgets/pose_painter.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  late final PoseDetector _poseDetector;
  bool _isDetecting = false;
  List<PoseLandmark> _landmarks = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final cameras = await availableCameras();
    final frontCamera =
        cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller!.initialize();

    final options = PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      model: PoseDetectionModel.base,
    );
    _poseDetector = PoseDetector(options: options);

    await _controller!.startImageStream(_processImage);
    setState(() {});
  }

  void _processImage(CameraImage image) async {
    if (_isDetecting || !_controller!.value.isStreamingImages) return;
    _isDetecting = true;

    try {
      if (image.format.group != ImageFormatGroup.yuv420) {
        debugPrint('❌ Unsupported image format: ${image.format.group}');
        _isDetecting = false;
        return;
      }

      final inputImage =
          _convertCameraImage(image, _controller!.description.sensorOrientation);
      final poses = await _poseDetector.processImage(inputImage);

      if (mounted && poses.isNotEmpty) {
        setState(() {
          _landmarks = poses.first.landmarks.values.toList();
        });
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
    }

    _isDetecting = false;
  }

  InputImage _convertCameraImage(CameraImage image, int rotation) {
    final WriteBuffer buffer = WriteBuffer();
    for (final plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }
    final bytes = buffer.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation:
          InputImageRotationValue.fromRawValue(rotation) ?? InputImageRotation.rotation0deg,
      format: InputImageFormat.nv21, // รองรับ Android เท่านั้น
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: metadata,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ML Kit Pose Detection')),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          if (_landmarks.isNotEmpty)
            CustomPaint(
              painter: PosePainter.fromLandmarks(
                _landmarks,
                _controller!.value.previewSize!.width,
                _controller!.value.previewSize!.height,
              ),
              size: Size.infinite,
            ),
        ],
      ),
    );
  }
}
