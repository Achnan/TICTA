import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:theraphy_flutter/main.dart'; // สำคัญสำหรับใช้ flutterLocalNotificationsPlugin จาก main.dart

class CourseEventService {
  static final List<DateTime> _scheduledDates = [];

  static final List<Map<String, dynamic>> courseList = [
    {
      'name': 'กายภาพบำบัดขา',
      'exercises': [
        {
          'title': 'Seated Leg Raise',
          'desc': 'เสริมกล้ามต้นขา',
          'reps': 'ข้างละ 10',
          'duration': '~3 นาที',
          'howto': 'นั่งบนเก้าอี้ หลังตรง มือวางบนต้นขา\nเหยียดขาขวาขึ้นจนตึง ค้างไว้ 5 วินาที\nลดลงช้า ๆ แล้วทำสลับข้าง',
        },
        {
          'title': 'Standing Knee Flexion',
          'desc': 'งอกล้ามเนื้อหลังขา',
          'reps': 'ข้างละ 10',
          'duration': '~3 นาที',
          'howto': 'ยืนหลังตรง จับพนักเก้าอี้เพื่อพยุงตัว\nงอเข่าให้ส้นเท้าชี้ขึ้นด้านหลัง\nค้างไว้ 3–5 วินาที แล้วลดลงช้า ๆ',
        },
        {
          'title': 'Side Leg Raise',
          'desc': 'กล้ามเนื้อสะโพก',
          'reps': 'ข้างละ 10',
          'duration': '~2 นาที',
          'howto': 'ยืนจับเก้าอี้หรือกำแพง\nยกขาออกด้านข้างโดยไม่เอนไปอีกฝั่ง\nค้างไว้ 5 วินาที แล้วลดลงช้า ๆ',
        },
        {
          'title': 'Heel Raise',
          'desc': 'เสริมกล้ามเนื้อน่อง',
          'reps': '10–15 ครั้ง',
          'duration': '~2 นาที',
          'howto': 'ยืนตรง เขย่งส้นเท้าขึ้น ค้างไว้ 3 วินาที\nแล้วลดลงช้า ๆ',
        },
      ],
    },
    {
      'name': 'กายภาพบำบัดไหล่',
      'exercises': [
        {
          'title': 'Shoulder Rolls',
          'desc': 'ผ่อนคลายข้อไหล่',
          'reps': '10 รอบ หน้า-หลัง',
          'duration': '~2 นาที',
          'howto': 'หมุนไหล่ไปข้างหน้า 10 รอบ\nหมุนกลับหลัง 10 รอบ',
        },
        {
          'title': 'Shoulder Shrug',
          'desc': 'ลดอาการตึงที่ไหล่',
          'reps': '10 ครั้ง',
          'duration': '~2 นาที',
          'howto': 'ยกไหล่ขึ้นสูงสุด ค้างไว้ 3 วินาที\nลดลงช้า ๆ',
        },
        {
          'title': 'Wall Slide',
          'desc': 'เพิ่มการเคลื่อนไหวของข้อไหล่',
          'reps': '10 ครั้ง',
          'duration': '~3 นาที',
          'howto': 'เหยียดแขนแนบผนังเป็นตัว Y\nเลื่อนขึ้น-ลงช้า ๆ โดยหลังแนบผนัง',
        },
        {
          'title': 'Shoulder Abduction',
          'desc': 'กางแขนออกข้าง เสริมไหล่',
          'reps': '10 ครั้ง',
          'duration': '~3 นาที',
          'howto': 'กางแขนออกด้านข้างจนถึงระดับไหล่\nค้างไว้ 5 วินาที แล้วลดลงช้า ๆ',
        },
      ],
    },
    {
      'name': 'กายภาพบำบัดแขน',
      'exercises': [
        {
          'title': 'Arm Circles',
          'desc': 'เพิ่มความยืดหยุ่นหัวไหล่',
          'reps': '10 รอบ หน้า–หลัง',
          'duration': '~2 นาที',
          'howto': 'หมุนแขนเป็นวงเล็ก ๆ ด้านหน้า 10 รอบ\nแล้วหมุนกลับด้านหลัง 10 รอบ',
        },
        {
          'title': 'Elbow Flexion',
          'desc': 'ฝึกงอ-เหยียดข้อศอก',
          'reps': 'ข้างละ 10 ครั้ง',
          'duration': '~2 นาที',
          'howto': 'งอข้อศอกขึ้นแตะไหล่ ค้างไว้ 2 วินาที\nเหยียดลงช้า ๆ ทำสลับข้าง',
        },
        {
          'title': 'Arm Extension Forward',
          'desc': 'เหยียดแขนหน้า-ชูขึ้น',
          'reps': '10 ครั้ง',
          'duration': '~2 นาที',
          'howto': 'เหยียดแขนไปข้างหน้าแล้วชูขึ้น\nค้างไว้ 3 วินาที แล้วลดลงช้า ๆ',
        },
        {
          'title': 'Wall Push-Up',
          'desc': 'เสริมแรงต้นแขน/หัวไหล่',
          'reps': '10–15 ครั้ง',
          'duration': '~3 นาที',
          'howto': 'ยืนห่างจากผนัง 1 ก้าว\nมือยันผนัง งอศอกเข้า – เหยียดออก',
        },
      ],
    },
  ];

  /// ตั้งการแจ้งเตือนในเวลาที่กำหนด
  static Future<void> scheduleCourseEvent(String courseName, DateTime dateTime) async {
  final tzDateTime = tz.TZDateTime.from(dateTime, tz.local);
  final int id = dateTime.millisecondsSinceEpoch.remainder(100000);
  
  debugPrint('📅 ตั้งแจ้งเตือน: $courseName @ $tzDateTime (id=$id)');

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    'แจ้งเตือนคอร์ส',
    'ถึงเวลาฝึกคอร์ส: $courseName แล้ว!',
    tzDateTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'main_channel',
        'Main Channel',
        channelDescription: 'แจ้งเตือนคอร์สกายภาพ',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
  );

  _scheduledDates.add(dateTime);
  debugPrint('✅ แจ้งเตือนถูกตั้งสำเร็จ');

  await showScheduledConfirmationNotification(courseName, dateTime);
}



  /// แจ้งเตือนทันทีเพื่อทดสอบ
  static Future<void> testImmediateNotification() async {
    await flutterLocalNotificationsPlugin.show(
      1,
      'ทดสอบแจ้งเตือน',
      'นี่คือข้อความแจ้งเตือนทันที',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          channelDescription: 'ทดสอบการแจ้งเตือน',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// แจ้งเตือนเมื่อผู้ใช้ตั้งเวลาแจ้งเตือนเสร็จ
  static Future<void> showScheduledConfirmationNotification(String courseName, DateTime dateTime) async {
    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    await flutterLocalNotificationsPlugin.show(
      2,
      'ตั้งการแจ้งเตือนสำเร็จ',
      'คอร์ส: $courseName เวลา $timeStr',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          channelDescription: 'แจ้งเตือนยืนยัน',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  static List<DateTime> getScheduledDates() => _scheduledDates;
}
