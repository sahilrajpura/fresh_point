import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class ReadytodeliverDialog extends StatelessWidget {
  const ReadytodeliverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'હું ઓર્ડર ડિલિવરી કન્ફર્મ કરવા માગું છુ. પેમેન્ટ મળી ગયું છે?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Get.height / 54,
                fontWeight: FontWeight.w400,
                fontFamily: 'Urbanist',
                color: shade400,
              ),
            ),
            SizedBox(height: Get.height / 30),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: false),
                    child: Container(
                      height: Get.height / 14,
                      decoration: BoxDecoration(
                        color: shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ના',
                        style: TextStyle(
                          fontSize: Get.height / 44.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Urbanist',
                          color: dark,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: Get.height / 50.4),

                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: true),
                    child: Container(
                      height: Get.height / 14,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'હા',
                        style: TextStyle(
                          fontSize: Get.height / 44.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Urbanist',
                          color: light,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
