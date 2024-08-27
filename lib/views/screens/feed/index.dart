import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saka/providers/profile/profile.dart';
import 'package:saka/views/screens/dashboard/dashboard.dart';
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

  bool pause = false;

  late TabController tabController;
  late FeedProviderV2 feedProvider;
  late ProfileProvider profileProvider;

  late ScrollController sc;

  Future<void> getData() async {
    if(!mounted) return;
      await feedProvider.fetchFeedMostRecent(context);

    if(!mounted) return;  
      await profileProvider.getUserProfile(context);
  }

  @override
  void initState() {
    super.initState();
    
    feedProvider = context.read<FeedProviderV2>();

    profileProvider = context.read<ProfileProvider>();

    tabController = TabController(length: 1, vsync: this, initialIndex: 0);

    sc = ScrollController();

    Future.microtask(() => getData());
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
              child: RefreshIndicator.adaptive(
                onRefresh: () {
                  return Future.sync(() {
                    feedProvider.fetchFeedMostRecent(context);
                  });
                },
                child: ListView.separated(
                  key: PageStorageKey<String>('feedRecentListView'),
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int i) {
                    return Container(
                      color: Colors.blueGrey[50],
                      height: 10.0,
                    );
                  },
                  // physics: const AlwaysScrollableScrollPhysics(),
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
                        from: "index",
                        data: {
                          "forum_id": feedProvider.forum1[i].id,
                          "comment_id": "",
                          "reply_id": "",
                          "from": "click",
                        },
                      ));
                    },
                    child: Posts(
                      pause: pause,
                      forum: feedProvider.forum1[i],
                    ),
                  );
                }),
              ),
            );
          },
        ),

      ]
    );
  } 

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        setState(() {
          pause = true;
        });
        if(sc.position.pixels == 0.0) {
          NS.push(context, DashboardScreen());
        } else {
          Future.delayed(Duration(milliseconds: 1000),() {
            sc.animateTo(
              sc.position.minScrollExtent, 
              duration: Duration(milliseconds: 1000), 
              curve: Curves.easeIn
            );
          });
        }
      },
      child: Scaffold(
       body: NestedScrollView(
          controller: sc,
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
                    setState(() {
                      pause = true;
                    });
                    if(sc.position.pixels == 0.0) {
                      NS.push(context, DashboardScreen());
                    } else {
                      Future.delayed(Duration(milliseconds: 1000),() {
                        sc.animateTo(
                          sc.position.minScrollExtent, 
                          duration: Duration(milliseconds: 1000), 
                          curve: Curves.easeIn
                        );
                      });
                    }
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
      ),
    );
  }
}