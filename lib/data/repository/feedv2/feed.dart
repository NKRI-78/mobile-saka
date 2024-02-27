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

  Future<FeedModel?> fetchFeed(BuildContext context, int pageKey, String user_id) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/all?app_name=saka&type=MOST_RECENT&page=$pageKey&limit=10&user_id=$user_id");
      Map<String, dynamic> data = res.data;   
      FeedModel fm = FeedModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint("Fetch Feed (${e.error.toString()})");
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return null;
  }

  Future<FeedModel?> fetchDetail(BuildContext context, String postId) async {
    try{ 
      debugPrint("Detail id Post" + postId);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/detail?id=$postId&page=1&limit=10&app_name=saka");
      Map<String, dynamic> data = res.data;
      FeedModel fm = FeedModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint("Fetch Feed Detail (${e.error.toString()})");
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }
}