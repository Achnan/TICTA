// lib/widgets/navigation_bar.dart
import 'package:flutter/material.dart';

class TheraBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TheraBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'ข่าวสาร',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'เลือกคอร์ส',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'ตั้งค่า',
        ),
      ],
    );
  }
}
