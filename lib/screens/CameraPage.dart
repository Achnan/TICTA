import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    final frontCamera = cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    controller = CameraController(frontCamera, ResolutionPreset.medium);

    await controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Camera Preview')),
      body: CameraPreview(controller!),
    );
  }
}
