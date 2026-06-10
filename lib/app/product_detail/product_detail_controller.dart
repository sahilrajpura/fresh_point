import 'dart:convert';

import 'package:fresh_point/app/home/home_controller.dart';
import 'package:fresh_point/utility/common_rest_api.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/sharedprefrence.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  RxBool isLoading = false.obs;

  /// Product detail data
  RxMap<String, dynamic> productData = <String, dynamic>{}.obs;

  /// Product ID
  late String productId;
  RxInt localQty = 1.obs;

  /// HomeController reference
  final HomeController homeController = Get.find<HomeController>();

  /// Cart Count from HomeController
  RxInt get cartCount => homeController.cartCount;

  @override
  void onInit() {
    super.onInit();

    /// Get product id from arguments
    if (Get.arguments != null) {
      productId = Get.arguments.toString();
      fetchProductDetail();
    }
  }

  /// Fetch Product Detail API
  Future<void> fetchProductDetail() async {
    try {
      isLoading.value = true;

      SharedPreferencesManager sharedPreferences = Get.find<SharedPreferencesManager>();
      String? tokenUser = sharedPreferences.getString('token');

      if (tokenUser == null || tokenUser.isEmpty) {
        toasterMessage("User not logged in", error);
        return;
      }

      final params = {
        "user_agent": "EI-AAPP",
        "product_id": productId,
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.productDetail,
        params,
        tokenUser,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        productData.value = Map<String, dynamic>.from(responseData['data']);
        final existingQty = homeController.getQty(productId);
        localQty.value = existingQty == 0 ? 1 : existingQty;
      } else {
        toasterMessage(responseData['message'], error);
      }
    } catch (e) {
      toasterMessage("Something went wrong!", error);
    } finally {
      isLoading.value = false;
    }
  }

  // update Local Cart — no API call
  void updateQtyLocal(String productId, int newQty) {
    if (newQty >= 1) {
      localQty.value = newQty;
    }
  }

  void syncQtyAcrossControllers(
    String productId,
    int newQty, {
    bool showToast = false,
  }) async {
    if (newQty == 0) {
      homeController.removeCart(productId: productId);
    } else {
      // Pehle local update karo
      homeController.cartQtyMap[productId] = newQty;
      homeController.updateCartCount();
      homeController.saveCartToLocal();

      // Phir API call karo
      await homeController.addToCart(
        productId: productId,
        quantity: newQty,
        showToast: showToast,
      );

      // API ke baad localQty bhi sync karo
      localQty.value = newQty;
    }
  }
}
