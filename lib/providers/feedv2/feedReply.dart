import 'package:flutter/widgets.dart';
import 'package:saka/data/models/feedv2/feedReply.dart';
import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/feedv2/feed.dart';
import 'package:saka/utils/exceptions.dart';

enum FeedReplyStatus { idle, loading, loaded, empty, error }

class FeedReplyProvider with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepoV2 fr;
  FeedReplyProvider({
    required this.ar,
    required this.fr
  });

  late TextEditingController commentC;

  bool hasMore = true;
  int pageKey = 1;

  FeedReplyStatus _feedReplyStatus = FeedReplyStatus.loading;
  FeedReplyStatus get feedReplyStatus => _feedReplyStatus;

  void setStateFeedReplyStatus(FeedReplyStatus feedReplyStatus) {
    _feedReplyStatus = feedReplyStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  FeedReplyData _feedReplyData = FeedReplyData();
  FeedReplyData get feedReplyData => _feedReplyData;

  final List<ReplyElement> _reply = [];
  List<ReplyElement> get reply => [..._reply];

  Future<void> getFeedReply({required BuildContext context,required String commentId}) async {
    pageKey = 1;
    hasMore = true;

    try {
      FeedReplyModel frm = await fr.getReply(commentId: commentId, pageKey: pageKey, context: context);
      _feedReplyData = frm.data;

      _reply.clear();
      _reply.addAll(frm.data.comment!.reply!.replies);
      setStateFeedReplyStatus(FeedReplyStatus.loaded);

      // if (reply.isEmpty) {
      //   setStateFeedReplyStatus(FeedReplyStatus.empty);
      // }
    } on CustomException catch (_) {
      setStateFeedReplyStatus(FeedReplyStatus.error);
    } catch (_) {
      setStateFeedReplyStatus(FeedReplyStatus.error);
    }
  }

  // Future<void> postComment(
  //   BuildContext context,
  //   String feedId,
  //   ) async {
  //   try {
  //     if (commentC.text.trim() == "") {
  //       commentC.text = "";
  //       return;
  //     }

  //     await fr.postComment(context: context, feedId: feedId, comment: commentC.text, userId: ar.getUserId().toString());

  //     FeedReplyModel? fdm = await fr.fetchDetail(context, feedId);
  //     _feedReplyData = fdm!.data.forum;

  //     _reply.clear();
  //     _reply.addAll(fdm.data.forum.comment!.comments);

  //     commentC.text = "";

  //     setStateFeedReplyStatus(FeedReplyStatus.loaded);
  //   } on CustomException catch (e) {
  //     setStateFeedReplyStatus(FeedReplyStatus.error);
  //     debugPrint(e.toString());
  //   } catch (_) {
  //     setStateFeedReplyStatus(FeedReplyStatus.error);
  //   }
  // }
  
}