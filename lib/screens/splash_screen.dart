import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const SplashScreen({super.key, required this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _splashDuration = Duration(seconds: 2);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_splashDuration, _goToHome);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
