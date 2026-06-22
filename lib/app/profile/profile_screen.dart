import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fresh_point/app/admin_detail/admin_detail_screen.dart';
import 'package:fresh_point/app/profile/profile_controller.dart';
import 'package:fresh_point/app/setting/setting_list_controller.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:fresh_point/utility/model/show_language_model.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:fresh_point/utility/toaster_message.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Controller Import
  final settingController = Get.put(SettingListController());
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return BackToHomeWrapper(
      child: BackgroundScaffold(
        child: ListView(
          children: [
            // Top Bar
            topBar(),

            // Person Info
            SizedBox(
              height: Get.height / 18.09,
            ),
            personInfo(profileController),

            // Facilities Section
            SizedBox(
              height: Get.height / 18.09,
            ),

            FacilitiesSection(controller: settingController),
            SizedBox(
              height: Get.height / 18.09,
            ),
          ],
        ),
      ),
    );
  }
}

// Facilities Section
class FacilitiesSection extends StatelessWidget {
  final SettingListController controller;

  const FacilitiesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'facilities'.tr,
            style: TextStyle(
              fontSize: Get.height / 37.8,
              fontWeight: FontWeight.w700,
              fontFamily: 'Urbanist',
            ),
          ),
        ),

        // Items
        FacilityTile(
          icon: Icons.shopping_cart_outlined,
          title: 'all_orders'.tr,
          onTap: () {
            Get.toNamed(
              AppRouter.order,
            );
          },
        ),

        FacilityTile(
          icon: Icons.phone_outlined,
          title: 'contact_admin'.tr,
          onTap: () {
            Get.dialog(AdminContactModel());
          },
        ),

        FacilityTile(
          icon: Icons.description_outlined,
          title: 'policies'.tr,
          onTap: () {
            Get.toNamed(AppRouter.policy);
          },
        ),

        FacilityTile(
          icon: Icons.share_outlined,
          title: 'share_app'.tr,
          onTap: () => shareApp(Get.find<ProfileController>()),
        ),

        Obx(
          () => FacilityTile(
            icon: Icons.language_outlined,
            title:
                '${'change_language'.tr} '
                '(${controller.selectedLanguage.value == 'Gujarati' ? 'gujarati'.tr : 'english'.tr})',
            onTap: () {
              showLanguageModal();
            },
          ),
        ),
      ],
    );
  }
}

// Facility Title
class FacilityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const FacilityTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 47.25, vertical: Get.height / 126),
      child: InkWell(
        borderRadius: BorderRadius.circular(Get.height / 54),
        onTap: onTap,
        child: Container(
          height: Get.height / 17.18,
          padding: EdgeInsets.symmetric(horizontal: Get.height / 47.25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Get.height / 54),
            border: Border.all(width: 1, color: shade200),
          ),
          child: Row(
            children: [
              Icon(icon, size: Get.height / 37.8, color: shade400),
              SizedBox(width: Get.height / 54),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Get.height / 50.4,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Urbanist',
                    color: dark,
                  ),
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Person Info
Widget personInfo(ProfileController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Get.height / 18.09),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/profile.png',
          width: Get.height / 16.8,
          color: primary,
        ),
        SizedBox(
          height: Get.height / 75.6,
        ),
        Obx(
          () => Text(
            controller.userName.value,
            style: TextStyle(
              color: dark,
              fontSize: Get.height / 47.25,
              fontWeight: FontWeight.w700,
              fontFamily: 'Urbanist',
            ),
          ),
        ),

        Obx(
          () => Text(
            controller.mobileNumber.value,
            style: TextStyle(
              color: shade400,
              fontSize: Get.height / 54,
              fontWeight: FontWeight.w500,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
      ],
    ),
  );
}

// Top Bar
Widget topBar() {
  return Container(
    height: Get.height / 10.95,
    width: double.infinity,
    color: primary,
    alignment: Alignment.center,
    child: Text(
      'profile'.tr,
      style: TextStyle(
        fontSize: Get.height / 37.8,
        fontWeight: FontWeight.w800,
        color: light,
      ),
    ),
  );
}

// For Share Application
void shareApp(ProfileController controller) async {
  if (controller.appData.isEmpty) {
    toasterMessage("App data not loaded yet", error);
    return;
  }

  if (Platform.isIOS) {
    final appLink = controller.appData['ios_app_link'] ?? '';

    if (appLink.isEmpty) {
      toasterMessage("App link not available", error);
      return;
    }

    await launchUrl(
      Uri.parse(appLink),
      mode: LaunchMode.externalApplication,
    );
    return;
  }

  if (Platform.isAndroid) {
    final appLink = controller.appData['android_app_link'] ?? '';

    if (appLink.isEmpty) {
      toasterMessage("App link not available", error);
      return;
    }

    // ignore: deprecated_member_use
    Share.share(
      'મારી એપ ડાઉનલોડ કરો 👇\n$appLink',
      subject: 'App Share',
    );
  }
}
