// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fresh_point/app/home/home_controller.dart';
// import 'package:fresh_point/utility/common_rest_api.dart';
// import 'package:fresh_point/utility/environment.dart';
// import 'package:fresh_point/utility/sharedprefrence.dart';
// import 'package:fresh_point/utility/theme.dart';
// import 'package:fresh_point/utility/toaster_message.dart';
// import 'package:get/get.dart';

// class ProductListController extends GetxController {
//   // Veg
//   RxList<Map<String, dynamic>> vegProductList = <Map<String, dynamic>>[].obs;
//   RxBool isLoadingVegPagination = false.obs;
//   int vegCurrentPage = 1;
//   RxInt vegTotalCount = 0.obs;
//   final ScrollController vegScrollController = ScrollController();

//   // Fruit
//   RxList<Map<String, dynamic>> fruitProductList = <Map<String, dynamic>>[].obs;
//   RxBool isLoadingFruitPagination = false.obs;
//   int fruitCurrentPage = 1;
//   RxInt fruitTotalCount = 0.obs;
//   final ScrollController fruitScrollController = ScrollController();

//   // Dry Fruit
//   RxList<Map<String, dynamic>> dryFruitProductList = <Map<String, dynamic>>[].obs;
//   RxBool isLoadingDryFruitPagination = false.obs;
//   int dryFruitCurrentPage = 1;
//   RxInt dryFruitTotalCount = 0.obs;
//   final ScrollController dryFruitScrollController = ScrollController();

//   // All
//   final ScrollController allScrollController = ScrollController();

//   /// HomeController reference for cart operations
//   final HomeController homeController = Get.find<HomeController>();

//   /// Cart Count from HomeController
//   RxInt get cartCount => homeController.cartCount;

//   /// Get qty — HomeController = single source of truth
//   int getQty(String productId) => homeController.getQty(productId);

//   /// Add to cart
//   void addToCartItem({required String productId, required int quantity}) {
//     homeController.addToCart(productId: productId, quantity: quantity);
//     homeController.updateCartCount();
//   }

//   /// Remove from cart
//   void removeCartItem({required String productId}) {
//     homeController.removeCart(productId: productId);
//     homeController.updateCartCount();
//   }

//   /// Update qty — HomeController first, then local lists sync
//   void updateQtyItem(String productId, int qty) {
//     homeController.updateQty(
//       productId,
//       qty,
//       fromUserInteraction: true,
//     );

//     // Local lists sync karo
//     for (var item in vegProductList) {
//       if (item['id'].toString() == productId) {
//         item['qty'] = qty;
//       }
//     }

//     for (var item in fruitProductList) {
//       if (item['id'].toString() == productId) {
//         item['qty'] = qty;
//       }
//     }

//     for (var item in dryFruitProductList) {
//       if (item['id'].toString() == productId) {
//         item['qty'] = qty;
//       }
//     }

//     vegProductList.refresh();
//     fruitProductList.refresh();
//     dryFruitProductList.refresh();
//   }

//   @override
//   void onInit() {
//     super.onInit();

//     fetchProductsVegFirstLoad();
//     fetchProductsFruitFirstLoad();
//     fetchProductsDryFruitFirstLoad();

//     vegScrollController.addListener(() {
//       if (vegScrollController.position.pixels >= vegScrollController.position.maxScrollExtent - 200) {
//         fetchProductsVegPagination();
//       }
//     });

//     fruitScrollController.addListener(() {
//       if (fruitScrollController.position.pixels >= fruitScrollController.position.maxScrollExtent - 200) {
//         fetchProductsFruitPagination();
//       }
//     });

//     dryFruitScrollController.addListener(() {
//       if (dryFruitScrollController.position.pixels >= dryFruitScrollController.position.maxScrollExtent - 200) {
//         fetchProductsDryFruitPagination();
//       }
//     });

//     allScrollController.addListener(() {
//       if (allScrollController.position.pixels >= allScrollController.position.maxScrollExtent - 200) {
//         fetchProductsVegPagination();
//         fetchProductsFruitPagination();
//         fetchProductsDryFruitPagination();
//       }
//     });
//   }

//   // Common Api
//   Future<Map<String, dynamic>?> commonApiCall(
//     String categoryId,
//     int page,
//   ) async {
//     try {
//       SharedPreferencesManager sharedPreferences = Get.find<SharedPreferencesManager>();
//       String? tokenUser = sharedPreferences.getString('token');
//       if (tokenUser == null || tokenUser.isEmpty) return null;

//       final params = {
//         "user_agent": "EI-AAPP",
//         'category_id': categoryId,
//         'page_number': page.toString(),
//         'limit_per_page': '10',
//       };

//       final response = await ApiServices.postPublicAuthToken(
//         Environment.productList,
//         params,
//         tokenUser,
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 200 && responseData['status'] == 'success') {
//         return responseData;
//       }
//     } catch (e) {
//       toasterMessage('Something Went Wrong', error);
//     }
//     return null;
//   }

//   // Fetch Veg Product
//   Future<void> fetchProductsVegFirstLoad() async {
//     final data = await commonApiCall('1', 1);
//     if (data != null) {
//       vegProductList.assignAll(
//         List<Map<String, dynamic>>.from(data['data'] ?? []).map((item) {
//           item['qty'] = 0;
//           return item;
//         }).toList(),
//       );
//       applyLocalCart(vegProductList);
//       vegTotalCount.value = data['total_count'] ?? 0;
//     }
//   }

//   // Fetch Fruite Product
//   Future<void> fetchProductsFruitFirstLoad() async {
//     final data = await commonApiCall('2', 1);
//     if (data != null) {
//       fruitProductList.assignAll(
//         List<Map<String, dynamic>>.from(data['data'] ?? []).map((item) {
//           item['qty'] = 0;
//           return item;
//         }).toList(),
//       );
//       applyLocalCart(fruitProductList);
//       fruitTotalCount.value = data['total_count'] ?? 0;
//     }
//   }

//   // Fetch Dry Fruite Product
//   Future<void> fetchProductsDryFruitFirstLoad() async {
//     final data = await commonApiCall('3', 1);
//     if (data != null) {
//       dryFruitProductList.assignAll(
//         List<Map<String, dynamic>>.from(data['data'] ?? []).map((item) {
//           item['qty'] = 0;
//           return item;
//         }).toList(),
//       );
//       applyLocalCart(dryFruitProductList);
//       dryFruitTotalCount.value = data['total_count'] ?? 0;
//     }
//   }

//   // Pagination For Veg Product
//   Future<void> fetchProductsVegPagination() async {
//     if (isLoadingVegPagination.value || vegProductList.length >= vegTotalCount.value) return;

//     isLoadingVegPagination.value = true;
//     final data = await commonApiCall('1', ++vegCurrentPage);
//     if (data != null) {
//       final newData = List<Map<String, dynamic>>.from(data['data'] ?? []);

//       for (var item in newData) {
//         item['qty'] = getQty(item['id'].toString());
//       }

//       vegProductList.addAll(newData);

//       homeController.vegProductList.addAll(newData);
//       homeController.vegProductList.refresh();
//     }
//     isLoadingVegPagination.value = false;
//   }

//   // Pagination For Fruite Product
//   Future<void> fetchProductsFruitPagination() async {
//     if (isLoadingFruitPagination.value || fruitProductList.length >= fruitTotalCount.value) return;

//     isLoadingFruitPagination.value = true;
//     final data = await commonApiCall('2', ++fruitCurrentPage);
//     if (data != null) {
//       final newData = List<Map<String, dynamic>>.from(data['data'] ?? []);

//       for (var item in newData) {
//         item['qty'] = getQty(item['id'].toString());
//       }
//       fruitProductList.addAll(newData);

//       homeController.fruitProductList.addAll(newData);
//       homeController.fruitProductList.refresh();
//     }
//     isLoadingFruitPagination.value = false;
//   }

//   // Pagination For Dry Fruite Product
//   Future<void> fetchProductsDryFruitPagination() async {
//     if (isLoadingDryFruitPagination.value || dryFruitProductList.length >= dryFruitTotalCount.value) return;

//     isLoadingDryFruitPagination.value = true;
//     final data = await commonApiCall('3', ++dryFruitCurrentPage);
//     if (data != null) {
//       final newData = List<Map<String, dynamic>>.from(data['data'] ?? []);

//       for (var item in newData) {
//         item['qty'] = getQty(item['id'].toString());
//       }

//       dryFruitProductList.addAll(newData);

//       homeController.dryFruitProductList.addAll(newData);
//       homeController.dryFruitProductList.refresh();
//     }
//     isLoadingDryFruitPagination.value = false;
//   }

//   List<Map<String, dynamic>> get allProductList => [...vegProductList, ...fruitProductList, ...dryFruitProductList];

//   @override
//   void onClose() {
//     vegScrollController.dispose();
//     fruitScrollController.dispose();
//     dryFruitScrollController.dispose();
//     allScrollController.dispose();
//     super.onClose();
//   }

//   // Apply Local Cart
//   void applyLocalCart(List<Map<String, dynamic>> productList) {
//     try {
//       SharedPreferencesManager sharedPreferences = Get.find<SharedPreferencesManager>();

//       String? cartJson = sharedPreferences.getString('cart_qty_map');

//       if (cartJson == null || cartJson.isEmpty) return;

//       Map<String, dynamic> cartMap = jsonDecode(cartJson);

//       for (var item in productList) {
//         String id = item['id'].toString();
//         if (cartMap.containsKey(id)) {
//           item['qty'] = cartMap[id];
//         } else {
//           item['qty'] = 0;
//         }
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//     }
//   }

//   // Jump to All Tab flag
//   final RxBool jumpToAll = false.obs;

//   void jumpToAllTab() {
//     jumpToAll.value = true;
//   }
// }



import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fresh_point/app/home/home_controller.dart';
import 'package:fresh_point/utility/common_rest_api.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/sharedprefrence.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  // Veg
  RxList<Map<String, dynamic>> vegProductList = <Map<String, dynamic>>[].obs;
  RxBool isLoadingVegPagination = false.obs;
  int vegCurrentPage = 1;
  RxInt vegTotalCount = 0.obs;
  final ScrollController vegScrollController = ScrollController();

  // Fruit
  RxList<Map<String, dynamic>> fruitProductList = <Map<String, dynamic>>[].obs;
  RxBool isLoadingFruitPagination = false.obs;
  int fruitCurrentPage = 1;
  RxInt fruitTotalCount = 0.obs;
  final ScrollController fruitScrollController = ScrollController();

  // Dry Fruit
  RxList<Map<String, dynamic>> dryFruitProductList = <Map<String, dynamic>>[].obs;
  RxBool isLoadingDryFruitPagination = false.obs;
  int dryFruitCurrentPage = 1;
  RxInt dryFruitTotalCount = 0.obs;
  final ScrollController dryFruitScrollController = ScrollController();

  // All
  final ScrollController allScrollController = ScrollController();

  // Search
  RxString searchQuery = ''.obs;
  RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;

  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }
    final all = [...vegProductList, ...fruitProductList, ...dryFruitProductList];
    searchResults.assignAll(
      all.where((p) => (p['product_name'] ?? '').toString().toLowerCase().contains(query.toLowerCase())).toList(),
    );
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }

  /// HomeController reference for cart operations
  final HomeController homeController = Get.find<HomeController>();

  /// Cart Count from HomeController
  RxInt get cartCount => homeController.cartCount;

  /// Get qty — HomeController = single source of truth
  int getQty(String productId) => homeController.getQty(productId);

  /// Add to cart
  void addToCartItem({required String productId, required int quantity}) {
    homeController.addToCart(productId: productId, quantity: quantity);
    homeController.updateCartCount();
  }

  /// Remove from cart
  void removeCartItem({required String productId}) {
    homeController.removeCart(productId: productId);
    homeController.updateCartCount();
  }

  /// Update qty — HomeController first, then local lists sync
  void updateQtyItem(String productId, int qty) {
    homeController.updateQty(
      productId,
      qty,
      fromUserInteraction: true,
    );

    // Local lists sync karo
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
  }

  @override
  void onInit() {
    super.onInit();

    fetchProductsVegFirstLoad();
    fetchProductsFruitFirstLoad();
    fetchProductsDryFruitFirstLoad();

    vegScrollController.addListener(() {
      if (vegScrollController.position.pixels >= vegScrollController.position.maxScrollExtent - 200) {
        fetchProductsVegPagination();
      }
    });

    fruitScrollController.addListener(() {
      if (fruitScrollController.position.pixels >= fruitScrollController.position.maxScrollExtent - 200) {
        fetchProductsFruitPagination();
      }
    });

    dryFruitScrollController.addListener(() {
      if (dryFruitScrollController.position.pixels >= dryFruitScrollController.position.maxScrollExtent - 200) {
        fetchProductsDryFruitPagination();
      }
    });

    allScrollController.addListener(() {
      if (allScrollController.position.pixels >= allScrollController.position.maxScrollExtent - 200) {
        fetchProductsVegPagination();
        fetchProductsFruitPagination();
        fetchProductsDryFruitPagination();
      }
    });
  }

  // Common Api
  Future<Map<String, dynamic>?> commonApiCall(
    String categoryId,
    int page,
  ) async {
    try {
      SharedPreferencesManager sharedPreferences = Get.find<SharedPreferencesManager>();
      String? tokenUser = sharedPreferences.getString('token');
      if (tokenUser == null || tokenUser.isEmpty) return null;

      final params = {
        "user_agent": "EI-AAPP",
        'category_id': categoryId,
        'page_number': page.toString(),
        'limit_per_page': '10',
      };

      final response = await ApiServices.postPublicAuthToken(
        Environment.productList,
        params,
        tokenUser,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        return responseData;
      }
    } catch (e) {
      toasterMessage('Something Went Wrong', error);
    }
    return null;
  }

  // Fetch Veg Product
  Future<void> fetchProductsVegFirstLoad() async {
    final data = await commonApiCall('1', 1);
    if (data != null) {
      vegProductList.assignAll(
        List<Map<String, dynamic>>.from(data['data'] ?? []).map((item) {
          item['qty'] = 0;
          return item;
        }).toList(),
      );
      applyLocalCart(vegProductList);
      vegTotalCount.value = data['total_count'] ?? 0;
    }
  }

  // Fetch Fruite Product
  Future<void> fetchProductsFruitFirstLoad() async {
    final data = await commonApiCall('2', 1);
    if (data != null) {
      fruitProductList.assignAll(
        List<Map<String, dynamic>>.from(data['data'] ?? []).map((item) {
          item['qty'] = 0;
          return item;
        }).toList(),
      );
      applyLocalCart(fruitProductList);
      fruitTotalCount.value = data['total_count'] ?? 0;
    }
  }

  // Fetch Dry Fruite Product
  Future<void> fetchProductsDryFruitFirstLoad() async {
    final data = await commonApiCall('3', 1);
    if (data != null) {
      dryFruitProductList.assignAll(
        List<Map<String, dynamic>>.from(data['data'] ?? []).map((item) {
          item['qty'] = 0;
          return item;
        }).toList(),
      );
      applyLocalCart(dryFruitProductList);
      dryFruitTotalCount.value = data['total_count'] ?? 0;
    }
  }

  // Pagination For Veg Product
  Future<void> fetchProductsVegPagination() async {
    if (isLoadingVegPagination.value || vegProductList.length >= vegTotalCount.value) return;

    isLoadingVegPagination.value = true;
    final data = await commonApiCall('1', ++vegCurrentPage);
    if (data != null) {
      final newData = List<Map<String, dynamic>>.from(data['data'] ?? []);

      for (var item in newData) {
        item['qty'] = getQty(item['id'].toString());
      }

      vegProductList.addAll(newData);

      homeController.vegProductList.addAll(newData);
      homeController.vegProductList.refresh();
    }
    isLoadingVegPagination.value = false;
  }

  // Pagination For Fruite Product
  Future<void> fetchProductsFruitPagination() async {
    if (isLoadingFruitPagination.value || fruitProductList.length >= fruitTotalCount.value) return;

    isLoadingFruitPagination.value = true;
    final data = await commonApiCall('2', ++fruitCurrentPage);
    if (data != null) {
      final newData = List<Map<String, dynamic>>.from(data['data'] ?? []);

      for (var item in newData) {
        item['qty'] = getQty(item['id'].toString());
      }
      fruitProductList.addAll(newData);

      homeController.fruitProductList.addAll(newData);
      homeController.fruitProductList.refresh();
    }
    isLoadingFruitPagination.value = false;
  }

  // Pagination For Dry Fruite Product
  Future<void> fetchProductsDryFruitPagination() async {
    if (isLoadingDryFruitPagination.value || dryFruitProductList.length >= dryFruitTotalCount.value) return;

    isLoadingDryFruitPagination.value = true;
    final data = await commonApiCall('3', ++dryFruitCurrentPage);
    if (data != null) {
      final newData = List<Map<String, dynamic>>.from(data['data'] ?? []);

      for (var item in newData) {
        item['qty'] = getQty(item['id'].toString());
      }

      dryFruitProductList.addAll(newData);

      homeController.dryFruitProductList.addAll(newData);
      homeController.dryFruitProductList.refresh();
    }
    isLoadingDryFruitPagination.value = false;
  }

  List<Map<String, dynamic>> get allProductList => [...vegProductList, ...fruitProductList, ...dryFruitProductList];

  @override
  void onClose() {
    vegScrollController.dispose();
    fruitScrollController.dispose();
    dryFruitScrollController.dispose();
    allScrollController.dispose();
    super.onClose();
  }

  // Apply Local Cart
  void applyLocalCart(List<Map<String, dynamic>> productList) {
    try {
      SharedPreferencesManager sharedPreferences = Get.find<SharedPreferencesManager>();

      String? cartJson = sharedPreferences.getString('cart_qty_map');

      if (cartJson == null || cartJson.isEmpty) return;

      Map<String, dynamic> cartMap = jsonDecode(cartJson);

      for (var item in productList) {
        String id = item['id'].toString();
        if (cartMap.containsKey(id)) {
          item['qty'] = cartMap[id];
        } else {
          item['qty'] = 0;
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  // Jump to All Tab flag
  final RxBool jumpToAll = false.obs;

  void jumpToAllTab(String query) {
    searchProducts(query);
    jumpToAll.value = true;
  }
}