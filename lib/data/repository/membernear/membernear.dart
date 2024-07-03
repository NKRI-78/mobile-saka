import 'dart:convert';

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
      debugPrint(sp.getString('lat'));
      debugPrint(sp.getString('lng'));
      Response res = await dio.get("https://api-saka.inovatiftujuh8.com/data/nearme?lat=${sp.getString("lat")}&lng=${sp.getString("lng")}");
      Map<String, dynamic> data = json.decode(res.data);
      debugPrint(data.toString());
      MembernearModel membernearModel = MembernearModel.fromJson(data);
      return membernearModel.body;
    } on DioError catch(e) {
      if(e.response!.statusCode == 400) {
        debugPrint(e.response!.data.toString());
      } else {
        debugPrint("Membernear (${e.response!.statusCode})");
      }
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return [];
  }
}
