import 'dart:convert';
import 'package:fresh_point/utility/common_rest_api.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController extends GetxController {
  // Variables
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> orderList = <Map<String, dynamic>>[].obs;

  //  Fetch Orders API
  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      if (tokenUser == null || tokenUser.isEmpty) {
        toasterMessage("User not logged in", error);
        return;
      }

      final params = {
        "user_agent": "EI-AAPP",
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.getOrders,
        params,
        tokenUser,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final data = List<Map<String, dynamic>>.from(responseData['data']);

        //  Process Data
        for (var item in data) {
          item['formatted_amount'] = "₹ ${item['paid_amount']}";
          item['status_text'] = item['order_status_disp'] ?? "";
        }

        orderList.assignAll(data);
      } else {
        toasterMessage(responseData['message'], error);
      }
    } catch (e) {
      toasterMessage('Something Went Wrong', error);
    } finally {
      isLoading.value = false;
    }
  }

  //  Status Color Helper
  getStatusColor(String status) {
    if (status == "Order Placed") return orange;
    if (status == "Delivered") return primary;
    if (status == "Cancelled") return error;
    return dark;
  }

  //  Auto Call when Controller Init
  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }
}
