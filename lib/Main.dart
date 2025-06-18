import 'package:flutter/material.dart';
import 'screens/NewsScreen.dart';
import 'screens/CameraPage.dart';
import 'screens/Login.dart';
import 'screens/SelectCourse.dart';
import 'screens/SettingsScreen.dart';

void main() {
  runApp(const TheraPhyApp());
}

class TheraPhyApp extends StatelessWidget {
  const TheraPhyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheraPhy',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
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
