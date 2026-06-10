import 'package:flutter/material.dart';
import 'package:fresh_point/app/register/register_controller.dart';
import 'package:fresh_point/utility/common.dart';
import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

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

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height / 37.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height / 4.10),

                    // Title
                    Text(
                      'register'.tr,
                      style: TextStyle(
                        fontSize: Get.height / 21,
                        color: primary,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                      ),
                    ),

                    // Name
                    SizedBox(height: Get.height / 25.2),
                    CustomTextField(
                      labelText: "name".tr,
                      hintText: "enter_name".tr,
                      controller: controller.name,
                      keyboardType: TextInputType.name,
                      allowedRegExp: RegExp('[a-zA-Z ]'),
                      errorText: controller.nameError,
                      onChanged: controller.validatename,
                    ),

                    // Village DropDown
                    SizedBox(
                      height: Get.height / 37.8,
                    ),
                    Text(
                      "village".tr,
                      style: TextStyle(
                        fontSize: Get.height / 54,
                        fontWeight: FontWeight.w700,
                        color: dark,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 75.6,
                    ),
                    Obx(
                      () => LocationCommonDropdown(
                        hintText: 'select_village'.tr,
                        selectedValue: controller.selectedVillageName,
                        itemsList: controller.villageList.isEmpty
                            ? ['Loading...']
                            : controller.villageList.map((e) => e['name']!).toList(),
                        errorText: controller.villageError,
                        onChanged: controller.villageList.isEmpty
                            ? null
                            : (value) async {
                                if (value == null) return;
                                final selected = controller.villageList.firstWhere(
                                  (e) => e['name'] == value,
                                  orElse: () => {},
                                );
                                if (selected.isEmpty) return;
                                controller.selectedVillageName.value = selected['name']!;
                                controller.selectedVillageId.value = selected['id']!;
                                controller.villageError.value = '';
                                controller.selectedAreaId.value = '';
                                controller.selectedAreaName.value = '';
                                controller.areaError.value = '';
                                controller.areaList.clear();
                                await controller.fetchAreaList(selected['id']!);
                              },
                      ),
                    ),

                    // Area DropDown
                    SizedBox(
                      height: Get.height / 37.8,
                    ),
                    Text(
                      "area".tr,
                      style: TextStyle(
                        fontSize: Get.height / 54,
                        fontWeight: FontWeight.w700,
                        color: dark,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 75.6,
                    ),
                    Obx(
                      () {
                        if (controller.isAreaLoading.value) {
                          return Container(
                            height: Get.height / 16.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(primary),
                              ),
                            ),
                          );
                        }
                        return LocationCommonDropdown(
                          selectedValue: controller.selectedAreaName,
                          hintText: 'select_area'.tr,
                          itemsList: controller.areaList.map((e) => e['name']!).toList(),
                          errorText: controller.areaError,
                          onChanged: (value) {
                            if (value == null) return;
                            final selected = controller.areaList.firstWhere(
                              (e) => e['name'] == value,
                            );
                            controller.selectedAreaName.value = selected['name']!;
                            controller.selectedAreaId.value = selected['id']!;
                            controller.areaError.value = '';
                          },
                        );
                      },
                    ),
                    // Address
                    SizedBox(
                      height: Get.height / 37.8,
                    ),
                    CustomBigTextField(
                      labelText: "address".tr,
                      hintText: "enter_address".tr,
                      controller: controller.address,
                      errorText: controller.addressError,
                      onChanged: controller.validateaddress,
                    ),

                    // Mobile Number
                    SizedBox(
                      height: Get.height / 25.2,
                    ),
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
                      onTap: () {
                        controller.saveUserData();
                      },
                      text: "register".tr,
                    ),

                    // Login Text
                    SizedBox(height: Get.height / 37.8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'already_account'.tr,
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

                        // Router To Login
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRouter.login);
                          },
                          child: Text(
                            'login'.tr,
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
                    SizedBox(
                      height: Get.height / 18.09,
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
