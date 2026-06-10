import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  goDefaultPage() {
    Timer(Duration(seconds: 2), () {
      Get.offAllNamed(AppRouter.home);
    });
  }

  @override
  void initState() {
    super.initState();
    goDefaultPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Splash_image.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
