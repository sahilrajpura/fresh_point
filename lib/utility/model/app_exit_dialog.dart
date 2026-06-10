import 'package:flutter/material.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class AppExitDialog extends StatelessWidget {
  const AppExitDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'એપમાંથી બહાર નીકળો',
              style: TextStyle(
                fontSize: Get.height / 37.8,
                fontWeight: FontWeight.w800,
                fontFamily: 'Urbanist',
                color: dark,
              ),
            ),
            SizedBox(height: Get.height / 50.4),
            Text(
              'તમે ખાતરીપૂર્વક એપમાંથી બહાર નીકળવા માંગો છો?',
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
