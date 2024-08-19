import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:saka/data/models/feedv2/feed.dart';
import 'package:saka/data/models/feedv2/feedDetail.dart';
import 'package:saka/data/models/feedv2/feedReply.dart';
import 'package:saka/data/models/feedv2/user_mention.dart';

import 'package:path/path.dart' as p;

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class FeedRepoV2 {
  final SharedPreferences sp;
  FeedRepoV2({ 
    required this.sp
  });

  Future<List<UserMention>?> userMentions(context, username) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response res = await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/user-mentions",
        data: {
          "app_name": "saka",
          "username": username
        }
      );
      Map<String, dynamic> data = res.data;
      UserMentionModel userMentionModel = UserMentionModel.fromJson(data);
      return userMentionModel.data;
    } catch(e) {
      debugPrint(e.toString());
    }

    return [];
  }

  Future<FeedModel?> fetchFeedMostRecent(BuildContext context, int pageKey, String userId) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/all?app_name=saka&type=MOST_RECENT&page=$pageKey&limit=10&user_id=$userId");
      Map<String, dynamic> data = res.data;   
      FeedModel fm = FeedModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }

    return null;
  
  }

  Future<FeedModel?> fetchFeedPopuler(BuildContext context, int pageKey, String userId) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/all?app_name=saka&type=POPULAR&page=$pageKey&limit=10&user_id=$userId");
      Map<String, dynamic> data = res.data;   
      FeedModel fm = FeedModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(EdgeInsets.only.toString());
    }

    return null;
  }

  Future<FeedModel?> fetchFeedSelf(BuildContext context, int pageKey, String userId) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/all?app_name=saka&type=SELF&page=$pageKey&limit=10&user_id=$userId");
      Map<String, dynamic> data = res.data;   
      FeedModel fm = FeedModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }

    return null;
  }

  Future<FeedDetailModel?> fetchDetail(BuildContext context, int pageKey, String forumId) async {
    try{ 
      Dio dio = DioManager.shared.getClient();
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/detail?id=$forumId&page=$pageKey&limit=100&app_name=saka");
      Map<String, dynamic> data = res.data;
      FeedDetailModel fm = FeedDetailModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }

    return null;
  }

  Future<FeedDetailModel?> fetchReply(BuildContext context, int pageKey, String forumId) async {
    try{ 
      Dio dio = DioManager.shared.getClient();
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/detail-reply?id=$forumId&page=$pageKey&limit=10&app_name=saka");
      Map<String, dynamic> data = res.data;
      FeedDetailModel fm = FeedDetailModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }

    return null;
  }

  Future<Map<String, dynamic>?> uploadMedia({
    required String folder, 
    required File media
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "folder": folder,
        "file": await MultipartFile.fromFile(media.path, filename: p.basename(media.path)),
      });
      Dio dio = DioManager.shared.getClient();
      Response res = await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/upload", data: formData);
      Map<String, dynamic> data = res.data;
      return data;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
    
    return {};
  }

  Future<void> postMedia({
    required String forumId,
    required String path,
    required String size
  }) async {
    try {
      Object data = {
        "forum_id": forumId, 
        "path": path, 
        "size": size
      };
      Dio dio = DioManager.shared.getClient();
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/upload-media",
        data: data
      );
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> post({
    required String forumId,
    required String appName,
    required String userId,
    required String feedType,
    required String media,
    required String link,
    required String caption,
  }) async {
    try {
      Object data = {
        "id": forumId,
        "app_name": appName,
        "user_id": userId,
        "forum_type": feedType,
        "media": media,
        "link": link,
        "caption": caption
      };
      Dio dio = DioManager.shared.getClient();
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/create", data: data);
    } on DioError catch (e) {
      debugPrint(e.response!.data.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deletePost(BuildContext context, String forumId) async {
    try {
      Object data = {
        "id": forumId
      };
      Dio dio = DioManager.shared.getClient();
      await dio.delete("${AppConstants.baseUrlFeedV2}/forums/v1/delete-forum", data: data);
   } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteComment(BuildContext context, String commentId) async {
    try {
      Object data = {
        "id": commentId
      };
      Dio dio = DioManager.shared.getClient();
      await dio.delete("${AppConstants.baseUrlFeedV2}/forums/v1/delete-comment", data: data);
   } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteReply(BuildContext context, String id) async {
    try {
      Object data = {
        "id": id
      };
      Dio dio = DioManager.shared.getClient();
      await dio.delete("${AppConstants.baseUrlFeedV2}/forums/v1/delete-reply", data: data);
   } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> postComment({
    required BuildContext context,
    required String commentId,
    required String forumId,
    required String userId,
    required String comment,
  }) async {
    try {
      Object data = {
        "comment_id": commentId,
        "forum_id": forumId,
        "user_id": userId,
        "comment": comment,
        "app_name": "saka",
      };
      Dio dio = DioManager.shared.getClient();
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/create-comment", data: data);
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> postReply({
    required BuildContext context,
    required String replyIdStore,
    required String replyId,
    required String commentId,
    required String userId,
    required String reply,
  }) async {
    try {
      Object data = {
        "reply_id_store": replyIdStore,
        "reply_id": replyId,
        "comment_id": commentId,
        "user_id": userId,
        "reply": reply,
        "app_name": "saka",
      };
      Dio dio = DioManager.shared.getClient();
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/create-reply", data: data);
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<FeedReplyModel?> getReply({
    required BuildContext context,
    required int pageKey, 
    required String commentId
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response res = await dio.get("${AppConstants.baseUrlFeedV2}/forums/v1/detail-reply?id=$commentId&page=$pageKey&limit=50&app_name=saka");
      Map<String, dynamic> data = res.data;
      FeedReplyModel fm = FeedReplyModel.fromJson(data);
      return fm;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
    
    return null;
  }

  Future<void> toggleLike({
    required BuildContext context,
    required String forumId,
    required String userId
  }) async {
    try {
      Object data = {
        "forum_id": forumId, 
        "user_id": userId,
        "app_name": "saka",
      };
      Dio dio = DioManager.shared.getClient();
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/like", data: data);
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }
  
  Future<void> toggleLikeComment({
    required BuildContext context,
    required String forumId,
    required String commentId,
    required String userId
  }) async {
    try {
      Object data = {
        "forum_id": forumId, 
        "comment_id": commentId, 
        "user_id": userId,
        "app_name": "saka",
      };
      Dio dio = DioManager.shared.getClient();
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/comment-like", data: data);
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> toggleLikeReplyComment({
    required String replyId,
    required String userId
  }) async {
    try {
      Object data = {
        "reply_id": replyId,
        "user_id": userId,
        "app_name": "saka"
      };
      Dio dio = DioManager.shared.getClient();
      await dio.post("${AppConstants.baseUrlFeedV2}/forums/v1/comment-reply-like",
        data: data
      );
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }
  
}
