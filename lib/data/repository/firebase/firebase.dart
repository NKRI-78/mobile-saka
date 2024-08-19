import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

class FirebaseRepo {
  final AuthRepo ar;
  final SharedPreferences sp;
  FirebaseRepo({
    required this.ar,
    required this.sp
  });
  
  Future<void> initFcm(BuildContext context, {
    required String lat, 
    required String lng
  }) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response res = await dio.post("${AppConstants.baseUrl}/data/user", data: 
        {
          "fcmSecret": await FirebaseMessaging.instance.getToken(),
          "latitude": lat,
          "longitude": lng
        }
      );
      debugPrint("Initialize FCM : ${res.statusCode}");
    } on DioError catch(e) {
      debugPrint("initFcm (${e.response!.data.toString()})");
    } catch(e, stacktrace) {
      debugPrint("initFcm (${e.toString()})");
      debugPrint(stacktrace.toString());
    }
  }
}