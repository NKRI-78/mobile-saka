import 'package:flutter/material.dart';

import 'package:saka/services/services.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class ShowSnackbar {
  ShowSnackbar._();

  static void snackbar(
    String content,
    String label,
    Color backgroundColor, {
    int durationSeconds = 3,
  }) {
    final messenger = ScaffoldMessenger.of(navigatorKey.currentContext!);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        duration: Duration(seconds: durationSeconds),
        content: Text(
          content,
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
        action: label.trim().isEmpty
            ? null
            : SnackBarAction(
                textColor: ColorResources.white,
                label: label,
                onPressed: () => messenger.hideCurrentSnackBar(),
              ),
      ),
    );
  }
}