import 'package:flutter/material.dart';
import 'screens/Home.dart';
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/select-course': (context) => const SelectCourseScreen(),
        '/camera': (context) => const CameraPage(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
