import 'package:flutter/widgets.dart';

import 'package:saka/data/models/feedv2/feedReply.dart';
import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/feedv2/feed.dart';

import 'package:saka/utils/exceptions.dart';

enum FeedReplyStatus { idle, loading, loaded, empty, error }
enum FeedReplyDetailStatus { idle, loading, loaded, empty, error }

class FeedReplyProvider with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepoV2 fr;

  FeedReplyProvider({
    required this.ar,
    required this.fr
  });

  bool hasMore = true;
  int pageKey = 1;

  String valReply = "";

  FeedReplyStatus _feedReplyStatus = FeedReplyStatus.loading;
  FeedReplyStatus get feedReplyStatus => _feedReplyStatus;

  FeedReplyDetailStatus _feedReplyDetailStatus = FeedReplyDetailStatus.loading;
  FeedReplyDetailStatus get feedReplyDetailStatus => _feedReplyDetailStatus;

  void setStateFeedReplyStatus(FeedReplyStatus feedReplyStatus) {
    _feedReplyStatus = feedReplyStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedReplyDetailStatus(FeedReplyDetailStatus feedReplyDetailStatus) {
    _feedReplyDetailStatus = feedReplyDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  FeedReplyData _feedReplyData = FeedReplyData();
  FeedReplyData get feedReplyData => _feedReplyData;

  final List<ReplyElement> _reply = [];
  List<ReplyElement> get reply => [..._reply];

  void changeReply(String val) {
    valReply = val;
    
    notifyListeners();
  }

  Future<void> getFeedReply({required BuildContext context,required String commentId}) async {
    pageKey = 1;
    hasMore = true;

    try {
      FeedReplyModel? frm = await fr.getReply(
        commentId: commentId, 
        pageKey: pageKey, 
        context: context
      );

      _feedReplyData = frm!.data;

      _reply.clear();
      _reply.addAll(frm.data.comment!.reply!.replies);
      setStateFeedReplyStatus(FeedReplyStatus.loaded);

      if (reply.isEmpty) {
        setStateFeedReplyStatus(FeedReplyStatus.empty);
      }
    } on CustomException catch (_) {
      setStateFeedReplyStatus(FeedReplyStatus.error);
    } catch (_) {
      setStateFeedReplyStatus(FeedReplyStatus.error);
    }
  }

  Future<void> loadMoreReply({required BuildContext context, required String commentId}) async {
    pageKey++;

    FeedReplyModel? frm = await fr.getReply(commentId: commentId, pageKey: pageKey, context: context);

    hasMore = frm!.data.pageDetail!.hasMore;
    _reply.addAll(frm.data.comment!.reply!.replies);

    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> postReply(
    BuildContext context,
    String commentVal,
    String commentId,
    ) async {
    try {

      // if (mentionKey.currentState!.controller!.text.trim() == "") {
      //   mentionKey.currentState!.controller!.text = "";
      //   return;
      // }

      await fr.postReply(
        context: context,
        replyIdStore: "",
        replyId: "", 
        reply: commentVal, 
        commentId: commentId,
        userId: ar.getUserId().toString(), 
      );

      // mentionKey.currentState!.controller!.text = "";

      FeedReplyModel? frm = await fr.getReply(
        context: context, 
        commentId: commentId, 
        pageKey: 1
      );
      
      _feedReplyData = frm!.data;

      _reply.clear();
      _reply.addAll(frm.data.comment!.reply!.replies);

      setStateFeedReplyStatus(FeedReplyStatus.loaded);
    } on CustomException catch (e) {
      setStateFeedReplyStatus(FeedReplyStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedReplyStatus(FeedReplyStatus.error);
    }
  }

  Future<void> deleteReply( {
    required BuildContext context, 
    required String feedId, 
    required String deleteId
  }) async {
    try {
      await fr.deleteReply(context, deleteId);

      FeedReplyModel? frm = await fr.getReply(commentId: feedId, pageKey: pageKey, context: context);
      _feedReplyData = frm!.data;

      _reply.clear();
      _reply.addAll(frm.data.comment!.reply!.replies);
      
      setStateFeedReplyStatus(FeedReplyStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  
}