// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:draggable_float_widget/draggable_float_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/inbox/inbox.dart';
import 'package:saka/providers/banner/banner.dart';
import 'package:saka/providers/profile/profile.dart';
import 'package:saka/providers/news/news.dart';
import 'package:saka/providers/location/location.dart';
import 'package:saka/providers/auth/auth.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/box_shadow.dart';

import 'package:saka/views/basewidgets/drawer/drawer.dart';

import 'package:saka/views/screens/feed/index.dart';
import 'package:saka/views/screens/membernear/membernear.dart';
import 'package:saka/views/screens/comingsoon/comingsoon.dart';
import 'package:saka/views/screens/radio/radio.dart';
import 'package:saka/views/screens/news/detail.dart';
import 'package:saka/views/screens/eventjoin/event_join.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showAllNews = false;

  // late EcommerceProvider ep;
  late NewsProvider np;
  late LocationProvider lp;
  late InboxProvider ip;
  late BannerProvider bp;
  late ProfileProvider pp;
  late AuthProvider ap;

  Future<void> getData() async {
    if (mounted) {
      ip.getInbox(context, "sos");
    }
    if (mounted) {
      bp.getBanner(context);
    }
    if (mounted) {
      pp.getUserProfile(context);
    }
    if (mounted) {
      np.getNews(context);
    }
    if (mounted) {
      ap.mascot(context);
    }
    if (mounted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      lp.getCurrentPosition(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      Helper.prefs?.setString("lat", position.latitude.toString());
      Helper.prefs?.setString("lng", position.longitude.toString());
    }
    // if (!mounted) return;
    // await ep.getBalance();
  }

  @override
  void initState() {
    super.initState();

    np = context.read<NewsProvider>();
    ip = context.read<InboxProvider>();
    bp = context.read<BannerProvider>();
    pp = context.read<ProfileProvider>();
    lp = context.read<LocationProvider>();
    ap = context.read<AuthProvider>();
    // ep = context.read<EcommerceProvider>();

    if (mounted) {
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
                ap.mascot(context);
                // ep.getBalance();
              });
            },
            child: CustomScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverAppBar(
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  backgroundColor: ColorResources.transparent,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    "SAKA DIRGANTARA",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.brown,
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState!.openDrawer();
                        },
                        child: SvgPicture.asset(
                          "assets/imagesv2/svg/hamburger-menu.svg",
                          color: ColorResources.brown,
                        ),
                      ),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    infoAccount(context),
                    banner(context),
                    ourService(context),
                    Container(
                      margin: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: Consumer<NewsProvider>(
                        builder: (context, newsProvider, child) {
                          final hasMoreThanFive =
                              newsProvider.newsData.length > 5;
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                getTranslated("NEWS", context),
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.brown,
                                ),
                              ),
                              const Spacer(),
                              if (hasMoreThanFive)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showAllNews = !_showAllNews;
                                    });
                                  },
                                  child: Text(
                                    _showAllNews ? "Show less" : "See all",
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w600,
                                      color: ColorResources.brown,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    newsWidget(context, showAll: _showAllNews),
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      alignment: Alignment.center,
                      child: Text(
                        "@ PT Inovatif 78",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.brown,
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          context.watch<AuthProvider>().mascotStatus == MascotStatus.loading
              ? const SizedBox()
              : context.read<AuthProvider>().isShow == 1
              ? DraggableFloatWidget(
                  width: 120.0,
                  height: 120.0,
                  config: const DraggableFloatWidgetBaseConfig(
                    isFullScreen: false,
                    initPositionYInTop: false,
                    borderRight: 5.0,
                    initPositionXInLeft: false,
                    initPositionYMarginBorder: 100.0,
                  ),
                  onTap: () {
                    NS.push(context, EventScannerJoinScreen());
                  },
                  child: BounceIn(
                    preferences: AnimationPreferences(
                      autoPlay: AnimationPlayStates.Loop,
                    ),
                    child: Image.asset("assets/images/ic-jambore.png"),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

Widget banner(BuildContext context) {
  return Consumer<BannerProvider>(
    builder:
        (BuildContext context, BannerProvider bannerProvider, Widget? child) {
          if (bannerProvider.bannerStatus == BannerStatus.loading) {
            return Container(
              margin: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                left: 25.0,
                right: 25.0,
              ),
              width: double.infinity,
              height: 180.0,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorResources.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            );
          }

          if (bannerProvider.bannerStatus == BannerStatus.empty) {
            return SizedBox(
              width: double.infinity,
              height: 180.0,
              child: Center(
                child: Text(
                  getTranslated("NO_BANNER_AVAILABLE", context),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.black,
                  ),
                ),
              ),
            );
          }

          if (bannerProvider.bannerStatus == BannerStatus.error) {
            return SizedBox(
              width: double.infinity,
              height: 180.0,
              child: Center(
                child: Text(
                  getTranslated("THERE_WAS_PROBLEM", context),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.black,
                  ),
                ),
              ),
            );
          }

          return Container(
            margin: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 25.0,
              right: 25.0,
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
                        onPageChanged:
                            (int i, CarouselPageChangedReason reason) {
                              bannerProvider.setCurrentIndex(i);
                            },
                      ),
                      itemCount: bannerProvider.bannerListMap.length,
                      itemBuilder: (BuildContext context, int i, int z) {
                        return GestureDetector(
                          onTap: () async {
                            await launchUrl(
                              bannerProvider.bannerListMap[i]["link"],
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${bannerProvider.bannerListMap[i]["path"]}",
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) {
                                return Image.asset(
                                  'assets/images/default_image.png',
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  'assets/images/default_image.png',
                                );
                              },
                            ),
                          ),
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
                          int index = bannerProvider.bannerListMap.indexOf(
                            banner,
                          );
                          return TabPageSelectorIndicator(
                            backgroundColor:
                                index == bannerProvider.currentIndex
                                ? ColorResources.primaryOrange
                                : ColorResources.brown,
                            borderColor: Colors.white,
                            size: 10.0,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
  );
}

Widget infoAccount(BuildContext context) {
  return Container(
    height: 70.0,
    margin: EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
    child: Container(
      padding: EdgeInsets.only(
        top: 10.0,
        left: 15.0,
        right: 15.0,
        bottom: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Consumer<ProfileProvider>(
        builder:
            (
              BuildContext context,
              ProfileProvider profileProvider,
              Widget? child,
            ) {
              if (profileProvider.profileStatus == ProfileStatus.loading) {
                return Text(
                  "...",
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: ColorResources.white,
                  ),
                );
              }
              if (profileProvider.profileStatus == ProfileStatus.error) {
                return Text(
                  "-",
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: ColorResources.white,
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profileProvider.userProfile.fullname!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(
                      overflow: TextOverflow.fade,
                      color: ColorResources.black,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),

                  Text(
                    profileProvider.userProfile.lanud!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(
                      overflow: TextOverflow.fade,
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.black,
                    ),
                  ),
                ],
              );
            },
      ),
    ),
  );
}

Widget ourService(BuildContext context) {
  final List<Map<String, dynamic>> menus = [
    {"id": 1, "name": "Radio", "asset": "radio.png", "link": const SizedBox()},
    {"id": 2, "name": "Forum", "asset": "forum.png", "link": FeedIndex()},
    {
      "id": 3,
      "name": "Nearby",
      "asset": "nearby.png",
      "link": MemberNearScreen(),
    },
  ];

  const double maxContentWidth = 420;

  Widget menuItem(BuildContext context, Map<String, dynamic> m) {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: ColorResources.white,
        boxShadow: kElevationToShadow[3],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            if (m["name"] == "Radio") {
              if (Platform.isAndroid) {
                NS.push(context, RadioScreen());
              } else {
                NS.push(context, const ComingSoonScreen(title: "Airmen FM"));
              }
            } else {
              NS.push(context, m["link"]);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/${m["asset"]}', width: 20, height: 20),
              const SizedBox(height: 8),
              Text(
                m["name"],
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  color: ColorResources.brown,
                  fontSize: Dimensions.fontSizeExtraSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final double width = constraints.maxWidth > maxContentWidth
          ? maxContentWidth
          : constraints.maxWidth;

      return Center(
        child: SizedBox(
          width: width,
          height: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: menus.map((m) => menuItem(context, m)).toList(),
          ),
        ),
      );
    },
  );
}

Widget newsWidget(BuildContext context, {bool showAll = false}) {
  return Consumer<NewsProvider>(
    builder: (BuildContext context, NewsProvider newsProvider, Widget? child) {
      if (newsProvider.getNewsStatus == GetNewsStatus.loading) {
        return Container(
          margin: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 5,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
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
      if (newsProvider.getNewsStatus == GetNewsStatus.empty) {
        return Center(
          child: SizedBox(
            height: 150.0,
            child: Text(
              getTranslated("THERE_IS_NO_DATA", context),
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.black,
              ),
            ),
          ),
        );
      }
      if (newsProvider.getNewsStatus == GetNewsStatus.error) {
        return Center(
          child: SizedBox(
            height: 150.0,
            child: Text(
              "Hmm... Mohon tunggu yaa",
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.black,
              ),
            ),
          ),
        );
      }
      final newsItems = showAll
          ? newsProvider.newsData
          : newsProvider.newsData.take(5).toList();
      return Container(
        margin: EdgeInsets.only(left: 25.0, right: 25.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: newsItems.length,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                    NS.push(
                      context,
                      DetailNewsScreen(
                        contentId: newsItems[i].articleId.toString(),
                      ),
                    );
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
                              imageUrl: "${newsItems[i].media![0].path}",
                              fit: BoxFit.fitHeight,
                              width: 80.0,
                              height: 80.0,
                              placeholder: (context, url) {
                                return Image.asset(
                                  'assets/images/default_image.png',
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  'assets/images/default_image.png',
                                );
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
                              SizedBox(
                                width: 150.0,
                                child: Text(
                                  newsItems[i].title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  DateFormat(
                                    'dd MMM yyyy',
                                  ).format(newsItems[i].created!),
                                  textAlign: TextAlign.end,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: ColorResources.dimGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
