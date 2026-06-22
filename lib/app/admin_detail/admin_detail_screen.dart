import 'package:flutter/material.dart';
import 'package:fresh_point/app/admin_detail/admin_controller.dart';
import 'package:fresh_point/app/home/home_screen.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class AdminContactModel extends StatelessWidget {
  AdminContactModel({super.key});

  // Controller Import
  final controller = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Obx(() {
        if (controller.isLoading.value) {
          return adminContactShimmer();
        }
        return Container(
          decoration: BoxDecoration(
            color: light,
            borderRadius: BorderRadius.circular(Get.height / 34.36),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Get.height / 126,
              ),
              topbar(),

              SizedBox(
                height: Get.height / 126,
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: shade200,
              ),

              SizedBox(
                height: Get.height / 50.4,
              ),

              InfoContainer(
                backgroundColor: primary.withValues(alpha: 0.2),
                iconBgColor: primary,
                icon: Icons.phone_in_talk_outlined,
                title: 'mobile_number_label'.tr,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mobileText(
                      controller.adminData['contact_no'] ?? '',
                    ),
                  ],
                ),
              ),

              SizedBox(height: Get.height / 50.4),

              InfoContainer(
                backgroundColor: orange.withValues(alpha: 0.2),
                iconBgColor: orange,
                icon: Icons.call,
                title: 'address_label'.tr,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addressText(
                      controller.adminData['full_address'] ?? '',
                    ),
                  ],
                ),
              ),

              SizedBox(height: Get.height / 50.4),
            ],
          ),
        );
      }),
    );
  }
}

// Admin Contact Shimmer
Widget adminContactShimmer() {
  return Container(
    decoration: BoxDecoration(
      color: light,
      borderRadius: BorderRadius.circular(Get.height / 34.36),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: Get.height / 126,
        ),

        topbar(),

        SizedBox(
          height: Get.height / 126,
        ),
        Container(height: 1, width: double.infinity, color: shade200),

        SizedBox(
          height: Get.height / 50.4,
        ),

        shimmerInfoContainer(),
        SizedBox(
          height: Get.height / 50.4,
        ),
        shimmerInfoContainer(),

        SizedBox(
          height: Get.height / 50.4,
        ),
      ],
    ),
  );
}

// Shimmer Info Container
Widget shimmerInfoContainer() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Get.height / 50.4),
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerBox(
            height: 48,
            width: 48,
          ),
          SizedBox(height: Get.height / 75.6),
          shimmerBox(height: 14, width: 120),
          SizedBox(height: 8),
          shimmerBox(height: 14, width: double.infinity),
          SizedBox(height: 6),
          shimmerBox(height: 14, width: Get.width * 0.6),
        ],
      ),
    ),
  );
}

// Mobile Text
Widget mobileText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: Get.height / 54,
      fontWeight: FontWeight.w600,
      color: dark,
      fontFamily: 'Urbanist',
    ),
  );
}

// Address
Widget addressText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: Get.height / 54,
      fontWeight: FontWeight.w700,
      color: dark,
      fontFamily: 'Urbanist',
    ),
  );
}

class InfoContainer extends StatelessWidget {
  final Color backgroundColor;
  final Color iconBgColor;
  final IconData icon;
  final String title;
  final Widget content;

  const InfoContainer({
    super.key,
    required this.backgroundColor,
    required this.iconBgColor,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 50.4),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon box

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height / 75.6,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: Get.height / 54,
                          fontWeight: FontWeight.w300,
                          color: dark,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      SizedBox(height: Get.height / 126),
                      content,
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Top Bar
Widget topbar() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'contact_us'.tr,
          maxLines: 1,
          style: TextStyle(
            color: dark,
            fontFamily: "Mulish",
            fontWeight: FontWeight.w300,
            fontSize: Get.height / 42,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.close,
            size: 20,
            color: shade400,
          ),
        ),
      ],
    ),
  );
}
