import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:fresh_point/utility/environment.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utility/common_rest_api.dart';

class LoginController extends GetxController {
  // Input Controllers
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();

  // Error Variable
  RxString mobileError = ''.obs;
  RxString passwordError = ''.obs;

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

  // On Submit Validation Function
  void saveUserData() {
    if (mobile.text.isEmpty) {
      mobileError.value = 'mobile_required';
    }
    if (password.text.isEmpty) {
      passwordError.value = 'password_required';
    }

    if (mobileError.value == '' && mobile.text.isNotEmpty && passwordError.value == '' && password.text.isNotEmpty) {
      loginUser();
    }
  }

  // Login Api
  Future<void> loginUser() async {
    if (Get.isSnackbarOpen) return;

    try {
      appProgressBarIndicator();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, dynamic> deviceInfo = await getDeviceInfo();

      var userFcm = prefs.getString('fcmTkn');
      if (userFcm == null) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        prefs.setString('fcmTkn', fcmToken.toString());
        userFcm = fcmToken;
      }

      final params = {
        'mobile': mobile.text,
        'password': password.text,
        'user_agent': 'EI-AAPP',
        'device_id': userFcm ?? '',
        'device_info': deviceInfo['device_model'],
        'device_type': deviceInfo['device_type'],
        'device_model': deviceInfo['device_model'],
        'device_platform': deviceInfo['device_platform'],
        'device_udid': deviceInfo['device_udid'],
        'device_version': deviceInfo['device_version'],
        'device_manufacturer': deviceInfo['device_manufacturer'],
        'device_IsVirtual': deviceInfo['device_IsVirtual'],
        'app_version_code': Platform.isAndroid
            ? Environment.ANDROID_VERSION_CODE.toString()
            : Environment.IOS_VERSION_CODE.toString(),
      };

      final response = await ApiServices.postPublicSingle(
        Environment.login,
        params,
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        prefs.setString('token', responseData['data']['jwt_token']);
        prefs.setString('UserData', jsonEncode(responseData['data']));
        prefs.setString('userStatus', responseData['data']['status'].toString());
        prefs.setString('userType', responseData['data']['user_type'].toString());

        toasterMessage(responseData['message'], primary);

        // Route conditionally based on response user or admin
        if (responseData['data']['user_type'].toString() == 'W') {
          // Go to home page
          Get.offAllNamed(AppRouter.home);
        } else {
          // Go to delivery boy deliveryDashboard
          Get.offAllNamed(AppRouter.deliveryDashboard);
        }
        clear();
      } else {
        toasterMessage(responseData['message'], error);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      toasterMessage('Something Went Wrong', error);
    }
  }

  // Get Device Information
  Future<Map<String, dynamic>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceUdid = await FlutterUdid.udid;
    Map<String, dynamic> deviceInfoMap = {};

    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      deviceInfoMap = {
        'device_id': androidInfo.id,
        'device_type': 'Android',
        'device_model': androidInfo.model,
        'device_platform': 'Android',
        'device_udid': deviceUdid,
        'device_version': androidInfo.version.release,
        'device_manufacturer': androidInfo.manufacturer,
        'device_IsVirtual': androidInfo.isPhysicalDevice ? 'false' : 'true',
      };
    } else if (GetPlatform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      deviceInfoMap = {
        'device_id': iosInfo.identifierForVendor ?? '',
        'device_type': 'iOS',
        'device_model': iosInfo.utsname.machine,
        'device_platform': 'iOS',
        'device_udid': deviceUdid,
        'device_version': iosInfo.systemVersion,
        'device_manufacturer': 'Apple',
        'device_IsVirtual': iosInfo.isPhysicalDevice ? 'false' : 'true',
      };
    }

    return deviceInfoMap;
  }

  // Clear Function
  void clear() {
    mobile.clear();
    password.clear();
  }
}
