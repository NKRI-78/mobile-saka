import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/data/models/nearme/nearme.dart';

import 'package:saka/utils/dio.dart';

class MembernearRepo {
  final SharedPreferences sp;
  MembernearRepo({
    required this.sp
  });

  Future<List<MembernearData>> membernear(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("https://api-custom.inovatif78.com/api/v1/saka/membernear",
        data: {
          "origin_lat": sp.getString("lat"),
          "origin_lng": sp.getString("lng"),
          "user_id": sp.getString("userId")
        }
      );
      Map<String, dynamic> data = res.data;
      MembernearModel membernearModel = MembernearModel.fromJson(data);
      return membernearModel.data;
    } on DioError catch(e) {
      if(e.response!.statusCode == 400) {
        debugPrint(e.response!.data.toString());
        debugPrint("Membernear (400)");
      } else {
        debugPrint("Membernear (${e.response!.statusCode})");
      }
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return [];
  }
}
