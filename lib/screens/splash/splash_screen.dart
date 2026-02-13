import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pari_enterprises_delivery/screens/home/home_screen.dart';
import 'package:pari_enterprises_delivery/screens/login/login_screen.dart';
import 'package:pari_enterprises_delivery/shared_pref/shared_pref.dart';
import 'package:pari_enterprises_delivery/utils/animation_helper/animated_page_route.dart';
import 'package:pari_enterprises_delivery/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 2500), () async {
      if (!mounted) return;

      final isLoggedIn = await SharedPref.isLoggedIn();

      Navigator.pushReplacement(
        context,
        AnimatedPageRoute(
          page: isLoggedIn ? const HomeScreen() : const LoginScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/pari-enterprises-logo.png',
              width: 220.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
