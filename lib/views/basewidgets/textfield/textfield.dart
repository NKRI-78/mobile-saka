import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(this);
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPrefixIcon; 
  final Widget? prefixIcon;
  final String? labelText;
  final bool? alignLabelWithHint;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final TextInputType textInputType;
  final int maxLines;
  final FocusNode focusNode;
  final FocusNode? nextNode;
  final TextInputAction textInputAction;
  final Color counterColor;
  final bool isPhoneNumber;
  final bool isEmail;
  final bool isBorder;
  final bool isBorderRadius;
  final bool readOnly;
  final bool isEnabled;
  final int? maxLength;

  const CustomTextField({
    Key? key, 
    required this.controller,
    this.isPrefixIcon = false,
    this.prefixIcon,
    required this.hintText,
    this.alignLabelWithHint = false,
    this.labelText,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    required this.textInputType,
    this.counterColor = ColorResources.white,
    required this.focusNode,
    this.nextNode,
    required this.textInputAction,
    this.maxLines = 1,
    this.isEmail = false,
    this.isBorder = true,
    this.isBorderRadius = false,
    this.readOnly = false,
    this.isEnabled = true,
    this.maxLength,
    this.isPhoneNumber = false
  }) : super(key: key);


  @override
  Widget build(context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      focusNode: focusNode,
      keyboardType: textInputType,
      maxLength: maxLength,
      readOnly: readOnly,
      textCapitalization: TextCapitalization.sentences,
      toolbarOptions: const ToolbarOptions(
        selectAll: true,
        cut: true,
        paste: true,
        copy: true
      ),
      enabled: isEnabled,
      textInputAction: textInputAction,
      style: robotoRegular.copyWith(
        fontSize: Dimensions.fontSizeSmall,
      ), 
      onFieldSubmitted: (String v) => FocusScope.of(context).requestFocus(nextNode),
      inputFormatters: [
        isPhoneNumber 
        ? MaskTextInputFormatter(
            mask: "(+62) ### #### ####", 
            filter: { "#": RegExp(r'[0-9]') }
          )
        : FilteringTextInputFormatter.singleLineFormatter
      ],
      validator: (input) => isEmail 
      ? input!.isValidEmail() 
      ? null
      : getTranslated("EMAIL_IS_VALID", context) : null,
      decoration: InputDecoration(
        alignLabelWithHint: alignLabelWithHint,
        fillColor: isEnabled 
        ? ColorResources.white 
        : ColorResources.greyLightPrimary,
        filled: true,
        isDense: true,
        prefixIcon: isPrefixIcon 
        ? prefixIcon 
        : null,
        counterStyle: robotoRegular.copyWith(
          color: counterColor,
          fontSize: Dimensions.fontSizeExtraSmall
        ),
        floatingLabelBehavior: floatingLabelBehavior,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        hintText: hintText,
        hintStyle: robotoRegular.copyWith(
          color: ColorResources.grey, 
          fontSize: Dimensions.fontSizeSmall
        ),
        border: OutlineInputBorder(
          borderRadius: isBorderRadius 
          ? BorderRadius.circular(20.0) 
          : BorderRadius.circular(0.0),
          borderSide: BorderSide(
            color: isBorder ? ColorResources.gainsBoro : Colors.transparent          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: isBorderRadius ? BorderRadius.circular(20.0) : BorderRadius.circular(0.0),
          borderSide: BorderSide(
            color: isBorder ? ColorResources.gainsBoro : Colors.transparent          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: isBorderRadius ? BorderRadius.circular(20.0) : BorderRadius.circular(0.0),
          borderSide: BorderSide(
            color: isBorder ? ColorResources.gainsBoro : Colors.transparent          )
        )
      ),
    );
  }
}
