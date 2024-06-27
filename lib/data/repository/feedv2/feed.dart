import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:saka/data/models/feedv2/feed.dart';
import 'package:saka/data/models/feedv2/feedDetail.dart';
import 'package:saka/data/models/feedv2/feedReply.dart';

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

  Future<FeedDetailModel?> fetchDetail(BuildContext context, int pageKey, String postId) async {
    try{ 
      debugPrint("Page Key : $pageKey");
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/detail?id=$postId&page=$pageKey&limit=10&app_name=saka");
      debugPrint("${AppConstants.baseUrlFeedV2}/forums/v1/detail?id=$postId&page=$pageKey&limit=10&app_name=saka");
      Map<String, dynamic> data = res.data;
      FeedDetailModel fm = FeedDetailModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint("Fetch Feed (${e.error.toString()})");
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return null;
  }

  Future<FeedDetailModel?> fetchReply(BuildContext context, int pageKey, String postId) async {
    try{ 
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/detail-reply?id=$postId&page=$pageKey&limit=10&app_name=saka");
      Map<String, dynamic> data = res.data
      ;
      FeedDetailModel fm = FeedDetailModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint("Fetch Feed (${e.error.toString()})");
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
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
    required String link,
    required String caption,
  }) async {
    try {
      Object data = {
        "id": feedId,
        "app_name": appName,
        "user_id": userId,
        "forum_type": feedType,
        "media": media,
        "link": link,
        "caption": caption
      };
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/create", data: data);
    } on DioError catch (e) {
      debugPrint(e.response!.data.toString());
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
  Future<void> deleteComment(BuildContext context, String id) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.delete("${AppConstants.baseUrlFeedV2}/forums/v1/delete-comment", data: {"id": id});
   } on DioError catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }
  Future<void> deleteReply(BuildContext context, String id) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.delete("${AppConstants.baseUrlFeedV2}/forums/v1/delete-reply", data: {"id": id});
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
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/create-comment", data: {
        "forum_id": feedId,
        "user_id": userId,
        "comment": comment,
        "app_name": "saka",
      });
    } on DioError catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> postReply(
      {
      required BuildContext context,
      required String feedId,
      required String commentId,
      required String userId,
      required String reply,
      }) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/create-reply", data: {
        "forum_id": feedId,
        "comment_id": commentId,
        "user_id": userId,
        "reply": reply,
        "app_name": "saka",
      });
    } on DioError catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<FeedReplyModel> getReply(
    {
    required BuildContext context,
    required int pageKey, 
    required String commentId
    }) async {
      debugPrint("Id Comment : $commentId");
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/detail-reply?id=$commentId&page=$pageKey&limit=10&app_name=saka");
      Map<String, dynamic> data = res.data;
      FeedReplyModel fm = FeedReplyModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    } catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> toggleLike(
    {
    required BuildContext context,
    required String feedId,
    required String userId
    }) async {
    try {
      Object data = {
        "forum_id": feedId, 
        "user_id": userId,
        "app_name": "saka",
      };

      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/like", data: data);
    } on DioError catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    } catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }
  }
  Future<void> toggleLikeComment(
    {
    required BuildContext context,
    required String feedId,
    required String commentId,
    required String userId
    }) async {
    try {
      Object data = {
        "forum_id": feedId, 
        "comment_id": commentId, 
        "user_id": userId,
        "app_name": "saka",
      };

      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/comment-like", data: data);
    } on DioError catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    } catch(e) {
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }
  }
  
}