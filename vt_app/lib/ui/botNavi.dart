import 'package:flutter/material.dart';
import 'package:volume_tracker/ui/theme.dart';

class CustomBottomNaviBar extends StatefulWidget {
  const CustomBottomNaviBar({super.key});

  @override
  State<CustomBottomNaviBar> createState() => _CustomBottomNaviBarState();
}

class _CustomBottomNaviBarState extends State<CustomBottomNaviBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Plan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.mainGreen,
        onTap: _onItemTapped,
      );
  }
}
