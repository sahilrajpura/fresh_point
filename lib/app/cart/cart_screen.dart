import 'package:flutter/material.dart';
import 'package:fresh_point/app/cart/cart_controller.dart';
import 'package:fresh_point/app/home/home_controller.dart';
import 'package:fresh_point/app/home/home_screen.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:fresh_point/utility/model/confirm_delete.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  // Controller ImportCartUnSuccessfullDialogScreen
  final controller = Get.put(CartController());
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return BackToHomeWrapper(
      child: BackgroundScaffold(
        backgroundGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary2, light, primary2],
          stops: [0.0, 0.5, 1.0],
        ),
        child: Column(
          children: [
            topBar(homeController),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: Get.height / 25.2),

                  // Products Cart
                  Obx(() {
                    if (controller.isLoading.value) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: Get.height / 37.8),
                            child: shimmerCartItem(),
                          );
                        },
                      );
                    }

                    if (controller.cartList.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: noDataFuond(),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.cartList.length,
                      itemBuilder: (context, index) {
                        var item = controller.cartList[index];

                        return Padding(
                          padding: EdgeInsets.only(bottom: Get.height / 37.8),
                          child: ProductQuantityCard(
                            index: index,
                            imagePath: item['default_image'] ?? '',
                            gujaratiName: item['product_name'] ?? '',
                            englishName: "",
                            price: (double.tryParse(item['sale_price']?.toString() ?? '0') ?? 0).round(),
                            oldPrice: (double.tryParse(item['list_price']?.toString() ?? '0') ?? 0).round(),
                            quantity: item['unit_number'] ?? '',
                            initialQuantity: int.tryParse(item['quantity']?.toString() ?? '1') ?? 1,
                            showDiscount: item['discount_percent'] != "0",
                            discountPercent: (double.tryParse(item['discount_percent']?.toString() ?? '0') ?? 0)
                                .round(),
                            productId: item['pro_id']?.toString() ?? item['id']?.toString() ?? '',
                            onTotalChanged: (i, v) {
                              controller.updateTotal(i, v);
                            },
                          ),
                        );
                      },
                    );
                  }),

                  // Bill Summary
                  Obx(() {
                    if (controller.cartList.isEmpty) return SizedBox();

                    return cartBillSummary(
                      productTotal: controller.productTotal.value,
                      deliveryCharge: controller.deliveryCharge.value,
                    );
                  }),

                  // Cart Note Section
                  Obx(() {
                    if (controller.cartList.isEmpty) return SizedBox();

                    return cartNoteSection();
                  }),

                  // Cart Checkout Button
                  Obx(() {
                    final bool showApproval =
                        homeController.isLoading.isTrue || homeController.userData['user_status'] == "I";

                    if (showApproval || controller.cartList.isEmpty) return SizedBox.shrink();

                    return cartCheckoutButton();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Cart Checkout Button
Widget cartCheckoutButton() {
  return Padding(
    padding: EdgeInsets.only(
      left: Get.height / 37.8,
      right: Get.height / 37.8,
      bottom: Get.height / 18.09,
    ),
    child: GestureDetector(
      onTap: () {
        Get.find<CartController>().placeOrder();
      },
      child: Container(
        height: Get.height / 15.12,
        decoration: BoxDecoration(
          border: Border.all(color: primary, width: 1),
          borderRadius: BorderRadius.circular(Get.height / 7.56),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'proceed_order'.tr,
              style: TextStyle(
                color: primary,
                fontFamily: "urbanist",
                fontWeight: FontWeight.w600,
                fontSize: Get.height / 42,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Cart Note Section
Widget cartNoteSection() {
  return Padding(
    padding: EdgeInsets.only(
      left: Get.height / 37.8,
      right: Get.height / 37.8,
      bottom: Get.height / 37.8,
    ),
    child: Container(
      padding: EdgeInsets.all(Get.height / 50.4),
      decoration: BoxDecoration(
        color: Color(0XFFFFF8DB),
        borderRadius: BorderRadius.circular(Get.height / 63),
        boxShadow: [
          BoxShadow(
            color: dark.withValues(alpha: 0.05),
            offset: Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            maxLines: 1,
            text: TextSpan(
              style: TextStyle(
                fontFamily: "urbanist",
                fontSize: Get.height / 47.25,
                color: dark,
              ),
              children: [
                TextSpan(
                  text: 'પેમેન્ટ મોડ :',
                  style: TextStyle(
                    fontFamily: "urbanist",
                    fontWeight: FontWeight.w600,
                    fontSize: Get.height / 54,
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 5)),
                TextSpan(
                  text: 'હાલમાં માત્ર કેશ ઓન ડિલિવરી ઉપલબ્ધ છે.',
                  style: TextStyle(
                    fontFamily: "urbanist",
                    fontWeight: FontWeight.w400,
                    fontSize: Get.height / 54,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: Get.height / 31.5),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/Delivery_van.png',
                width: Get.height / 18.43,
                height: Get.height / 18.43,
              ),
              SizedBox(width: Get.height / 50.4),
              Expanded(
                child: RichText(
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: "urbanist",
                      fontSize: Get.height / 47.25,
                      color: dark,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: 'next_delivery_date'.tr,
                        style: TextStyle(
                          fontFamily: "urbanist",
                          fontWeight: FontWeight.w400,
                          fontSize: Get.height / 54,
                        ),
                      ),
                      TextSpan(
                        text: 'તારીખ : ',
                        style: TextStyle(
                          fontFamily: "urbanist",
                          fontWeight: FontWeight.w400,
                          fontSize: Get.height / 54,
                        ),
                      ),
                      TextSpan(
                        text: controller.userData['delivery_date_orig'],
                        style: TextStyle(
                          fontFamily: "urbanist",
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height / 47.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Divider(height: Get.height / 31.5),

          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: "urbanist",
                fontSize: Get.height / 47.25,
                color: dark,
              ),
              children: [
                TextSpan(
                  text: 'નોંધ : ',
                  style: TextStyle(
                    fontFamily: "urbanist",
                    fontWeight: FontWeight.w600,
                    fontSize: Get.height / 47.25,
                  ),
                ),
                TextSpan(
                  text: 'મોટા ફળો અને શાકભાજી ના ઓર્ડર પર વજન અને કિંમત માં 10% ની વધઘટ રહી શકે છે.',
                  style: TextStyle(
                    fontFamily: "urbanist",
                    fontWeight: FontWeight.w400,
                    fontSize: Get.height / 54,
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

// Product Quantity Card
class ProductQuantityCard extends StatefulWidget {
  final int index;
  final String imagePath;
  final String gujaratiName;
  final String? englishName;
  final int price;
  final int? oldPrice;
  final String quantity;
  final int initialQuantity;
  final bool showDiscount;
  final int discountPercent;
  final Function(int, double) onTotalChanged;
  final String productId;

  const ProductQuantityCard({
    super.key,
    required this.index,
    required this.imagePath,
    required this.gujaratiName,
    required this.price,
    required this.onTotalChanged,
    required this.productId,
    this.englishName,
    this.oldPrice,
    this.quantity = '1 કિલો માટે',
    this.initialQuantity = 1,
    this.showDiscount = false,
    this.discountPercent = 0,
  });

  @override
  State<ProductQuantityCard> createState() => _ProductQuantityCardState();
}

class _ProductQuantityCardState extends State<ProductQuantityCard> {
  late int quantity;
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onTotalChanged(widget.index, widget.price * quantity.toDouble());
      }
    });
  }

  @override
  void didUpdateWidget(covariant ProductQuantityCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuantity != widget.initialQuantity) {
      if (mounted) {
        setState(() {
          quantity = widget.initialQuantity;
        });
      }
    }
  }

  void updateQuantity(int newQty) {
    if (!mounted) return;
    setState(() => quantity = newQty);
    widget.onTotalChanged(widget.index, widget.price * quantity.toDouble());

    // HomeController update karo — sari screens sync rahegi
    homeController.updateQty(widget.productId, newQty, fromUserInteraction: true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
      child: Container(
        decoration: BoxDecoration(
          color: light,
          border: Border.all(color: shade200),
          borderRadius: BorderRadius.circular(Get.height / 75.6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(Get.height / 151.2),
                      width: Get.height / 6.75,
                      height: Get.height / 7.79,
                      decoration: BoxDecoration(
                        color: shade100,
                        borderRadius: BorderRadius.circular(Get.height / 47.25),
                      ),
                      child: Center(
                        child: Image.network(
                          widget.imagePath,
                          width: Get.height / 10.5,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported, color: shade400),
                        ),
                      ),
                    ),
                    if (widget.showDiscount)
                      Positioned(
                        top: Get.height / 108,
                        right: Get.height / 108,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          height: Get.height / 42,
                          decoration: BoxDecoration(
                            color: error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '${widget.discountPercent}% બચત',
                              style: TextStyle(
                                fontSize: Get.height / 63,
                                color: error,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.height / 58.15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.gujaratiName,
                                style: TextStyle(
                                  color: primary,
                                  fontSize: Get.height / 44.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                              if (widget.englishName != null && widget.englishName!.isNotEmpty)
                                TextSpan(
                                  text: ' (${widget.englishName})',
                                  style: TextStyle(
                                    color: primary,
                                    fontSize: Get.height / 44.5,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: Get.height / 126),

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.oldPrice != null)
                                Text(
                                  '₹ ${widget.oldPrice}',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: shade400,
                                    fontSize: Get.height / 54,
                                  ),
                                ),
                              SizedBox(width: Get.height / 94.5),
                              Text(
                                '₹ ${widget.price}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Get.height / 54,
                                  color: dark,
                                ),
                              ),
                              SizedBox(width: Get.height / 126),
                              Text(
                                '(${widget.quantity})',
                                style: TextStyle(
                                  color: shade400,
                                  fontSize: Get.height / 54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Get.height / 75.6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                quantityButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    if (quantity <= 1) return;

                                    updateQuantity(quantity - 1);
                                  },
                                ),
                                SizedBox(width: Get.height / 54),
                                Text(
                                  quantity.toString(),
                                  style: TextStyle(
                                    fontSize: Get.height / 47.25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: Get.height / 54),
                                quantityButton(
                                  icon: Icons.add,
                                  onTap: () => updateQuantity(quantity + 1),
                                ),
                              ],
                            ),

                            // Delete Button
                            GestureDetector(
                              onTap: () {
                                final productId = widget.productId;

                                Get.dialog(
                                  ConfirmDelete(
                                    onConfirm: () {
                                      Get.find<CartController>().deleteCartItem(productId);
                                    },
                                  ),
                                  barrierDismissible: false,
                                );
                              },
                              child: Container(
                                height: Get.height / 25.2,
                                width: Get.height / 25.2,
                                decoration: BoxDecoration(
                                  color: error,
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                ),
                                child: Center(
                                  child: ImageIcon(
                                    AssetImage(
                                      'assets/images/delete.png',
                                    ),
                                    color: light,
                                    size: Get.height / 50.4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Divider(color: shade200),

            Padding(
              padding: EdgeInsets.all(Get.height / 75.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'કુલ :',
                    style: TextStyle(
                      color: shade600,
                      fontSize: Get.height / 58.15,
                    ),
                  ),
                  Text(
                    '₹ ${widget.price * quantity}',
                    style: TextStyle(
                      color: primary,
                      fontSize: Get.height / 58.15,
                      fontWeight: FontWeight.w700,
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

  Widget quantityButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height / 25.2,
        width: Get.height / 25.2,
        decoration: BoxDecoration(
          border: Border.all(color: dark),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
        ),
      ),
    );
  }
}

// Bill Summary
Widget cartBillSummary({
  required double productTotal,
  required double deliveryCharge,
}) {
  final double grandTotal = productTotal + deliveryCharge;

  return Padding(
    padding: EdgeInsets.all(
      Get.height / 37.8,
    ),
    child: Container(
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(Get.height / 63),
      ),
      child: Column(
        children: [
          Container(
            height: Get.height / 20.43,
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Get.height / 75.6),
            child: Column(
              children: [
                billRow('product_price'.tr, productTotal),
                billRow('delivery_charge'.tr, deliveryCharge),
                billRow('total_amount'.tr, grandTotal, isBold: true),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Bill Row
Widget billRow(String title, double value, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isBold ? dark : shade500,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            fontFamily: 'Urbanist',
          ),
        ),
        Text(
          '₹ ${value.toStringAsFixed(2)}',
          style: TextStyle(
            color: isBold ? dark : shade500,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            fontFamily: 'Urbanist',
          ),
        ),
      ],
    ),
  );
}

// Top Bar
Widget topBar(HomeController homeController) {
  return Stack(
    children: [
      Container(
        height: 70,
        width: double.infinity,
        color: primary,
      ),
      Positioned(
        top: 20,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'your_cart'.tr,
                  style: TextStyle(
                    fontSize: Get.height / 37.8,
                    fontWeight: FontWeight.w800,
                    color: light,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: Get.height / 25.2,
                  width: Get.height / 25.2,
                  decoration: BoxDecoration(
                    color: light,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(
                    () => Center(
                      child: Text(
                        homeController.cartCount.value.toString(),
                        style: TextStyle(
                          fontSize: Get.height / 54.5,
                          fontWeight: FontWeight.w600,
                          color: dark,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

// No Data Found
Widget noDataFuond() {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 18.09),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/no_data_found_icon.png',
            width: Get.height / 7.56,
          ),
          SizedBox(height: Get.height / 18.09),
          Text(
            'તમારું કાર્ટ ખાલી છે!',
            style: TextStyle(
              color: dark,
              fontSize: Get.height / 37.8,
              fontWeight: FontWeight.w700,
              fontFamily: 'Urbanist',
            ),
          ),
          SizedBox(height: Get.height / 75.6),
          Text(
            'તમારા કાર્ટમાં કોઈ વસ્તુ નથી. અમારા પ્રોડક્ટ્સ જોવો અને શોપિંગ શરૂ કરવા માટે વસ્તુઓ ઉમેરો!',
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
  );
}

Widget shimmerCartItem() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
    child: Container(
      padding: EdgeInsets.all(Get.height / 75.6),
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Image shimmer
          shimmerBox(
            height: Get.height / 7.79,
            width: Get.height / 6.75,
          ),

          SizedBox(width: Get.height / 50.4),

          // Text shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(height: 15, width: 120),
                SizedBox(height: 10),
                shimmerBox(height: 15, width: 80),
                SizedBox(height: 10),
                shimmerBox(height: 15, width: 60),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
