import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const BottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Personer"),
        BottomNavigationBarItem(
            icon: Icon(Icons.directions_car), label: "Fordon"),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on), label: "P-platser"),
        BottomNavigationBarItem(
            icon: Icon(Icons.local_parking), label: "Parkering"),
      ],
    );
  }
}
