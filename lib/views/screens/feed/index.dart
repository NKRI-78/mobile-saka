import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/views/screens/feed/widgets/input_post.dart';
import 'package:saka/views/screens/feed/notification.dart';
import 'package:saka/views/screens/feed/posts.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/providers/feed/feed.dart';

class FeedIndex extends StatefulWidget {
  const FeedIndex({Key? key}) : super(key: key);

  @override
  _FeedIndexState createState() => _FeedIndexState();
}

class _FeedIndexState extends State<FeedIndex> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late TabController tabController;
  late FeedProvider feedProvider;

  GlobalKey g1Key = GlobalKey();
  GlobalKey g2Key = GlobalKey();
  GlobalKey g3Key = GlobalKey();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey1 = GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey2 = GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey3 = GlobalKey<RefreshIndicatorState>();
  
  FocusNode groupsFocusNode = FocusNode();
  FocusNode commentFocusNode = FocusNode();

  Future refresh(BuildContext context) async {
    Future.sync((){
      feedProvider.fetchGroupsMostRecent(context);
      feedProvider.fetchGroupsMostPopular(context);
      feedProvider.fetchGroupsSelf(context);
    });
  }

  @override
  void initState() {
    super.initState();
    feedProvider = context.read<FeedProvider>();
    Future.delayed(Duration.zero, () {
      if(mounted) {
        feedProvider.fetchGroupsMostRecent(context);    
      }
      if(mounted) {
        feedProvider.fetchGroupsMostPopular(context);
      }
      if(mounted) {
        feedProvider.fetchGroupsSelf(context);
      }
    });
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }
  
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget tabSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: TabBar(
        controller: tabController,
        unselectedLabelColor: ColorResources.primaryOrange,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorResources.white,
        indicator: const BubbleTabIndicator(
          indicatorHeight: 30.0,
          indicatorRadius: 10.0,
          padding: EdgeInsets.zero,
          indicatorColor: ColorResources.primaryOrange,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        labelStyle: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall
        ),
      tabs: [
        Tab(text: getTranslated("LATEST", context)),
        Tab(text: getTranslated("POPULAR", context)),
        Tab(text: getTranslated("ME", context)),
      ]),
    );
  }

  Widget tabbarviewsection(BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: tabController,
      children: [

        Consumer<FeedProvider>(
          builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
            if (feedProvider.groupsMostRecentStatus == GroupsMostRecentStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primaryOrange,
                ),
              );
            }
            if (feedProvider.groupsMostRecentStatus == GroupsMostRecentStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_POST", context), style: robotoRegular)
              );
            }
            return NotificationListener<ScrollNotification>(
              child: RefreshIndicator(
                backgroundColor: ColorResources.primaryOrange,
                color: ColorResources.white,
                key: refreshIndicatorKey1,
                  onRefresh: () => refresh(context),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int i) {
                      return Container(
                        color: Colors.blueGrey[50],
                        height: 40.0,
                      );
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    key: g1Key,
                    itemCount: feedProvider.g1.nextCursor != null ? feedProvider.g1List.length + 1 : feedProvider.g1List.length,
                    itemBuilder: (BuildContext content, int i) {
                    if (feedProvider.g1List.length == i) {
                      return const Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: ColorResources.primaryOrange,
                        ),
                      );
                    }
                    return Posts(
                      i: i,
                      groupsBody: feedProvider.g1List,
                    );
                  }
                ),
              ),
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (feedProvider.g1.nextCursor != null) {
                    feedProvider.fetchGroupsMostRecentLoad(context, feedProvider.g1.nextCursor!);
                    feedProvider.g1.nextCursor = null;
                  }
                }
                return false;
              },
            );
          },
        ),

        Consumer<FeedProvider>(
          builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
            if(feedProvider.groupsMostPopularStatus == GroupsMostPopularStatus.loading) {
              return const SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primaryOrange
              );
            } 
            if(feedProvider.groupsMostPopularStatus == GroupsMostPopularStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_POST", context), style: robotoRegular)
              );
            }
            return NotificationListener<ScrollNotification>(
              child: RefreshIndicator(
                backgroundColor: ColorResources.primaryOrange,
                color: ColorResources.white,
                key: refreshIndicatorKey2,
                  onRefresh: () => refresh(context),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int i) {
                      return Container(
                        color: Colors.blueGrey[50],
                        height: 40.0,
                      );
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    key: g2Key,
                    itemCount: feedProvider.g2.nextCursor != null ? feedProvider.g2List.length + 1 : feedProvider.g2List.length,
                    itemBuilder: (BuildContext content, int i) {
                    if (feedProvider.g2List.length == i) {
                      return const Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: ColorResources.primaryOrange,
                        ),
                      );
                    }
                    return Posts(
                      i: i,
                      groupsBody: feedProvider.g2List,
                    );
                  }
                ),
              ),
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (feedProvider.g2.nextCursor != null) {
                    feedProvider.fetchGroupsMostPopularLoad(context, feedProvider.g2.nextCursor!);
                    feedProvider.g2.nextCursor = null;
                  }
                }
                return false;
              },
            );
          },
        ),
        
        Consumer<FeedProvider>(
          builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
            if(feedProvider.groupsSelfStatus == GroupsSelfStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primaryOrange,
                )
              );
            } 
            if(feedProvider.groupsSelfStatus == GroupsSelfStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_POST", context), 
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault
                  )
                )
              );
            }
            return NotificationListener<ScrollNotification>(
              child: RefreshIndicator(
                backgroundColor: ColorResources.primaryOrange,
                color: ColorResources.white,
                key: refreshIndicatorKey3,
                  onRefresh: () => refresh(context),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int i) {
                      return Container(
                        color: Colors.blueGrey[50],
                        height: 40.0,
                      );
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    key: g3Key,
                    itemCount: feedProvider.g3.nextCursor != null ? feedProvider.g3List.length + 1 : feedProvider.g3List.length,
                    itemBuilder: (BuildContext content, int i) {
                    if (feedProvider.g3List.length == i) {
                      return const SpinKitThreeBounce(
                        size: 20.0,
                        color: ColorResources.primaryOrange,
                      );
                    }
                    return Posts(
                      i: i,
                      groupsBody: feedProvider.g3List,
                    );
                  }
                ),
              ),
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (feedProvider.g3.nextCursor != null) {
                    feedProvider.fetchGroupsSelfLoad(context, feedProvider.g3.nextCursor!);
                    feedProvider.g3.nextCursor = null;
                  }
                }
                return false;
              },
            );
          },
        )
      ]
    );
  } 

  @override
  Widget build(BuildContext context) {
    return buildUI(); 
  }

  Widget buildUI() {
    return Scaffold(
     key: globalKey,
     body: NestedScrollView(
       physics: const ScrollPhysics(),
       headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: ColorResources.white,
              automaticallyImplyLeading: false,
              title: Text('Community Feed',
                style: robotoRegular.copyWith(
                  color: ColorResources.primaryOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.fontSizeDefault
                )
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    NS.push(context, NotificationScreen());
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: ColorResources.primaryOrange
                  ),
                ),
              ],
              leading: CupertinoNavigationBarBackButton(
                color: ColorResources.primaryOrange,
                onPressed: () {
                  NS.pop(context);
                },
              ),
              elevation: 0.0,
              forceElevated: true,
              pinned: true,
              centerTitle: true,
              floating: true,
            ),
            InputPostComponent(),
            tabSection(context)
          ];
         },
        body: tabbarviewsection(context),
      )
    );
  }
}