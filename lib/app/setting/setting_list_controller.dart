import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingListController extends GetxController {
  // selected language for radio button
  RxString selectedLanguage = 'Gujarati'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  // load saved language from storage
  Future<void> loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // selectedLanguage.value = prefs.getString('language') ?? 'English';
    selectedLanguage.value = prefs.getString('language') ?? 'Gujarati';
  }

  // only select language (radio / tap)
  void onLanguageSelect(String value) {
    selectedLanguage.value = value;
  }

  // apply language + save
  Future<void> applyLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (selectedLanguage.value == 'English') {
      Get.updateLocale(const Locale('en', 'US'));
      await prefs.setString('langCode', 'en');
      await prefs.setString('countryCode', 'US');
    } else if (selectedLanguage.value == 'Gujarati') {
      Get.updateLocale(const Locale('gu', 'IN'));
      await prefs.setString('langCode', 'gu');
      await prefs.setString('countryCode', 'IN');
    }

    // save selected language name
    await prefs.setString('language', selectedLanguage.value);
  }
}
