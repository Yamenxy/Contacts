import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/route_logo.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _redirectTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Center(
        child: Padding(padding: EdgeInsets.all(16), child: _SplashCard()),
      ),
    );
  }
}

class _SplashCard extends StatelessWidget {
  const _SplashCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 520,
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(42),
      ),
      child: const Center(child: RouteLogo(width: 160)),
    );
  }
}
