import 'package:flutter/material.dart';
import 'package:fresh_point/app/home/home_screen.dart';
import 'package:fresh_point/app/order/order_controller.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:fresh_point/utility/routes.dart';

import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // controller Import
    final controller = Get.put(OrderController());
    return BackgroundScaffold(
      child:
          // For Scaffold Color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary2,
                  light,
                  primary2,
                ],
                stops: [
                  0.0,
                  0.5,
                  1.0,
                ],
              ),
            ),

            child: Column(
              children: [
                // Top Bar
                topBar(),

                // Expanded(child: orderEmptyScreen()),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return shimmerList();
                    }

                    if (controller.orderList.isEmpty) {
                      return orderEmptyScreen();
                    }

                    return ListView.builder(
                      itemCount: controller.orderList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(
                            height: Get.height / 37.8,
                          );
                        }

                        final order = controller.orderList[index - 1];

                        return Padding(
                          padding: EdgeInsets.only(bottom: Get.height / 37.8),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRouter.orderDetail,
                                arguments: order['id'],
                              );
                            },
                            child: orderCard(
                              statusText: order['status_text'],
                              statusColor: controller.getStatusColor(order['status_text']),
                              showTick: order['status_text'] == "Delivered",
                              orderId: "#${order['order_number']}",
                              dateTime: order['order_date'],
                              amount: order['formatted_amount'],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
    );
  }
}

Widget shimmerList() {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (context, index) {
      return orderShimmerCard();
    },
  );
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
              padding: EdgeInsets.only(bottom: 5),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: light,
                size: Get.height / 37.8,
              ),
            ),
          ),
        ),
        Text(
          'order'.tr,
          style: TextStyle(
            fontSize: Get.height / 37.8,
            fontWeight: FontWeight.w800,
            fontFamily: 'Urbanist',
            color: light,
          ),
        ),
      ],
    ),
  );
}

// Order Card
Widget orderCard({
  required String statusText,
  required Color statusColor,
  required bool showTick,
  required String orderId,
  required String dateTime,
  required String amount,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: Get.height / 37.8,
    ),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(Get.height / 37.8),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Row
          Padding(
            padding: EdgeInsets.all(Get.height / 50.4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: Get.height / 58.15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Urbanist',
                      color: statusColor,
                    ),
                  ),
                ),
                if (showTick)
                  Container(
                    height: Get.height / 37.8,
                    width: Get.height / 37.8,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: light,
                      size: Get.height / 50.4,
                    ),
                  ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height / 50.4),
            child: Container(
              height: 1,
              width: double.infinity,
              color: shade200,
            ),
          ),

          // Order Info
          Padding(
            padding: EdgeInsets.all(Get.height / 50.4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Color Line
                Container(
                  height: Get.height / 12.6,
                  width: 2,
                  color: statusColor,
                ),
                SizedBox(width: Get.height / 63),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ઓર્ડર આઈડી',
                        style: TextStyle(
                          fontSize: Get.height / 63,
                          color: shade400,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      SizedBox(height: Get.height / 189),
                      Text(
                        orderId,
                        style: TextStyle(
                          fontSize: Get.height / 52,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Urbanist',
                          color: dark,
                        ),
                      ),
                      SizedBox(height: Get.height / 63),

                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: Get.height / 50.4,
                            color: shade400,
                          ),
                          SizedBox(
                            width: Get.height / 126,
                          ),
                          Text(
                            dateTime,
                            style: TextStyle(
                              fontSize: Get.height / 63,
                              color: shade400,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          Spacer(),
                          Text(
                            amount,
                            style: TextStyle(
                              fontSize: Get.height / 52,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Urbanist',
                              color: dark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// No Data Found
Widget orderEmptyScreen() {
  return SizedBox.expand(
    child: Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height / 18.09),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/order_empty_icon.png',
              width: Get.height / 7.56,
            ),
            SizedBox(
              height: Get.height / 18.09,
            ),
            Text(
              textAlign: TextAlign.center,
              'અમે તમારા પ્રથમ ઓર્ડર માટે રાહ જોઈ રહ્યા છીએ',
              style: TextStyle(
                color: dark,
                fontSize: Get.height / 37.8,
                fontWeight: FontWeight.w700,
                fontFamily: 'Urbanist',
              ),
            ),
            SizedBox(height: Get.height / 75.6),
            Text(
              'હજુ સુધી કોઈ ઓર્ડર મૂક્યો નથી. અમારી કેટેગરીમાંથી ખરીદી કરો અને તમારા ઓર્ડર પર શ્રેષ્ઠ ડીલ્સ મેળવો...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: shade400,
                fontSize: Get.height / 54,
                fontWeight: FontWeight.w500,
                fontFamily: 'Urbanist',
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget orderShimmerCard() {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: Get.height / 37.8,
      vertical: 10,
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Get.height / 37.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status
          Padding(
            padding: EdgeInsets.all(12),
            child: shimmerBox(height: 15, width: 120),
          ),

          Divider(),

          // Content
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                shimmerBox(height: 80, width: 2),
                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerBox(height: 12, width: 80),
                      SizedBox(height: 8),
                      shimmerBox(height: 16, width: 150),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          shimmerBox(height: 12, width: 100),
                          Spacer(),
                          shimmerBox(height: 16, width: 60),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
