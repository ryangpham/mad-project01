import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  //callback is triggered when splash is finished
  final VoidCallback onFinished;

  const SplashScreen({super.key, required this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //Duration that the splash screen can be seen
  static const Duration _splashDuration = Duration(seconds: 2);
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    //Start timer when screen loads
    _timer = Timer(_splashDuration, _goToHome);
  }

  @override
  void dispose() {
    //Cancel timer to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }

  //Navigate to screen after splash
  void _goToHome() {
    if (!mounted) {
      return;
    }

    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('lib/images/logo.png', width: 260, height: 260),
      ),
    );
  }
}
