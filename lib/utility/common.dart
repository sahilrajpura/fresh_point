import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fresh_point/utility/routes.dart';
import 'package:fresh_point/utility/theme.dart';
import 'package:get/get.dart';

// Back Ground Scaffold
class BackgroundScaffold extends StatelessWidget {
  final Widget child;
  final bool safeArea;

  final Color? backgroundColor;
  final Gradient? backgroundGradient;

  const BackgroundScaffold({
    super.key,
    required this.child,
    this.safeArea = true,
    this.backgroundColor,
    this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    double topOffset = Get.height / 6.87;
    double imageSize = Get.height / 16.43;

    final body = Stack(
      children: [
        Positioned(
          top: topOffset,
          left: 0,
          child: Image.asset(
            'assets/images/scaffold_image_1.png',
            width: imageSize,
          ),
        ),
        Positioned(
          bottom: topOffset,
          right: 0,
          child: Image.asset(
            'assets/images/scaffold_image_2.png',
            width: imageSize,
          ),
        ),
        Positioned.fill(child: child),
      ],
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: backgroundGradient == null ? (backgroundColor ?? light) : Colors.transparent,
        body: Container(
          decoration: backgroundGradient != null ? BoxDecoration(gradient: backgroundGradient) : null,
          child: safeArea ? SafeArea(child: body) : body,
        ),
      ),
    );
  }
}

// Back Ground Scaffold

//Customize Button
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;
  final IconData? icon;
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.backgroundColor = primary,
    this.textColor = light,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height / 16.8,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Get.height / 47.25),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: Get.height / 42),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: Get.height / 54,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: 'Urbanist',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// / Customize Button

//CustomTextField

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final TextStyle? labelStyle;

  final String hintText;
  final IconData? suffixIcon;
  final double height;

  final TextEditingController? controller;

  final Color borderColor;
  final Color textColor;
  final Color hintColor;
  final Color iconColor;
  final Color backgroundColor;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  final bool onlyNumbers;
  final TextInputType keyboardType;
  final int? maxLength;

  final bool isPassword;

  final List<TextInputFormatter>? inputFormatters;
  final RegExp? allowedRegExp;

  final RxString? errorText;

  const CustomTextField({
    super.key,
    this.labelText,
    this.labelStyle,
    required this.hintText,
    this.suffixIcon,
    this.height = 56,
    this.controller,
    this.borderColor = shade300,
    this.textColor = dark,
    this.hintColor = shade300,
    this.iconColor = shade300,
    this.backgroundColor = Colors.transparent,
    this.onlyNumbers = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.isPassword = false,
    this.inputFormatters,
    this.allowedRegExp,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    widget.controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double fieldHeight = Get.height / 16.8;

    final bool isActive = _focusNode.hasFocus || (widget.controller?.text.isNotEmpty ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style:
                widget.labelStyle ??
                TextStyle(
                  fontSize: Get.height / 54,
                  fontWeight: FontWeight.w700,
                  color: widget.textColor,
                  fontFamily: 'Urbanist',
                ),
          ),
          SizedBox(height: Get.height / 75.6),
        ],

        // Text Feild
        Container(
          height: fieldHeight,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(Get.height / 47.25),
            border: Border.all(
              color: widget.errorText != null && widget.errorText!.value.isNotEmpty
                  ? error
                  : isActive
                  ? primary
                  : widget.borderColor,
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Get.height / 75.6,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  controller: widget.controller,
                  cursorColor: primary,
                  keyboardType: widget.keyboardType,
                  maxLength: widget.maxLength,
                  maxLines: 1,
                  obscureText: widget.isPassword ? obscureText : false,
                  inputFormatters: widget.allowedRegExp != null
                      ? [
                          FilteringTextInputFormatter.allow(
                            widget.allowedRegExp!,
                          ),
                        ]
                      : widget.inputFormatters ??
                            (widget.onlyNumbers ? [FilteringTextInputFormatter.digitsOnly] : null),
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: Get.height / 54,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    counterText: "",
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: widget.hintColor,
                      fontSize: Get.height / 54,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (widget.suffixIcon != null)
                GestureDetector(
                  onTap: widget.isPassword
                      ? () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        }
                      : null,
                  child: Icon(
                    widget.isPassword
                        ? (obscureText ? Icons.remove_red_eye_sharp : Icons.visibility_off)
                        : widget.suffixIcon,
                    color: widget.iconColor,
                    size: Get.height / 37.8,
                  ),
                ),
            ],
          ),
        ),

        if (widget.errorText != null)
          Obx(
            () => widget.errorText!.value.isEmpty
                ? SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(
                      top: Get.height / 151.2,
                    ),
                    child: Text(
                      widget.errorText!.value.tr,
                      style: TextStyle(
                        color: error,
                        fontSize: Get.height / 63,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}

// / CustomTextField

//CustomBigTextField

class CustomBigTextField extends StatefulWidget {
  final String? labelText;
  final TextStyle? labelStyle;

  final String hintText;
  final double height;
  final TextEditingController? controller;

  final Color borderColor;
  final Color textColor;
  final Color hintColor;
  final Color backgroundColor;

  final RxString? errorText;
  final void Function(String value) onChanged;

  const CustomBigTextField({
    super.key,
    this.labelText,
    this.labelStyle,
    required this.hintText,
    this.height = 85,
    this.controller,
    this.borderColor = shade300,
    this.textColor = dark,
    this.hintColor = shade300,
    this.backgroundColor = Colors.transparent,
    this.errorText,
    required this.onChanged,
  });

  @override
  State<CustomBigTextField> createState() => _CustomBigTextFieldState();
}

class _CustomBigTextFieldState extends State<CustomBigTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    widget.controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = _focusNode.hasFocus || (widget.controller?.text.isNotEmpty ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style:
                widget.labelStyle ??
                TextStyle(
                  fontSize: Get.height / 54,
                  fontWeight: FontWeight.w700,
                  color: widget.textColor,
                  fontFamily: 'Urbanist',
                ),
          ),
          SizedBox(height: Get.height / 75.6),
        ],

        // Text feild
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(Get.height / 47.25),
            border: Border.all(
              color: widget.errorText != null && widget.errorText!.value.isNotEmpty
                  ? error
                  : isActive
                  ? primary
                  : widget.borderColor,
              width: 1,
            ),
          ),
          padding: EdgeInsets.all(Get.height / 75.6),
          child: TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            onChanged: widget.onChanged,
            cursorColor: primary,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: TextStyle(
              color: widget.textColor,
              fontSize: Get.height / 54,
            ),
            decoration: InputDecoration(
              isCollapsed: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: widget.hintColor,
                fontSize: Get.height / 54,
              ),
              border: InputBorder.none,
            ),
          ),
        ),

        if (widget.errorText != null)
          Obx(
            () => widget.errorText!.value.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(
                      top: Get.height / 151.2,
                    ),
                    child: Text(
                      widget.errorText!.value.tr,
                      style: TextStyle(
                        color: error,
                        fontSize: Get.height / 63,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}

// CustomBigTextField

// Drop Down
class LocationCommonDropdown extends StatelessWidget {
  final String hintText;
  final RxString selectedValue;
  final List<String> itemsList;
  final Function(String?)? onChanged;
  final RxString? errorText;

  const LocationCommonDropdown({
    super.key,
    required this.hintText,
    required this.selectedValue,
    required this.itemsList,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: Obx(
            () => DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                hintText,
                style: TextStyle(
                  color: shade300,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.w400,
                  fontSize: Get.height / 54,
                ),
              ),
              items: itemsList
                  .map(
                    (String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          color: dark,
                          fontFamily: "Urbanist",
                          fontWeight: FontWeight.w500,
                          fontSize: Get.height / 54,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              value: selectedValue.isEmpty ? null : selectedValue.value,
              onChanged: onChanged,
              buttonStyleData: ButtonStyleData(
                height: Get.height / 16,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width / 30.24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Get.height / 47.25),
                  border: Border.all(
                    width: 1,
                    color: selectedValue.value.isNotEmpty ? primary : shade300,
                  ),
                ),
              ),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down),
                iconSize: 25,
                openMenuIcon: Icon(Icons.keyboard_arrow_up),
                iconEnabledColor: shade300,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: light,
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(height: 45),
            ),
          ),
        ),

        if (errorText != null)
          Obx(
            () => errorText!.value.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      errorText!.value,
                      style: const TextStyle(
                        color: error,
                        fontSize: 12,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}

// Back To Home Wrapper

class BackToHomeWrapper extends StatelessWidget {
  final Widget child;
  const BackToHomeWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop) Get.offAllNamed(AppRouter.home);
      },
      child: child,
    );
  }
}
