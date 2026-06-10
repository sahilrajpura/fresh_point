import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fresh_point/app/home/home_screen.dart';
import 'package:fresh_point/app/policy/policy_controller.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class PolicyScreen extends StatelessWidget {
  PolicyScreen({super.key});

  // Controller Import
  final controller = Get.put(PolicyController());

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Column(
        children: [
          // Top Bar
          topBar(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.height / 37.8,
              ),
              child: ListView(
                children: [
                  SizedBox(height: Get.height / 30.24),
                  description(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Description
Widget description(PolicyController controller) {
  return Obx(() {
    // Shimmer Loader
    if (controller.isLoading.value) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: Get.height / 63,
            ),
            child: shimmerBox(
              height: Get.height / 25,
              width: double.infinity,
            ),
          );
        },
      );
    }

    return Html(
      data: controller.pageContent.value,
      style: {
        "body": Style(
          fontSize: FontSize(Get.height / 50.4),
          fontWeight: FontWeight.w400,
          fontFamily: 'Urbanist',
          color: dark,
          lineHeight: LineHeight.number(1.6),
        ),
        "h3": Style(
          fontWeight: FontWeight.w700,
        ),
        "li": Style(
          margin: Margins.only(bottom: 8),
        ),
      },
    );
  });
}

// Top Bar
Widget topBar() {
  return Container(
    height: Get.height / 10.95,
    width: double.infinity,
    color: primary,
    padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: light,
                size: Get.height / 37.8,
              ),
            ),
          ),
        ),
        Text(
          'policies'.tr,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: Get.height / 37.8,
            fontWeight: FontWeight.w900,
            fontFamily: 'Urbanist',
            color: light,
          ),
        ),
      ],
    ),
  );
}
