import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

class MediaRepo {
  final SharedPreferences sp;
  MediaRepo({
    required this.sp
  });
  late Response response;
  
  Future<Response> postMedia(BuildContext context, File file) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: basename(file.path)),
      });
      Response res = await dio.post("${AppConstants.baseUrl}/media-service/upload", data: formData);
      response = res;
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return response;
  }
  
}
