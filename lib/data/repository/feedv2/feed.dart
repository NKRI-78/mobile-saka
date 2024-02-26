import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saka/data/models/feedv2/feed.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class FeedRepoV2 {
  final SharedPreferences sp;
  FeedRepoV2({ 
    required this.sp
  });

  Future<FeedModel?> fetchFeed(BuildContext context, int pageKey) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/all?app_name=saka&page=$pageKey&limit=10");
      Map<String, dynamic> data = res.data;   
      return compute(parseFetchFeed, data);
    } on DioError catch(e) {
      debugPrint("Fetch Groups Most Recent (${e.error.toString()})");
      NS.pop(context);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return null;
  }

  FeedModel parseFetchFeed(dynamic data) {
  FeedModel groupsModel = FeedModel.fromJson(data);
  return groupsModel;
}
}