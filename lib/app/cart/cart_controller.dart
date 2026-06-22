import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fresh_point/app/home/home_controller.dart';
import 'package:fresh_point/utility/common_rest_api.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/model/cart_successfull_dialog.dart';
import 'package:fresh_point/utility/model/cart_unsuccessfull_dialog.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  RxDouble productTotal = 0.0.obs;
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> cartList = <Map<String, dynamic>>[].obs;
  RxDouble deliveryCharge = 30.0.obs;
  final Map<int, double> _productTotals = {};

  // Cached fees
  double _fee1 = 0.0;
  double _fee2 = 0.0;
  double _fee3 = 0.0;
  double _fee4 = 0.0;

  final HomeController homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    fetchCart();

    ever(homeController.cartQtyMap, (_) {
      if (!isLoading.value) {
        syncCartLocal();
      }
    });
  }

  void syncCartLocal() {
    if (cartList.isEmpty) return;

    bool changed = false;

    for (var item in cartList) {
      final String productId = item['pro_id']?.toString() ?? item['id']?.toString() ?? '';
      final int newQty = homeController.getQty(productId);
      final int currentQty = int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;

      if (newQty != currentQty) {
        item['quantity'] = newQty.toString();
        changed = true;
      }
    }

    cartList.removeWhere((item) {
      final String productId = item['pro_id']?.toString() ?? item['id']?.toString() ?? '';
      return homeController.getQty(productId) == 0;
    });

    if (changed) {
      cartList.refresh();
      calculateTotal();
    }
  }

  // Fetch Cart Data
  Future<void> fetchCart() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      final params = {"user_agent": "EI-AAPP"};

      final response = await ApiServices.postPublicAuthToken(
        Environment.getCart,
        params,
        tokenUser!,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        cartList.value = List<Map<String, dynamic>>.from(responseData['data']);
        calculateTotal();
        await _fetchAndCacheFees();
        _updateDeliveryChargeLocal();
      }
    } catch (e) {
      debugPrint('$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchAndCacheFees() async {
    try {
      final response = await ApiServices.getPublicAuth(Environment.siteData);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final settings = data['data'];

        _fee1 = double.parse(settings['delivery_fee_1']);
        _fee2 = double.parse(settings['delivery_fee_2']);
        _fee3 = double.parse(settings['delivery_fee_3']);
        _fee4 = double.parse(settings['delivery_fee_4']);
      }
    } catch (e) {
      debugPrint('Fee fetch error: $e');
    }
  }

  void _updateDeliveryChargeLocal() {
    final amount = productTotal.value;
    if (amount < 100) {
      deliveryCharge.value = _fee1;
    } else if (amount < 200) {
      deliveryCharge.value = _fee2;
    } else if (amount < 400) {
      deliveryCharge.value = _fee3;
    } else {
      deliveryCharge.value = _fee4;
    }
  }

  // Delete Item IN Cart
  Future<void> deleteCartItem(String productId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      final params = {
        "product_id": productId,
        "user_agent": "EI-AAPP",
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.removeCart,
        params,
        tokenUser!,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final homeController = Get.find<HomeController>();
        homeController.updateQty(productId, 0, fromUserInteraction: false);

        cartList.removeWhere((item) => item['pro_id'].toString() == productId || item['id'].toString() == productId);

        cartList.refresh();
        calculateTotal();
        _updateDeliveryChargeLocal();

        toasterMessage(data['message'], primary);
      }
    } catch (e) {
      debugPrint("Delete error: $e");
    }
  }

  // Order Api
  Future<void> placeOrder() async {
    if (isLoading.value) return;

    try {
      if (_fee1 == 0.0) {
        await _fetchAndCacheFees();
        _updateDeliveryChargeLocal();
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      if (tokenUser == null) {
        toasterMessage("User not logged in", error);
        return;
      }

      final params = {
        "user_agent": "EI-AAPP",
        "payment_method": "Cash On Delivery",
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.makeOrder,
        params,
        tokenUser,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        await prefs.setDouble('last_order_product_total', productTotal.value);
        await prefs.setDouble('last_order_delivery_charge', deliveryCharge.value);
        await prefs.setDouble('last_order_grand_total', productTotal.value + deliveryCharge.value);

        cartList.clear();
        cartList.refresh();
        calculateTotal();

        final homeController = Get.find<HomeController>();

        await homeController.resetCartEverywhere();

        toasterMessage(
          responseData['message'],
          primary,
        );

        Get.dialog(CartSuccessfullDialogScreen());
      } else {
        Get.dialog(CartUnSuccessfullDialogScreen());

        toasterMessage(
          responseData['message'] ?? "Order failed",
          error,
        );
      }
    } catch (e) {
      debugPrint("Order error: $e");

      toasterMessage(
        "Something went wrong",
        error,
      );
    }
  }

  // Calculate Total
  void calculateTotal() {
    _productTotals.clear();
    double total = 0;
    for (int i = 0; i < cartList.length; i++) {
      var item = cartList[i];
      double price = double.tryParse(item['sale_price']?.toString() ?? '0') ?? 0;
      int qty = int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
      double itemTotal = price * qty;
      _productTotals[i] = itemTotal;
      total += itemTotal;
    }
    productTotal.value = total;
  }

  void updateTotal(int index, double value) {
    _productTotals[index] = value;
    productTotal.value = _productTotals.values.fold(0.0, (sum, item) => sum + item);
    _updateDeliveryChargeLocal();
  }

  // Delivery Charge

  Future<double> getDeliveryCharge(double cartAmount) async {
    final response = await ApiServices.getPublicAuth(
      Environment.siteData,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final settings = data['data'];

      // values string me hai
      double fee1 = double.parse(settings['delivery_fee_1']);
      double fee2 = double.parse(settings['delivery_fee_2']);
      double fee3 = double.parse(settings['delivery_fee_3']);
      double fee4 = double.parse(settings['delivery_fee_4']);

      // Cache karo
      _fee1 = fee1;
      _fee2 = fee2;
      _fee3 = fee3;
      _fee4 = fee4;

      // condition apply
      if (cartAmount < 100) {
        return fee1;
      } else if (cartAmount < 200) {
        return fee2;
      } else if (cartAmount < 400) {
        return fee3;
      } else {
        return fee4;
      }
    } else {
      // fallback
      return 30;
    }
  }
}
