import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

import 'package:saka/data/models/banner/banner.dart';

class BannerRepo {
  final SharedPreferences sp;
  BannerRepo({
    required this.sp
  });

  List<BannerData> bannerData = [];
 
  Future<List<BannerData>> getBanner(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrl}/content-service/banner");
      Map<String, dynamic> data = json.decode(res.data);
      return compute(parseBanner, data);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return [];
  }
}

List<BannerData> parseBanner(dynamic data) {
  BannerModel bannerModel = BannerModel.fromJson(data); 
  return bannerModel.data!;
}