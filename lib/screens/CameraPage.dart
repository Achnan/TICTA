import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class CameraPage extends StatefulWidget {
  final String? course;
  const CameraPage({super.key, this.course});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  late Interpreter _interpreter;

  String? _selectedCourse;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _selectedCourse = widget.course; // ถ้ามีค่าใน constructor ก็เก็บไว้ก่อน
    _initializeCamera();
    _loadModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ถ้ายังไม่มีคอร์สจาก constructor ลองดึงจาก route arguments
    if (_selectedCourse == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        setState(() {
          _selectedCourse = args;
        });
        print("🧘 Course selected via route args: $_selectedCourse");
      }
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCam, ResolutionPreset.medium);

    await _controller!.initialize();

    // เริ่ม stream ภาพจากกล้อง
    await _controller!.startImageStream(_processCameraImage);

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('models/move.tflite');
    print('✅ Model loaded!');
  }

  void _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final inputTensor = _interpreter.getInputTensor(0);
      final inputShape = inputTensor.shape; // [1, height, width, 3]
      final inputHeight = inputShape[1];
      final inputWidth = inputShape[2];

      // แปลงภาพ YUV420 => RGB
      final rgbBytes = _convertYUV420ToImage(image);

      // สร้าง TensorImage จาก bytes
      TensorImage inputImage = TensorImage.fromBytes(
        bytes: rgbBytes,
        shape: [image.height, image.width, 3],
      );

      // สร้าง ImageProcessor สำหรับ resize ให้พอดีกับ model input
      ImageProcessor imageProcessor = ImageProcessorBuilder()
          .add(ResizeOp(inputHeight, inputWidth, ResizeMethod.BILINEAR))
          .build();

      inputImage = imageProcessor.process(inputImage);

      // เตรียม output buffer
      final output = List.generate(1, (_) => List.filled(17 * 3, 0.0));

      // รันโมเดล
      _interpreter.run(inputImage.buffer, output);

      // debug: print keypoints บางส่วน
      print('🧍‍♂️ Output keypoints sample: ${output[0].sublist(0, 6)}');

      // TODO: แสดงผล keypoints บน UI ต่อได้

    } catch (e) {
      print("Error processing image: $e");
    }

    _isDetecting = false;
  }

  Uint8List _convertYUV420ToImage(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final uvRowStride = image.planes[1].bytesPerRow;
    final uvPixelStride = image.planes[1].bytesPerPixel!;

    final img = Uint8List(width * height * 3);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final uvIndex =
            uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);

        final yp = image.planes[0].bytes[y * width + x];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];

        int r = (yp + (1.370705 * (vp - 128))).clamp(0, 255).toInt();
        int g = (yp - (0.337633 * (up - 128)) - (0.698001 * (vp - 128)))
            .clamp(0, 255)
            .toInt();
        int b = (yp + (1.732446 * (up - 128))).clamp(0, 255).toInt();

        final pixelIndex = y * width * 3 + x * 3;
        img[pixelIndex] = r;
        img[pixelIndex + 1] = g;
        img[pixelIndex + 2] = b;
      }
    }
    return img;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _interpreter.close();
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
      appBar: AppBar(
        title: Text('ฝึก: ${_selectedCourse ?? "ไม่ระบุ"}'),
      ),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                'Course: ${_selectedCourse ?? "None"}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
          // TODO: วาดจุด keypoints ทับที่นี่ได้
        ],
      ),
    );
  }
}
