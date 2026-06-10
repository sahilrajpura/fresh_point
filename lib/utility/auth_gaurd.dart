import 'package:flutter/material.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMiddlewareIsUser extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final prefs = Get.find<SharedPreferences>();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      return const RouteSettings(name: AppRouter.register);
    }

    return null;
  }
}


// import 'package:flutter/material.dart';
// import 'package:freshmart/Utility/routes.dart';
// import 'package:freshmart/Utility/shared_preferences.dart';
// import 'package:get/get.dart';

// // AuthMiddleware for is  user or not

// class AuthMiddlewareIsUser extends GetMiddleware {
//   @override
//   RouteSettings? redirect(String? route) {
//     String? userToken;
//     String? currentUserType;
//     SharedPreferencesManager sharedPreferences =
//         Get.find<SharedPreferencesManager>();

//     userToken = sharedPreferences.getString('token');
//     currentUserType = sharedPreferences.getString('userType');
//     if (userToken != null && currentUserType == 'U') {
//       return RouteSettings(name: AppRouter.home);
//     } else if (userToken != null && currentUserType == 'W') {
//       return RouteSettings(name: AppRouter.home);
//     } else if (userToken != null && currentUserType == 'D') {
//       return RouteSettings(name: AppRouter.deliverydeliveryDashboard);
//     } else {
//       return super.redirect(route);
//     }
//   }
// }