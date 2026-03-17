import 'package:flutter/material.dart';

import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const PantherBitesApp());
}

class PantherBitesApp extends StatelessWidget {
  const PantherBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantherBites',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0039A6), // GSU blue
      ),
      home: const MainNavigationScreen(),
    );
  }
}
