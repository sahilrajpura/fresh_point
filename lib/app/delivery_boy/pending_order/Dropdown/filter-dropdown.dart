import 'package:flutter/material.dart';
import 'package:fresh_point/app/delivery_boy/pending_order/pending_order_screen.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class FilterDropdown extends StatelessWidget {
  const FilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Top Bar
          TopBar(),

          AreaSelection(),
          AreaSelection(),
        ],
      ),
    );
  }
}

// Top Bar
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height / 14.26,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primary.withValues(
          alpha: 0.2,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.height / 37.8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ગ્રાહકની વિગતો દાખલ કરો',
              style: TextStyle(
                fontSize: Get.height / 50.4,
                fontWeight: FontWeight.w700,
                color: primary,
                fontFamily: 'Urbanist',
              ),
            ),

            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.close,
                size: Get.height / 37.8,
                color: shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
