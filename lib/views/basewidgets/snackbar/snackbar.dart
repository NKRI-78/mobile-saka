import 'package:flutter/material.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

class ShowSnackbar {
  ShowSnackbar._();

  static snackbar(BuildContext context, String content, String label, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        content: Text(
          content, 
          style: robotoRegular.copyWith(
          color: ColorResources.white
        )),
        action: SnackBarAction(
          textColor: ColorResources.white,
          label: label,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()
        ),
      )
    );
  }
  
}