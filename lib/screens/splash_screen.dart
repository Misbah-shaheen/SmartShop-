// screens/splash_screen.dart
// Concept: StatefulWidget, Future.delayed, async/await, AnimationController

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.75, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _run();
  }

  Future<void> _run() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _ctrl.forward();
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.5), blurRadius: 32, spreadRadius: 6)],
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, color: AppColors.white, size: 42),
                ),
                const SizedBox(height: 20),
                Text('SmartShop+',
                    style: AppTextStyles.h1.copyWith(color: AppColors.white, fontSize: 30, letterSpacing: -0.8)),
                const SizedBox(height: 6),
                Text('Shop smarter, live better',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white38)),
                const SizedBox(height: 56),
                SizedBox(
                  width: 24, height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.accent.withOpacity(0.7)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
