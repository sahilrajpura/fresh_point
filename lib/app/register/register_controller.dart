import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fresh_point/utility/common_rest_api.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  // Variables
  RxString selectedVillageId = ''.obs;
  RxString selectedVillageName = ''.obs;

  RxString selectedAreaId = ''.obs;
  RxString selectedAreaName = ''.obs;

  RxList<Map<String, String>> villageList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> areaList = <Map<String, String>>[].obs;

  RxBool isAreaLoading = false.obs;
  RxBool isVillageLoading = false.obs;

  // Input Controllers
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController village = TextEditingController();
  TextEditingController area = TextEditingController();

  // Error Variable
  RxString mobileError = ''.obs;
  RxString passwordError = ''.obs;
  RxString nameError = ''.obs;
  RxString addressError = ''.obs;
  RxString villageError = ''.obs;
  RxString areaError = ''.obs;

  // Mobile Validation
  void validateMobile(String value) {
    if (value.isEmpty) {
      mobileError.value = 'mobile_required';
    } else if (value.length != 10) {
      mobileError.value = 'mobile_invalid';
    } else {
      mobileError.value = '';
    }
  }

  // Password Validation
  void validatepassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'password_required';
    } else if (value.length < 6) {
      passwordError.value = 'password_length';
    } else {
      passwordError.value = '';
    }
  }

  // Name Validation
  void validatename(String value) {
    if (value.isEmpty) {
      nameError.value = 'name_required';
    } else if (value.length < 3) {
      nameError.value = 'name_length';
    } else {
      nameError.value = '';
    }
  }

  // Name Validation
  void validateaddress(String value) {
    if (value.isEmpty) {
      addressError.value = 'enter_full_address';
    } else if (value.length < 10) {
      addressError.value = 'address_min_length';
    } else {
      addressError.value = '';
    }
  }

  // Dropdown (Village) Validation
  void validateVillage(String value) {
    if (selectedVillageId.value.isEmpty) {
      villageError.value = 'select_village'.tr;
    } else {
      villageError.value = '';
    }
  }

  // Dropdown (Area) Validation
  void validatearea(String value) {
    if (selectedAreaId.value.isEmpty) {
      areaError.value = 'select_area'.tr;
    } else {
      areaError.value = '';
    }
  }

  // On Submit Validation Function
  void saveUserData() {
    if (mobile.text.isEmpty) {
      mobileError.value = 'mobile_required';
    }
    if (password.text.isEmpty) {
      passwordError.value = 'password_required';
    }
    if (name.text.isEmpty) {
      nameError.value = 'name_required';
    }
    if (address.text.isEmpty) {
      addressError.value = 'enter_full_address';
    }

    if (selectedVillageId.value.isEmpty) {
      villageError.value = 'select_village'.tr;
    } else {
      villageError.value = '';
    }

    if (selectedAreaId.value.isEmpty) {
      areaError.value = 'select_area'.tr;
    } else {
      areaError.value = '';
    }

    if (mobileError.value.isEmpty &&
        passwordError.value.isEmpty &&
        nameError.value.isEmpty &&
        addressError.value.isEmpty &&
        villageError.value.isEmpty &&
        areaError.value.isEmpty) {
      registerUser();
    }
  }

  // ===== Initial call =====
  @override
  void onReady() {
    super.onReady();
    fetchVillageList();
  }

  // ===== Village API =====
  Future<void> fetchVillageList() async {
    try {
      final response = await ApiServices.getPublicAuth(
        Environment.villageList,
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        villageList.clear();

        for (int i = 0; i < responseData['data'].length; i++) {
          villageList.add({
            'id': responseData['data'][i]['id'].toString(),
            'name': responseData['data'][i]['village_name'].toString(),
          });
        }
      } else {
        toasterMessage(responseData['message'], error);
      }
    } catch (e) {
      toasterMessage('Something Went Wrong', error);
    }
  }

  // ===== FetchArea List =====
  Future<void> fetchAreaList(String villageId) async {
    try {
      isAreaLoading.value = true;

      final params = {
        'user_agent': 'EI-AAPP',
        'village_id': villageId,
      };

      final response = await ApiServices.postPublicSingle(
        Environment.areaList,
        params,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        areaList.clear();
        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          for (var item in responseData['data']) {
            areaList.add({
              'id': item['id'].toString(),
              'name': item['area_name'].toString(),
            });
          }
        }
      } else {
        toasterMessage(
          responseData['message'],
          error,
        );
      }
    } catch (e) {
      toasterMessage('Something Went Wrong', error);
    } finally {
      isAreaLoading.value = false;
    }
  }

  // Register Api
  Future<void> registerUser() async {
    try {
      appProgressBarIndicator();

      final params = {
        'mobile': mobile.text,
        'password': password.text,
        'name': name.text,
        'address': address.text,
        'village_id': selectedVillageId.value,
        'area_id': selectedAreaId.value,
        'user_type': 'U',
        'user_agent': 'EI-AAPP',
      };

      final response = await ApiServices.postPublicSingle(
        Environment.register,
        params,
      );

      final responseData = jsonDecode(response.body);

      Get.back();

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        // Shared Preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final data = responseData['data'];
        await prefs.setString('token', data['jwt_token']);

        toasterMessage(
          responseData['message'],
          primary,
        );

        Get.offAllNamed(AppRouter.home);

        clear();
      } else {
        toasterMessage(
          responseData['message'],
          error,
        );
      }
    } catch (e) {
      Get.back();

      toasterMessage(
        'Something Went Wrong',
        error,
      );
    }
  }

  // Clear Function
  void clear() {
    mobile.clear();
    password.clear();
    name.clear();
    address.clear();
    selectedVillageId.value = '';
    selectedAreaId.value = '';
  }
}
