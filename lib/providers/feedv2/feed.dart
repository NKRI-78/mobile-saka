import 'package:flutter/widgets.dart';
import 'package:saka/data/models/feedv2/feed.dart';
import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/feedv2/feed.dart';

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

  FeedModel? _fm;
  FeedModel get fm => _fm!;

  List<Forum> _forum = [];
  List<Forum> get forum => [..._forum];

  Future<void> fetchFeed(BuildContext context) async {
    pageKey = 1;
    FeedModel? g = await fr.fetchFeed(context, pageKey, ar.getUserId().toString());
    _fm = g;
    if (g!.data!.forums!.isNotEmpty) {
      _forum = [];
      _forum.addAll(g.data!.forums!.reversed);     
      setStateFeedStatus(FeedStatus.loaded);
    } else {
      setStateFeedStatus(FeedStatus.empty);
    } 
  }

  Future<void> fetchDetail2(BuildContext context, String postId) async {
    pageKey = 1;
    FeedModel? g = await fr.fetchDetail(context, postId);
    _fm = g;
    if (g!.data!.forums!.isNotEmpty) {
      _forum = [];
      _forum.addAll(g.data!.forums!);     
      setStateFeedStatus(FeedStatus.loaded);
    } else {
      setStateFeedStatus(FeedStatus.empty);
    } 
  }

  Future<void> fetchDetail(BuildContext context, String postId) async {
    // setStateFeedDetailStatus(FeedStatus.loading);
    FeedModel? p = await fr.fetchDetail(context, postId);
    _fm = p;
    setStateFeedDetailStatus(FeedDetailStatus.loaded);
    if(_fm == null) {
      setStateFeedDetailStatus(FeedDetailStatus.empty);
    }
  }
  
}