import 'package:flutter/material.dart';

class AppVersionBuildNumberPage extends StatelessWidget {
  const AppVersionBuildNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5D3B7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('App Version', style: TextStyle(color: Colors.black)),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(
        child: Text(
          'Version: 1.0.0\nBuild: 100',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
