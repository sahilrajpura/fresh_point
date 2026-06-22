import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    loadUserData();
    super.onInit();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('UserData');

    if (data != null) {
      userData.value = Map<String, dynamic>.from(jsonDecode(data)); // ✅
    }
  }
}
