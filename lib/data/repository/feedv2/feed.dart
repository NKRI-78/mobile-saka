import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saka/data/models/feedv2/feed.dart';
import 'package:saka/data/models/feedv2/feedDetail.dart';
import 'package:saka/services/navigation.dart';
import 'package:path/path.dart' as p;
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';
import 'package:saka/utils/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class FeedRepoV2 {
  final SharedPreferences sp;
  FeedRepoV2({ 
    required this.sp
  });

  Future<FeedModel?> fetchFeedMostRecent(BuildContext context, int pageKey, String userId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/all?app_name=saka&type=MOST_RECENT&page=$pageKey&limit=10&user_id=$userId");
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
  Future<FeedModel?> fetchFeedPopuler(BuildContext context, int pageKey, String userId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/all?app_name=saka&type=POPULAR&page=$pageKey&limit=10&user_id=$userId");
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
  Future<FeedModel?> fetchFeedSelf(BuildContext context, int pageKey, String userId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/all?app_name=saka&type=SELF&page=$pageKey&limit=10&user_id=$userId");
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

  Future<FeedDetailModel?> fetchDetail(BuildContext context, String postId) async {
    try{ 
      debugPrint("Detail id Post" + postId);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/detail?id=$postId&page=1&limit=10&app_name=saka");
      Map<String, dynamic> data = res.data
      ;
      FeedDetailModel fm = FeedDetailModel.fromJson(data);
      debugPrint("Detail id Post" + fm.data.forum.caption!);
      return fm;
    } on DioError catch(e) {
      debugPrint("Fetch Feed Detail (${e.error.toString()})");
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>> testMedia(
      {required BuildContext context,required String folder, required File media}) async {
    try {
      FormData formData = FormData.fromMap({
        "folder": folder,
        "media": await MultipartFile.fromFile(media.path,
            filename: p.basename(media.path)),
      });
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/upload", data: formData);
      Map<String, dynamic> data = res.data;
      return data;
    } on DioError catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }  catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }
  }

  Future<Response?> sendPostText(BuildContext context, String text) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlFeed}/post/write", 
        data: {
          "groupId": "",
          "visibilityType": "PUBLIC",
          "type": "TEXT",
          "content": {
            "charset": "UTF_8",
            "text": text
          }
        }
      );
      return res;
    } on DioError catch(_) {  
      
    }
    catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }
}