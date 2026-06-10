import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:fresh_point/app/home/home_screen.dart';
import 'package:fresh_point/app/product_list/product_list_controller.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  // Controller Import
  final controller = Get.put(ProductListController());

  @override
  Widget build(BuildContext context) {
    return BackToHomeWrapper(
      child: BackgroundScaffold(
        child: Column(
          children: [
            topBar(),
            Expanded(
              child: CategoryTabWithProducts(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Top Bar
Widget topBar() {
  final controller = Get.find<ProductListController>();
  return Stack(
    children: [
      Container(
        height: 130,
        width: double.infinity,
        color: primary,
        child: Opacity(
          opacity: 0.06,
          child: Image.asset(
            'assets/images/background.png',
            repeat: ImageRepeat.repeat,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        top: 20,
        left: 0,
        right: 0,
        child: Center(
          child: Text(
            'products'.tr,
            style: TextStyle(
              fontSize: Get.height / 37.8,
              fontWeight: FontWeight.w800,
              color: light,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
      ),
      Positioned(
        top: 60,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
          child: CustomTextField(
            backgroundColor: light,
            hintText: 'search_products'.tr,
            suffixIcon: Icons.search,
            onChanged: (value) {
              if (value.trim().isNotEmpty) {
                controller.searchProducts(value);
                controller.jumpToAll.value = true;
              } else {
                controller.clearSearch();
                controller.jumpToAll.value = false;
              }
            },
          ),
        ),
      ),
    ],
  );
}
// Category Tab

class CategoryTabWithProducts extends StatefulWidget {
  final ProductListController controller;

  const CategoryTabWithProducts({
    super.key,
    required this.controller,
  });

  @override
  State<CategoryTabWithProducts> createState() => _CategoryTabWithProductsState();
}

class _CategoryTabWithProductsState extends State<CategoryTabWithProducts> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Jab bhi jumpToAllTab() call ho, All tab auto-select ho
    ever(widget.controller.jumpToAll, (val) {
      if (val && mounted) {
        setState(() => selectedIndex = 3);
        widget.controller.jumpToAll.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    final List<String> tabs = [
      'vegetables'.tr,
      'fruits'.tr,
      'dry_fruits'.tr,
      'all'.tr,
    ];

    return Column(
      children: [
        SizedBox(
          height: Get.height / 16.8,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() => selectedIndex = index);

                  // Tab change hone par search clear karo
                  if (index != 3) {
                    widget.controller.clearSearch();
                  }

                  if (index == 0) {
                    widget.controller.vegScrollController.jumpTo(0);
                  }
                  if (index == 1) {
                    widget.controller.fruitScrollController.jumpTo(0);
                  }
                  if (index == 2) {
                    widget.controller.dryFruitScrollController.jumpTo(0);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height / 47.25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: Get.height / 42,
                          fontFamily: 'Urbanist',
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? primary : shade400,
                        ),
                        child: Text(
                          tabs[index],
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 378,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        height: Get.height / 756,
                        width: Get.height / 17.6,
                        decoration: BoxDecoration(
                          color: primary.withValues(
                            alpha: isSelected ? 1 : 0,
                          ),
                          borderRadius: BorderRadius.circular(
                            Get.height / 378,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: Get.height / 63,
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: Duration(
              milliseconds: 300,
            ),
            child: Container(
              key: ValueKey(selectedIndex),
              child: getProductsByTab(selectedIndex, controller),
            ),
          ),
        ),
      ],
    );
  }

  // Product Card Builder
  Widget buildCard(Map<String, dynamic> item, int index) {
    double priceDouble = double.tryParse(item['sale_price']?.toString() ?? '') ?? 0.0;
    int price = priceDouble.round();

    double? oldPriceDouble = double.tryParse(item['list_price']?.toString() ?? '');
    int? oldPrice = oldPriceDouble?.round();

    double discountDouble = double.tryParse(item['discount_percent']?.toString() ?? '') ?? 0.0;
    int discount = discountDouble.round();

    bool hasDiscount = discount > 0;

    final String productId = item['id'].toString();

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRouter.productdetail,
          arguments: productId,
        );
      },
      child: ProductListCard(
        controller: widget.controller,
        imagePath: item['default_image'] ?? '',
        gujaratiName: item['product_name'] ?? '',
        price: price,
        oldPrice: oldPrice,
        discount: hasDiscount ? discount : null,
        quantity: item['unit_number'],
        productId: productId,
      ),
    );
  }

  List<Widget> buildTwoPerRow(List<Widget> products) {
    List<Widget> rows = [];

    for (int i = 0; i < products.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(child: products[i]),
            SizedBox(width: Get.height / 75.6),
            if (i + 1 < products.length) Expanded(child: products[i + 1]) else const Spacer(),
          ],
        ),
      );
      rows.add(SizedBox(height: Get.height / 63));
    }

    return rows;
  }

  Widget shimmerList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: Get.height / 63),
            child: Row(
              children: [
                Expanded(child: shimmerBox(height: 220)),
                SizedBox(width: Get.height / 75.6),
                Expanded(child: shimmerBox(height: 220)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getProductsByTab(int selectedIndex, ProductListController controller) {
    switch (selectedIndex) {
      case 0:
        return Obx(() {
          if (controller.vegProductList.isEmpty) {
            return shimmerList();
          }
          return buildList(
            controller.vegScrollController,
            controller.vegProductList,
            controller.isLoadingVegPagination.value,
          );
        });

      case 1:
        return Obx(() {
          if (controller.fruitProductList.isEmpty) {
            return shimmerList();
          }
          return buildList(
            controller.fruitScrollController,
            controller.fruitProductList,
            controller.isLoadingFruitPagination.value,
          );
        });

      case 2:
        return Obx(() {
          if (controller.dryFruitProductList.isEmpty) {
            return shimmerList();
          }
          return buildList(
            controller.dryFruitScrollController,
            controller.dryFruitProductList,
            controller.isLoadingDryFruitPagination.value,
          );
        });

      case 3:
        // All tab — search results ya all products
        return Obx(() {
          final list = controller.searchQuery.value.isNotEmpty ? controller.searchResults : controller.allProductList;

          if (list.isEmpty && controller.searchQuery.value.isNotEmpty) {
            return Center(
              child: Text(
                'No Product Found',
                style: TextStyle(
                  fontSize: Get.height / 47.25,
                  color: shade400,
                  fontFamily: 'Urbanist',
                ),
              ),
            );
          }

          if (list.isEmpty) {
            return shimmerList();
          }

          return buildList(
            controller.allScrollController,
            list,
            controller.isLoadingVegPagination.value ||
                controller.isLoadingFruitPagination.value ||
                controller.isLoadingDryFruitPagination.value,
          );
        });

      default:
        return const SizedBox();
    }
  }

  Widget buildList(ScrollController controller, List products, bool isLoading) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
      child: ListView(
        controller: controller,
        children: [
          ...buildTwoPerRow(products.indexed.map((e) => buildCard(e.$2, e.$1)).toList()),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          SizedBox(height: Get.height / 37.8),
        ],
      ),
    );
  }
}

// Product List Card — ProductListController se cart handle karo
// Product List Card
class ProductListCard extends StatelessWidget {
  final ProductListController controller;
  final String imagePath;
  final String gujaratiName;
  final int price;
  final int? oldPrice;
  final int? discount;
  final String? quantity;
  final String productId;

  const ProductListCard({
    super.key,
    required this.controller,
    required this.imagePath,
    required this.gujaratiName,
    required this.price,
    required this.productId,
    this.oldPrice,
    this.discount,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(Get.height / 47.25);
    final plController = Get.find<ProductListController>();

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
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: shade100,
                        borderRadius: borderRadius,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Discount Badge
                          if (discount != null && discount! > 0)
                            Positioned(
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
                                    '$discount% બચત',
                                    style: TextStyle(
                                      fontSize: Get.height / 63,
                                      fontWeight: FontWeight.w400,
                                      color: error,
                                      fontFamily: 'Urbanist',
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          // Product Image
                          CachedNetworkImage(
                            imageUrl: imagePath,
                            width: Get.height / 4.9,
                            height: Get.height / 10,
                            fit: BoxFit.contain,
                            errorWidget: (context, url, error) {
                              return Icon(
                                Icons.image_not_supported,
                                size: Get.height / 20,
                                color: shade400,
                              );
                            },
                          ),

                          // Add/Remove Button
                          Positioned(
                            bottom: Get.height / 94.5,
                            right: Get.height / 94.5,
                            child: Obx(() {
                              // ✅ FINAL FIX: ONLY getQty use
                              final int qty = plController.getQty(productId);

                              if (qty == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    plController.updateQtyItem(productId, 1);
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
                                    // Minus
                                    GestureDetector(
                                      onTap: () {
                                        if (qty > 1) {
                                          plController.updateQtyItem(productId, qty - 1);
                                        } else {
                                          plController.updateQtyItem(productId, 0);
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

                                    // Qty
                                    Text(
                                      qty.toString(),
                                      style: TextStyle(
                                        fontSize: Get.height / 54,
                                        fontWeight: FontWeight.w600,
                                        color: dark,
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),

                                    // Plus
                                    GestureDetector(
                                      onTap: () {
                                        plController.updateQtyItem(productId, qty + 1);
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
              Text(
                gujaratiName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primary,
                  fontFamily: 'Urbanist',
                  fontSize: Get.height / 44.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.1,
                ),
              ),

              // Quantity
              Text(
                quantity ?? '1 કિલો',
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
                  if (oldPrice != null)
                    Text(
                      '₹ $oldPrice  ',
                      style: TextStyle(
                        fontSize: Get.height / 63,
                        fontWeight: FontWeight.w400,
                        color: shade400,
                        decoration: TextDecoration.lineThrough,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  Text(
                    '₹ $price',
                    style: TextStyle(
                      fontSize: Get.height / 47.25,
                      fontWeight: FontWeight.w700,
                      color: dark,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ],
              ),

              SizedBox(height: Get.height / 75.6),
            ],
          ),
        ),
      ],
    );
  }
}
