import 'package:flutter/material.dart';

class TheraBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<String>? labels;

  const TheraBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.labels,
  });

  static const Color bgColor = Color(0xFF205781);
  static const Color selectedBlockColor = Color(0xFF4F959D);
  static const Color iconNormalColor = Color(0xFF98D2C0);
  static const Color iconSelectedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final usedLabels = labels ?? ['ข่าวสาร', 'เลือกคอร์ส', 'ผู้ใช้งาน'];

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
          icon: _buildIcon(Icons.newspaper, 0),
          label: usedLabels[0],
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.accessibility_new, 1),
          label: usedLabels[1],
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.leaderboard_rounded, 2),
          label: usedLabels[2],
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
