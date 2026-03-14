import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const PantherBitesApp());
}

class PantherBitesApp extends StatelessWidget {
  const PantherBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantherBites',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
