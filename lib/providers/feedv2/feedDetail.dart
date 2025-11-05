import 'package:flutter/material.dart';

import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:saka/localization/language_constraints.dart';
import 'package:saka/utils/date_util.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

import 'package:saka/data/models/feedv2/feedDetail.dart';
import 'package:saka/data/models/feedv2/user_mention.dart';

import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/feedv2/feed.dart';

import 'package:saka/providers/profile/profile.dart';

import 'package:saka/utils/exceptions.dart';

enum FeedDetailStatus { idle, loading, loaded, empty, error }
enum CommentStatus { idle, loading, loaded, empty, error }
enum UserMentionStatus { idle, loading, loaded, empty, error }

class FeedDetailProviderV2 with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepoV2 fr;

  FeedDetailProviderV2({
    required this.ar,
    required this.fr
  });

  DetectableTextEditingController controller = DetectableTextEditingController(
    regExp: atSignRegExp,
    detectedStyle: const TextStyle(
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.blue,
    ),
  );

  bool showListUserMention = false;

  FocusNode focusNode = FocusNode();

  String type = "COMMENT";
  String commentId = "";
  String replyId = "";

  String highlightedComment = "";
  String highlightedReply = "";

  Set<String> ids = {}; 

  bool hasMore = true;
  int pageKey = 1;

  List<Map<String, dynamic>> _userMentions = [];
  List<Map<String, dynamic>> get userMentions  => [..._userMentions];

  // List<CommentElement> _comments = [];
  // List<CommentElement> get comments => [..._comments];

  FeedDetailData _feedDetailData = FeedDetailData();
  FeedDetailData get feedDetailData => _feedDetailData;

  FeedDetailStatus _feedDetailStatus = FeedDetailStatus.loading;
  FeedDetailStatus get feedDetailStatus => _feedDetailStatus;

  CommentStatus _commentStatus = CommentStatus.idle;
  CommentStatus get commentStatus => _commentStatus; 

  UserMentionStatus _userMentionStatus = UserMentionStatus.loading;
  UserMentionStatus get userMentionStatus => _userMentionStatus;

  void clearInput() {
    type = "COMMENT";
    controller.clear();
    showListUserMention = false;

    notifyListeners();
  }

  void toggleShowListUserMention(bool newVal) {
    showListUserMention = newVal;

    notifyListeners();
  }

  void setStateFeedDetailStatus(FeedDetailStatus feedDetailStatus) {
    _feedDetailStatus = feedDetailStatus;

    notifyListeners();
  }

  void setStateCommentStatus(CommentStatus param) {
    _commentStatus = param;

    notifyListeners();
  }

  void setStateUserMentionStatus(UserMentionStatus userMentionStatus) {
    _userMentionStatus = userMentionStatus;

    notifyListeners();
  } 

  void onUpdateHighlightComment(String val) {
    highlightedComment = val;

    notifyListeners();
  }

  void onUpdateHighlightReply(String val) {
    highlightedReply = val;

    notifyListeners();
  }

  void onUpdateType(String val) {{
    type = val;

    notifyListeners();
  }}

  void onSelectedReply({
    required String valReply,
    required String valComment
  }) {
    replyId = valReply;
    commentId = valComment;

    notifyListeners();
  }

  Future<void> getFeedDetail(BuildContext context, String forumId) async {
    setStateFeedDetailStatus(FeedDetailStatus.loading);

    pageKey = 1;
    hasMore = true;

    try {
      FeedDetailModel? fdm = await fr.fetchDetail(context, pageKey, forumId);
      _feedDetailData = fdm!.data;

      setStateFeedDetailStatus(FeedDetailStatus.loaded);

    } on CustomException catch (e) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
    }
  }

  Future<void> getUserMentions(BuildContext context, String username) async {
    try {

      List<UserMention>? mentions = await fr.userMentions(context, username.replaceAll('@', ''));

      _userMentions = [];
      
      for (UserMention mention in mentions!) {

        // if(!ids.contains(mention.id)) {

          _userMentions.add({
            "id": mention.id.toString(),
            "photo": mention.photo.toString(),
            "display": mention.username.toString(),
            "fullname": mention.display.toString(),
          });
          
          // ids.add(mention.id);

        // }

      }

      showListUserMention = true;

      setStateUserMentionStatus(UserMentionStatus.loaded);

      if(userMentions.isEmpty) {
        showListUserMention = false;

        setStateUserMentionStatus(UserMentionStatus.empty);
      } 
    } on CustomException catch(e) {
      debugPrint(e.toString());
      setStateUserMentionStatus(UserMentionStatus.error);
    } catch(e) {
      debugPrint(e.toString());
      setStateUserMentionStatus(UserMentionStatus.error);
    } 
  }

  Future<void> loadMoreComment({required BuildContext context, required String postId}) async {
    pageKey++;

    FeedDetailModel? g = await fr.fetchDetail(context, pageKey, postId);

    hasMore = g!.data.pageDetail!.hasMore;
    _feedDetailData.forum!.comment!.comments.addAll(g.data.forum!.comment!.comments);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> postComment(
    BuildContext context,
    String forumId,
  ) async {

    setStateCommentStatus(CommentStatus.loading);
    
    try {

      if (controller.text.trim() == "") {
        controller.text = "";
        return;
      }

      if(type == "REPLY") {

        debugPrint("=== REPLY ===");

        String replyIdStore = Uuid().v4();

        int i = _feedDetailData.forum!.comment!.comments.indexWhere((el) => el.id == commentId);

        _feedDetailData.forum!.comment!.comments[i].reply.replies.add(ReplyElement(
          id: replyIdStore, 
          reply: controller.text, 
          createdAt: DateHelper.formatDateTime("seconds ago", context), 
          user: UserReply(
            id: context.read<ProfileProvider>().userProfile.userId.toString(),
            avatar: context.read<ProfileProvider>().userProfile.profilePic.toString(), 
            username: context.read<ProfileProvider>().userProfile.fullname.toString(),
            mention: context.read<ProfileProvider>().userProfile.fullname.toString().split('@')[0]
          ), 
          like: ReplyLike(
            total: 0, 
            likes: []
          ),
          key: GlobalKey()
        ));
       
        await fr.postReply(
          context: context, 
          replyIdStore: replyIdStore,
          replyId: replyId, commentId: commentId, 
          reply: controller.text, userId: ar.getUserId()!,
        ).then((_) {
          clearInput();
        });

        highlightedReply = _feedDetailData.forum!.comment!.comments[i].reply.replies.last.id;

        Future.delayed(const Duration(milliseconds: 1000), () {
          GlobalKey targetContext = _feedDetailData.forum!.comment!.comments[i].reply.replies.last.key;
          if(targetContext.currentContext != null) {
            Scrollable.ensureVisible(targetContext.currentContext!,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          }
        });

        Future.delayed(const Duration(milliseconds: 1000), () {
          highlightedReply = "";

          notifyListeners();
        });

        onUpdateType("COMMENT");

      } else {
        
        debugPrint("=== COMMENT ===");

        String commentIdStore = Uuid().v4();

        _feedDetailData.forum!.comment!.comments.add(
          CommentElement(
            id: commentIdStore,
            comment: controller.text,
            createdAt: getTranslated("SECONDS_AGO", context), 
            user: User(
              id: context.read<ProfileProvider>().userProfile.userId.toString(),
              avatar: context.read<ProfileProvider>().userProfile.profilePic.toString(), 
              username: context.read<ProfileProvider>().userProfile.fullname.toString(),
              mention: context.read<ProfileProvider>().userProfile.fullname.toString().split('@')[0]
            ),
            reply: CommentReply(total: 0, replies: []), 
            like: CommentLike(total: 0, likes: []),
            key: GlobalKey()
          )
        );

        await fr.postComment(
          context: context, commentId: commentIdStore, forumId: forumId, 
          comment: controller.text, userId: ar.getUserId()!,
        ).then((_) {
          clearInput();
        });

        highlightedComment =_feedDetailData.forum!.comment!.comments.last.id;

        Future.delayed(const Duration(milliseconds: 1000), () {
          GlobalKey<State<StatefulWidget>>? targetContext = _feedDetailData.forum!.comment!.comments.last.key;
          if(targetContext.currentContext != null) {
            Scrollable.ensureVisible(targetContext.currentContext!,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          }
        });

        Future.delayed(const Duration(milliseconds: 1000), () {
          highlightedComment = "";

          notifyListeners();
        });

      }

      setStateCommentStatus(CommentStatus.loaded);
    }  catch (e) {
      debugPrint(e.toString());
      setStateCommentStatus(CommentStatus.error);
    }
  }

  Future<void> toggleLike({
    required BuildContext context,
    required String forumId, 
    required ForumLike forumLikes
  }) async {
    try {
      int idxLikes = forumLikes.likes.indexWhere((el) => el.user!.id == ar.getUserId());
      if (idxLikes != -1) {
        forumLikes.likes.removeAt(idxLikes);
        forumLikes.total = forumLikes.total - 1;
      } else {
        forumLikes.likes.add(UserLikes(
          user: UserLike(
          id: ar.getUserId()!,
          avatar: '-',
          username: ar.getUserfullname()!,
        ),
          
        ));
        forumLikes.total = forumLikes.total + 1;
      }
      await fr.toggleLike(context: context, forumId: forumId, userId: ar.getUserId()!);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> toggleLikeComment({
    required BuildContext context,
    required String forumId, 
    required String commentId, 
    required CommentLike commentLikes
  }) async {
    try {
      int idxLikes = commentLikes.likes.indexWhere((el) => el.user!.id == ar.getUserId());
      if (idxLikes != -1) {
        commentLikes.likes.removeAt(idxLikes);
        commentLikes.total = commentLikes.total - 1;
      } else {
        commentLikes.likes.add(UserLikes(
          user: UserLike(
            id: ar.getUserId()!,
            avatar: "-",
            username: ar.getUserfullname()!,
          )
        ));
        commentLikes.total = commentLikes.total + 1;
      }
      await fr.toggleLikeComment(
        context: context, 
        forumId: forumId, 
        userId: ar.getUserId()!, 
        commentId: commentId
      );
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> toggleLikeReply({
    required BuildContext context,
    required String replyIdP, 
    required String commentIdP
  }) async {

    try {
      int idxComment = _feedDetailData.forum!.comment!.comments.indexWhere((el) => el.id == commentIdP);
      int idxReply = _feedDetailData.forum!.comment!.comments[idxComment].reply.replies.indexWhere((el) => el.id == replyIdP);
      int idxLikes = _feedDetailData.forum!.comment!.comments[idxComment].reply.replies[idxReply].like.likes.indexWhere((el) => el.user!.id == ar.getUserId());

      if (idxLikes != -1) {

        _feedDetailData.forum!.comment!.comments[idxComment].reply.replies[idxReply].like.likes.removeAt(idxLikes);
        _feedDetailData.forum!.comment!.comments[idxComment].reply.replies[idxReply].like.total = _feedDetailData.forum!.comment!.comments[idxComment].reply.replies[idxReply].like.total - 1;

      } else {

        _feedDetailData.forum!.comment!.comments[idxComment].reply.replies[idxReply].like.likes.add(
          UserLikes(
            id: Uuid().v4(),
            user: UserLike(
              id: ar.getUserId()!, 
              avatar: context.read<ProfileProvider>().userProfile.profilePic.toString(), 
              username: context.read<ProfileProvider>().userProfile.fullname.toString()
            )
          )
        );

        _feedDetailData.forum!.comment!.comments[idxComment].reply.replies[idxReply].like.total = _feedDetailData.forum!.comment!.comments[idxComment].reply.replies[idxReply].like.total + 1;
      
      }

      await fr.toggleLikeReplyComment(
        replyId: replyIdP, 
        userId: ar.getUserId()!
      );
   
      Future.delayed(Duration.zero, () => notifyListeners());

    } catch(e) {
      debugPrint(e.toString());
    }

  }

  Future<void> deleteComment({
    required BuildContext context, 
    required String forumId, 
    required String commentId
  }) async {
    try {
      await fr.deleteComment(context, commentId);

      int index = _feedDetailData.forum!.comment!.comments.indexWhere((el) => el.id == commentId);

      if(index != -1) {
        _feedDetailData.forum!.comment!.comments.removeAt(index);
      }

      notifyListeners();

      Navigator.of(context).pop();
      
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }


  Future<void> deleteReply({
    required BuildContext context,
    required String forumId, 
    required String replyId
  }) async {
    try {
      await fr.deleteReply(context, replyId);

      int indexComment = _feedDetailData.forum!.comment!.comments.indexWhere((el) => el.id == commentId);

      if(indexComment != -1) {
        int indexReply = _feedDetailData.forum!.comment!.comments[indexComment].reply.replies.indexWhere((el) => el.id == replyId);

        if(indexReply != -1) {
          _feedDetailData.forum!.comment!.comments[indexComment].reply.replies.removeAt(indexReply);
        }
      }

      notifyListeners();


      Navigator.of(context).pop();       
      
      setStateFeedDetailStatus(FeedDetailStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }
}