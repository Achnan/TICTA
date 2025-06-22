import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

import 'screens/NewsScreen.dart';
import 'screens/CameraPage.dart';
import 'screens/Login.dart';
import 'screens/SelectCourse.dart';
import 'screens/SettingsScreen.dart';

List<CameraDescription> cameras = [];

// ✅ Global notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// ✅ Request notification permission
Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied ||
      await Permission.notification.isPermanentlyDenied) {
    await Permission.notification.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Set timezone
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));

  // ✅ Request permission (Android 13+)
  await requestNotificationPermission();

  // ✅ Initialize notification
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      debugPrint('🔔 Notification clicked: ${response.payload}');
    },
  );

  // ✅ Initialize camera
  cameras = await availableCameras();

  runApp(const TheraPhyApp());
}

class TheraPhyApp extends StatelessWidget {
  const TheraPhyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheraPhy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        primaryColor: const Color(0xFF205781),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF205781),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/select-course',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/news': (context) => const NewsScreen(),
        '/select-course': (context) => const SelectCourseScreen(),
        '/camera': (context) => const CameraPage(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
