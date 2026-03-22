import 'package:flutter/material.dart';

import 'screens/main_navigation_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PantherBitesApp());
}

class PantherBitesApp extends StatefulWidget {
  const PantherBitesApp({super.key});

  @override
  State<PantherBitesApp> createState() => _PantherBitesAppState();
}

class _PantherBitesAppState extends State<PantherBitesApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantherBites',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0039A6), // GSU blue
      ),
      home: _showSplash
          ? SplashScreen(
              onFinished: () {
                if (!mounted) {
                  return;
                }
                setState(() {
                  _showSplash = false;
                });
              },
            )
          : const MainNavigationScreen(),
    );
  }
}
