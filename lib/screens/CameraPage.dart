import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import '../widgets/pose_painter.dart';
import '../services/pose_evaluator_service.dart';

class CameraPage extends StatefulWidget {
  final String courseName;

  const CameraPage({super.key, required this.courseName});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  late final PoseDetector _poseDetector;
  final FlutterTts _flutterTts = FlutterTts();

  bool _isDetecting = false;
  bool _isSpeaking = false;
  List<PoseLandmark> _landmarks = [];
  bool _isFrontCamera = true;
  String? _feedbackText;

  @override
  void initState() {
    super.initState();
    _initialize();
    _flutterTts.setLanguage("th-TH"); // พูดภาษาไทย
    _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _initialize() async {
    final cameras = await availableCameras();
    final frontCamera =
        cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
    _isFrontCamera = true;

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
        _isDetecting = false;
        return;
      }

      final inputImage =
          _convertCameraImage(image, _controller!.description.sensorOrientation);
      final poses = await _poseDetector.processImage(inputImage);

      if (mounted && poses.isNotEmpty) {
        final landmarks = poses.first.landmarks.values.toList();
        final points = {
          for (var lm in landmarks) lm.type: Offset(lm.x, lm.y),
        };

        final evaluator =
            PoseEvaluatorService.getEvaluatorByName(widget.courseName);
        String? feedback;

        if (evaluator != null && !evaluator.evaluate(points)) {
          feedback = evaluator.feedback;

          if (!_isSpeaking) {
            _isSpeaking = true;
            await _flutterTts.speak(feedback!);
            _isSpeaking = false;
          }
        }

        setState(() {
          _landmarks = landmarks;
          _feedbackText = feedback;
        });
      }
    } catch (e) {
      debugPrint('❌ Detection error: $e');
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
      rotation: InputImageRotationValue.fromRawValue(rotation) ??
          InputImageRotation.rotation0deg,
      format: InputImageFormat.nv21,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _poseDetector.close();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;
    final previewSize = _controller!.value.previewSize!;
    final scale = size.aspectRatio * previewSize.aspectRatio;

    return Scaffold(
      appBar: AppBar(title: Text('ฝึก: ${widget.courseName}')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: scale < 1 ? 1 / scale : scale,
            child: Center(child: CameraPreview(_controller!)),
          ),
          if (_landmarks.isNotEmpty)
            CustomPaint(
              painter: PosePainter.fromLandmarks(
                _landmarks,
                previewSize.width,
                previewSize.height,
                isFrontCamera: _isFrontCamera,
              ),
            ),
          if (_feedbackText != null)
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _feedbackText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
