import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import 'package:saka/utils/box_shadow.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/button/bounce.dart';

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String? btnTxt;
  final bool customText;
  final Text? text;
  final double width;
  final double height;
  final double sizeBorderRadius;
  final Color loadingColor;
  final Color btnColor;
  final Color btnTextColor;
  final Color btnBorderColor;
  final double fontSize;
  final bool isBorder;
  final bool isBorderRadius;
  final bool isLoading;
  final bool isBoxShadow;

  const CustomButton({
    Key? key, 
    required this.onTap, 
    this.btnTxt, 
    this.customText = false,
    this.text,
    this.width = double.infinity,
    this.height = 45.0,
    this.fontSize = 14.0,
    this.sizeBorderRadius = 15.0,
    this.isLoading = false,
    this.loadingColor = ColorResources.white,
    this.btnColor = ColorResources.primaryOrange,
    this.btnTextColor = ColorResources.white,
    this.btnBorderColor = ColorResources.transparent,
    this.isBorder = false,
    this.isBorderRadius = false,
    this.isBoxShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bouncing(
      onPress: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          boxShadow: isBoxShadow 
          ? boxShadow 
          : [],
          color: btnColor,
          border: Border.all(
            color: isBorder 
            ? btnBorderColor 
            : ColorResources.transparent,
          ),
          borderRadius: isBorderRadius 
          ? BorderRadius.circular(sizeBorderRadius)
          : null
        ),
        child: isLoading 
        ? Center(
            child: SpinKitFadingCircle(
              color: loadingColor,
              size: 25.0
            ),
          )
        : Center(
            child: customText ? text : Text(btnTxt!,
            style: robotoRegular.copyWith(
              color: btnTextColor,
              fontWeight: FontWeight.w600,
              fontSize: fontSize
            ) 
          ),
        )
      ),
    );
  }
}
