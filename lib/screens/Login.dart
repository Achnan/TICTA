import 'package:flutter/material.dart';
import 'SelectCourse.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SelectCourseScreen()),
            );
          },
          child: const Text("Mock Sign In"),
        ),
      ),
    );
  }
}