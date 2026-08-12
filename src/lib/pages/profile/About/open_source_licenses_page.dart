import 'package:flutter/material.dart';

class OpenSourceLicensesPage extends StatelessWidget {
  const OpenSourceLicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5D3B7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Open-source Licenses', style: TextStyle(color: Colors.black)),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'This app uses the following open-source packages:\n\n• provider\n• cupertino_icons\n• flutter_svg\n• ...',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
