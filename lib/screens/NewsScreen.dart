import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ข่าวสาร')),
      body: const Center(
        child: Text(
          'อัปเดตข่าวสารจากทีมแพทย์และนักกายภาพ',
          style: TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: TheraBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // อยู่ที่หน้า News แล้ว
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/select-course');
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
