import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

class PermissionHelper {
  static Future<void> check(BuildContext context, {
    required Permission permissionType,
    required String permissionName
  }) async {
    if (await permissionType.status.isDenied) {
      permissionType.request();
      return;
    } else if (await permissionType.status.isPermanentlyDenied) {
      if (context.mounted) {
        ShowSnackbar.snackbar("URL no found", "", ColorResources.error);
      }
      return;
    }
    permissionType.request();
  }
}
