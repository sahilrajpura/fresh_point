import 'package:flutter/material.dart';
import 'package:fresh_point/app/home/home_controller.dart';
import 'package:fresh_point/app/setting/setting_list_controller.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

void showLanguageModal() {
  final controller = Get.find<SettingListController>();

  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(Get.height / 37.8),
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Get.height / 28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            height: 4,
            width: 40,
            margin: EdgeInsets.only(bottom: Get.height / 37.8),
            decoration: BoxDecoration(
              color: shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Title
          Text(
            'change_language'.tr,
            style: TextStyle(
              fontSize: Get.height / 37.8,
              fontWeight: FontWeight.w800,
              color: dark,
            ),
          ),

          SizedBox(height: Get.height / 37.8),

          // Options
          Obx(
            () => Column(
              children: [
                languageTile(
                  title: 'english'.tr,
                  value: 'English',
                  controller: controller,
                ),
                languageTile(
                  title: 'gujarati'.tr,
                  value: 'Gujarati',
                  controller: controller,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

Widget languageTile({
  required String title,
  required String value,
  required SettingListController controller,
}) {
  final bool isSelected = controller.selectedLanguage.value == value;

  return InkWell(
    onTap: () async {
      controller.onLanguageSelect(value);
      await controller.applyLanguage();

      Get.find<HomeController>().refreshBottomBar();

      Get.back();
    },
    borderRadius: BorderRadius.circular(Get.height / 54),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: Get.height / 126),
      padding: EdgeInsets.symmetric(
        horizontal: Get.height / 37.8,
        vertical: Get.height / 75.6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Get.height / 54),
        border: Border.all(
          color: isSelected ? primary : shade300,
          width: isSelected ? 1.5 : 1,
        ),
        color: isSelected ? primary.withValues(alpha: 0.08) : Colors.transparent,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: Get.height / 50.4,
                fontWeight: FontWeight.w600,
                color: dark,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: primary,
              size: Get.height / 37.8,
            ),
        ],
      ),
    ),
  );
}
