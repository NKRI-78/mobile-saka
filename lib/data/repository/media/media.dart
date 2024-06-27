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
      Dio dio = await DioManager.shared.getClient(context);
      FormData formData = FormData.fromMap({
        "folder": "images",
        "subfolder": "saka",
        "media": await MultipartFile.fromFile(file.path, filename: basename(file.path)),

      });
      Response res = await dio.post("${AppConstants.baseUrl}/media-service/upload", data: formData);
      debugPrint(res.data.toString());
      
      response = res;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return response!;
  }
  
}
