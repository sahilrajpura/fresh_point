import 'package:flutter/material.dart';
import 'package:fresh_point/app/login/login_controller.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller
    final controller = Get.put(LoginController());
    return BackgroundScaffold(
      child: ListView(
        children: [
          Stack(
            children: [
              // Banner Image
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/login_screen_image.png',
                  width: 285,
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height / 4.11),

                    // Title
                    Text(
                      'login'.tr,
                      style: TextStyle(
                        fontSize: Get.height / 21,
                        color: primary,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                      ),
                    ),

                    // Mobile Number
                    SizedBox(height: Get.height / 25.2),
                    CustomTextField(
                      labelText: 'mobile_number'.tr,
                      hintText: 'enter_mobile'.tr,
                      controller: controller.mobile,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      onlyNumbers: true,
                      errorText: controller.mobileError,
                      onChanged: controller.validateMobile,
                    ),

                    // Password
                    SizedBox(height: Get.height / 37.8),
                    CustomTextField(
                      labelText: "password".tr,
                      hintText: "enter_password".tr,
                      controller: controller.password,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: Icons.remove_red_eye_sharp,
                      isPassword: true,
                      errorText: controller.passwordError,
                      onChanged: controller.validatepassword,
                    ),

                    // Button
                    SizedBox(height: Get.height / 37.8),
                    CustomButton(
                      text: "login".tr,
                      onTap: () {
                        controller.saveUserData();
                      },
                    ),

                    // Register Text
                    SizedBox(height: Get.height / 37.8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'no_account'.tr,
                          style: TextStyle(
                            fontSize: Get.height / 54,
                            fontWeight: FontWeight.w400,
                            color: dark,
                            fontFamily: 'Urbanist',
                          ),
                        ),

                        SizedBox(
                          width: Get.height / 151.2,
                        ),

                        // Route To Register
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRouter.register);
                          },
                          child: Text(
                            'register_now'.tr,
                            style: TextStyle(
                              fontSize: Get.height / 54,
                              fontWeight: FontWeight.w700,
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
            ],
          ),
        ],
      ),
    );
  }
}
