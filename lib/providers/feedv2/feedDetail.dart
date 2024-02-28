import 'package:flutter/widgets.dart';
import 'package:saka/data/models/feedv2/feedDetail.dart';
import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/feedv2/feed.dart';
import 'package:saka/utils/exceptions.dart';

enum FeedDetailStatus { idle, loading, loaded, empty, error }

class FeedDetailProviderV2 with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepoV2 fr;
  FeedDetailProviderV2({
    required this.ar,
    required this.fr
  });

  bool hasMore = true;
  int pageKey = 1;

  FeedDetailStatus _feedDetailStatus = FeedDetailStatus.loading;
  FeedDetailStatus get feedDetailStatus => _feedDetailStatus;

  void setStateFeedDetailStatus(FeedDetailStatus feedDetailStatus) {
    _feedDetailStatus = feedDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  ForumDetailData _feedDetailData = ForumDetailData();
  ForumDetailData get feedDetailData => _feedDetailData;

  final List<CommentElement> _comment = [];
  List<CommentElement> get comment => [..._comment];

  Future<void> getFeedDetail(BuildContext context, String postId) async {
    pageKey = 1;
    hasMore = true;

    try {
      FeedDetailModel? fdm = await fr.fetchDetail(context, postId);
      _feedDetailData = fdm!.data.forum;

      _comment.clear();
      _comment.addAll(fdm.data.forum.comment!.comments);
      setStateFeedDetailStatus(FeedDetailStatus.loaded);

      if (comment.isEmpty) {
        setStateFeedDetailStatus(FeedDetailStatus.empty);
      }
    } on CustomException catch (e) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
    }
  }
  
}