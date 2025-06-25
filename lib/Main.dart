import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/NewsScreen.dart';
import 'screens/CameraPage.dart';
import 'screens/Login.dart';
import 'screens/SelectCourse.dart';
import 'screens/SettingsScreen.dart';

List<CameraDescription> cameras = [];

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied ||
      await Permission.notification.isPermanentlyDenied) {
    await Permission.notification.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('th', null);

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));

  await requestNotificationPermission();

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      debugPrint('🔔 Notification clicked: ${response.payload}');
    },
  );

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
      builder: (context, child) {
        return WillPopScope(
          onWillPop: () async {
          final navigator = Navigator.of(context);
          if (!navigator.canPop()) {
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SelectCourseScreen()),
              (route) => false,
            );
            return false;
          }
          return true;
        },

          child: child!,
        );
      },
      initialRoute: '/select-course',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/news':
            return MaterialPageRoute(builder: (_) => const NewsScreen());
          case '/select-course':
            return MaterialPageRoute(builder: (_) => const SelectCourseScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/camera':
            final courseName = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => CameraPage(courseName: courseName),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('ไม่พบเส้นทางที่เรียก')),
              ),
            );
        }
      },
    );
  }
}
