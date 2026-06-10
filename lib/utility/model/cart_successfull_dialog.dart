import 'package:flutter/material.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class CartSuccessfullDialogScreen extends StatelessWidget {
  const CartSuccessfullDialogScreen({super.key});

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
                'assets/images/Received.png',
                width: Get.height / 8.89,
                height: Get.height / 8.89,
              ),
              SizedBox(height: Get.height / 28),
              Text(
                'ઓર્ડર કન્ફર્મ થયો છે!',
                style: TextStyle(
                  color: dark,
                  fontFamily: "urbanist",
                  fontWeight: FontWeight.w600,
                  fontSize: Get.height / 42,
                ),
              ),
              SizedBox(height: Get.height / 54),

              Text(
                textAlign: TextAlign.center,
                'આભાર! તમારો ઓર્ડર કન્ફર્મ કરવામાં આવ્યો છે અને ટૂંક સમયમાં પ્રોસેસ કરવામાં આવશે.',
                style: TextStyle(
                  color: dark,
                  fontFamily: "urbanist",
                  fontSize: Get.height / 54,
                  height: 1.4,
                ),
              ),
              SizedBox(
                height: Get.height / 24.38,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRouter.order);
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
