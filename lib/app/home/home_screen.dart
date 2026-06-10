import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_point/app/cart/cart_controller.dart';
import 'package:fresh_point/app/cart/cart_screen.dart';
import 'package:fresh_point/app/home/home_controller.dart';
import 'package:fresh_point/app/product_list/product_list_controller.dart';
import 'package:fresh_point/app/product_list/product_list_screen.dart';
import 'package:fresh_point/app/profile/profile_screen.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:fresh_point/utility/model/app_exit_dialog.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Controller Import
  final HomeController controller = Get.put(HomeController());

  // Bottom Tab Screens
  final List<Widget> screens = [
    HomeContent(controller: HomeController()),
    ProductListScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  // Navigate From Home screen
  Future<void> onWillPop() async {
    final shouldExit = await Get.dialog<bool>(
      AppExitDialog(),
    );
    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedIndex.value == 0) {
          await onWillPop();
        } else {
          controller.selectedIndex.value = 0;

          controller.tabBarKey.value = DateTime.now().millisecondsSinceEpoch;
        }
        return false;
      },
      child: Scaffold(
        // Body With Tab Switching
        body: Obx(() {
          return IndexedStack(
            index: controller.selectedIndex.value,
            children: screens,
          );
        }),

        // Bottom NavBar
        bottomNavigationBar: Obx(
          () => Container(
            key: ValueKey(
              controller.tabBarKey.value,
            ),
            child: MotionTabBar(
              labels: controller.tabs.map((e) => e.tr).toList(),
              initialSelectedTab: controller.tabs[controller.selectedIndex.value].tr,
              icons: const [
                Icons.home_outlined,
                Icons.apps,
                Icons.shopping_cart_outlined,
                Icons.person_2_outlined,
              ],
              onTabItemSelected: (index) {
                controller.selectedIndex.value = index;

                if (index == 2) {
                  if (Get.isRegistered<CartController>()) {
                    Get.find<CartController>().fetchCart();
                  }
                }
              },
              tabBarColor: primary,
              tabIconSelectedSize: 30,
              tabIconSize: 30,
              tabSelectedColor: light,
              tabIconColor: light,
              textStyle: TextStyle(
                color: light,
                fontFamily: 'Urbanist',
                fontSize: Get.height / 47.25,
                fontWeight: FontWeight.w500,
              ),
              tabIconSelectedColor: primary,
            ),
          ),
        ),
      ),
    );
  }
}

// Home Content

class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required HomeController controller});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return BackgroundScaffold(
      child: RefreshIndicator(
        color: primary,
        onRefresh: () async {
          await controller.loadHomeData();
        },
        child: ListView(
          children: [
            // Top Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.height / 37.8,
              ),
              child: topBar(controller),
            ),

            SizedBox(height: Get.height / 50.4),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return shimmerBox(height: 50, width: double.infinity);
                }
                return CustomTextField(
                  controller: controller.searchController,
                  hintText: 'search_hint'.tr,
                  suffixIcon: Icons.search,
                  onSubmitted: (value) {
                    if (value.trim().isEmpty) return;
                    final query = value.trim();
                    controller.searchController.clear();
                    controller.selectedIndex.value = 1;
                    Future.delayed(Duration(milliseconds: 100), () {
                      if (Get.isRegistered<ProductListController>()) {
                        Get.find<ProductListController>().jumpToAllTab(query);
                      }
                    });
                  },
                );
              }),
            ),

            // SizedBox(height: Get.height / 50.4),
            Obx(() {
              if (controller.searchText.value.isNotEmpty) {
                if (controller.searchProductList.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: Get.height / 8,
                    ),
                    child: Center(
                      child: Text("No Product Found"),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.height / 37.8,
                  ),
                  itemCount: controller.searchProductList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 280,
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.searchProductList[index];

                    final price =
                        (double.tryParse(
                                  product['sale_price']?.toString() ?? '0',
                                ) ??
                                0)
                            .round();

                    final oldPrice = double.tryParse(
                      product['list_price']?.toString() ?? '',
                    )?.round();

                    final discount =
                        (double.tryParse(
                                  product['discount_percent']?.toString() ?? '0',
                                ) ??
                                0)
                            .round();

                    final productId = product['id'].toString();

                    return discount > 0
                        ? ProductCard.withDiscount(
                            index: index,
                            imagePath: product['default_image'] ?? '',
                            gujaratiName: product['product_name'] ?? '',
                            price: price,
                            oldPrice: oldPrice,
                            discountValue: discount,
                            quantity: product['unit_number'],
                            productId: productId,
                            showArrow: true,
                          )
                        : ProductCard(
                            index: index,
                            imagePath: product['default_image'] ?? '',
                            gujaratiName: product['product_name'] ?? '',
                            price: price,
                            quantity: product['unit_number'],
                            productId: productId,
                            showArrow: true,
                          );
                  },
                );
              }

              return Column(
                children: [
                  // User Approval Info
                  Obx(() {
                    final bool showApproval = controller.isLoading.isTrue || controller.userData['user_status'] == "I";
                    if (!showApproval) return SizedBox.shrink();
                    return Column(
                      children: [
                        SizedBox(height: Get.height / 37.8),
                        userApprovalInfo(controller),
                      ],
                    );
                  }),

                  // Delivery Info Card
                  SizedBox(height: Get.height / 37.8),
                  deliveryInfoCard(controller),

                  // Banner
                  SizedBox(height: Get.height / 37.8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
                    child: banner(controller),
                  ),

                  // Scrolling Info Text
                  SizedBox(height: Get.height / 37.8),
                  scrollingInfoText(controller),

                  // Offer Banner
                  SizedBox(height: Get.height / 37.8),
                  offerBannerSlider(controller),

                  // Vegetables Section
                  SizedBox(height: Get.height / 18.09),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
                    child: titleHeader('fresh_vegetables'.tr),
                  ),
                  SizedBox(height: Get.height / 37.8),

                  // Vegetable horizontal list
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Row(
                          children: List.generate(
                            controller.shimmerCount.value,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? Get.height / 37.8 : 0,
                                right: Get.height / 37.8,
                              ),
                              child: shimmerBox(
                                height: Get.height / 4.8,
                                width: Get.height / 5.4,
                              ),
                            ),
                          ),
                        );
                      }
                      return Row(
                        children: List.generate(
                          controller.vegProductList.length,
                          (index) {
                            final product = controller.vegProductList[index];

                            final double salePrice =
                                double.tryParse(
                                  product['sale_price']?.toString() ?? '',
                                ) ??
                                0.0;
                            final int price = salePrice.round();

                            final double? oldPriceDouble = double.tryParse(
                              product['list_price']?.toString() ?? '',
                            );
                            final int? oldPrice = oldPriceDouble?.round();

                            final double discountDouble =
                                double.tryParse(
                                  product['discount_percent']?.toString() ?? '',
                                ) ??
                                0.0;
                            final int discount = discountDouble.round();

                            final bool hasDiscount = discount > 0;
                            final String productId = product['id'].toString();

                            return Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? Get.height / 37.8 : 0,
                                right: Get.height / 37.8,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    AppRouter.productdetail,
                                    arguments: productId,
                                  );
                                },
                                child: hasDiscount
                                    ? ProductCardVeg.withDiscount(
                                        imagePath: product['default_image'] ?? '',
                                        gujaratiName: product['product_name'] ?? '',
                                        price: price,
                                        oldPrice: oldPrice,
                                        discountValue: discount,
                                        index: index,
                                        quantity: product['unit_number'],
                                        productId: productId,
                                      )
                                    : ProductCardVeg(
                                        imagePath: product['default_image'] ?? '',
                                        gujaratiName: product['product_name'] ?? '',
                                        price: price,
                                        index: index,
                                        quantity: product['unit_number'],
                                        productId: productId,
                                      ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: Get.height / 37.8),

                  // Fruits Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
                    child: titleHeader('fresh_fruits'.tr),
                  ),
                  SizedBox(height: Get.height / 37.8),

                  Obx(() {
                    if (controller.isLoading.value) {
                      return Column(
                        children: List.generate(2, (rowIndex) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: Get.height / 37.8),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Get.height / 37.8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: shimmerBox(
                                      height: Get.height / 3.8,
                                      width: double.infinity,
                                    ),
                                  ),
                                  SizedBox(width: Get.height / 75.6),
                                  Expanded(
                                    child: shimmerBox(
                                      height: Get.height / 3.8,
                                      width: double.infinity,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }

                    final fruits = controller.fruitProductList.take(4).toList();
                    if (fruits.isEmpty) return const SizedBox();

                    return Column(
                      children: List.generate(
                        (fruits.length / 2).ceil(),
                        (rowIndex) {
                          final int firstIndex = rowIndex * 2;
                          final int secondIndex = firstIndex + 1;
                          return Padding(
                            padding: EdgeInsets.only(bottom: Get.height / 37.8),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Get.height / 37.8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: fruitItem(fruits[firstIndex], firstIndex),
                                  ),
                                  SizedBox(width: Get.height / 75.6),
                                  Expanded(
                                    child: secondIndex < fruits.length
                                        ? fruitItem(fruits[secondIndex], secondIndex)
                                        : const SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              );
            }),

            // Bottom space
            SizedBox(
              height: Get.height / 18,
            ),
          ],
        ),
      ),
    );
  }
}

// Slider
Widget offerBannerSlider(HomeController controller) {
  return Obx(() {
    if (controller.isPageLoading.value) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.height / 37.8,
        ),
        child: Container(
          height: Get.height / 5.04,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(
              Get.height / 75.6,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: Get.height / 4.44,
          child: PageView.builder(
            controller: controller.offerPageController,
            itemCount: 3,
            onPageChanged: controller.onOfferPageChanged,
            itemBuilder: (context, index) {
              return offerBanner(index);
            },
          ),
        ),

        SizedBox(
          height: Get.height / 75.6,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(
                horizontal: Get.height / 189,
              ),
              height: Get.height / 94.5,
              width: controller.offerCurrentIndex.value == index ? 18 : 8,
              decoration: BoxDecoration(
                color: controller.offerCurrentIndex.value == index ? primary : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(
                  Get.height / 75.6,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  });
}

// Offer Banner
Widget offerBanner(int index) {
  final List<String> bannerTexts = [
    'લીંબુ પૌષ્ટિક છે. તે તમારી ત્વચા માટે ફાયદાકારક છે.',
    'તાજી શાકભાજી રોજ ખાઓ અને સ્વસ્થ રહો.',
    'ફળો ખાવાથી શરીરને જરૂરી વિટામિન્સ મળે છે.',
  ];

  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: Get.height / 37.8,
    ),
    child: Container(
      height: Get.height / 5.04,
      width: double.infinity,
      decoration: BoxDecoration(
        color: index == 1
            ? Colors.lightBlue.withValues(
                alpha: 0.2,
              )
            : orange.withValues(
                alpha: 0.2,
              ),
        borderRadius: BorderRadius.circular(
          Get.height / 75.6,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.height / 37.8,
            ),
            child: Column(
              children: [
                SizedBox(height: Get.height / 50.4),

                Image.asset(
                  'assets/icons/free.png',
                  width: Get.height / 9.45,
                ),

                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: error,
                      borderRadius: BorderRadius.circular(Get.height / 47.25),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.height / 50.4,
                        vertical: Get.height / 151.2,
                      ),
                      child: Text(
                        'Hurry Up',
                        style: TextStyle(
                          fontSize: Get.height / 63,
                          fontWeight: FontWeight.w400,
                          color: light,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/Pepper.png',
                        width: Get.height / 4.2,
                        opacity: AlwaysStoppedAnimation(0.1),
                      ),
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Text(
                          bannerTexts[index],
                          style: TextStyle(
                            fontSize: Get.height / 63,
                            fontWeight: FontWeight.w400,
                            color: dark,
                            fontFamily: 'Urbanist',
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
    ),
  );
}

// Fruit Item Fetch From Api
Widget fruitItem(
  Map<String, dynamic> product,
  int index,
) {
  final price = (double.tryParse(product['sale_price']?.toString() ?? '0') ?? 0).round();

  final oldPrice = double.tryParse(product['list_price']?.toString() ?? '')?.round();

  final discount = (double.tryParse(product['discount_percent']?.toString() ?? '0') ?? 0).round();

  final String productId = product['id'].toString();

  return GestureDetector(
    onTap: () {
      Get.toNamed(
        AppRouter.productdetail,
        arguments: productId,
      );
    },
    child: discount > 0
        ? ProductCard.withDiscount(
            imagePath: product['default_image'] ?? '',
            gujaratiName: product['product_name'] ?? '',
            price: price,
            index: index,
            oldPrice: oldPrice,
            discountValue: discount,
            quantity: product['unit_number'],
            showArrow: true,
            productId: productId,
          )
        : ProductCard(
            imagePath: product['default_image'] ?? '',
            gujaratiName: product['product_name'] ?? '',
            price: price,
            index: index,
            quantity: product['unit_number'],
            showArrow: true,
            productId: productId,
          ),
  );
}

// User Approval Info
Widget userApprovalInfo(HomeController controller) {
  return Obx(() {
    if (controller.isLoading.isTrue) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.height / 37.8,
        ),
        child: shimmerBox(
          height: Get.height / 8.4,
          width: double.infinity,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffFFF5CC),
              borderRadius: BorderRadius.circular(Get.height / 58.15),
            ),
            height: Get.height / 8.4,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(Get.height / 50.4),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/clock.png",
                    width: Get.height / 15.12,
                    height: Get.height / 15.12,
                  ),
                  SizedBox(width: Get.height / 50.4),
                  Expanded(
                    child: Text(
                      "તમારું અકાઉન્ટ હજી સક્રિય થયું નથી. તમે પ્રોડક્ટ્સ જોઈ શકશો, પણ મંજૂરી વિના ઓર્ડર કરી શકશો નહીં.",
                      style: TextStyle(
                        color: dark,
                        fontFamily: "urbanist",
                        fontWeight: FontWeight.w600,
                        fontSize: Get.height / 63,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}

// Scrolling Info Text
Widget scrollingInfoText(HomeController controller) {
  return Obx(() {
    final text = controller.userData['delivery_msg_new'];

    if (controller.isLoading.value || text == null || text.toString().isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
        child: shimmerBox(
          height: Get.height / 22,
          width: double.infinity,
        ),
      );
    }

    return Container(
      height: Get.height / 22,
      width: double.infinity,
      color: orange.withValues(alpha: 0.12),

      child: Align(
        alignment: Alignment.center,
        child: Marquee(
          text: '$text      ',
          style: TextStyle(
            color: orange,
            fontSize: Get.height / 56,
            fontWeight: FontWeight.w600,
            fontFamily: 'Urbanist',
            height: 1.3,
          ),

          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,

          velocity: 28,
          blankSpace: 160,
          pauseAfterRound: Duration(
            seconds: 2,
          ),
          startPadding: 20,

          accelerationDuration: Duration(
            milliseconds: 600,
          ),
          decelerationDuration: Duration(
            milliseconds: 600,
          ),
          accelerationCurve: Curves.easeInOut,
          decelerationCurve: Curves.easeInOut,
        ),
      ),
    );
  });
}

// Delivery Info Card
Widget deliveryInfoCard(
  HomeController controller,
) {
  return Obx(() {
    if (controller.isLoading.value) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.height / 37.8,
        ),
        child: shimmerBox(
          height: Get.height / 8.4,
          width: double.infinity,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Get.height / 37.8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffE6FAFF),
          borderRadius: BorderRadius.circular(
            Get.height / 58.15,
          ),
        ),
        height: Get.height / 8.4,
        width: Get.height / 0.7,
        child: Padding(
          padding: EdgeInsets.all(
            Get.height / 50.4,
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/images/calendar.png",
                width: Get.height / 15.12,
                height: Get.height / 15.12,
              ),
              SizedBox(
                width: Get.height / 50.4,
              ),
              Expanded(
                child: Text(
                  controller.userData['delivery_msg'] ?? '',
                  style: TextStyle(
                    color: dark,
                    fontFamily: "urbanist",
                    fontWeight: FontWeight.w600,
                    fontSize: Get.height / 63,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}

// Product Card Veg
class ProductCardVeg extends StatefulWidget {
  final int index;
  final String imagePath;
  final String gujaratiName;
  final String? englishName;
  final int price;
  final int? oldPrice;
  final bool showOldPrice;
  final String? quantity;
  final bool isDiscount;
  final int discountValue;
  final String productId;

  // Without Discount
  const ProductCardVeg({
    super.key,
    required this.index,
    required this.imagePath,
    required this.gujaratiName,
    required this.price,
    required this.productId,
    this.englishName,
    this.oldPrice,
    this.showOldPrice = false,
    this.quantity,
  }) : isDiscount = false,
       discountValue = 0;

  // With Discount
  const ProductCardVeg.withDiscount({
    super.key,
    required this.index,
    required this.imagePath,
    required this.gujaratiName,
    required this.price,
    required this.discountValue,
    required this.productId,
    this.englishName,
    this.oldPrice,
    this.showOldPrice = true,
    this.quantity,
  }) : isDiscount = true;

  @override
  State<ProductCardVeg> createState() => _ProductCardVegState();
}

final controller = Get.put(HomeController());

class _ProductCardVegState extends State<ProductCardVeg> {
  late RxBool isDiscount;
  late RxInt discountValue;

  @override
  void initState() {
    super.initState();
    isDiscount = widget.isDiscount.obs;
    discountValue = widget.discountValue.obs;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(Get.height / 47.25);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height / 75.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height / 151.2),

              Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: Get.height / 5.95,
                      width: Get.height / 5.4,
                      decoration: BoxDecoration(
                        color: shade100,
                        borderRadius: borderRadius,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Discount Badge
                          Obx(
                            () => isDiscount.value
                                ? Positioned(
                                    top: Get.height / 94.5,
                                    right: Get.height / 94.5,
                                    child: Container(
                                      height: Get.height / 42,
                                      width: Get.height / 13.03,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Get.height / 75.6),
                                        color: error.withValues(alpha: 0.1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${discountValue.value}% બચત',
                                          style: TextStyle(
                                            fontSize: Get.height / 63,
                                            fontWeight: FontWeight.w400,
                                            color: error,
                                            fontFamily: 'Urbanist',
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),

                          // Product Image
                          CachedNetworkImage(
                            imageUrl: widget.imagePath,
                            width: Get.height / 4.9,
                            height: Get.height / 10,
                            fit: BoxFit.contain,
                            placeholder: (context, url) {
                              return SizedBox(
                                height: Get.height / 10,
                                width: Get.height / 4.9,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: primary,
                                  ),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return Icon(
                                Icons.image_not_supported,
                                size: Get.height / 20,
                                color: shade400,
                              );
                            },
                          ),

                          Positioned(
                            bottom: Get.height / 94.5,
                            right: Get.height / 94.5,
                            child: Obx(() {
                              final int qty = controller.getQty(widget.productId);

                              if (qty == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.updateQty(
                                      widget.productId,
                                      1,
                                      fromUserInteraction: true,
                                    );
                                  },
                                  child: Container(
                                    height: Get.height / 30,
                                    width: Get.height / 30,
                                    alignment: Alignment.center,
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
                                      '+',
                                      style: TextStyle(
                                        fontSize: Get.height / 47.25,
                                        fontWeight: FontWeight.w600,
                                        color: dark,
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return Container(
                                height: Get.height / 30,
                                width: Get.height / 12,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: light,
                                  borderRadius: BorderRadius.circular(200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: dark.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        int currentQty = controller.getQty(widget.productId);

                                        int newQty = currentQty - 1;
                                        if (newQty < 0) newQty = 0;

                                        controller.updateQty(widget.productId, newQty);
                                      },
                                      child: Text(
                                        '-',
                                        style: TextStyle(
                                          fontSize: Get.height / 47.25,
                                          fontWeight: FontWeight.w600,
                                          color: dark,
                                          fontFamily: 'Urbanist',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      qty.toString(),
                                      style: TextStyle(
                                        fontSize: Get.height / 54,
                                        fontWeight: FontWeight.w600,
                                        color: dark,
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.updateQty(widget.productId, qty + 1);
                                      },
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          fontSize: Get.height / 47.25,
                                          fontWeight: FontWeight.w600,
                                          color: dark,
                                          fontFamily: 'Urbanist',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Get.height / 50.4),

              // Product Name
              SizedBox(
                width: Get.height / 5.4,
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.gujaratiName,
                        style: TextStyle(
                          color: primary,
                          fontFamily: "urbanist",
                          fontSize: Get.height / 44.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.1,
                        ),
                      ),
                      if (widget.englishName != null)
                        TextSpan(
                          text: ' (${widget.englishName})',
                          style: TextStyle(
                            color: primary,
                            fontFamily: "urbanist",
                            fontSize: Get.height / 44.5,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.1,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Quantity
              Text(
                widget.quantity ?? '1 કિલો',
                style: TextStyle(
                  fontSize: Get.height / 54,
                  fontWeight: FontWeight.w500,
                  color: shade400,
                  fontFamily: 'Urbanist',
                ),
              ),

              // Price
              Row(
                children: [
                  if (widget.showOldPrice && widget.oldPrice != null)
                    Text(
                      '₹ ${widget.oldPrice}  ',
                      style: TextStyle(
                        fontSize: Get.height / 63,
                        fontWeight: FontWeight.w400,
                        color: shade400,
                        decoration: TextDecoration.lineThrough,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  Text(
                    '₹ ${widget.price}',
                    style: TextStyle(
                      fontSize: Get.height / 47.25,
                      fontWeight: FontWeight.w700,
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
    );
  }
}

// Title Header
Widget titleHeader(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: Get.height / 37.8,
          fontWeight: FontWeight.w800,
          color: dark,
          fontFamily: 'Urbanist',
        ),
      ),

      Text(
        'view_all'.tr,
        style: TextStyle(
          fontSize: Get.height / 54,
          fontWeight: FontWeight.w600,
          color: primary,
          fontFamily: 'Urbanist',
        ),
      ),
    ],
  );
}

// Top Bar
Widget topBar(HomeController controller) {
  return Obx(() {
    if (controller.isLoading.value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerBox(
            height: Get.height / 50.4,
            width: Get.height / 7.56,
          ),
          SizedBox(height: Get.height / 94.5),
          shimmerBox(
            height: Get.height / 37.8,
            width: Get.height / 5.04,
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRouter.deliveryDashboard);
              },
              child: Text(
                'greeting'.tr,
                style: TextStyle(
                  fontSize: Get.height / 54,
                  fontWeight: FontWeight.w300,
                  color: shade300,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),

            SizedBox(height: Get.height / 151.2),
            Text(
              controller.userData['user_name'] ?? '',
              style: TextStyle(
                fontSize: Get.height / 54,
                fontWeight: FontWeight.w700,
                color: dark,
                fontFamily: 'Urbanist',
              ),
            ),
          ],
        ),

        GestureDetector(
          onTap: () {
            Get.offAllNamed(AppRouter.home, arguments: 2);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                'assets/icons/shopping_basket.png',
                width: Get.height / 30.24,
                color: primary,
              ),
              Positioned(
                top: -4,
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
    );
  });
}

// Banner
Widget banner(HomeController controller) {
  return Obx(() {
    if (controller.isLoading.value) {
      return shimmerBox(
        height: Get.height / 5.15,
        width: double.infinity,
      );
    }
    return Container(
      height: Get.height / 5.15,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Get.height / 75.6),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: Get.height / 75.6),
            child: Image.asset(
              'assets/images/banner.png',
              height: Get.height / 5.81,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            right: 0,
            child: greenShape(controller),
          ),
        ],
      ),
    );
  });
}

// Green Shape
Widget greenShape(HomeController controller) {
  return Obx(
    () => ClipPath(
      clipper: BannerClipper(),
      child: Container(
        height: Get.height / 5.14,
        width: Get.height / 3,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Get.height / 75.6),
            bottomRight: Radius.circular(Get.height / 75.6),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: Get.height / 7.9),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'next_delivery_date'.tr,
                    style: TextStyle(
                      color: light,
                      fontSize: Get.height / 47.25,
                      fontWeight: FontWeight.w200,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  SizedBox(height: Get.height / 94.5),
                  Text(
                    controller.userData['delivery_date'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Get.height / 42,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//  ProductCard (Fruit) — productId-based cart logic
class ProductCard extends StatefulWidget {
  final String imagePath;
  final int index;
  final String gujaratiName;
  final String? englishName;
  final int price;
  final int? oldPrice;
  final bool showOldPrice;
  final String? quantity;
  final bool isDiscount;
  final int discountValue;
  final bool showArrow;
  final String productId;

  // Without Discount
  const ProductCard({
    super.key,
    required this.index,
    required this.imagePath,
    required this.gujaratiName,
    required this.price,
    required this.productId,
    this.englishName,
    this.oldPrice,
    this.showOldPrice = false,
    this.showArrow = false,
    this.quantity,
  }) : isDiscount = false,
       discountValue = 0;

  // With Discount
  const ProductCard.withDiscount({
    super.key,
    required this.index,
    required this.imagePath,
    required this.gujaratiName,
    required this.price,
    required this.discountValue,
    required this.productId,
    this.englishName,
    this.oldPrice,
    this.showOldPrice = true,
    this.showArrow = false,
    this.quantity,
  }) : isDiscount = true;

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  final controller = Get.find<HomeController>();

  late RxBool isDiscount;
  late RxInt discountValue;

  @override
  void initState() {
    super.initState();
    isDiscount = widget.isDiscount.obs;
    discountValue = widget.discountValue.obs;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(Get.height / 47.25);

    return SizedBox(
      width: Get.height / 5.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: shade300, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height / 75.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),

                  // Image + Discount + Add Button
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: Get.height / 6.14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: shade100,
                            borderRadius: borderRadius,
                          ),
                          child: Stack(
                            children: [
                              // Image
                              Center(
                                child: CachedNetworkImage(
                                  imageUrl: widget.imagePath,
                                  width: Get.height / 4.87,
                                  height: Get.height / 8.93,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.image_not_supported,
                                    size: Get.height / 20,
                                    color: shade400,
                                  ),
                                ),
                              ),

                              // Discount Badge
                              Obx(
                                () => isDiscount.value
                                    ? Positioned(
                                        top: Get.height / 94.5,
                                        right: Get.height / 94.5,
                                        child: Container(
                                          height: Get.height / 42,
                                          width: Get.height / 13.03,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Get.height / 75.6),
                                            color: error.withValues(alpha: 0.1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${discountValue.value}% બચત',
                                              style: TextStyle(
                                                fontSize: Get.height / 63,
                                                fontWeight: FontWeight.w400,
                                                color: error,
                                                fontFamily: 'Urbanist',
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),

                              //  Add/Remove Button — productId based
                              Positioned(
                                bottom: Get.height / 94.5,
                                right: Get.height / 94.5,
                                child: Obx(() {
                                  final int qty = controller.getQty(widget.productId);

                                  if (qty == 0) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.updateQty(
                                          widget.productId,
                                          1,
                                          fromUserInteraction: true,
                                        );
                                      },
                                      child: Container(
                                        height: Get.height / 30,
                                        width: Get.height / 30,
                                        alignment: Alignment.center,
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
                                          '+',
                                          style: TextStyle(
                                            fontSize: Get.height / 47.25,
                                            fontWeight: FontWeight.w600,
                                            color: dark,
                                            fontFamily: 'Urbanist',
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Container(
                                    height: Get.height / 30,
                                    width: Get.height / 12,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: light,
                                      borderRadius: BorderRadius.circular(200),
                                      boxShadow: [
                                        BoxShadow(
                                          color: dark.withValues(alpha: 0.2),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (qty > 1) {
                                              controller.updateQty(widget.productId, qty - 1);
                                            } else {
                                              controller.updateQty(widget.productId, 0);
                                            }
                                          },
                                          child: Text(
                                            '-',
                                            style: TextStyle(
                                              fontSize: Get.height / 47.25,
                                              fontWeight: FontWeight.w600,
                                              color: dark,
                                              fontFamily: 'Urbanist',
                                            ),
                                          ),
                                        ),
                                        Text(
                                          qty.toString(),
                                          style: TextStyle(
                                            fontSize: Get.height / 54,
                                            fontWeight: FontWeight.w600,
                                            color: dark,
                                            fontFamily: 'Urbanist',
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            controller.updateQty(widget.productId, qty + 1);
                                          },
                                          child: Text(
                                            '+',
                                            style: TextStyle(
                                              fontSize: Get.height / 47.25,
                                              fontWeight: FontWeight.w600,
                                              color: dark,
                                              fontFamily: 'Urbanist',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Get.height / 50.4),

                  // Product Name
                  SizedBox(
                    width: Get.height / 5.4,
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.gujaratiName,
                            style: TextStyle(
                              color: primary,
                              fontFamily: "urbanist",
                              fontSize: Get.height / 44.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.1,
                            ),
                          ),
                          if (widget.englishName != null)
                            TextSpan(
                              text: ' (${widget.englishName})',
                              style: TextStyle(
                                color: primary,
                                fontFamily: "urbanist",
                                fontSize: Get.height / 44.5,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.1,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Quantity
                  SizedBox(height: Get.height / 151.2),
                  Text(
                    widget.quantity ?? '1 કિલો',
                    style: TextStyle(
                      fontSize: Get.height / 54,
                      fontWeight: FontWeight.w500,
                      color: shade400,
                      fontFamily: 'Urbanist',
                    ),
                  ),

                  // Price
                  Row(
                    mainAxisAlignment: widget.showArrow ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (widget.showOldPrice && widget.oldPrice != null)
                            Text(
                              '₹ ${widget.oldPrice}  ',
                              style: TextStyle(
                                fontSize: Get.height / 63,
                                fontWeight: FontWeight.w400,
                                color: shade400,
                                decoration: TextDecoration.lineThrough,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          Text(
                            '₹ ${widget.price}',
                            style: TextStyle(
                              fontSize: Get.height / 47.25,
                              fontWeight: FontWeight.w700,
                              color: dark,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                      if (widget.showArrow)
                        Container(
                          height: Get.height / 25.2,
                          width: Get.height / 25.2,
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: ImageIcon(
                            AssetImage('assets/icons/arrow.png'),
                            color: light,
                            size: Get.height / 58.15,
                          ),
                        ),
                    ],
                  ),
                  if (widget.showArrow) SizedBox(height: Get.height / 75.6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Common Shimmer Container
Widget shimmerBox({double? height, double? width}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

// Banner Clipper
class BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(size.width * 0.35, 0);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height / 2,
      size.width * 0.35,
      size.height,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
