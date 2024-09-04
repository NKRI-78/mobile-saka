import 'package:package_info_plus/package_info_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:saka/providers/auth/auth.dart';
import 'package:saka/providers/profile/profile.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/animated/animated_custom_dialog.dart' as cw;

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/screens/about/about.dart';
import 'package:saka/views/screens/comingsoon/comingsoon.dart';
import 'package:saka/views/screens/more/widgets/signout.dart';
import 'package:saka/views/screens/setting/setting.dart';
import 'package:saka/views/screens/auth/sign_in.dart';
import 'package:saka/views/screens/profile/profile.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(60.0)
          ),
          child: Consumer<ProfileProvider>(
            builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
              if(profileProvider.profileStatus == ProfileStatus.loading) {
                return Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    color: ColorResources.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/default_avatar.jpg')
                    )
                  ),
                );
              }
              if(profileProvider.profileStatus == ProfileStatus.error) {
                return Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    color: ColorResources.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/default_avatar.jpg')
                    )
                  ),
                );
              }
              return CachedNetworkImage(
                imageUrl: "${profileProvider.userProfile.profilePic}",
                imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                  return Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider
                      )
                    ),
                  );  
                },
                placeholder: (BuildContext context, String url) {
                  return Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      color: ColorResources.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/default_avatar.jpg')
                      )
                    ),
                  );
                },
                errorWidget: (BuildContext context, String url, dynamic error) {
                  return Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      color: ColorResources.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/default_avatar.jpg')
                      )
                    ),
                  );             
                }, 
              );         
            },
          ),
        )
      )
    );
  }
}

class DrawerWidget extends StatefulWidget {

  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  void termsAndCondition() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (BuildContext ctx, Animation<double> double, _) {
        return Center(
          child: Material(
            color: ColorResources.transparent,
            child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            height: 580.0,
            decoration: BoxDecoration(
              color: ColorResources.brown, 
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 0.0, 
                      left: 0.0
                    ),
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset("assets/images/background/shading-top-left.png")
                    )
                  )
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 0.0, 
                      right: 0.0
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset("assets/images/background/shading-right.png")
                    )
                  )
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 200.0, right: 0.0),
                    child: Image.asset("assets/images/background/shading-right-bottom.png")
                  )
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text("I'ts important that you understand what",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),
                      
                      const SizedBox(height: 8.0),

                      Text("information Saka Dirgantara collects.",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("Some examples of data Saka Dirgantara\n collects and users are:",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("● Your Forum Information & Content",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("This may include any information you share with us,\nfor example; your create a post and another users\ncan like your post or comment also you can delete\nyour post.",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("● Photos, Videos & Documents",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("This may include your can post on media\nphotos, videos, or documents",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("● Embedded Links",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("This may include your can post on link\nsort of news, etc",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),
                    ]
                  ) 
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          bottom: 30.0,
                        ),
                        child: CustomButton(
                          isBorderRadius: true,
                          onTap: () {
                            Helper.prefs!.setBool("isAccept", true);
                            NS.pop(ctx);
                          }, 
                          fontSize: Dimensions.fontSizeSmall,
                          btnColor: ColorResources.brown,
                          btnTextColor: ColorResources.white,
                          btnTxt: "Agree"
                        ),
                      )
                    ],
                  ) 
                )
              ],
            ),
          ),
        )
      );
    },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }
        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  @override 
  void initState() {
    super.initState();

    initPackageInfo();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorResources.brown,
                ColorResources.primaryOrange,
              ]
            )
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeaderWidget(),
              drawerUserDisplayAccount(context),
              Consumer<AuthProvider>(
                builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
                  if(authProvider.isLoggedIn()) {
                    return Container(
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.only(
                        top: 10.0, 
                        left: 30.0, 
                        right: 10.0
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text("Version ${packageInfo.version}",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w600,
                                color: ColorResources.white
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          drawerItems(context, AboutUsScreen(), "aboutus", "assets/images/svg/aboutus.svg", getTranslated("ABOUT_US", context)),
                          SizedBox(height: 10.0),
                          Divider(
                            color: ColorResources.brown,
                            height: 1.0,
                            thickness: 0.2
                          ),
                          SizedBox(height: 10.0),
                          drawerItems(context, ProfileScreen(), "profil", "assets/images/svg/user.svg", getTranslated("PROFILE", context)),
                          // SizedBox(height: 10.0),
                          // Divider(
                          //   color: ColorResources.brown,
                          //   height: 1.0,
                          //   thickness: 0.2
                          // ),
                          // SizedBox(height: 10.0),
                          // Consumer<StoreProvider>(
                          //   builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                          //     return storeProvider.sellerStoreStatus == SellerStoreStatus.loading 
                          //     ? drawerItems(context, Container(), "store", "assets/imagesv2/svg/store.svg",  "...")               
                          //     : drawerItems(context, Container(), "store", "assets/imagesv2/svg/store.svg", storeProvider.sellerStoreStatus == SellerStoreStatus.empty ? getTranslated("OPEN_STORE", context) : getTranslated("MY_STORE", context));                
                          //   },
                          // ),
                          SizedBox(height: 10.0),
                          Divider(
                            color: ColorResources.brown,
                            height: 1.0,
                            thickness: 0.2,
                          ),
                          SizedBox(height: 10.0),
                          drawerItems(context, SettingScreen(), "setting", "assets/imagesv2/svg/settings.svg", getTranslated("SETTINGS", context)),
                          SizedBox(height: 10.0),
                          Divider(
                            color: ColorResources.brown,
                            height: 1.0,
                            thickness: 0.2,
                          ),
                          SizedBox(height: 10.0),
                          drawerItems(context, Container(), "tos", "assets/imagesv2/svg/support.svg", getTranslated("TERMS_OF_CONDITION", context)),
                          SizedBox(height: 10.0),
                          // drawerItems(context, Container(), "cashout", "assets/imagesv2/svg/cashout.svg", getTranslated("CASH_OUT", context)),
                          // SizedBox(height: 10.0),
                          // Divider(
                          //   color: ColorResources.brown,
                          //   height: 1.0,
                          //   thickness: 0.2,
                          // ),
                          // SizedBox(height: 10.0),
                          Divider(
                            color: ColorResources.brown,
                            height: 1.0,
                            thickness: 0.2,
                          ),
                          SizedBox(height: 10.0),
                          drawerItems(context, Container(), "bantuan", "assets/imagesv2/svg/support.svg", getTranslated("SUPPORT", context)),
                          SizedBox(height: 10.0),
                          Divider(
                            color: ColorResources.brown,
                            height: 1.0,
                            thickness: 0.2,
                          ),
                          SizedBox(height: 10.0),
                          drawerItems(context, Container(), "logout", "assets/imagesv2/svg/logout.svg", getTranslated("LOGOUT", context)),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                        child: TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen())),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)
                            ),
                            backgroundColor: ColorResources.white
                          ),
                          child: Text(getTranslated("SIGN_IN", context),
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget drawerUserDisplayAccount(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10.0, 
        bottom: 10.0
      ),
      child: Consumer<ProfileProvider>(
        builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(profileProvider.profileStatus == ProfileStatus.loading 
                ? "..." 
                : profileProvider.profileStatus == ProfileStatus.error 
                ? "-" 
                : profileProvider.userProfile.fullname!,
                style: robotoRegular.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.fontSizeLarge,
                  color: ColorResources.white
                )
              ),
              SizedBox(
                width: 150.0,
                child: Text(profileProvider.profileStatus == ProfileStatus.loading 
                  ? "..." 
                  : profileProvider.profileStatus == ProfileStatus.error 
                  ? "-" 
                  : profileProvider.getUserEmail,
                  maxLines: 1,
                  style: robotoRegular.copyWith(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.white
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget drawerUserDisplayName(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Consumer<ProfileProvider>(
        builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(profileProvider.profileStatus == ProfileStatus.loading 
                ? "..." 
                : profileProvider.profileStatus == ProfileStatus.error 
                ? "..." 
                : profileProvider.userProfile.fullname!,
                style: robotoRegular.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorResources.primaryOrange
                )
              ),
            ],
          );
        },
      ),
    );
  }

  Widget drawerItems(BuildContext context, Widget widget, String menu, String svg, String title) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0),
      child:  ListTile(
        dense: true,
        isThreeLine: false,
        visualDensity: VisualDensity(
          horizontal: 0.0, 
          vertical: 0.0
        ),
        minVerticalPadding: 0.0,
        minLeadingWidth: 0.0,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
        onTap: () async { 
          if(menu == "logout") {
            cw.showAnimatedDialog(context,
              SignOutConfirmationDialog(),
              isFlip: true
            );
          } else if(menu == "aboutus") {
            NS.push(context, AboutUsScreen());
          } else if(menu == "cashout") {
            NS.push(context, ComingSoonScreen(
              title: "Cashout",
              key: UniqueKey(),
            ));
          } else if(menu == "bantuan") {
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: 'customercare@inovatiftujuh8.com',
              queryParameters: {
                'subject': '',
                'body': ''
              },
            );
            await launchUrl(emailLaunchUri);
          }
          else if(menu == "tos") {
            termsAndCondition();
          } else {
            NS.push(context, widget);
          }
        },  
        title: Text(title,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: ColorResources.white
          )
        ),
        leading: Container(
          width: 20.0,
          height: 20.0,
          margin: EdgeInsets.only(left: 20.0),
          child: SvgPicture.asset(svg,
            color: ColorResources.white
          ),
        ),
      )
    );
  }
  
}