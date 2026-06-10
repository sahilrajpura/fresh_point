import 'package:flutter/material.dart';
import 'package:fresh_point/app/home/home_controller.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class deliveryDashboardScreen extends StatelessWidget {
  const deliveryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // homecontoller import
    final HomeController homeController = Get.find<HomeController>();

    return BackgroundScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.height / 37.8,
        ),
        child: ListView(
          children: [
            // User Info
            UserInfo(homeController: homeController),

            // Order List
            SizedBox(
              height: Get.height / 37.8,
            ),
            Orderlist(),

            // Order By areas
            OrderByAreas(),
          ],
        ),
      ),
    );
  }
}

// Order By Areas Widget
class OrderByAreas extends StatelessWidget {
  const OrderByAreas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Get.height / 18.09,
        ),
        Text(
          'આજના વિસ્તાર મુજબ ઓર્ડર્સ',
          style: TextStyle(
            fontSize: Get.height / 42,
            fontWeight: FontWeight.w600,
            color: primary,
            fontFamily: 'Urbanist',
          ),
        ),
        SizedBox(
          height: Get.height / 37.09,
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRouter.pendingOrders);
              },
              child: AreaOrderCard(
                areaName: 'મોતીપુરા',
                count: 5,
                backgroundColor: primary,
                badgeColor: primary,
              ),
            ),

            AreaOrderCard(
              areaName: 'મહેતાપુરા',
              count: 10,
              backgroundColor: orange,
              badgeColor: orange,
            ),

            AreaOrderCard(
              areaName: 'મહાવીરનગર',
              count: 3,
              backgroundColor: warning,
              badgeColor: warning,
            ),

            AreaOrderCard(
              areaName: 'પોલોગ્રાઉન્ડ',
              count: 5,
              backgroundColor: primary,
              badgeColor: primary,
            ),

            AreaOrderCard(
              areaName: 'પાનપુર પાટિયા',
              count: 10,
              backgroundColor: orange,
              badgeColor: orange,
            ),

            AreaOrderCard(
              areaName: 'મહાવીરનગર',
              count: 3,
              backgroundColor: warning,
              badgeColor: warning,
            ),
          ],
        ),
      ],
    );
  }
}

// Area Order Card Widget
class AreaOrderCard extends StatelessWidget {
  final String areaName;
  final int count;
  final Color backgroundColor;
  final Color badgeColor;

  const AreaOrderCard({
    super.key,
    required this.areaName,
    required this.count,
    required this.backgroundColor,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height / 15.42,
      margin: EdgeInsets.only(
        bottom: Get.height / 44.47,
      ),
      padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(
          Get.height / 37.8,
        ),
        border: Border.all(
          color: backgroundColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            areaName,
            style: TextStyle(
              fontSize: Get.height / 47.25,
              fontWeight: FontWeight.w500,
              color: dark,
              fontFamily: 'Urbanist',
            ),
          ),

          Container(
            width: Get.height / 21.6,
            height: Get.height / 21.6,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: Get.height / 54,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Order List Widget
class Orderlist extends StatelessWidget {
  const Orderlist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              color: shade500,
              borderRadius: BorderRadius.circular(Get.height / 37.6),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '50',
                    style: TextStyle(
                      fontSize: Get.height / 21,
                      fontWeight: FontWeight.w700,
                      color: light,
                      fontFamily: 'Urbanist',
                    ),
                  ),

                  Text(
                    'આજના ટોટલ ઓર્ડર્સ',
                    style: TextStyle(
                      fontSize: Get.height / 54,
                      fontWeight: FontWeight.w700,
                      color: light,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: Get.height / 37.8),
        Expanded(
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(Get.height / 37.6),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height / 75.6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      '05',
                      style: TextStyle(
                        fontSize: Get.height / 21,
                        fontWeight: FontWeight.w700,
                        color: light,
                        fontFamily: 'Urbanist',
                      ),
                    ),

                    Text(
                      'આજના કમ્પ્લીટ થયેલા ઓર્ડર્સ',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: Get.height / 54,
                        fontWeight: FontWeight.w700,
                        color: light,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// User Info Widget
class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'greeting'.tr,
          style: TextStyle(
            fontSize: Get.height / 54,
            fontWeight: FontWeight.w300,
            color: shade300,
            fontFamily: 'Urbanist',
          ),
        ),

        SizedBox(height: Get.height / 151.2),
        Text(
          homeController.userData['user_name'] ?? '',
          style: TextStyle(
            fontSize: Get.height / 54,
            fontWeight: FontWeight.w700,
            color: dark,
            fontFamily: 'Urbanist',
          ),
        ),
      ],
    );
  }
}
