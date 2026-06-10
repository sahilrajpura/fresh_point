import 'dart:convert';

import 'package:fresh_point/utility/common_rest_api.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utility/theme.dart';

class OrderDetailController extends GetxController {
  RxBool isLoading = false.obs;
  RxMap<String, dynamic> orderDetail = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();

    final orderId = Get.arguments;
    fetchOrderDetail(orderId);
  }

  // Fetch Order Detail
  Future<void> fetchOrderDetail(String orderId) async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      if (tokenUser == null || tokenUser.isEmpty) {
        isLoading.value = false;
        return;
      }

      final params = {
        "user_agent": "EI-AAPP",
        "order_id": orderId,
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.orderDetail,
        params,
        tokenUser,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final data = responseData['data'];

        orderDetail.value = data;
      } else {
        toasterMessage(responseData['message'], error);
      }
    } catch (e) {
      toasterMessage("Something went wrong!", error);
    } finally {
      isLoading.value = false;
    }
  }
}
