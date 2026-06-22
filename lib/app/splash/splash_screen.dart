// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:fresh_point/utility/routes.dart';
// import 'package:get/get.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   goDefaultPage() {
//     Timer(Duration(seconds: 2), () {
//       Get.offAllNamed(AppRouter.home);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     goDefaultPage();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/Splash_image.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> goDefaultPage() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    final userType = prefs.getString('userType');

    Timer(const Duration(seconds: 2), () {
      if (token == null) {
        Get.offAllNamed(AppRouter.login);
      } else if (userType == 'W') {
        Get.offAllNamed(AppRouter.home);
      } else {
        Get.offAllNamed(AppRouter.deliveryDashboard);
      }
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Splash_image.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
