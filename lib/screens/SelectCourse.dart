import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';

class SelectCourseScreen extends StatefulWidget {
  const SelectCourseScreen({super.key});

  @override
  State<SelectCourseScreen> createState() => _SelectCourseScreenState();
}

class _SelectCourseScreenState extends State<SelectCourseScreen> {
  final List<String> courseList = [
    'Test Course 1',
    'Test Course 2',
    'Shoulder Stretch',
    'Lower Back Recovery',
  ];

  String? selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลือกคอร์ส')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'เลือกท่าฝึกกายภาพจากรายการ',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "เลือกคอร์ส",
                border: OutlineInputBorder(),
              ),
              value: selectedCourse,
              items: courseList.map((course) {
                return DropdownMenuItem(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedCourse == null
                  ? null
                  : () {
                      Navigator.pushNamed(
                        context,
                        '/camera',
                        arguments: selectedCourse,
                      );
                    },
              child: const Text("เริ่มคอร์ส"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TheraBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/news');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}
