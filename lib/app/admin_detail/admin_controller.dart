import 'dart:convert';

import 'package:fresh_point/utility/common_rest_api.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  // Variables
  RxBool isLoading = false.obs;
  RxMap<String, dynamic> adminData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    fetchAdminData();
    super.onInit();
  }

  // Fetch Admin Data
  Future<void> fetchAdminData() async {
    isLoading.value = true;

    try {
      final response = await ApiServices.getPublicAuth(
        Environment.siteData,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        adminData.value = responseData['data'];
      } else {
        toasterMessage(
          responseData['message'],
          error,
        );
      }
    } catch (e) {
      toasterMessage(
        'Something Went Wrong',
        error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
