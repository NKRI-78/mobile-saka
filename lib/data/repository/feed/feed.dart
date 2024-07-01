import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

import 'package:saka/data/models/feed/comment.dart';
import 'package:saka/data/models/feed/groups.dart';
import 'package:saka/data/models/feed/notification.dart';
import 'package:saka/data/models/feed/reply.dart';
import 'package:saka/data/models/feed/singlecomment.dart';
import 'package:saka/data/models/feed/singlereply.dart';
import 'package:saka/data/models/feed/sticker.dart';
import 'package:saka/data/models/feed/post.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

class FeedRepo {
  final SharedPreferences sp;
  FeedRepo({ required this.sp });

  Future<void> deletePost(BuildContext context, String postId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.delete("${AppConstants.baseUrlFeed}/post/delete/$postId");
   } on DioError catch(_) {
      
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<PostModel?> fetchPost(BuildContext context, String postId) async {
    try{ 
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeed}/post/fetch/$postId");
      Map<String, dynamic> data = res.data;
      return compute(parseFetchPost, data);
    } on DioError catch(_) {
      
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }  

  Future<Sticker?> fetchListSticker(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeed}/sticker/list");
      Map<String, dynamic> data = res.data;
      return compute(parseFetchListSticker, data);
    } on DioError catch(_) {
   
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<SingleReply?> fetchReply(BuildContext context, String postId) async {
    try { 
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeed}/reply/fetch/$postId");
      Map<String, dynamic> data = res.data;
      return compute(parseFetchReply, data);
    } on DioError catch(_) {
     
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<SingleComment?> fetchComment(BuildContext context, String targetId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeed}/comment/fetch/$targetId");
      Map<String, dynamic> data = res.data;
      return compute(parseFetchComment, data);
    } on DioError catch(_) {
     
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }  

  Future<Reply?> fetchAllReply(BuildContext context, String targetId, [String nextCursor = ""]) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeed}/reply/list?targetId=$targetId&cursorId=$nextCursor");
      Map<String, dynamic> data = res.data;
      return compute(parseFetchAllReply, data);
    } on DioError catch(_) {
     
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<FeedNotification?> fetchAllNotification(BuildContext context, [String cursorId = ""]) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeed}/notification/list?cursorId=$cursorId");
      Map<String, dynamic> data = res.data;
      return compute(parseFetchAllNotification, data);
    } on DioError catch(_) {
    
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }
    
  Future<Comment?> fetchListCommentMostRecent(BuildContext context, String targetId, [String nextCursor = ""]) async {
    try { 
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeed}/comment/list?targetType=POST&type=MOST_RECENT&targetId=$targetId&cursorId=$nextCursor");
      Map<String, dynamic> data = res.data;   
      return compute(parseFetchListCommentMostRecent, data);      
    } on DioError catch(_) {
      
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GroupsModel?> fetchGroupsMostRecent(BuildContext context, [String nextCursor = ""]) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeed}/post/list?type=MOST_RECENT&cursorId=$nextCursor");
      Map<String, dynamic> data = res.data;   
      return compute(parseFetchGroupsMostRecent, data);
    } on DioError catch(_) {
   
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GroupsModel?> fetchGroupsMostPopular(BuildContext context, [String nextCursor = ""]) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeed}/post/list?type=MOST_POPULAR&cursorId=$nextCursor");
      Map<String, dynamic> data = res.data;   
      return compute(parseFetchGroupsMostRecent, data);
    } on DioError catch(_) {
      
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GroupsModel?> fetchGroupsSelf(BuildContext context, [String nextCursor = ""]) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlFeed}/post/list?type=SELF&cursorId=$nextCursor");
      Map<String, dynamic> data = res.data;   
      return compute(parseFetchGroupsMostRecent, data);
    } on DioError catch(_) {
   
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Response?> uploadMedia(BuildContext context, File file) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      // Response res = await dio.post("${AppConstants.baseUrlFeedMedia}/$mediaKey/$base64?path=/community/${AppConstants.xContextId}/${basename(file.path.trim().replaceAll(' ',''))}", 
      //   data: file.readAsBytesSync()
      // );
      FormData formData = FormData.fromMap({
        "folder": "videos",
        "subfolder": "saka",
        "media": await MultipartFile.fromFile(file.path, filename: basename(file.path)),
      });
      Response res = await dio.post("${AppConstants.baseUrl}/media-service/upload", data: formData);
      return res;
    } on DioError catch(_) {
    
    }  catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Response?> like(BuildContext context, String targetId, String targetType, String type) async {
    try { 
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlFeed}/like/toggle", 
        data: {
          "targetType": targetType,
          "targetId": targetId,
          "type": type
        }
      );
      return res;
    } on DioError catch(_) {
      
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
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

  Future<Response?> sendPostLink(BuildContext context, String caption, String text) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlFeed}/post/write", 
        data: {
         "groupId": "",
          "visibilityType": "PUBLIC",
          "type": "LINK",
          "content": {
            "charset": "UTF_8",
            "caption": caption,
            "url": text
          }
        }
      );
      return res;
    } on DioError catch(_) {  
     
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Response?> sendPostDoc(BuildContext context, String caption, FilePickerResult files) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlFeed}/post/write", 
        data: {
          "groupId": "",
          "visibilityType": "PUBLIC",
          "type": "DOCUMENT",
          "content" : {
            "caption" : caption,
            "medias": [
              {
                "originalName": basename(files.files[0].path!.trim().replaceAll(' ','')),
                "fileLength": files.files[0].size,
                "path": "/community/${AppConstants.xContextId}/${basename(files.files[0].path!.trim().replaceAll(' ',''))}",
                "contentType": lookupMimeType(basename(files.files[0].path!))
              }
            ]
          }
        }
      );
      return res;
    } on DioError catch(_) {  
     
    }  catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Response?> sendPostImage(BuildContext context, String caption, List<File> files) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Map<String, Object> postsData = {};
      List<Map<String, Object>> postsMedia = [];
      if(files.length > 1) {
        for (int i = 0; i < files.length; i++) {
          postsMedia.add(
            {
              "originalName": basename(files[i].path),
              "fileLength": files[i].lengthSync(),
              "path": "/community/${AppConstants.xContextId}/${basename(files[i].path)}",
              "contentType": lookupMimeType(basename(files[i].path))!
            }
          );
        }
        postsData = {
          "groupId": "",
          "visibilityType": "PUBLIC",
          "type": "IMAGE",
          "content" : {
            "caption" : caption,
            "medias": postsMedia,
          }
        };
      } else {
        postsData = {
          "groupId": "",
          "visibilityType": "PUBLIC",
          "type": "IMAGE",
          "content" : {
            "caption" : caption,
            "medias": [
              {
                "originalName": basename(files[0].path),
                "fileLength": files[0].lengthSync(),
                "path": "/community/${AppConstants.xContextId}/${basename(files[0].path)}",
                "contentType": lookupMimeType(basename(files[0].path))
              }
            ]
          }
        };
      }
      Response res = await dio.post("${AppConstants.baseUrlFeed}/post/write", 
        data: postsData
      );
      return res;
    } on DioError catch(_) {  
     
    } catch(e) {
      debugPrint(e.toString());
    }  
    return null;
  }

  Future<Response?> sendPostImageCamera(BuildContext context, String caption, File file) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Map<String, Object> postsData = {}; 
      postsData = {
        "groupId": "",
        "visibilityType": "PUBLIC",
        "type": "IMAGE",
        "content" : {
          "caption" : caption,
          "medias": [
            {
              "originalName": basename(file.path),
              "fileLength": file.lengthSync(),
              "path": "/community/${AppConstants.xContextId}/${basename(file.path)}",
              "contentType": lookupMimeType(basename(file.path))
            }
          ]
        }
      };
      Response res = await dio.post("${AppConstants.baseUrlFeed}/post/write", 
        data: postsData
      );
      return res;
    } on DioError catch(_) {  
      
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Response?> sendPostVideo(BuildContext context, String caption, File file) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Map<String, Object> postsData = {
        "groupId": "",
        "visibilityType": "PUBLIC",
        "type": "VIDEO",
        "content" : {
          "caption" : caption,
          "medias": [
            {
              "originalName": basename(file.path.trim().replaceAll(' ','')),
              "fileLength": file.lengthSync(),
              "path": "/community/${AppConstants.xContextId}/${basename(file.path.trim().replaceAll(' ',''))}",
              "contentType": lookupMimeType(basename(file.path))
            }
          ]
        }
      };
      Response res = await dio.post("${AppConstants.baseUrlFeed}/post/write", 
        data: postsData
      );
      return res;
    } on DioError catch(_) {
    
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Response?> sendReply(BuildContext context, String text, String targetId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Map<String, Object> postsData = {
        "targetId": targetId,
        "type": "TEXT",
        "content" : {
          "text" : text
        }
      };
      Response res = await dio.post("${AppConstants.baseUrlFeed}/reply/write",
        data: postsData
      );
      return res;
    } on DioError catch(_) {  
      
    } catch(e) {
      debugPrint(e.toString());
    }
    return null;
  } 

  Future<void> sendComment(BuildContext context, String content, String targetId, [String type = "TEXT"]) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Map<String, Object> data = {};
      if(type == "TEXT") {
        data = {
          "targetType": "POST",
          "targetId": targetId,
          "visibilityType" : "FRIENDS",
          "type": type,
          "content" : {
            "text" : content
          }
        };
      }
      if(type == "STICKER") {
        data = {
          "targetType": "POST",
          "targetId": targetId,
          "visibilityType" : "FRIENDS",
          "type" : type,
          "content": {
            "url": content
          }
        };
      }
      await dio.post("${AppConstants.baseUrlFeed}/comment/write",
        data: data
      ); 
    } on DioError catch(_) {  
      
    } catch(e) {
      debugPrint(e.toString());
    }
  }

}

GroupsModel parseFetchGroupsMostRecent(dynamic data) {
  GroupsModel groupsModel = GroupsModel.fromJson(data);
  return groupsModel;
}

Comment parseFetchListCommentMostRecent(dynamic data) {
  Comment comment = Comment.fromJson(data);
  return comment; 
}

FeedNotification parseFetchAllNotification(dynamic data) {
  FeedNotification notification = FeedNotification.fromJson(data);
  return notification;
}

Reply parseFetchAllReply(dynamic data) {
  Reply reply = Reply.fromJson(data);
  return reply;
}

SingleComment parseFetchComment(dynamic data) {
  SingleComment singleComment = SingleComment.fromJson(data);
  return singleComment;
}

SingleReply parseFetchReply(dynamic data) {
  SingleReply singleReply = SingleReply.fromJson(data);
  return singleReply;
}

Sticker parseFetchListSticker(dynamic data) {
  Sticker sticker = Sticker.fromJson(data);
  return sticker;
}

PostModel parseFetchPost(dynamic data) {
  PostModel postModel = PostModel.fromJson(data);
  return postModel;
} 