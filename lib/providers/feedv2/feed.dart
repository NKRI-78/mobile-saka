import 'package:flutter/widgets.dart';
import 'package:saka/data/models/feedv2/feed.dart';
import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/feedv2/feed.dart';

enum FeedStatus { idle, loading, loaded, empty, error }

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

  void setStateFeedStatus(FeedStatus feedStatus) {
    _feedStatus = feedStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  FeedModel? _fm;
  FeedModel get fd => _fm!;

  List<Forum> _forum = [];
  List<Forum> get forum => [..._forum];

  Future<void> fetchFeed(BuildContext context) async {
    pageKey = 1;
    FeedModel? g = await fr.fetchFeed(context, pageKey);
    _fm = g;
    if (g!.data!.forums!.isNotEmpty) {
      _forum = [];
      _forum.addAll(g.data!.forums!);     
      setStateFeedStatus(FeedStatus.loaded);
    } else {
      setStateFeedStatus(FeedStatus.empty);
    } 
  }

}