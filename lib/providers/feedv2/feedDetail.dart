import 'package:flutter/widgets.dart';
import 'package:saka/data/models/feedv2/feedDetail.dart';
import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/feedv2/feed.dart';
import 'package:saka/utils/exceptions.dart';

enum FeedStatus { idle, loading, loaded, empty, error }

enum FeedDetailStatus { idle, loading, loaded, empty, error }

class FeedProviderV2 with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepoV2 fr;
  FeedProviderV2({
    required this.ar,
    required this.fr
  });

  bool hasMore = true;
  int pageKey = 1;

  FeedStatus _feedStatus = FeedStatus.loading;
  FeedStatus get feedStatus => _feedStatus;

  FeedDetailStatus _feedDetailStatus = FeedDetailStatus.loading;
  FeedDetailStatus get feedDetailStatus => _feedDetailStatus;

  void setStateFeedStatus(FeedStatus feedStatus) {
    _feedStatus = feedStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedDetailStatus(FeedDetailStatus feedDetailStatus) {
    _feedDetailStatus = feedDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  FeedDetailData _feedDetailData = FeedDetailData();
  FeedDetailData get feedDetailData => _feedDetailData;

  final List<Forum> _forums = [];
  List<Forum> get forums => [..._forums];

  // Future<void> getFeedDetail(BuildContext context, String postId) async {
  //   pageKey = 1;
  //   hasMore = true;

  //   try {
  //     FeedDetailModel? fdm = await fr.fetchDetail(context, postId);

  //     _forums.clear();
  //     _forums.addAll(fdm!.data!.forum! as Iterable<Forum>);
  //     setStateFeedDetailStatus(FeedDetailStatus.loaded);

  //     if (forums.isEmpty) {
  //       setStateFeedDetailStatus(FeedDetailStatus.empty);
  //     }
  //   } on CustomException catch (e) {
  //     setStateFeedDetailStatus(FeedDetailStatus.error);
  //     debugPrint(e.toString());
  //   } catch (_) {
  //     setStateFeedDetailStatus(FeedDetailStatus.error);
  //   }
  // }
  
}