import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saka/providers/profile/profile.dart';
import 'package:saka/views/screens/feed/post_detail.dart';
import 'package:provider/provider.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/providers/feedv2/feed.dart';

import 'package:saka/views/screens/feed/widgets/input_post.dart';
import 'package:saka/views/screens/feed/posts.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

class FeedIndex extends StatefulWidget {
  const FeedIndex({Key? key}) : super(key: key);

  @override
  FeedIndexState createState() => FeedIndexState();
}

class FeedIndexState extends State<FeedIndex> with TickerProviderStateMixin {

  late TabController tabController;
  late FeedProviderV2 feedProvider;
  late ProfileProvider profileProvider;

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
      feedProvider.fetchFeedMostRecent(context);
      feedProvider.fetchFeedPopuler(context);
      feedProvider.fetchFeedSelf(context);
    });
  }

  Future<void> getData() async {
    if(!mounted) return;
      await feedProvider.fetchFeedMostRecent(context);

    if(!mounted) return;
      await feedProvider.fetchFeedPopuler(context);
      
    if(!mounted) return;
      await feedProvider.fetchFeedSelf(context);  

    if(!mounted) return;  
      await profileProvider.getUserProfile(context);
  }

  @override
  void initState() {
    super.initState();
    
    feedProvider = context.read<FeedProviderV2>();

    profileProvider = context.read<ProfileProvider>();

    Future.microtask(() => getData());

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

        Consumer<FeedProviderV2>(
          builder: (BuildContext context, FeedProviderV2 feedProvider, Widget? child) {
            if (feedProvider.feedRecentStatus == FeedRecentStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primaryOrange,
                ),
              );
            }
            if (feedProvider.feedRecentStatus == FeedRecentStatus.empty) {
              return Center(
                child: Text(
                  getTranslated("THERE_IS_NO_POST", context), 
                  style: robotoRegular
                )
              );
            }
            if (feedProvider.feedRecentStatus == FeedRecentStatus.error) {
              return Center(
                child: Text(
                  getTranslated("THERE_WAS_PROBLEM", context), 
                  style: robotoRegular
                )
              );
            }
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    if (feedProvider.hasMore) {
                      feedProvider.loadMoreRecent(context: context);
                    }
                  }
                }
                return false;
              },
              child: RefreshIndicator(
                backgroundColor: ColorResources.primaryOrange,
                color: ColorResources.white,
                key: refreshIndicatorKey1,
                  onRefresh: () => refresh(context),
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int i) {
                      return Container(
                        color: Colors.blueGrey[50],
                        height: 10.0,
                      );
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    key: g1Key,
                    itemCount: feedProvider.forum1.length,
                    itemBuilder: (BuildContext content, int i) {
                    if (feedProvider.forum1.length == i) {
                      return const Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: ColorResources.primaryOrange,
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        NS.push(context, PostDetailScreen(
                          data: {
                            "forum_id": feedProvider.forum1[i].id,
                            "comment_id": "",
                            "reply_id": "",
                            "from": "click",
                          },
                        )).then((_) {
                          feedProvider.fetchFeedMostRecent(context);
                        });

                      },
                      child: Posts(
                        forum: feedProvider.forum1[i],
                      ),
                    );
                  }
                ),
              ),
            );
          },
        ),

        Consumer<FeedProviderV2>(
          builder: (BuildContext context, FeedProviderV2 feedProviderv2, Widget? child) {
            if (feedProviderv2.feedPopulerStatus == FeedPopulerStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primaryOrange,
                ),
              );
            }
            if (feedProviderv2.feedPopulerStatus == FeedPopulerStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_POST", context), style: robotoRegular)
              );
            }
            if (feedProviderv2.feedPopulerStatus == FeedPopulerStatus.error) {
              return Center(
                child: Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular)
              );
            }
            return NotificationListener<ScrollNotification>(
              child: RefreshIndicator.adaptive(
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
                    itemCount: feedProviderv2.forum2.length,
                    itemBuilder: (BuildContext content, int i) {
                    if (feedProviderv2.forum2.length == i) {
                      return const Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: ColorResources.primaryOrange,
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, NS.fromLeft(
                          PostDetailScreen(
                          data: {
                            "forum_id": feedProvider.forum1[i].id,
                            "comment_id": "",
                            "reply_id": "",
                            "from": "click",
                          },
                          ))).then((_) => setState(() {
                          feedProvider.fetchFeedPopuler(context);
                        }));
                      },
                      child: Posts(
                        forum: feedProviderv2.forum2[i],
                      ),
                    );
                  }
                ),
              ),
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    if (feedProviderv2.hasMore2) {
                      feedProviderv2.loadMorePopuler(context: context);
                    }
                  }
                }
                return false;
              },
            );
          },
        ),
        
        Consumer<FeedProviderV2>(
          builder: (BuildContext context, FeedProviderV2 feedProviderv2, Widget? child) {
            if (feedProviderv2.feedSelfStatus == FeedSelfStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primaryOrange,
                ),
              );
            }
            if (feedProviderv2.feedSelfStatus == FeedSelfStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_POST", context), style: robotoRegular)
              );
            }
            if (feedProviderv2.feedSelfStatus == FeedSelfStatus.error) {
              return Center(
                child: Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular)
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
                    itemCount: feedProviderv2.forum3.length,
                    itemBuilder: (BuildContext content, int i) {
                    if (feedProviderv2.forum3.length == i) {
                      return const SpinKitThreeBounce(
                        size: 20.0,
                        color: ColorResources.primaryOrange,
                      );
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, NS.fromLeft(
                          PostDetailScreen(
                            data: {
                              "forum_id": feedProvider.forum1[i].id,
                              "comment_id": "",
                              "reply_id": "",
                              "from": "click"
                            },
                          )
                        )).then((_) => setState(() {
                          feedProvider.fetchFeedSelf(context);
                        }));
                      },
                      child: Posts(
                        forum: feedProviderv2.forum3[i],
                      ),
                    );
                  }
                ),
              ),
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    if (feedProviderv2.hasMore3) {
                      feedProviderv2.loadMoreSelf(context: context);
                    }
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
     body: NestedScrollView(
       physics: const ScrollPhysics(),
       headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [

            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: ColorResources.white,
              automaticallyImplyLeading: false,
              toolbarHeight: 150.0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Image.asset('assets/images/logo/logo.png',
                    width: 70.0,
                  ),

                  const SizedBox(height: 8.0),

                  Text('Forum',
                    style: robotoRegular.copyWith(
                      color: ColorResources.black,
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.fontSizeOverLarge
                    )
                  ),

                  const SizedBox(height: 8.0),

                  const Text("Saka Dirgantara",
                    style: TextStyle(
                      color: ColorResources.black,
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.fontSizeLarge
                    ),
                  )

                ],
              ),
              leading: CupertinoNavigationBarBackButton(
                color: ColorResources.black,
                onPressed: () {
                  NS.pop(context);
                },
              ),
              elevation: 0.0,
              forceElevated: true,
              pinned: false,
              centerTitle: true,
              floating: true,
            ),
            
            const InputPostWidget(),

          ];
         },
        body: tabbarviewsection(context),
      )
    );
  }
}