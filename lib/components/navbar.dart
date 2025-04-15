import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: Icon(Icons.home, color: currentIndex == 0 ? Colors.white : Colors.grey), onPressed: () => onTap(0)),
          IconButton(icon: Icon(Icons.medical_services, color: currentIndex == 1 ? Colors.white : Colors.grey), onPressed: () => onTap(1)),
          const SizedBox(width: 48),
          IconButton(icon: Icon(Icons.search, color: currentIndex == 2 ? Colors.white : Colors.grey), onPressed: () => onTap(2)),
          IconButton(icon: Icon(Icons.settings, color: currentIndex == 3 ? Colors.white : Colors.grey), onPressed: () => onTap(3)),
        ],
      ),
    );
  }
}