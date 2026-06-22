import 'dart:convert';

import 'package:fresh_point/utility/common_rest_api.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';

class PolicyController extends GetxController {
  // Variables
  RxBool isLoading = false.obs;
  RxString pageContent = ''.obs;

  @override
  void onInit() {
    fetchprivacypolicy();
    super.onInit();
  }

  // Fetch Privacy Policy
  Future<void> fetchprivacypolicy() async {
    isLoading.value = true;
    try {
      final params = {
        "cms_name": "Privacy-Policy",
        "user_agent": "EI-AAPP",
      };

      final response = await ApiServices.postPublicSingle(
        Environment.policy,
        params,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        pageContent.value = responseData['data']['page_content'] ?? '';
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
