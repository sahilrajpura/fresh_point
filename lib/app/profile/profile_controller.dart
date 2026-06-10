import 'dart:convert';

import 'package:fresh_point/utility/common_rest_api.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  RxString userName = ''.obs;
  RxString mobileNumber = ''.obs;
  RxBool isLoading = false.obs;
  RxMap<String, dynamic> appData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchAppData();
  }

  // Local save user data
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userDataString = prefs.getString('UserData');

    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);

      userName.value = userData['name']?.toString() ?? '---';
      mobileNumber.value = userData['mobile']?.toString() ?? '---';
    }
  }

  // Fetch Privacy Policy
  Future<void> fetchAppData() async {
    isLoading.value = true;
    try {
      final response = await ApiServices.getPublicAuth(
        Environment.siteData,
      );

      final responseData = jsonDecode(
        response.body,
      );

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        appData.value = responseData['data'] ?? '';
      } else {
        toasterMessage(
          responseData['message'],
          error,
        );
      }
    } catch (e) {
      toasterMessage(
        "Something went wrong!",
        error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
