import 'package:flutter/material.dart';
import 'package:voice_recorder/main.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      onTap: _onItemTapped,
      currentIndex: _selectedIndex,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.home,
          ),
          label: 'Home',
          backgroundColor: kColorScheme.onPrimaryContainer,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.lyrics_outlined,
          ),
          label: 'Recordings',
          backgroundColor: kColorScheme.onPrimaryContainer,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Youtube Naat',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.surround_sound),
          label: 'Bayans',
          backgroundColor: kColorScheme.onPrimaryContainer,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.star),
          label: 'Online Naat',
          backgroundColor: kColorScheme.onPrimaryContainer,
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/homePage');
        break;
      case 1:
        Navigator.pushNamed(context, '/recordings');
        break;
      case 2:
        Navigator.pushNamed(context, '/youtube');
        break;
      case 3:
        Navigator.pushNamed(context, '/bayan');
        break;
      case 4:
        Navigator.pushNamed(context, '/naatPage');
        break;
    }
  }
}
