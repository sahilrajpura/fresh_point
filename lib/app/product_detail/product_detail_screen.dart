import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fresh_point/app/home/home_screen.dart';
import 'package:fresh_point/app/home/home_controller.dart';
import 'package:fresh_point/app/product_detail/product_detail_controller.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailController controller = Get.put(ProductDetailController());

  // HomeController
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: light,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView(
                    children: [
                      shimmerBox(
                        height: Get.height / 2.07,
                        width: double.infinity,
                      ),
                      SizedBox(height: Get.height / 37.8),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.height / 37.8,
                        ),
                        child: shimmerBox(
                          height: Get.height / 6,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(height: Get.height / 30.24),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.height / 37.8,
                        ),
                        child: shimmerBox(
                          height: Get.height / 5,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  );
                }

                return ListView(
                  children: [
                    // Top Bar
                    topbar(
                      controller.productData['default_image'] ?? '',
                    ),

                    // Product Details
                    SizedBox(height: Get.height / 37.8),
                    productDetails(),

                    // Final Price
                    SizedBox(height: Get.height / 75.8),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.height / 37.8,
                      ),
                      child: Obx(() {
                        // final String productId = controller.productData['id'].toString();

                        final double salePriceDouble =
                            double.tryParse(controller.productData['sale_price']?.toString() ?? '0') ?? 0.0;

                        final int salePrice = salePriceDouble.round();

                        final qty = controller.localQty.value;
                        return priceColumn(
                          qty: qty,
                          salePrice: salePrice,
                          quantity: controller.productData['unit_number'] ?? '1 kg',
                        );
                      }),
                    ),

                    // OrganicBadge
                    SizedBox(height: Get.height / 30.24),
                    organicBadge(),

                    // Content
                    SizedBox(height: Get.height / 30.24),
                    content(),
                    SizedBox(height: Get.height / 15.12),
                  ],
                );
              }),
            ),

            // Bottom Add to Cart Button
            Container(
              height: Get.height / 8.59,
              width: double.infinity,
              color: primary.withValues(alpha: 0.2),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    child: Image.asset(
                      'assets/images/scaffold_image_2.png',
                      height: Get.height / 18.09,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.height / 37.8,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: Get.height / 63),
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              height: Get.height / 15.12,
                              child: CustomButton(
                                text: 'add_to_cart'.tr,
                                icon: Icons.shopping_cart_outlined,
                                onTap: () {
                                  final productId = controller.productData['id'].toString();
                                  controller.syncQtyAcrossControllers(
                                    productId,
                                    controller.localQty.value,
                                    showToast: true,
                                  );
                                },
                              ),
                            ),
                          ),
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

  // Content (HTML handled)
  Widget content() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'પ્રોડક્ટ ની વિગત',
            style: TextStyle(
              color: dark,
              fontSize: Get.height / 37.8,
              fontWeight: FontWeight.w700,
              fontFamily: 'Urbanist',
            ),
          ),
          SizedBox(height: Get.height / 75.6),
          Html(
            data: controller.productData['product_description'] ?? '',
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                color: shade400,
                fontSize: FontSize(Get.height / 54),
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w500,
              ),
            },
          ),
        ],
      ),
    );
  }

  // Price Column
  Widget priceColumn({
    required int qty,
    required int salePrice,
    required String quantity,
  }) {
    final int totalPrice = qty * salePrice;

    final double baseQty = double.tryParse(quantity.split(' ').first) ?? 1;

    final String unit = quantity.split(' ').length > 1 ? quantity.split(' ')[1] : '';

    final double totalQty = baseQty * qty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '₹ $totalPrice',
          style: TextStyle(
            fontSize: Get.height / 50.4,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        SizedBox(width: Get.height / 151.2),
        Text(
          '/',
          style: TextStyle(
            fontSize: Get.height / 50.4,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        SizedBox(width: Get.height / 151.2),
        Text(
          '${totalQty.toStringAsFixed(0)} $unit',
          style: TextStyle(
            fontSize: Get.height / 50.4,
            color: primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Organic Badge
  Widget organicBadge() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
      child: Container(
        height: Get.height / 16,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Get.height / 63),
          border: Border.all(color: shade200, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/organic.png',
              width: Get.height / 28,
            ),
            SizedBox(width: Get.height / 75.6),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '100% ',
                    style: TextStyle(
                      color: primary,
                      fontSize: Get.height / 47.25,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  TextSpan(
                    text: 'ઓર્ગેનિક',
                    style: TextStyle(
                      color: shade400,
                      fontFamily: 'Urbanist',
                      fontSize: Get.height / 54,
                      fontWeight: FontWeight.w500,
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

  // Product Details
  Widget productDetails() {
    final String productId = controller.productData['id'].toString();

    final double salePriceDouble = double.tryParse(controller.productData['sale_price']?.toString() ?? '0') ?? 0.0;

    final double listPriceDouble =
        double.tryParse(controller.productData['list_price']?.toString() ?? '0') ?? salePriceDouble;

    final int salePrice = salePriceDouble.round();
    final int listPrice = listPriceDouble.round();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
      child: Obx(() {

        final qty = controller.localQty.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.productData['product_name'] ?? '',
                  style: TextStyle(
                    color: primary,
                    fontSize: Get.height / 44.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  controller.productData['unit_number'] ?? '',
                  style: TextStyle(
                    fontSize: Get.height / 54,
                    color: shade400,
                  ),
                ),
                SizedBox(height: Get.height / 50),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (qty > 1) {
                          controller.updateQtyLocal(productId, qty - 1);
                        }
                      },
                      child: Container(
                        height: Get.height / 25.2,
                        width: Get.height / 25.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: dark),
                          borderRadius: BorderRadius.circular(Get.height / 75.6),
                        ),
                        child: Icon(Icons.remove, size: Get.height / 34.36),
                      ),
                    ),
                    SizedBox(width: Get.height / 47.25),
                    Text(
                      qty.toString(),
                      style: TextStyle(
                        fontSize: Get.height / 42,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: Get.height / 47.25),
                    // Plus Button — sirf local update, no API
                    GestureDetector(
                      onTap: () {

                        controller.updateQtyLocal(productId, qty + 1);
                      },
                      child: Container(
                        height: Get.height / 25.2,
                        width: Get.height / 25.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: dark),
                          borderRadius: BorderRadius.circular(Get.height / 75.6),
                        ),
                        child: Icon(Icons.add, size: Get.height / 34.36),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹ $salePrice',
                  style: TextStyle(
                    fontSize: Get.height / 42,
                    fontWeight: FontWeight.w700,
                    color: dark,
                  ),
                ),
                Text(
                  '₹ $listPrice',
                  style: TextStyle(
                    fontSize: Get.height / 63,
                    color: shade400,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

// Top Bar
Widget topbar(String imageUrl) {
  final controller = Get.find<ProductDetailController>();

  return Container(
    height: Get.height / 2.07,
    width: double.infinity,
    decoration: BoxDecoration(
      color: primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(Get.height / 15.12),
        bottomRight: Radius.circular(Get.height / 15.12),
      ),
    ),
    child: Column(
      children: [
        SizedBox(height: Get.height / 18.09),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              Container(
                height: Get.height / 25.2,
                width: Get.height / 25.2,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: light,
                    size: Get.height / 50.4,
                  ),
                ),
              ),

              Text(
                'product_detail'.tr,
                style: TextStyle(
                  fontSize: Get.height / 42,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),

              // Cart Icon with Badge
              GestureDetector(
                onTap: () {
                  Get.offAllNamed(
                    AppRouter.home,
                    arguments: 2,
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: Get.height / 23.62,
                      width: Get.height / 23.62,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(Get.height / 75.6),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/shopping_basket.png',
                          width: Get.height / 30.24,
                          color: light,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 3,
                      child: Obx(
                        () => controller.cartCount.value == 0
                            ? Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: light,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: dark.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: Get.height / 94.5,
                                    fontWeight: FontWeight.w600,
                                    color: dark,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: light,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: dark.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  controller.cartCount.value.toString(),
                                  style: TextStyle(
                                    fontSize: Get.height / 94.5,
                                    fontWeight: FontWeight.w600,
                                    color: dark,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Product Image
        Expanded(
          child: Center(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: Get.height / 3.95,
              fit: BoxFit.contain,
              placeholder: (context, url) {
                return SizedBox(
                  height: Get.height / 3.95,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: primary,
                    ),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return const Icon(Icons.image_not_supported);
              },
            ),
          ),
        ),
      ],
    ),
  );
}
