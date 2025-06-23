import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/course_event_service.dart';
import '../widgets/navigation_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:theraphy_flutter/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _navIndex = 2;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _highlightedDates = {};
  int _streak = 0;
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _highlightedDates = CourseEventService.getScheduledDates().toSet();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _streak = prefs.getInt('streak') ?? 0;
      _points = prefs.getInt('points') ?? 0;
    });
  }

  Future<void> _incrementStreak() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _streak++);
    await prefs.setInt('streak', _streak);
  }

  void _onNavTapped(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/news');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/select-course');
        break;
    }
  }

  void _showPointsPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('แต้มสะสม'),
        content: Text('🎯 คุณมี $_points แต้ม'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog(DateTime selectedDay) async {
    String? selectedCourse;
    TimeOfDay? timeOfDay;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("ตั้งแจ้งเตือน"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              items: CourseEventService.courseList.map<DropdownMenuItem<String>>((course) {
                return DropdownMenuItem<String>(
                  value: course['name'] as String,
                  child: Text(course['name']),
                );
              }).toList(),
              hint: const Text("เลือกคอร์ส"),
              onChanged: (val) => selectedCourse = val,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
              child: const Text("เลือกเวลา"),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (selectedCourse != null && timeOfDay != null) {
                final dateTime = DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                  timeOfDay!.hour,
                  timeOfDay!.minute,
                );
                await CourseEventService.scheduleCourseEvent(selectedCourse!, dateTime);
                await _incrementStreak();
                setState(() => _highlightedDates.add(dateTime));

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('ตั้งแจ้งเตือนคอร์ส "$selectedCourse" เวลา ${timeOfDay!.format(context)} สำเร็จ'),
                  ));
                }
              }
            },
            child: const Text("ตกลง"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TheraPhy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.stars),
            tooltip: 'แต้มสะสม',
            onPressed: _showPointsPopup,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'ผู้ใช้งาน',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F4E79)),
          ),
          const SizedBox(height: 4),
          Text('🔥 Streak: $_streak วัน', style: const TextStyle(fontSize: 18, color: Colors.orange)),
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await CourseEventService.testImmediateNotification();
                  },
                  child: const Text('ทดสอบแจ้งเตือนทันที'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await flutterLocalNotificationsPlugin.cancelAll();
                    setState(() => _highlightedDates.clear());
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ยกเลิกการแจ้งเตือนทั้งหมดแล้ว')),
                      );
                    }
                  },
                  child: const Text('ยกเลิกการแจ้งเตือนทั้งหมด'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.all(16),
            child: TableCalendar(
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(2026, 1, 1),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
                _showScheduleDialog(selected);
              },
              availableCalendarFormats: const {
                CalendarFormat.month: 'เดือน',
              },
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, _) {
                  final isHighlighted = _highlightedDates.any((d) => isSameDay(d, day));
                  if (isHighlighted) {
                    return Container(
                      margin: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('${day.day}', style: const TextStyle(color: Colors.white)),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: TheraBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTapped,
        labels: const ['ข่าวสาร', 'เลือกคอร์ส', 'ผู้ใช้งาน'], // 👈 เพิ่ม label ใหม่
      ),
    );
  }
}
