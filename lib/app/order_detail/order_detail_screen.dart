import 'package:flutter/material.dart';
import 'package:fresh_point/app/order_detail/order_detail_controller.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../utility/theme.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller Import
    final controller = Get.put(OrderDetailController());
    return BackgroundScaffold(
      child: Container(
        // For Scaffold Color
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

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.height / 37.8,
                ),
                child: ListView(
                  children: [
                    SizedBox(height: Get.height / 30.24),

                    // Order ID Row
                    Obx(() {
                      if (controller.isLoading.value) {
                        // Shimmer for order ID
                        return shimmerBox(height: Get.height / 63, width: Get.width / 1.5);
                      }

                      return Text(
                        'ઓર્ડર આઈડી #${controller.orderDetail['order_number']?.toString() ?? ''}',
                        style: TextStyle(
                          fontSize: Get.height / 63,
                          color: shade400,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Urbanist',
                        ),
                      );
                    }),

                    SizedBox(height: Get.height / 50.4),

                    // Order Product Cards
                    Obx(() {
                      if (controller.isLoading.value) {
                        // Shimmer for product cards
                        return Column(
                          children: [
                            _shimmerProductCard(),
                            SizedBox(height: Get.height / 63),
                            _shimmerProductCard(),
                          ],
                        );
                      }
                      return orderProductCard(controller);
                    }),

                    // Card Bills Summary
                    SizedBox(height: Get.height / 50.4),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return _shimmerBillSummary();
                      }

                      final List products = controller.orderDetail['order_detail_data'] ?? [];

                      double productTotal = 0.0;
                      for (var product in products) {
                        final double adjustTotal = double.tryParse(product['adjust_total']?.toString() ?? '0') ?? 0;
                        productTotal += adjustTotal;
                      }

                      return FutureBuilder<SharedPreferences>(
                        future: SharedPreferences.getInstance(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return _shimmerBillSummary();

                          final double deliveryCharge = snapshot.data!.getDouble('last_order_delivery_charge') ?? 0.0;

                          return cartBillSummary(
                            productTotal: productTotal,
                            deliveryCharge: deliveryCharge,
                          );
                        },
                      );
                    }),
                    // Cart Note Section
                    SizedBox(height: Get.height / 37.8),
                    Obx(() {
                      if (controller.isLoading.value) {
                        // Shimmer for note section
                        return _shimmerNoteSection();
                      }
                      final String paymentMethod = controller.orderDetail['payment_method']?.toString() ?? '';
                      final String deliveryDate = controller.orderDetail['delivery_date']?.toString() ?? '';
                      return cartNoteSection(
                        paymentMethod: paymentMethod,
                        deliveryDate: deliveryDate,
                      );
                    }),

                    // Order Tracker
                    SizedBox(height: Get.height / 30.24),
                    Text(
                      'shipping_tracking'.tr,
                      style: TextStyle(
                        fontFamily: "Urbanist",
                        fontWeight: FontWeight.w800,
                        fontSize: Get.height / 38,
                        color: dark,
                      ),
                    ),
                    SizedBox(height: Get.height / 63),
                    Obx(() {
                      if (controller.isLoading.value) {
                        // Shimmer for tracker
                        return _shimmerTracker();
                      }
                      final List shippingData = controller.orderDetail['order_shipping_data'] ?? [];
                      return SingleChildScrollView(
                        child: OrderTracker(shippingData: shippingData),
                      );
                    }),

                    SizedBox(height: Get.height / 30.24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  Shimmer Widgets ─

Widget shimmerBox({double? height, double? width, double radius = 8}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

// Shimmer for product card
Widget _shimmerProductCard() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(Get.height / 63),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(Get.height / 50.4),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image shimmer
        shimmerBox(height: Get.height / 8.5, width: Get.height / 7.2, radius: 12),
        SizedBox(width: Get.height / 63),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerBox(height: Get.height / 44.5, width: double.infinity),
              SizedBox(height: 8),
              shimmerBox(height: Get.height / 63, width: Get.height / 4),
              SizedBox(height: 6),
              shimmerBox(height: Get.height / 63, width: Get.height / 5),
            ],
          ),
        ),
      ],
    ),
  );
}

// Shimmer for bill summary
Widget _shimmerBillSummary() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(Get.height / 63),
    ),
    child: Column(
      children: [
        // Header shimmer
        shimmerBox(height: Get.height / 20.43, width: double.infinity, radius: 0),
        Padding(
          padding: EdgeInsets.all(Get.height / 63),
          child: Column(
            children: [
              shimmerBox(height: Get.height / 63, width: double.infinity),
              SizedBox(height: 8),
              shimmerBox(height: Get.height / 63, width: double.infinity),
              SizedBox(height: 8),
              shimmerBox(height: Get.height / 58, width: double.infinity),
            ],
          ),
        ),
      ],
    ),
  );
}

// Shimmer for note section
Widget _shimmerNoteSection() {
  return Container(
    padding: EdgeInsets.all(Get.height / 50.4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(Get.height / 63),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmerBox(height: Get.height / 63, width: Get.height / 2.5),
        SizedBox(height: Get.height / 63),
        Divider(color: Colors.grey.shade200),
        SizedBox(height: Get.height / 63),
        shimmerBox(height: Get.height / 54, width: double.infinity),
        SizedBox(height: 6),
        shimmerBox(height: Get.height / 63, width: Get.height / 2),
        SizedBox(height: Get.height / 63),
        Divider(color: Colors.grey.shade200),
        SizedBox(height: Get.height / 63),
        shimmerBox(height: Get.height / 54, width: double.infinity),
        SizedBox(height: 6),
        shimmerBox(height: Get.height / 63, width: Get.height / 1.5),
      ],
    ),
  );
}

// Shimmer for tracker
Widget _shimmerTracker() {
  return Column(
    // 4 stages API ma che isliye 4
    children: List.generate(4, (index) {
      return Padding(
        padding: EdgeInsets.only(bottom: Get.height / 50.4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circle shimmer
            shimmerBox(height: 28, width: 28, radius: 14),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(height: Get.height / 75, width: Get.height / 3),
                  SizedBox(height: 6),
                  shimmerBox(height: Get.height / 63, width: Get.height / 2),
                ],
              ),
            ),
          ],
        ),
      );
    }),
  );
}

//  Order Tracker
class OrderTracker extends StatelessWidget {
  const OrderTracker({super.key, required this.shippingData});

  final List shippingData;

  final List<Map<String, String>> _allStages = const [
    {'stage': 'ઓર્ડર કરવામાં આવ્યો છે.'},
    {'stage': 'ઓર્ડર કન્ફર્મ કર્યો છે.'},
    {'stage': 'ઓર્ડર સોંપવામાં આવ્યો છે.'},
    {'stage': 'ઓર્ડર પહોંચાડવામાં આવ્યો છે.'},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Always 4 stages show karo
      itemCount: _allStages.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final bool completed = index < shippingData.length;

        final item = completed ? shippingData[index] : null;

        final String title = completed ? item!['shipping_status']?.toString() ?? '' : _allStages[index]['stage']!;

        final String subtitle = completed ? item!['created_on']?.toString() ?? '' : '';

        return Opacity(
          // Incomplete steps blur
          opacity: completed ? 1.0 : 0.35,
          child: TimelineTile(
            alignment: TimelineAlign.start,
            isFirst: index == 0,
            isLast: index == _allStages.length - 1,

            indicatorStyle: IndicatorStyle(
              width: 28,
              height: 28,
              // Completed green, incomplete grey
              color: completed ? primary : shade200,
              iconStyle: completed
                  ? IconStyle(
                      iconData: Icons.check_rounded,
                      color: Colors.white,
                      fontSize: 16,
                    )
                  : null,
            ),

            beforeLineStyle: LineStyle(
              thickness: 2,
              // Completed primary, incomplete shade200
              color: index > 0 && completed ? primary : shade200,
            ),

            afterLineStyle: LineStyle(
              thickness: 2,
              color: completed ? primary : shade200,
            ),

            endChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 12, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // shipping_status from API
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Get.height / 54,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Urbanist",
                      // Completed dark, incomplete shade400
                      color: completed ? dark : shade400,
                    ),
                  ),
                  // Date sirf completed stages ma dikhao
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    // created_on from API
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: Get.height / 75,
                        fontFamily: 'Urbanist',
                        color: shade400,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

//  Cart Note Section ──
Widget cartNoteSection({
  required String paymentMethod,
  required String deliveryDate,
}) {
  return Container(
    padding: EdgeInsets.all(Get.height / 50.4),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFBE6),
      borderRadius: BorderRadius.circular(Get.height / 63),
      boxShadow: [
        BoxShadow(
          color: dark.withValues(alpha: 0.06),
          offset: const Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Payment Mode Row
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: "Urbanist",
              fontSize: Get.height / 54,
              color: dark,
            ),
            children: [
              TextSpan(
                text: 'પેમેન્ટ મોડ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Get.height / 54,
                ),
              ),
              const TextSpan(text: ': '),
              TextSpan(
                // Payment method from API
                text: paymentMethod,
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),

        Divider(height: Get.height / 31.5, color: shade200),

        // Delivery Date Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/Delivery_van.png',
              width: Get.height / 16,
              height: Get.height / 16,
            ),
            SizedBox(width: Get.height / 63),
            Expanded(
              child: RichText(
                softWrap: true,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: "Urbanist",
                    fontSize: Get.height / 54,
                    color: dark,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'next_delivery_date'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: Get.height / 58,
                      ),
                    ),
                    TextSpan(
                      // Delivery date from API
                      text: ' $deliveryDate',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Get.height / 54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Divider(height: Get.height / 31.5, color: shade200),

        // Note Row
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: "Urbanist",
              fontSize: Get.height / 54,
              color: dark,
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'નૉંધ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Get.height / 54,
                ),
              ),
              const TextSpan(text: ': '),
              const TextSpan(
                text: 'મોટા ફળો અને શાકભાજી ના ઓર્ડર પર વજન અને કિંમત માં 10% ની વધઘટ રહી શકે છે.',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

//  Card Bill Summary ──
Widget cartBillSummary({
  required double productTotal,
  required double deliveryCharge,
}) {
  final double grandTotal = productTotal + deliveryCharge;

  return Container(
    decoration: BoxDecoration(
      color: light,
      borderRadius: BorderRadius.circular(Get.height / 63),
      boxShadow: [
        BoxShadow(
          color: dark.withValues(alpha: 0.05),
          offset: const Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    ),
    child: Column(
      children: [
        // Green Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: Get.height / 63),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Get.height / 63),
            ),
          ),
          child: Center(
            child: Text(
              'bill_details'.tr,
              style: TextStyle(
                color: light,
                fontSize: Get.height / 47.25,
                fontWeight: FontWeight.w700,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ),

        // Bill Rows
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.height / 63,
            vertical: Get.height / 75.6,
          ),
          child: Column(
            children: [
              billRow('product_price'.tr, productTotal),
              billRow('delivery_charge'.tr, deliveryCharge),
              Divider(color: shade200, height: Get.height / 63),
              billRow('total_amount'.tr, grandTotal, isBold: true),
            ],
          ),
        ),
      ],
    ),
  );
}

//  Bill Row ──
Widget billRow(String title, double value, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isBold ? dark : shade500,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            fontFamily: 'Urbanist',
            fontSize: Get.height / 58.15,
          ),
        ),
        Text(
          '₹ ${value.toStringAsFixed(2)}',
          style: TextStyle(
            color: isBold ? dark : shade500,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            fontFamily: 'Urbanist',
            fontSize: Get.height / 58.15,
          ),
        ),
      ],
    ),
  );
}

//  Order Product Card ─
Widget orderProductCard(OrderDetailController controller) {
  // All products from API
  final List products = controller.orderDetail['order_detail_data'] ?? [];

  return Column(
    children: products.map((product) {
      // Product fields from API
      final String productName = product['product_name']?.toString() ?? '';
      final String defaultImage = product['default_image']?.toString() ?? '';
      final String unitPrice = product['unit_price']?.toString() ?? '0';
      final String halNiKimmat = product['hal_ni_kimmat']?.toString() ?? '0';
      final String unitNumber = product['unit_number']?.toString() ?? '';
      final String totalUnit = product['total_unit']?.toString() ?? '';
      final String discountPercent = product['discount_percent']?.toString() ?? '0';
      final double adjustTotal = double.tryParse(product['adjust_total']?.toString() ?? '0') ?? 0;
      final String adjustUnitNumber = product['adjust_unit_number']?.toString() ?? '';
      final String adjustPrice = product['adjust_price']?.toString() ?? '';

      // Has adjust data from API
      final bool hasAdjust = adjustUnitNumber.isNotEmpty && adjustUnitNumber != 'null';
      final bool hasAdjustPrice = adjustPrice.isNotEmpty && adjustPrice != 'null';

      // Has discount from API
      final bool hasDiscount = discountPercent != '0' && discountPercent.isNotEmpty;

      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: Get.height / 63),
        decoration: BoxDecoration(
          color: light,
          borderRadius: BorderRadius.circular(Get.height / 50.4),
          border: Border.all(color: shade200),
          boxShadow: [
            BoxShadow(
              color: dark.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Top Section: Image + Details ──
            Padding(
              padding: EdgeInsets.all(Get.height / 63),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image with discount badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: Get.height / 8.5,
                        width: Get.height / 7.2,
                        decoration: BoxDecoration(
                          color: shade100,
                          borderRadius: BorderRadius.circular(Get.height / 75.6),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(Get.height / 126),
                          child: Image.network(
                            defaultImage,
                            fit: BoxFit.contain,
                            errorBuilder: (context, err, st) => const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      // Discount badge from API
                      if (hasDiscount)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.height / 126,
                              vertical: Get.height / 252,
                            ),
                            decoration: BoxDecoration(
                              color: error,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Get.height / 75.6),
                                bottomRight: Radius.circular(Get.height / 75.6),
                              ),
                            ),
                            child: Text(
                              '$discountPercent% બચત',
                              style: TextStyle(
                                fontSize: Get.height / 88,
                                color: light,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(width: Get.height / 63),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name from API
                        Text(
                          productName,
                          style: TextStyle(
                            color: primary,
                            fontFamily: "Urbanist",
                            fontSize: Get.height / 44.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.1,
                          ),
                        ),
                        SizedBox(height: Get.height / 126),

                        // Price Row
                        Row(
                          children: [
                            Text(
                              '₹ $unitPrice',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Get.height / 54,
                                color: dark,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                            SizedBox(width: Get.height / 189),
                            Text(
                              '($unitNumber માટે)',
                              style: TextStyle(
                                color: shade400,
                                fontSize: Get.height / 63,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: Get.height / 151),

                        // Quantity Row
                        Row(
                          children: [
                            Text(
                              'પ્રમાણ : ',
                              style: TextStyle(
                                color: shade400,
                                fontSize: Get.height / 63,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                            Text(
                              // Total unit from API
                              totalUnit,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Get.height / 63,
                                color: dark,
                                fontFamily: 'Urbanist',
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

            // ── Bottom Section: Price Details (only if adjust data) ──
            if (hasAdjust || hasAdjustPrice) ...[
              Divider(height: 1, color: shade200),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.height / 63,
                  vertical: Get.height / 94.5,
                ),
                child: Column(
                  children: [
                    // Current price row from API
                    priceRow('હાલ કિંમત :', '₹ $halNiKimmat'),
                    // Adjust weight row from API (if exists)
                    if (hasAdjust) priceRow('એડજસ્ટ વજન :', adjustUnitNumber),
                    // Adjust price row from API (if exists)
                    if (hasAdjustPrice) priceRow('એડજસ્ટ કિંમત :', '₹ $adjustPrice'),
                  ],
                ),
              ),
            ],

            // ── Kul (Total) Row ──
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: shade200)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Get.height / 63,
                vertical: Get.height / 94.5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'કુલ :',
                    style: TextStyle(
                      fontSize: Get.height / 54,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Urbanist',
                      color: shade500,
                    ),
                  ),
                  Text(
                    // Adjust total from API
                    '₹ ${adjustTotal.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: Get.height / 54,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Urbanist',
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

//  Price Row ─
Widget priceRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Get.height / 63,
            color: shade500,
            fontFamily: 'Urbanist',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: Get.height / 63,
            color: shade500,
            fontFamily: 'Urbanist',
          ),
        ),
      ],
    ),
  );
}

//  Top Bar
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
          'order_details'.tr,
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
