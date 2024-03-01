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

  Future<Map<String, dynamic>> uploadMedia(
      {required BuildContext context,required String folder, required File media}) async {
    try {
      FormData formData = FormData.fromMap({
        "folder": folder,
        "file": await MultipartFile.fromFile(media.path,
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

  Future<void> postMedia(
      {
      required BuildContext context,
      required String feedId,
      required String path,
      required String size}) async {
    try {
      debugPrint("Forum id : $feedId");
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/upload-media",
      data: {"forum_id": feedId, "path": path, "size": size});
    } on DioError catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }  catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> post({
    required BuildContext context,
    required String feedId,
    required String appName,
    required String userId,
    required String feedType,
    required String media,
    required String caption,
  }) async {
    try {
      Object data = {
        "id": feedId,
        "app_name": appName,
        "user_id": userId,
        "forum_type": feedType,
        "media": media,
        "caption": caption
      };
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/create", data: data);
    } on DioError catch (e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> deletePost(BuildContext context, String postId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.delete("${AppConstants.baseUrlFeedV2}/forums/v1/delete-forum", data: {"id": postId});
   } on DioError catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> postComment(
      {
      required BuildContext context,
      required String feedId,
      required String userId,
      required String comment,
      }) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("/api/v1/feed/reply", data: {
        "forum_id": feedId,
        "user_id": userId,
        "comment": comment
      });
    } on DioError catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }
  
}