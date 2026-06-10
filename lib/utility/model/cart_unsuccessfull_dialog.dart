import 'package:flutter/material.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class CartUnSuccessfullDialogScreen extends StatelessWidget {
  const CartUnSuccessfullDialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: light,
          borderRadius: BorderRadius.circular(Get.height / 34.36),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: Get.height / 21.6,
            bottom: Get.height / 37.8,
            left: Get.height / 32.87,
            right: Get.height / 32.87,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/Cancel.png',
                width: Get.height / 8.89,
                height: Get.height / 8.89,
              ),
              SizedBox(height: Get.height / 28),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'માફ કરશો, ઓડૅર કન્ફર્મ થયો નથી',
                  maxLines: 1,
                  style: TextStyle(
                    color: dark,
                    fontFamily: "urbanist",
                    fontWeight: FontWeight.w600,
                    fontSize: Get.height / 42,
                  ),
                ),
              ),
              SizedBox(height: Get.height / 54),
              Text(
                'ટેકનિકલ કારણોસર તમારો ઓર્ડર કન્ફર્મ થયો નથી. તમે થોડી વાર પછી ફરીથી ટ્રાય કરો... જો તમને વધુ માહિતી જરૂર હોય, તો કૃપા કરીને અમારો સંપર્ક કરો.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dark,
                  fontFamily: "urbanist",
                  fontSize: Get.height / 54,

                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: Get.height / 24.38),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: Get.height / 15.12,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(Get.height / 7.56),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'મારો ઓર્ડર',
                        style: TextStyle(
                          color: light,
                          fontFamily: "urbanist",
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height / 42,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
