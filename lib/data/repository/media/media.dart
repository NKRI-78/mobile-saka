import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:saka/utils/constant.dart';

import 'package:saka/utils/dio.dart';

class MediaRepo {
  Response? response;

  Future<Response> postMedia(BuildContext context, File file) async {
    try {
      Dio dio = DioManager.shared.getClient();
      FormData formData = FormData.fromMap({
        "folder": "images",
        "subfolder": "fasi",
        "media": await MultipartFile.fromFile(
          file.path,
          filename: basename(file.path),
        ),
      });
      Response res = await dio.post(AppConstants.baseUrlMedia, data: formData);
      debugPrint(res.statusCode.toString());
      debugPrint(res.statusMessage);
      response = res;
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return response!;
  }
}
