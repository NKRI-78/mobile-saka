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

  List<Forum> _forum1 = [];
  List<Forum> get forum1 => [..._forum1];
  List<Forum> _forum2 = [];
  List<Forum> get forum2 => [..._forum2];
  List<Forum> _forum3 = [];
  List<Forum> get forum3 => [..._forum3];

  Future<void> fetchFeedMostRecent(BuildContext context) async {
    pageKey = 1;
    FeedModel? g = await fr.fetchFeedMostRecent(context, pageKey, ar.getUserId().toString());
    _fm = g;
    if (g!.data!.forums!.isNotEmpty) {
      _forum1 = [];
      _forum1.addAll(g.data!.forums!);     
      setStateFeedStatus(FeedStatus.loaded);
    } else {
      setStateFeedStatus(FeedStatus.empty);
    } 
  }
  Future<void> fetchFeedPopuler(BuildContext context) async {
    pageKey = 1;
    FeedModel? g = await fr.fetchFeedPopuler(context, pageKey, ar.getUserId().toString());
    _fm = g;
    if (g!.data!.forums!.isNotEmpty) {
      _forum2 = [];
      _forum2.addAll(g.data!.forums!);     
      setStateFeedStatus(FeedStatus.loaded);
    } else {
      setStateFeedStatus(FeedStatus.empty);
    } 
  }
  Future<void> fetchFeedSelf(BuildContext context) async {
    pageKey = 1;
    FeedModel? g = await fr.fetchFeedSelf(context, pageKey, ar.getUserId().toString());
    _fm = g;
    if (g!.data!.forums!.isNotEmpty) {
      _forum3 = [];
      _forum3.addAll(g.data!.forums!);     
      setStateFeedStatus(FeedStatus.loaded);
    } else {
      setStateFeedStatus(FeedStatus.empty);
    } 
  }

  Future<void> sendPostText(BuildContext context, String text) async {
    setStateFeedStatus(FeedStatus.loading);
    await fr.sendPostText(context, text);
    setStateFeedStatus(FeedStatus.loaded);
    Future.delayed(Duration.zero, () {
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });
  }
  
}