import 'package:flutter/material.dart';

class TheraBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TheraBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color bgColor = Color(0xFF205781);
  static const Color selectedBlockColor = Color(0xFF4F959D);
  static const Color iconNormalColor = Color(0xFF98D2C0);
  static const Color iconSelectedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: bgColor,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: iconSelectedColor,
      unselectedItemColor: iconNormalColor,
      items: [
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.article, 0),
          label: 'ข่าวสาร',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.fitness_center, 1),
          label: 'เลือกคอร์ส',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.settings, 2),
          label: 'ตั้งค่า',
        ),
      ],
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    final bool selected = index == currentIndex;
    return Container(
      decoration: selected
          ? BoxDecoration(
              color: selectedBlockColor,
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      padding: const EdgeInsets.all(6),
      child: Icon(
        icon,
        color: selected ? iconSelectedColor : iconNormalColor,
      ),
    );
  }
}
