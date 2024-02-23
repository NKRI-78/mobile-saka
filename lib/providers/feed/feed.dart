import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

import 'package:saka/data/models/feed/feedlike.dart';
import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/models/feed/all.member.dart';
import 'package:saka/data/models/feed/comment.dart';
import 'package:saka/data/models/feed/groups.dart';
import 'package:saka/data/models/feed/groupsmember.dart';
import 'package:saka/data/models/feed/groupsmetadata.dart';
import 'package:saka/data/models/feed/notification.dart';
import 'package:saka/data/models/feed/post.dart';
import 'package:saka/data/models/feed/reply.dart';
import 'package:saka/data/models/feed/singlecomment.dart';
import 'package:saka/data/models/feed/singlegroup.dart';
import 'package:saka/data/models/feed/singlereply.dart';
import 'package:saka/data/models/feed/sticker.dart';
import 'package:saka/data/repository/feed/feed.dart';

enum AllMemberStatus { idle, loading, loaded, empty }
enum NotificationStatus { idle, loading, loaded, empty }
enum PostStatus { idle, loading, loaded, empty }
enum WritePostStatus { idle, loading, loaded, empty }

enum CommentMostRecentStatus { idle, loading, loaded, error, empty }
enum CommentMostPopularStatus { idle, loading, loaded, error, empty }
enum CommentSelfStatus { idle, loading, loaded, error, empty }

enum SingleReplyStatus { idle, loading, loaded, error, empty } 
enum SingleCommentStatus { idle, loading, loaded, error, empty }
enum SingleGroupStatus { idle, loading, loaded, error, empty }
enum ReplyStatus { idle, loading, loaded, error, empty }  

enum StickerStatus { idle, loading, loaded, empty } 

enum GroupsMostRecentStatus { idle, loading, loaded, error, empty }
enum GroupsMostPopularStatus { idle, loading, loaded, error, empty }
enum GroupsSelfStatus { idle, loading, loaded, error, empty }

enum GroupsMostRecentStatusC { idle, loading, loaded, empty }
enum GroupsMostPopularStatusC { idle, loading, loaded, empty }
enum GroupsSelfStatusC { idle, loading, loaded, empty }

enum GroupsMemberStatus { idle, loading, loaded, empty }
enum GroupsMetaDataStatus { idle, loading, loaded, empty }

class FeedProvider with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepo fr;
  FeedProvider({
    required this.ar,
    required this.fr
  });

  VideoPlayerController? videoPlayerController;

  WritePostStatus _writePostStatus = WritePostStatus.idle;
  WritePostStatus get writePostStatus => _writePostStatus;

  AllMemberStatus _allMemberStatus = AllMemberStatus.loading;
  AllMemberStatus get allMemberStatus => _allMemberStatus;

  NotificationStatus _notificationStatus = NotificationStatus.loading;
  NotificationStatus get notificationStatus => _notificationStatus;

  PostStatus _postStatus = PostStatus.loading;
  PostStatus get postStatus => _postStatus;

  CommentMostRecentStatus _commentMostRecentStatus = CommentMostRecentStatus.loading;
  CommentMostRecentStatus get commentMostRecentStatus => _commentMostRecentStatus;

  StickerStatus _stickerStatus = StickerStatus.loading;
  StickerStatus get stickerStatus => _stickerStatus;

  SingleCommentStatus _singleCommentStatus = SingleCommentStatus.loading;
  SingleCommentStatus get singleCommentStatus => _singleCommentStatus;

  SingleGroupStatus _singleGroupStatus = SingleGroupStatus.loading;
  SingleGroupStatus get singleGroupStatus => _singleGroupStatus;

  ReplyStatus _replyStatus = ReplyStatus.loading;
  ReplyStatus get replyStatus => _replyStatus;

  GroupsMostRecentStatus _groupsMostRecentStatus = GroupsMostRecentStatus.loading;
  GroupsMostRecentStatus get groupsMostRecentStatus => _groupsMostRecentStatus;

  GroupsMostPopularStatus _groupsMostPopularStatus = GroupsMostPopularStatus.loading;
  GroupsMostPopularStatus get groupsMostPopularStatus => _groupsMostPopularStatus;

  GroupsSelfStatus _groupsSelfStatus = GroupsSelfStatus.loading;
  GroupsSelfStatus get groupsSelfStatus => _groupsSelfStatus;

  GroupsMostRecentStatusC _groupsMostRecentStatusC = GroupsMostRecentStatusC.loading;
  GroupsMostRecentStatusC get groupsMostRecentStatusC => _groupsMostRecentStatusC;

  GroupsMostPopularStatusC _groupsMostPopularStatusC = GroupsMostPopularStatusC.loading;
  GroupsMostPopularStatusC get groupsMostPopularStatusC => _groupsMostPopularStatusC;

  GroupsSelfStatusC _groupsSelfStatusC = GroupsSelfStatusC.loading;
  GroupsSelfStatusC get groupSelfStatusC => _groupsSelfStatusC;

  GroupsMemberStatus _groupsMemberStatus = GroupsMemberStatus.loading;
  GroupsMemberStatus get groupsMemberStatus => _groupsMemberStatus;

  GroupsMetaDataStatus _groupsMetaDataStatus = GroupsMetaDataStatus.loading;
  GroupsMetaDataStatus get groupsMetaDataStatus => _groupsMetaDataStatus;

  void setStateWritePost(WritePostStatus writePostStatus) {
    _writePostStatus = writePostStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateMemberStatus(AllMemberStatus allMemberStatus) {
    _allMemberStatus = allMemberStatus;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }
  
  void setStateNotificationStatus(NotificationStatus notificationStatus) {
    _notificationStatus = notificationStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePostStatus(PostStatus postStatus) {
    _postStatus = postStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCommentRecentStatus(CommentMostRecentStatus commentMostRecentStatus) {
    _commentMostRecentStatus = commentMostRecentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  } 

  void setStateStickerStatus(StickerStatus stickerStatus) {
    _stickerStatus = stickerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSingleCommentStatus(SingleCommentStatus singleCommentStatus) {
    _singleCommentStatus = singleCommentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSingleGroupStatus(SingleGroupStatus singleGroupStatus) {
    _singleGroupStatus = singleGroupStatus;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }

  void setStateReplyStatus(ReplyStatus replyStatus) {
    _replyStatus = replyStatus;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }

  void setStateGroupsMostRecentStatus(GroupsMostRecentStatus groupsMostRecentStatus) {
    _groupsMostRecentStatus = groupsMostRecentStatus;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }

  void setStateGroupsMostPopularStatus(GroupsMostPopularStatus groupsMostPopularStatus) {
    _groupsMostPopularStatus = groupsMostPopularStatus;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }

  void setStateGroupsSelfStatus(GroupsSelfStatus groupsSelfStatus) {
    _groupsSelfStatus = groupsSelfStatus;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }

  void setStateGroupsMostRecentStatusC(GroupsMostRecentStatusC groupsMostRecentStatusC) {
    _groupsMostRecentStatusC = groupsMostRecentStatusC;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }

  void setStateGroupsMostPopularStatusC(GroupsMostPopularStatusC groupsMostPopularStatusC) {
    _groupsMostPopularStatusC = groupsMostPopularStatusC;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }

  void setStateGroupsSelfStatusC(GroupsSelfStatusC groupsSelfStatusC) {
    _groupsSelfStatusC = groupsSelfStatusC;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }

  void setStateGroupsMemberStatus(GroupsMemberStatus groupsMemberStatus) {
    _groupsMemberStatus = groupsMemberStatus;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }

  void setStateMetaDataStatus(GroupsMetaDataStatus groupsMetaDataStatus) {
    _groupsMetaDataStatus = groupsMetaDataStatus;
    Future.delayed(Duration.zero, ()=> notifyListeners());
  }

  AllMember? _allMember;
  AllMember get allMember => _allMember!;

  GroupsMember? _groupsMember;
  GroupsMember get groupsMember => _groupsMember!; 

  SingleGroup? _singleGroup;
  SingleGroup get singleGroup => _singleGroup!;

  PostModel? _post;
  PostModel get post => _post!;

  Reply? _reply;
  Reply get reply => _reply!;

  SingleComment? _singleComment;
  SingleComment get singleComment => _singleComment!;

  SingleReply? _singleReply;
  SingleReply get singleReply => _singleReply!;

  Comment? _c1;
  Comment get c1 => _c1!;

  Comment? _c2;
  Comment get c2 => _c2!;

  Comment? _c3;
  Comment get c3 => _c3!;

  CommentBody? _c2List;
  CommentBody get c2List => _c2List!;

  CommentBody? _c3List;
  CommentBody get c3List => _c3List!;

  Sticker? _sticker;
  Sticker get sticker => _sticker!;

  GroupsModel? _g1;
  GroupsModel get g1 => _g1!;

  GroupsModel? _g2;
  GroupsModel get g2 => _g2!; 

  GroupsModel? _g3;
  GroupsModel get g3 => _g3!;

  FeedNotification? _notification;
  FeedNotification get notification => _notification!;

  GroupsMetaData? _groupsMetaData;
  GroupsMetaData get groupsMetaData => _groupsMetaData!; 

  List<CommentBody> _c1List = [];
  List<CommentBody> get c1List => [..._c1List];

  List<ReplyBody> _replyList = [];
  List<ReplyBody> get replyList => [..._replyList]; 

  List<GroupsBody> _g1List = [];
  List<GroupsBody> get g1List => [..._g1List];

  List<GroupsBody> _g2List = [];
  List<GroupsBody> get g2List => [..._g2List];

  List<GroupsBody> _g3List = [];
  List<GroupsBody> get g3List => [..._g3List];
 
  List<NotificationBody> _notificationList = [];
  List<NotificationBody> get notificationList => [..._notificationList];

  Future<void> fetchListSticker(BuildContext context) async {
    try {
      Sticker? s = await fr.fetchListSticker(context);
      _sticker = s;
      setStateStickerStatus(StickerStatus.loaded);
    if(_sticker == null) {
      setStateStickerStatus(StickerStatus.empty);       
    }
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deletePost(BuildContext context, String postId) async {
    await fr.deletePost(context, postId);
    Future.delayed(Duration.zero, () {
      fetchGroupsMostRecent(context);
      fetchGroupsMostPopular(context);
      fetchGroupsSelf(context);
    });
  }

  Future<void> fetchPost(BuildContext context, String postId) async {
    setStatePostStatus(PostStatus.loading);
    PostModel? p = await fr.fetchPost(context, postId);
    _post = p;
    setStatePostStatus(PostStatus.loaded);
    if(_post == null) {
      setStatePostStatus(PostStatus.empty);
    }
  }

  Future<void> fetchReply(BuildContext context, String replyId) async {
    SingleReply? s = await fr.fetchReply(context, replyId);
    _singleReply = s;
    setStateReplyStatus(ReplyStatus.loaded);
    if(_singleReply == null) {
      setStateReplyStatus(ReplyStatus.empty);
    }
  }

  Future<void> fetchComment(BuildContext context, String targetId) async {
    SingleComment? s = await fr.fetchComment(context, targetId);
    _singleComment = s;
    setStateSingleCommentStatus(SingleCommentStatus.loaded);
    if(_singleComment == null) {
      setStateSingleCommentStatus(SingleCommentStatus.empty);
    }
  }

  Future<void> fetchAllNotification(BuildContext context) async {
    FeedNotification? n = await fr.fetchAllNotification(context);
    _notification = n!;
    setStateNotificationStatus(NotificationStatus.loaded);
    if(notification.body!.isNotEmpty) {
      _notificationList = [];
      _notificationList.addAll(n.body!);
    } else {
      setStateNotificationStatus(NotificationStatus.empty);
    }
  }

  Future<void> fetchAllNotificationLoad(BuildContext context, String nextCursor) async {
    FeedNotification? n = await fr.fetchAllNotification(context, nextCursor);
    _notification = n!;
    _notificationList.addAll(n.body!);
    setStateNotificationStatus(NotificationStatus.loaded);
  }

  Future<void> fetchAllReply(BuildContext context, String targetId)  async {
    Reply? r = await fr.fetchAllReply(context, targetId);
    _reply = r;
    setStateReplyStatus(ReplyStatus.loaded);
    if(r!.body!.isNotEmpty) {
      _replyList = [];
      _replyList.addAll(r.body!);
    } else {
      setStateReplyStatus(ReplyStatus.empty);
    }
  }

  Future<void> fetchAllReplyLoad(BuildContext context, String targetId, [String nextCursor = ""])  async {
    Reply? r = await fr.fetchAllReply(context, targetId, nextCursor);
    _reply = r;
    _replyList.addAll(r!.body!);
    setStateReplyStatus(ReplyStatus.loaded);
  }

  Future<void> fetchListCommentMostRecent(BuildContext context, String targetId) async {
    Comment? c = await fr.fetchListCommentMostRecent(context, targetId);
    _c1 = c;
    setStateCommentRecentStatus(CommentMostRecentStatus.loaded);
    if(c!.body!.isNotEmpty) {
      _c1List = [];
      _c1List.addAll(c1.body!.reversed);
    } else {
      setStateCommentRecentStatus(CommentMostRecentStatus.empty);
    }
  }

  Future<void> fetchListCommentMostRecentLoad(BuildContext context, String targetId, [String nextCursor = ""]) async {
    Comment? c = await fr.fetchListCommentMostRecent(context, targetId, nextCursor);
    _c1 = c;
    _c1List.addAll(c!.body!);
    setStateCommentRecentStatus(CommentMostRecentStatus.loaded);
  }

  Future<void> fetchGroupsMostRecent(BuildContext context) async {
    GroupsModel? g = await fr.fetchGroupsMostRecent(context);
    _g1 = g;
    if (g!.body!.isNotEmpty) {
      _g1List = [];
      _g1List.addAll(g.body!);     
      setStateGroupsMostRecentStatus(GroupsMostRecentStatus.loaded);
    } else {
      setStateGroupsMostRecentStatus(GroupsMostRecentStatus.empty);
    } 
  }

  Future<void> fetchGroupsMostPopular(BuildContext context) async {
    GroupsModel? g = await fr.fetchGroupsMostPopular(context);
    _g2 = g;
    if (g!.body!.isNotEmpty) {
      _g2List = [];
      _g2List.addAll(g.body!);     
      setStateGroupsMostPopularStatus(GroupsMostPopularStatus.loaded);
    } else {
      setStateGroupsMostPopularStatus(GroupsMostPopularStatus.empty);
    } 
  }

  Future<void> fetchGroupsSelf(BuildContext context) async {
    GroupsModel? g = await fr.fetchGroupsSelf(context);
    _g3 = g;
    if (g!.body!.isNotEmpty) {
      _g3List = [];
      _g3List.addAll(g.body!);     
      setStateGroupsSelfStatus(GroupsSelfStatus.loaded);
    } else {
      setStateGroupsSelfStatus(GroupsSelfStatus.empty);
    } 
  }

  Future<void> fetchGroupsMostRecentLoad(BuildContext context, [String cursorId = ""]) async {
    GroupsModel? g = await fr.fetchGroupsMostRecent(context, cursorId);
    _g1 = g;
    _g1List.addAll(g!.body!);     
    setStateGroupsMostRecentStatus(GroupsMostRecentStatus.loaded);
  }

  Future<void> fetchGroupsMostPopularLoad(BuildContext context, [String cursorId = ""]) async {
    GroupsModel? g = await fr.fetchGroupsMostPopular(context, cursorId);
    _g2 = g;
    _g2List.addAll(g!.body!);     
    setStateGroupsMostPopularStatus(GroupsMostPopularStatus.loaded);
  }

  Future<void> fetchGroupsSelfLoad(BuildContext context, [String cursorId = ""]) async {
    GroupsModel? g = await fr.fetchGroupsSelf(context, cursorId);
    _g3 = g;
    g3List.addAll(g!.body!);     
    setStateGroupsSelfStatus(GroupsSelfStatus.loaded);
  }

  Future<void> sendPostText(BuildContext context, String text) async {
    setStateWritePost(WritePostStatus.loading);
    await fr.sendPostText(context, text);
    setStateWritePost(WritePostStatus.loaded);
    Future.delayed(Duration.zero, () {
      fetchGroupsMostRecent(context);
      fetchGroupsMostPopular(context);
      fetchGroupsSelf(context);
    });
  }

  Future<void> sendComment(BuildContext context, String text, String postId, [String type = "TEXT"]) async {
    await fr.sendComment(context, text, postId, type);
    Future.delayed(Duration.zero, () {
      fetchListCommentMostRecent(context, postId);
    });
  }

  Future<void> sendReply(BuildContext context, String text, String targetId, String postId) async {
    await fr.sendReply(context, text, targetId);
    Future.delayed(Duration.zero, () {
      fetchListCommentMostRecent(context, postId);
    });
  }

  Future<void> sendPostLink(BuildContext context, String caption, String url) async {
    setStateWritePost(WritePostStatus.loading);
    await fr.sendPostLink(context, caption, url);
    setStateWritePost(WritePostStatus.loaded);
    Future.delayed(Duration.zero, () {
      fetchGroupsMostRecent(context);
      fetchGroupsMostPopular(context);
      fetchGroupsSelf(context);
    });
  }

  Future<void> sendPostImage(BuildContext context, String caption, List<File> files) async {
    await fr.sendPostImage(context, caption, files);
    Future.delayed(Duration.zero, () {
      fetchGroupsMostRecent(context);
      fetchGroupsMostPopular(context);
      fetchGroupsSelf(context);
    });
  }

  Future<void> sendPostImageCamera(BuildContext context, String caption, File file) async {
    setStateWritePost(WritePostStatus.loading);
    await fr.sendPostImageCamera(context, caption, file);
    setStateWritePost(WritePostStatus.loaded);
    Future.delayed(Duration.zero, () {
      fetchGroupsMostRecent(context);
      fetchGroupsMostPopular(context);
      fetchGroupsSelf(context);
    });
  }

  Future<void> sendPostDoc(BuildContext context, String caption, FilePickerResult files) async {
    await fr.sendPostDoc(context, caption, files);
    Future.delayed(Duration.zero, () {
      fetchGroupsMostRecent(context);
      fetchGroupsMostPopular(context);
      fetchGroupsSelf(context);
    });
  }

  Future<void> sendPostVideo(BuildContext context, String caption, File? file) async {
    await fr.sendPostVideo(context, caption, file!);
    Future.delayed(Duration.zero, () {
      fetchGroupsMostRecent(context);
      fetchGroupsMostPopular(context);
      fetchGroupsSelf(context);
    });
  }

  Future<void> like(BuildContext context, String targetId, String targetType, [String groupId = ""]) async {
    int iMostRecent = g1List.indexWhere((element) => element.id == targetId);
    int iMostPopular = g2List.indexWhere((element) => element.id == targetId);
    int iSelf = g3List.indexWhere((element) => element.id == targetId);
    int iCommentMostRecent = c1List.indexWhere((element) => element.id == targetId);
    int iReply = replyList.indexWhere((element) => element.id == targetId);
    Response? response = await fr.like(context, targetId, targetType, "THUMB_UP");
    Map<String, dynamic> decoded = response!.data;
    if(iMostRecent != -1) {
      _g1List[iMostRecent].numOfLikes = decoded["body"]["targetNumOfLikes"]; 
      if(decoded["body"]["type"] == "THUMB_UP") {
        _g1List[iMostRecent].liked!.add(
          FeedLiked(
            targetType: targetType,
            targetId: targetId,
            type: "THUMB_UP"
          )
        );
      } else {
        _g1List[iMostRecent].liked!.clear();
      }
      setStateGroupsMostRecentStatus(GroupsMostRecentStatus.loaded);
    }
    if(iMostPopular != -1) {
      _g2List[iMostPopular].numOfLikes = decoded["body"]["targetNumOfLikes"]; 
      if(decoded["body"]["type"] == "THUMB_UP") {
        _g2List[iMostPopular].liked!.add(
          FeedLiked(
            targetType: targetType,
            targetId: targetId,
            type: "THUMB_UP"
          )
        );
      } else {
        _g2List[iMostPopular].liked!.clear();
      }
      setStateGroupsMostPopularStatus(GroupsMostPopularStatus.loaded);
    }
    if(iSelf != -1) {
      _g3List[iSelf].numOfLikes = decoded["body"]["targetNumOfLikes"]; 
      if(decoded["body"]["type"] == "THUMB_UP") {
        _g3List[iSelf].liked!.add(
          FeedLiked(
            targetType: targetType,
            targetId: targetId,
            type: "THUMB_UP"
          )
        );
      } else {
        _g3List[iSelf].liked!.clear();
      }
      setStateGroupsSelfStatus(GroupsSelfStatus.loaded);
    }

    if(targetType == "POST") {
      if(_post?.body != null) {
        _post!.body!.numOfLikes = decoded["body"]["targetNumOfLikes"]; 
        if(decoded["body"]["type"] == "THUMB_UP") {
          _post!.body!.liked!.add(
            FeedLiked(
              targetType: targetType,
              targetId: targetId,
              type: "THUMB_UP"
            )
          );
        } else {
          _post!.body!.liked!.clear();
        }
        setStatePostStatus(PostStatus.loaded);
      }
    }

    if(targetType == "COMMENT") {
      if(_singleComment?.body != null) {
        _singleComment!.body!.numOfLikes = decoded["body"]["targetNumOfLikes"]; 
        if(decoded["body"]["type"] == "THUMB_UP") {
          _singleComment!.body!.liked!.add(
            FeedLiked(
              targetType: targetType,
              targetId: targetId,
              type: "THUMB_UP"
            )
          );
        } else {
          _singleComment!.body!.liked!.clear();
        }
        setStateSingleCommentStatus(SingleCommentStatus.loaded);
      }
    }

    if(targetType == "REPLY") {
      if(_singleReply?.body != null) {
        _singleReply!.body!.numOfLikes = decoded["body"]["targetNumOfLikes"]; 
        if(decoded["body"]["type"] == "THUMB_UP") {
          _singleReply!.body!.liked!.add(
            FeedLiked(
              targetType: targetType,
              targetId: targetId,
              type: "THUMB_UP"
            )
          );
        } else {
          _singleReply!.body!.liked!.clear();
        }
        setStateReplyStatus(ReplyStatus.loaded);
      }
    }
   
    if(iCommentMostRecent != -1) {
      _c1List[iCommentMostRecent].numOfLikes = decoded["body"]["targetNumOfLikes"]; 
      if(decoded["body"]["type"] == "THUMB_UP") {
        _c1List[iCommentMostRecent].liked!.add(
          FeedLiked(
            targetType: targetType,
            targetId: targetId,
            type: "THUMB_UP"
          )
        );
      } else {
        _c1List[iCommentMostRecent].liked!.clear();
      }
      setStateCommentRecentStatus(CommentMostRecentStatus.loaded);
    }

    if(iReply != -1) {
      _replyList[iReply].numOfLikes = decoded["body"]["targetNumOfLikes"]; 
      if(decoded["body"]["type"] == "THUMB_UP") {
        _replyList[iReply].liked!.add(
          FeedLiked(
            targetType: targetType,
            targetId: targetId,
            type: "THUMB_UP"
          )
        );
      } else {
        _replyList[iReply].liked!.clear();
      }
      setStateReplyStatus(ReplyStatus.loaded);
    }
  }

}
