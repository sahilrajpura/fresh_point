import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_point/utility/theme.dart';

class ConfirmDelete extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmDelete({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: light,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Message
            Text(
              "શું તમે ખરેખર આ આઇટમ કાઢી નાખવા માંગો છો?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: shade400,
                fontFamily: 'Mulish',
              ),
            ),

            SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                // Cancel
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: shade300),
                      ),
                      child: Text(
                        "ના",
                        style: TextStyle(
                          color: dark,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                // Delete
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      onConfirm();
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "હા",
                        style: TextStyle(
                          color: light,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Mulish',
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
