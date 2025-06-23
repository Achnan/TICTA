import 'package:flutter/material.dart';
import '../services/course_event_service.dart';
import '../widgets/navigation_bar.dart';

class SelectCourseScreen extends StatefulWidget {
  const SelectCourseScreen({super.key});

  @override
  State<SelectCourseScreen> createState() => _SelectCourseScreenState();
}

class _SelectCourseScreenState extends State<SelectCourseScreen> {
  int _navIndex = 1;

  void _onNavTapped(int index) {
    setState(() {
      _navIndex = index;
    });
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
  }

  final List<Map<String, dynamic>> courseList = CourseEventService.courseList;

  void _startCourse(String exerciseName) {
    Navigator.pushNamed(context, '/camera', arguments: exerciseName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกคอร์ส'),
        backgroundColor: const Color(0xFF1F4E79),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courseList.length,
        itemBuilder: (context, index) {
          final course = courseList[index];
          return ExpansionTile(
            title: Text(
              course['name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F4E79),
              ),
            ),
            children: List.generate(course['exercises'].length, (i) {
              final ex = course['exercises'][i];
              return ListTile(
                title: Text(ex['title']),
                subtitle: Text('${ex['desc']} - ${ex['reps']} (${ex['duration']})'),
                onTap: () => _startCourse(ex['title']), // ✅ ส่งชื่อท่าฝึกไปแทนชื่อคอร์ส
              );
            }),
          );
        },
      ),
      bottomNavigationBar: TheraBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
