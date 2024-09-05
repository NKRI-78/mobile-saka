import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:saka/views/screens/ecommerce/product.dart';
import 'package:saka/views/screens/feed/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:draggable_float_widget/draggable_float_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/inbox/inbox.dart';
import 'package:saka/providers/banner/banner.dart';
import 'package:saka/providers/firebase/firebase.dart';
import 'package:saka/providers/profile/profile.dart';
import 'package:saka/providers/news/news.dart';
import 'package:saka/providers/location/location.dart';
import 'package:saka/providers/auth/auth.dart';
import 'package:saka/providers/event/event.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/box_shadow.dart';

import 'package:saka/views/basewidgets/drawer/drawer.dart';

import 'package:saka/views/screens/comingsoon/comingsoon.dart';
import 'package:saka/views/screens/radio/radio.dart';
import 'package:saka/views/screens/media/media.dart';
import 'package:saka/views/screens/news/detail.dart';
import 'package:saka/views/screens/eventjoin/event_join.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late FirebaseProvider fp;
  late NewsProvider np;
  late LocationProvider lp;
  late InboxProvider ip;
  late BannerProvider bp;
  late ProfileProvider pp;
  late AuthProvider ap;
  late EventProvider ep;

  Future<void> getData() async {
    if(mounted) {
      fp.initFcm(context);
    }
    if(mounted) {
      ip.getInbox(context, "sos");
    }
    if(mounted) {
      bp.getBanner(context);
    }
    if(mounted) {
      pp.getUserProfile(context);
    }
    if(mounted) {
      np.getNews(context);
    }
    if(mounted) {
      ap.mascot(context);
    }
    if(mounted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    
      lp.getCurrentPosition(
        latitude: position.latitude, 
        longitude: position.longitude
      );

      Helper.prefs?.setString("lat", position.latitude.toString());
      Helper.prefs?.setString("lng", position.longitude.toString());
    }
    if(mounted) {
      // ppopP.getBalance(context);
    }
    if(mounted) {
      // sp.getDataStore(context);
    }
    if(mounted) {
      // sp.getDataCategoryProduct(context, "commerce");  
    }
  }

  @override
  void initState() {
    super.initState();

    fp = context.read<FirebaseProvider>();
    np = context.read<NewsProvider>();
    ip = context.read<InboxProvider>();
    bp = context.read<BannerProvider>();
    pp = context.read<ProfileProvider>();
    lp = context.read<LocationProvider>();
    ap = context.read<AuthProvider>();
    ep = context.read<EventProvider>();

    if(mounted) { 
      // NewVersionPlus newVersion = NewVersionPlus(
      //   androidId: 'com.inovasi78.saka',
      //   iOSId: 'com.inovatif78.saka'
      // );
      // Future.delayed(Duration.zero, () async {
      //   VersionStatus? vs = await newVersion.getVersionStatus();
      //   if(vs!.canUpdate) {
      //     NS.push(context, const UpdateScreen());
      //   } 
      // });
    }
    
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorResources.backgroundColor,
      drawerEnableOpenDragGesture: false,
      drawer: DrawerWidget(),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
  
          RefreshIndicator(
            backgroundColor: ColorResources.brown,
            color: ColorResources.white,
            onRefresh: () {
              return Future.sync(() {
                np.getNews(context);
                bp.getBanner(context);
                pp.getUserProfile(context);
                ip.getInbox(context, "sos");
                ep.checkEvent(context);
                ap.mascot(context);
                // ppopP.getBalance(context);
                // sp.getDataStore(context);
                // sp.getDataCategoryProduct(context, "commerce");
              });
            },
            child: CustomScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
  
                SliverAppBar(
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  backgroundColor: ColorResources.transparent,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text("SAKA DIRGANTARA",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w600,
                      color: ColorResources.brown
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState!.openDrawer();
                        },
                        child: SvgPicture.asset("assets/imagesv2/svg/hamburger-menu.svg",
                          color: ColorResources.brown,
                        ),
                      ),
                    )
                  ],
                ),
  
                SliverList(
                  delegate: SliverChildListDelegate([
                    
                    banner(context),

                    infoAccount(context),

                    Container(
                      margin: EdgeInsets.only(
                        left: 25.0, 
                        right: 25.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(getTranslated("OUR_SERVICE", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              fontWeight: FontWeight.w600,
                              color: ColorResources.brown
                            )
                          ),
                        ],
                      ),
                    ),

                    ourService(context),

                    Container(
                      margin: EdgeInsets.only(
                        left: 25.0, 
                        right: 25.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(getTranslated("NEWS", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              fontWeight: FontWeight.w600,
                              color: ColorResources.brown
                            )
                          ),
                        ],
                      ),
                    ),
                    
                    newsWidget(context),

                    Container(
                      margin: EdgeInsets.only(
                        bottom: 15.0
                      ),
                      alignment: Alignment.center,
                      child: Text("@ PT Inovatif 78",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.brown
                        ),
                      ),
                    )

                  ])
                )
              ],
            )
          ),
  
          context.watch<AuthProvider>().mascotStatus == MascotStatus.loading 
          ? Container() 
          : context.read<AuthProvider>().isShow == 1  
          ? DraggableFloatWidget(
              width: 120.0,
              height: 120.0,
              child: BounceIn(
                preferences: AnimationPreferences(autoPlay: AnimationPlayStates.Loop),
                child: Image.asset("assets/images/ic-jambore.png"),
              ),
              config: const DraggableFloatWidgetBaseConfig(
                isFullScreen: false,
                initPositionYInTop: false,    
                borderRight: 5.0,
                initPositionXInLeft: false,                        
                initPositionYMarginBorder: 100.0,
              ),
              onTap: () {
                NS.push(context, EventJoinScreen());
              },
            )
          : Container()
        ],
      )                     
    );
  }
  
}


Widget banner(BuildContext context) {
return Consumer<BannerProvider>(
  builder: (BuildContext context, BannerProvider bannerProvider, Widget? child) {
    if(bannerProvider.bannerStatus == BannerStatus.loading)
      return Container(
        margin: EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
          left: 25.0,
          right: 25.0
        ),
        width: double.infinity,
        height: 180.0,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[200]!,
          child: Container( 
            decoration: BoxDecoration(
              color: ColorResources.white,
              borderRadius: BorderRadius.circular(15.0)
            )
          ),
        )
      );
      
    if(bannerProvider.bannerStatus == BannerStatus.empty)      
      return Container(
        width: double.infinity,
        height: 180.0,
        child: Center(
          child: Text(getTranslated("NO_BANNER_AVAILABLE", context),
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.black
            ),
          )
        )
      );

    if(bannerProvider.bannerStatus == BannerStatus.error)      
      return Container(
        width: double.infinity,
        height: 180.0,
        child: Center(
          child: Text(getTranslated("THERE_WAS_PROBLEM", context),
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.black
            ),
          )
        )
      );
    
      return Container(
        margin: EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
          left: 25.0,
          right: 25.0
        ),
        width: double.infinity,
        height: 180.0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
          
            Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                
                CarouselSlider.builder(
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    initialPage: 3,
                    onPageChanged: (int i, CarouselPageChangedReason reason) {
                      bannerProvider.setCurrentIndex(i);
                    },
                  ),
                  itemCount: bannerProvider.bannerListMap.length,
                  itemBuilder: (BuildContext context, int i, int z) {
                    return GestureDetector(
                      onTap: () async {
                        await launchUrl(bannerProvider.bannerListMap[i]["link"]);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                          imageUrl: "${bannerProvider.bannerListMap[i]["path"]}",
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) {
                            return Image.asset('assets/images/default_image.png');
                          },
                          errorWidget: (context, url, error) {
                            return Image.asset('assets/images/default_image.png');
                          },
                        ),
                      )
                    );                  
                  },
                ),

                Positioned(
                  bottom: 12.0,
                  left: 0.0,
                  right: 0.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: bannerProvider.bannerListMap.map((banner) {
                      int index = bannerProvider.bannerListMap.indexOf(banner);
                      return TabPageSelectorIndicator(
                        backgroundColor: index == bannerProvider.currentIndex ? ColorResources.primaryOrange : ColorResources.brown,
                        borderColor: Colors.white,
                        size: 10.0,
                      );
                    }).toList(),
                  ),
                ),
              ],
            )

          ],
        )
      );
    },
  );
}

Widget infoAccount(BuildContext context) {
  return Container(
    height: 90.0,
    margin: EdgeInsets.only(
      top: 15.0,
      left: 40.0,
      right: 40.0,
      bottom: 20.0
    ),
    decoration: BoxDecoration(
      color: ColorResources.white,
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: kElevationToShadow[4],
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          ColorResources.brown.withOpacity(0.8),
          ColorResources.brown,
        ]
      )
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 10.0,
            left: 15.0,
            right: 15.0,
            bottom: 10.0  
          ),
          decoration: BoxDecoration(
            color: ColorResources.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0)
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorResources.black.withOpacity(0.8),
                ColorResources.brown,
              ]
            ),
            boxShadow: kElevationToShadow[4]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Consumer<ProfileProvider>(
                    builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
                      if(profileProvider.profileStatus == ProfileStatus.loading) {
                        return Text("...",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: ColorResources.white
                          ),
                        );
                      } 
                      if(profileProvider.profileStatus == ProfileStatus.error) {
                        return Text("-",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: ColorResources.white
                          ),
                        );
                      }      
                      return Text(profileProvider.userProfile.fullname!,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: ColorResources.white
                        ),
                      );           
                    },
                  ),
                  const SizedBox(height: 5.0),
                  Image.asset("assets/images/logo.png",
                    width: 35.0,
                    height: 35.0,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {

            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(getTranslated("MY_BALANCE", context),
                //   style: robotoRegular.copyWith(
                //     fontSize: Dimensions.fontSizeSmall,
                //     color: ColorResources.white
                //   ),
                // ),
                // const SizedBox(height: 5.0),
                // Consumer<PPOBProvider>(
                //   builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                //     if(ppobProvider.balanceStatus == BalanceStatus.loading) {
                //       return Text("...",
                //         style: robotoRegular.copyWith(
                //           fontSize: Dimensions.fontSizeLarge,
                //           color: ColorResources.white
                //         ),
                //       );
                //     }                             
                //     if(ppobProvider.balanceStatus == BalanceStatus.error) {
                //       return Text("-",
                //         style: robotoRegular.copyWith(
                //           fontSize: Dimensions.fontSizeLarge,
                //           color: ColorResources.white
                //         ),
                //       );
                //     }    
                //     return Text(Helper.formatCurrency(ppobProvider.balance!),
                //       style: robotoRegular.copyWith(
                //         fontSize: Dimensions.fontSizeLarge,
                //         color: ColorResources.white
                //       ),
                //     );           
                //   },
                // )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget ourService(BuildContext context) {

  List<Map<String, dynamic>> menus = [
    {
      "id": 1,
      "name": "Toko Saka",
      "asset": "shop.png",
      "link": ProductScreen()
    },

    {
      "id": 2,
      "name": "Radio",
      "asset": "radio.png",
      "link": const SizedBox()
    },
    {
      "id": 3,
      "name": "Forum",
      "asset": "forum.png",
      "link": FeedIndex(),
    },
    {
      "id": 4,
      "name": "Media",
      "asset": "media.png",
      "link": MediaScreen(),
    },
    {
      "id": 5,
      "name": "PPOB",
      "asset": "ppob.png",
      "link": ComingSoonScreen(title: "PPOB"),
    },
  ];

  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 10.0,
    ),
    height: 100.0,
    child: StaggeredGridView.countBuilder(
      crossAxisCount: 5,
      shrinkWrap: true,
      itemCount: menus.length,
      padding: EdgeInsets.zero,
      crossAxisSpacing: 0.0,
      mainAxisSpacing: 0.0,
      physics: const NeverScrollableScrollPhysics(),
      staggeredTileBuilder: (int i) => const StaggeredTile.count(1, 1.0),
      itemBuilder: (BuildContext context, int i) {
        return Container(
          decoration: BoxDecoration(
            color: ColorResources.white,
            boxShadow: kElevationToShadow[3],
            borderRadius: BorderRadius.circular(10.0)
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 4.0
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                if(menus[i]["name"] == "Radio") {
                  if(Platform.isAndroid) {
                    NS.push(context, RadioScreen());
                  } else {
                    NS.push(context, ComingSoonScreen(title: "Airmen FM"));
                  }
                } else {
                  NS.push(context, menus[i]["link"]);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              
                  Container(
                    width: menus[i]["name"] == "Radio" ? 40.0 : 20.0,
                    height: menus[i]["name"] == "Radio" ? 20.0 : 20.0,
                    child: Image.asset('assets/images/${menus[i]["asset"]}')
                  ),
              
                  SizedBox(height: 8.0),
              
                  Text(menus[i]["name"],
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      color: ColorResources.brown,
                      fontSize: Dimensions.fontSizeExtraSmall
                    ),
                  ),
              
                ],
              ),
            ),
          ),
        );
      },
    )
  );
}

Widget newsWidget(BuildContext context) {
  return Consumer<NewsProvider>(
    builder: (BuildContext context, NewsProvider newsProvider, Widget? child) {
      if(newsProvider.getNewsStatus == GetNewsStatus.loading) {
        return Container(
          margin: EdgeInsets.only(
            left: 25.0,
            right: 25.0,
            bottom: 10.0
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 5, 
            itemBuilder: (BuildContext context, int i) {
              return Container(
                margin: EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: ColorResources.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              );               
            },
          ),
        );
      }
      if(newsProvider.getNewsStatus == GetNewsStatus.empty) {
        return Container(
          height: 150.0,
          child: Text(getTranslated("THERE_IS_NO_DATA", context),
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.black
            ),
          )
        );
      }
      if(newsProvider.getNewsStatus == GetNewsStatus.error) {
        return Container(
          height: 150.0,
          child: Text(getTranslated("THERE_WAS_PROBLEM", context),
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.black
            ),
          )
        );
      }
      return Container(
        margin: EdgeInsets.only(
          top: 10.0,
          left: 25.0,
          right: 25.0,
          bottom: 10.0
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: newsProvider.newsData.length, 
          itemBuilder: (BuildContext context, int i) {
            return Container(
              margin: EdgeInsets.only(
                top: 8.0,
                bottom: 8.0
              ),
              decoration: BoxDecoration(
                color: ColorResources.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: boxShadow,
              ),
              child: Material(
                color: ColorResources.white,
                borderRadius: BorderRadius.circular(15.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  onTap: () {
                    NS.push(context, DetailNewsScreen(
                      contentId: newsProvider.newsData[i].articleId.toString(),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: CachedNetworkImage(
                              imageUrl: "${newsProvider.newsData[i].media![0].path}",
                              fit: BoxFit.fitHeight,
                              width: 80.0,
                              height: 80.0,
                              placeholder: (context, url) {
                                return Image.asset('assets/images/default_image.png');
                              },
                              errorWidget: (context, url, error) {
                                return Image.asset('assets/images/default_image.png');
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 19,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 150.0,
                                child: Text(newsProvider.newsData[i].title!, 
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    fontWeight: FontWeight.w600
                                  )
                                ),
                              ),   
                              Container(
                                width: double.infinity,
                                child: Text(DateFormat('dd MMM yyyy').format(newsProvider.newsData[i].created!), 
                                  textAlign: TextAlign.end,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: ColorResources.dimGrey
                                  ),
                                ),
                              ) 
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      );      
    },
  );
} 

class IconTitleColumnButton extends StatelessWidget {
  final String iconUrl;
  final String title;
  IconTitleColumnButton({
    required this.iconUrl,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50.0,
          height: 50.0,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: ColorResources.white, 
            borderRadius: BorderRadius.circular(44.0)
          ),
          child: Image.asset(iconUrl, fit: BoxFit.scaleDown),
        ),
        Text(title, style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall, 
          color: ColorResources.dimGrey
        )),
      ],
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 140);
    path.quadraticBezierTo(size.width / 2, size.height, 
    size.width, size.height - 140);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {

  Widget child;
  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }

}
