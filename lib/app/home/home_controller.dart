import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fresh_point/app/product_list/product_list_controller.dart';
import 'package:fresh_point/utility/common_rest_api.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/sharedprefrence.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  // Variables
  RxInt selectedIndex = 0.obs;
  RxInt tabBarKey = 0.obs;

  RxBool isLoading = false.obs;
  RxBool isPageLoading = true.obs;

  RxInt shimmerCount = 0.obs;

  RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> vegProductList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> fruitProductList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> dryFruitProductList = <Map<String, dynamic>>[].obs;

  TextEditingController searchController = TextEditingController();

  RxList<Map<String, dynamic>> searchProductList = <Map<String, dynamic>>[].obs;

  RxMap<String, int> cartQtyMap = <String, int>{}.obs;

  RxList<Map<String, dynamic>> offerList = <Map<String, dynamic>>[].obs;

  var offerCurrentIndex = 0.obs;
  late PageController offerPageController;
  Timer? offerTimer;

  RxInt cartCount = 0.obs;
  RxString searchText = ''.obs;

  // For Slider
  void onOfferPageChanged(int index) {
    offerCurrentIndex.value = index;
  }

  // Refresh BottomBar
  void refreshBottomBar() {
    tabBarKey.value++;
  }

  // Bottom Bar Tabs
  final tabs = [
    'home',
    'products',
    'cart',
    'profile',
  ];

  // onInit
  @override
  void onInit() {
    super.onInit();

    loadCartQtyMap().then((_) {
      fetchCartFromServer();
    });

    loadHomeData();

    offerPageController = PageController();

    offerTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      // offerCurrentIndex.value = (offerCurrentIndex.value + 1) % 3;
      if (offerList.isNotEmpty) {
        offerCurrentIndex.value = (offerCurrentIndex.value + 1) % offerList.length;

        offerPageController.animateToPage(
          offerCurrentIndex.value,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      offerPageController.animateToPage(
        offerCurrentIndex.value,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    if (Get.arguments != null && Get.arguments is int) {
      selectedIndex.value = Get.arguments;
    }
  }

  // Local Cart
  Future<void> loadCartQtyMap() async {
    try {
      SharedPreferencesManager sharedPreferences = Get.find<SharedPreferencesManager>();
      String? cartJson = sharedPreferences.getString('cart_qty_map');

      if (cartJson != null && cartJson.isNotEmpty) {
        Map<String, dynamic> raw = jsonDecode(cartJson);
        cartQtyMap.value = raw.map((k, v) => MapEntry(k, (v as num).toInt()));
        updateCartCount();
      }
    } catch (e) {
      toasterMessage('Can not load', error);
    }
  }

  // Clear Local Cart
  Future<void> clearLocalCart() async {
    SharedPreferencesManager sharedPreferences = Get.find<SharedPreferencesManager>();
    await sharedPreferences.putString('cart_qty_map', '{}');
    cartQtyMap.clear();
    updateCartCount();
  }

  // On Close
  @override
  void onClose() {
    offerTimer?.cancel();
    offerPageController.dispose();
    super.onClose();
  }

  // Get Qauntity
  int getQty(String productId) {
    return cartQtyMap[productId] ?? 0;
  }

  // Update Qauntity
  void updateQty(String productId, int qty, {bool fromUserInteraction = true}) {
    qty = qty < 0 ? 0 : qty;

    if (qty == 0) {
      cartQtyMap.remove(productId);
    } else {
      cartQtyMap[productId] = qty;
    }

    for (var item in vegProductList) {
      if (item['id'].toString() == productId) {
        item['qty'] = qty;
      }
    }

    for (var item in fruitProductList) {
      if (item['id'].toString() == productId) {
        item['qty'] = qty;
      }
    }

    for (var item in dryFruitProductList) {
      if (item['id'].toString() == productId) {
        item['qty'] = qty;
      }
    }

    vegProductList.refresh();
    fruitProductList.refresh();
    dryFruitProductList.refresh();

    updateCartCount();
    saveCartToLocal();

    if (fromUserInteraction) {
      if (qty == 0) {
        removeCart(productId: productId);
      } else {
        addToCart(productId: productId, quantity: qty);
      }
    }
  }

  // Save in Local Cart
  Future<void> saveCartToLocal() async {
    try {
      SharedPreferencesManager sharedPreferences = Get.find<SharedPreferencesManager>();
      await sharedPreferences.putString('cart_qty_map', jsonEncode(cartQtyMap));
    } catch (e) {
      debugPrint("$e");
    }
  }

  // Apply Local Cart
  void applyLocalCart(List<Map<String, dynamic>> productList) {
    for (var item in productList) {
      String id = item['id'].toString();
      item['qty'] = cartQtyMap[id] ?? 0;
    }
  }

  // Load Home Data
  Future<void> loadHomeData() async {
    isLoading.value = true;
    isPageLoading.value = true;
    await fetchUserData();
    await fetchCartFromServer();
    await fetchProductsVeg();
    await fetchProductsfruites();
    await fetchOffers();
    isLoading.value = false;
    isPageLoading.value = false;
  }

  // Fetch User Data
  Future<void> fetchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      final params = {
        'user_agent': 'EI-AAPP',
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.userProfile,
        params,
        tokenUser!,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        userData.value = responseData['data'];
      } else {
        toasterMessage(responseData['message'], error);
      }
    } catch (e) {
      toasterMessage("Something went wrong!", error);
    }
  }

  // Fetch Veg Data
  Future<void> fetchProductsVeg() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      if (tokenUser == null || tokenUser.isEmpty) return;

      final params = {
        "user_agent": "EI-AAPP",
        'category_id': '1',
        'page_number': '1',
        'limit_per_page': '10',
      };

      shimmerCount.value = int.parse(params['limit_per_page']!);

      final response = await ApiServices.postPublicAuthToken(
        Environment.productList,
        params,
        tokenUser,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final data = List<Map<String, dynamic>>.from(responseData['data']);

        for (var item in data) {
          item['qty'] = 0;
        }

        applyLocalCart(data);

        vegProductList.value = data;
        updateCartCount();
      }
    } catch (e) {
      toasterMessage('Something Went Wrong', error);
    }
  }

  // Fetch Fruits Data
  Future<void> fetchProductsfruites() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      if (tokenUser == null || tokenUser.isEmpty) return;

      final params = {
        "user_agent": "EI-AAPP",
        'category_id': '2',
        'page_number': '1',
        'limit_per_page': '10',
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.productList,
        params,
        tokenUser,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final data = List<Map<String, dynamic>>.from(responseData['data']);

        for (var item in data) {
          item['qty'] = 0;
        }

        applyLocalCart(data);

        fruitProductList.value = data;
        updateCartCount();
      }
    } catch (e) {
      toasterMessage('Something Went Wrong', error);
    }
  }

  // Update Cart Count
  void updateCartCount() {
    cartCount.value = cartQtyMap.length;
  }

  // Fetch Cart From Server For (Storing Notify Data)
  Future<void> fetchCartFromServer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');
      if (tokenUser == null || tokenUser.isEmpty) return;

      final params = {"user_agent": "EI-AAPP"};

      final response = await ApiServices.postPublicAuthToken(
        Environment.getCart,
        params,
        tokenUser,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final List cartItems = responseData['data'] ?? [];

        for (var item in cartItems) {
          String productId = item['pro_id'].toString();
          int qty = int.tryParse(item['quantity'].toString()) ?? 0;
          if (qty > 0) {
            cartQtyMap[productId] = qty;
          }
        }

        updateCartCount();
        await saveCartToLocal();
      }
    } catch (e) {
      debugPrint("fetchCartFromServer error: $e");
    }
  }

  // Add To Cart
  Future<void> addToCart({
    required String productId,
    required int quantity,
    bool showToast = false,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      if (tokenUser == null || tokenUser.isEmpty) return;

      final params = {
        "user_agent": "EI-AAPP",
        "product_id": productId,
        "quantity": quantity.toString(),
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.addToCart,
        params,
        tokenUser,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        if (showToast) {
          toasterMessage(responseData['message'], primary);
        }
      } else {
        if (showToast) {
          toasterMessage(responseData['message'], error);
        }
      }
    } catch (e) {
      if (showToast) {
        toasterMessage("Something went wrong!", error);
      }
    }
  }

  // Remove From Cart
  Future<void> removeCart({
    required String productId,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      if (tokenUser == null || tokenUser.isEmpty) return;

      final params = {
        "user_agent": "EI-AAPP",
        "product_id": productId,
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.removeCart,
        params,
        tokenUser,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        toasterMessage(responseData['message'], primary);
      } else {
        toasterMessage(responseData['message'], error);
      }
    } catch (e) {
      toasterMessage("Something went wrong!", error);
    }
  }

  Future<void> resetCartEverywhere() async {
    await clearLocalCart();

    // Home products reset
    for (var item in vegProductList) {
      item['qty'] = 0;
    }

    for (var item in fruitProductList) {
      item['qty'] = 0;
    }

    for (var item in dryFruitProductList) {
      item['qty'] = 0;
    }

    vegProductList.refresh();
    fruitProductList.refresh();
    dryFruitProductList.refresh();

    // Product List screen reset
    if (Get.isRegistered<ProductListController>()) {
      final plc = Get.find<ProductListController>();

      for (var item in plc.vegProductList) {
        item['qty'] = 0;
      }

      for (var item in plc.fruitProductList) {
        item['qty'] = 0;
      }

      for (var item in plc.dryFruitProductList) {
        item['qty'] = 0;
      }

      plc.vegProductList.refresh();
      plc.fruitProductList.refresh();
      plc.dryFruitProductList.refresh();
    }

    updateCartCount();
  }

  // Search Api
  Future<void> searchProducts(String keyword) async {
    try {
      searchText.value = keyword;

      if (keyword.trim().isEmpty) {
        searchProductList.clear();

        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? tokenUser = prefs.getString('token');

      final params = {
        "user_agent": "EI-AAPP",
        "page_number": "1",
        "limit_per_page": "50",
        "order_by": "ASC",
        "search": keyword,
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.searchProduct,
        params,
        tokenUser!,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final List<Map<String, dynamic>> allProducts = List<Map<String, dynamic>>.from(
          responseData['data'],
        );

        // Local Filter
        final filteredProducts = allProducts.where((product) {
          final name = product['product_name']?.toString().toLowerCase() ?? '';

          return name.contains(
            keyword.toLowerCase(),
          );
        }).toList();

        searchProductList.value = filteredProducts;
      } else {
        searchProductList.clear();
      }
    } catch (e) {
      debugPrint("Search Error: $e");

      searchProductList.clear();
    }
  }

  // Fetch offer List

  Future<void> fetchOffers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenUser = prefs.getString('token');

      final params = {
        "user_agent": "EI-AAPP",
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.offerList,
        params,
        tokenUser!,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        offerList.value =
            List<Map<String, dynamic>>.from(
                  responseData['data'],
                )
                .where(
                  (e) => e['offer_type'] == 'W' || e['offer_type'] == 'M' || e['offer_type'] == 'P', // ← yeh add karo
                )
                .toList();
      }
    } catch (e) {
      debugPrint("Offer Error: $e");
    }
  }
}
