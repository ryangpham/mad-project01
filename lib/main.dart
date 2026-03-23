import 'package:flutter/material.dart';

import 'screens/main_navigation_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  //Start of the Flutter app
  runApp(const PantherBitesApp());
}

class PantherBitesApp extends StatefulWidget {
  const PantherBitesApp({super.key});

  @override
  State<PantherBitesApp> createState() => _PantherBitesAppState();
}

class _PantherBitesAppState extends State<PantherBitesApp> {
  //Controlls if the splash screen is shown
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantherBites',
      debugShowCheckedModeBanner: false, //Removes the debug banner
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0039A6), // App theme color of GSU blue
      ),

      //Shows splash then the main app
      home: _showSplash
          ? SplashScreen(
              onFinished: () {
                if (!mounted) {
                  return;
                }

                //Switch to main app after splash
                setState(() {
                  _showSplash = false;
                });
              },
            )
          : const MainNavigationScreen(),
    );
  }
}
