import 'package:flutter/material.dart';
import 'package:hci_mi5y_dormconnect/widgets/navigation_bar/navigation_bar.dart';
import 'package:hci_mi5y_dormconnect/pages/home/home_page.dart';
import 'package:hci_mi5y_dormconnect/pages/discover/discover_page.dart';
import 'package:hci_mi5y_dormconnect/pages/profile/MainPages/settings_home_page.dart';
import 'package:hci_mi5y_dormconnect/pages/communities/communities_page.dart';

class FloatingNavBarPage extends StatefulWidget {
  @override
  _FloatingNavBarPageState createState() => _FloatingNavBarPageState();
}

class _FloatingNavBarPageState extends State<FloatingNavBarPage> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    HomePage(onNavigateToDiscover: () {
      setState(() {
        _selectedIndex = 1;
      });
    }),

    const DiscoverPage(),
    const CommunitiesPage(),
    const SettingsHomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBarWithLine(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}