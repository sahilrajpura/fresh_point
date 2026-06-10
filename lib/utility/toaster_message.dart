import 'package:flutter/material.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// Toaster Message
toasterMessage(String message, Color color) {
  Get.showSnackbar(
    GetSnackBar(
      backgroundColor: color,
      margin: EdgeInsets.all(Get.width / 36),
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      message: message,
      messageText: Text(
        message,
        style: TextStyle(
          fontFamily: 'krub',
          fontWeight: FontWeight.w500,
          fontSize: Get.height / 47.25,
          color: light,
        ),
      ),
      duration: Duration(seconds: 2),
    ),
  );
}

// Circular Progress Indicator Loader
appProgressBarIndicator() {
  Get.dialog(
    Stack(
      children: [
        Container(color: Colors.transparent),
        Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: light,
            size: Get.height / 10.23,
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
