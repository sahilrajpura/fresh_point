import 'package:flutter/material.dart';
import 'package:fresh_point/app/delivery_boy/pending_order/Dropdown/Filter-dropdown.dart';
import 'package:fresh_point/utility/model/readytodeliver_dialog.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class PendingOrderScreen extends StatefulWidget {
  const PendingOrderScreen({super.key});

  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: light,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Top Bar
          TopBar(),

          // Area Selection
          AreaSelection(),

          // Pending Orders
          PendingOrder(),
          PendingOrder(),
          PendingOrder(),
          PendingOrder(),

          // noDataFound(),
          SizedBox(
            height: Get.height / 18.09,
          ),
        ],
      ),
    );
  }
}

Widget noDataFound() {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/Empty box.png',
            width: Get.height / 7.56,
          ),
          SizedBox(
            height: Get.height / 37.8,
          ),
          Text(
            textAlign: TextAlign.center,
            'આ વિસ્તાર માટે કોઈ ડિલિવરી નથી ',
            style: TextStyle(
              color: dark,
              fontSize: Get.height / 37.8,
              fontWeight: FontWeight.w700,
              fontFamily: 'Urbanist',
            ),
          ),
          SizedBox(height: Get.height / 75.6),
          Text(
            ' આ વિસ્તાર માટે કોઈ ઓર્ડર આપવામાં આવ્યો નથી જેથી બીજા વિસ્તારમાં ડિલિવરી માટે આગળ વધો.',
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

// Pending Order Card Widget
class PendingOrder extends StatefulWidget {
  const PendingOrder({super.key});

  @override
  State<PendingOrder> createState() => _PendingOrderState();
}

class _PendingOrderState extends State<PendingOrder> {
  // Tracks expansion state of the order card
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Get.height / 37.8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.height / 37.8,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.grey.shade400,
              ),
            ),
            child: ExpansionTile(
              onExpansionChanged: (value) {
                setState(() {
                  isExpanded = value;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              tilePadding: EdgeInsets.symmetric(horizontal: 10),

              // Customer Info - Name & Address
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icons - Person & Location
                  Column(
                    children: [
                      Icon(
                        Icons.person,
                        color: shade400,
                      ),
                      Icon(
                        Icons.location_on,
                        color: shade400,
                      ),
                    ],
                  ),
                  SizedBox(width: 12),

                  // Customer Name & Address Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hashim Rajpura',
                          style: TextStyle(
                            fontSize: Get.height / 54,
                            fontWeight: FontWeight.w700,
                            color: dark,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                        Text(
                          'Ramkrishna Society, Motipura...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Get.height / 58.15,
                            fontWeight: FontWeight.w400,
                            color: dark,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Trailing - Status Badge & Expand Arrow
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Order Status Badge
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: orange.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'પેન્ડિંગ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: orange,
                        height: 2.5,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),

                  // Expand / Collapse Arrow
                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 18,
                        color: light,
                      ),
                    ),
                  ),
                ],
              ),

              // Expanded Order Detail
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.height / 75.6,
                    vertical: Get.height / 75.6,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                      color: light,
                    ),
                    child: Column(
                      children: [
                        // Product List Header - વસ્તુ, જથ્થો, ભાવ
                        Container(
                          decoration: BoxDecoration(
                            color: secondary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          height: 31,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.height / 37.8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Item Label
                                Text(
                                  'વસ્તુ',
                                  style: TextStyle(
                                    fontSize: Get.height / 58.15,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                    height: 2.5,
                                    leadingDistribution: TextLeadingDistribution.even,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Quantity Label
                                    Text(
                                      'જથ્થો',
                                      style: TextStyle(
                                        fontSize: Get.height / 58.15,
                                        fontWeight: FontWeight.w700,
                                        color: primary,
                                        height: 2.5,
                                        leadingDistribution: TextLeadingDistribution.even,
                                      ),
                                    ),
                                    SizedBox(width: Get.height / 15.12),

                                    // Price Label
                                    Text(
                                      'ભાવ',
                                      style: TextStyle(
                                        fontSize: Get.height / 58.15,
                                        fontWeight: FontWeight.w700,
                                        color: primary,
                                        height: 2.5,
                                        leadingDistribution: TextLeadingDistribution.even,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: Get.height / 84),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Get.height / 50.4,
                          ),
                          child: Column(
                            children: [
                              // Product Item - Lemon (લીંબુ)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'લીંબુ',
                                          style: TextStyle(
                                            color: dark,
                                            fontFamily: "urbanist",
                                            fontSize: Get.height / 54,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.1,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' (Lemon)',
                                          style: TextStyle(
                                            color: dark,
                                            fontFamily: "urbanist",
                                            fontSize: Get.height / 54,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '2 કિલો',
                                        style: TextStyle(
                                          color: dark,
                                          fontFamily: "urbanist",
                                          fontSize: Get.height / 54,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                      SizedBox(width: Get.height / 18.09),
                                      Text(
                                        '₹ 200',
                                        style: TextStyle(
                                          color: dark,
                                          fontFamily: "urbanist",
                                          fontSize: Get.height / 54,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: Get.height / 75.6),

                              // Lemon Price Breakdown Card
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: shade200,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Get.height / 94.5,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: Get.height / 94.5),

                                      // Current Price Row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'હાલ કિંમત :',
                                            style: TextStyle(
                                              color: dark,
                                              fontFamily: "urbanist",
                                              fontSize: Get.height / 58.15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            '₹ 400',
                                            style: TextStyle(
                                              color: dark,
                                              fontFamily: "urbanist",
                                              fontSize: Get.height / 58.15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Adjusted Weight Row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'એડજસ્ટ વજન :',
                                            style: TextStyle(
                                              color: dark,
                                              fontFamily: "urbanist",
                                              fontSize: Get.height / 58.15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            '100 ગ્રામ',
                                            style: TextStyle(
                                              color: dark,
                                              fontFamily: "urbanist",
                                              fontSize: Get.height / 58.15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Adjusted Price Row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'એડજસ્ટ કિંમત :',
                                            style: TextStyle(
                                              color: dark,
                                              fontFamily: "urbanist",
                                              fontSize: Get.height / 58.15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            '₹ 20',
                                            style: TextStyle(
                                              color: dark,
                                              fontFamily: "urbanist",
                                              fontSize: Get.height / 58.15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Divider(),

                                      // Total Price Row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'કુલ :',
                                            style: TextStyle(
                                              color: dark,
                                              fontFamily: "urbanist",
                                              fontSize: Get.height / 58.15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            '₹ 420',
                                            style: TextStyle(
                                              color: dark,
                                              fontFamily: "urbanist",
                                              fontSize: Get.height / 58.15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: Get.height / 94.5),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: Get.height / 84),

                              // Product Item - Apple (સફરજન)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'સફરજન ',
                                          style: TextStyle(
                                            color: dark,
                                            fontFamily: "urbanist",
                                            fontSize: Get.height / 54,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.1,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' (Apple)',
                                          style: TextStyle(
                                            color: dark,
                                            fontFamily: "urbanist",
                                            fontSize: Get.height / 54,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '2 કિલો',
                                        style: TextStyle(
                                          color: dark,
                                          fontFamily: "urbanist",
                                          fontSize: Get.height / 54,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                      SizedBox(width: Get.height / 18.09),
                                      Text(
                                        '₹ 200',
                                        style: TextStyle(
                                          color: dark,
                                          fontFamily: "urbanist",
                                          fontSize: Get.height / 54,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Divider(),

                              SizedBox(height: Get.height / 84),

                              // Product Item - Pineapple (અનાનસ)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'અનાનસ ',
                                          style: TextStyle(
                                            color: dark,
                                            fontFamily: "urbanist",
                                            fontSize: Get.height / 54,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.1,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' (Pineapple)',
                                          style: TextStyle(
                                            color: dark,
                                            fontFamily: "urbanist",
                                            fontSize: Get.height / 54,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '5 કિલો',
                                        style: TextStyle(
                                          color: dark,
                                          fontFamily: "urbanist",
                                          fontSize: Get.height / 54,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                      SizedBox(width: Get.height / 18.09),
                                      Text(
                                        '₹ 200',
                                        style: TextStyle(
                                          color: dark,
                                          fontFamily: "urbanist",
                                          fontSize: Get.height / 54,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Divider(),

                              // Order Bill Summary
                              // Product Total
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'પ્રોડક્ટની કિંમત',
                                    style: TextStyle(
                                      color: dark,
                                      fontFamily: "urbanist",
                                      fontSize: Get.height / 54,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                  SizedBox(width: Get.height / 18.09),
                                  Text(
                                    '₹ 1420.00',
                                    style: TextStyle(
                                      color: dark,
                                      fontFamily: "urbanist",
                                      fontSize: Get.height / 54,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                ],
                              ),

                              // Delivery Charge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ડિલિવરી ચાર્જ',
                                    style: TextStyle(
                                      color: dark,
                                      fontFamily: "urbanist",
                                      fontSize: Get.height / 54,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                  SizedBox(width: Get.height / 18.09),
                                  Text(
                                    '₹ 30.00',
                                    style: TextStyle(
                                      color: dark,
                                      fontFamily: "urbanist",
                                      fontSize: Get.height / 54,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                ],
                              ),

                              // Grand Total
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'કુલ રકમ',
                                    style: TextStyle(
                                      color: dark,
                                      fontFamily: "urbanist",
                                      fontSize: Get.height / 58.15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '₹ 1450.00',
                                    style: TextStyle(
                                      color: dark,
                                      fontFamily: "urbanist",
                                      fontSize: Get.height / 58.15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: Get.height / 63,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.height / 75.6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.dialog(ReadytodeliverDialog());
                          },
                          child: Text(
                            'ડિલિવરી કન્ફર્મ કરો',
                            style: TextStyle(
                              color: light,
                              fontFamily: "urbanist",
                              fontSize: Get.height / 58.15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      Text(
                        '#ORD81525648885',
                        style: TextStyle(
                          color: dark,
                          fontFamily: "urbanist",
                          fontSize: Get.height / 58.15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: Get.height / 50.4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Area Selection Dropdown
class AreaSelection extends StatelessWidget {
  const AreaSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Get.height / 37.8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height / 37.8),

          // Area Label
          Text(
            'વિસ્તાર :',
            style: TextStyle(
              fontSize: Get.height / 54,
              fontWeight: FontWeight.w700,
              color: dark,
              fontFamily: 'Urbanist',
              height: 2.5,
            ),
          ),

          SizedBox(height: Get.height / 75.8),

          // Area Dropdown Field
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: shade300),
            ),
            child: TextFormField(
              readOnly: true,
              style: TextStyle(height: 1),
              decoration: InputDecoration(
                hintText: 'વિસ્તાર પસંદ કરો',
                hintStyle: TextStyle(height: -2.5),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                  bottom: 20,
                ),
                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Screen Top Bar with Back Button & Title
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background - Primary Color with Pattern
        Container(
          height: 89,
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

        // Top Bar Content - Back, Title, Action
        Positioned(
          top: 40,
          left: 20,
          right: 20,
          child: Row(
            children: [
              // Back Button
              InkWell(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: light,
                ),
              ),

              // Screen Title
              Expanded(
                child: Center(
                  child: Text(
                    'વિભાગવાર યાદી',
                    style: TextStyle(
                      fontSize: Get.height / 37.8,
                      fontWeight: FontWeight.w800,
                      color: light,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
              ),

              // Action Button - Torch
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    FilterDropdown(),
                    isScrollControlled: true,
                  );
                },
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: light.withValues(alpha: 0.3),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/tourch.png',
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
