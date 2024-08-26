import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:geolocator/geolocator.dart';

import 'package:saka/providers/splash/splash.dart';
import 'package:saka/providers/auth/auth.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/images.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/screens/auth/sign_in.dart';
import 'package:saka/views/screens/dashboard/dashboard.dart';
import 'package:saka/views/screens/onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

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
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),
                      
                      const SizedBox(height: 8.0),

                      Text("information Saka Dirgantara collects.",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("Some examples of data Saka Dirgantara\n collects and users are:",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("● Your Forum Information & Content",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("This may include any information you share with us,\nfor example; your create a post and another users\ncan like your post or comment also you can delete\nyour post.",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("● Photos, Videos & Documents",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("This may include your can post on media\nphotos, videos, or documents",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("● Embedded Links",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.white
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Text("This may include your can post on link\nsort of news, etc",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
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
                          btnColor: ColorResources.brown,
                          btnTextColor: ColorResources.white,
                          onTap: () {
                            Helper.prefs!.setBool("isAccept", true);
                            NS.pop(ctx);
                          }, 
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
    });
  }

  @override
  void initState() {
    super.initState();

    context.read<SplashProvider>().initConfig().then((val) {
      if(val) {
        Timer(Duration(seconds: 2), () {
          if (context.read<AuthProvider>().isLoggedIn()) {
            NS.pushReplacement(context, DashboardScreen());
          } else {
            if(context.read<SplashProvider>().isSkipOnboarding()) {
              NS.pushReplacement(context,  SignInScreen());
            } else {
              NS.push(context, OnBoardingScreen(
                indicatorColor: ColorResources.grey, 
                selectedIndicatorColor: ColorResources.primaryOrange
              ));
            }
          }
        });
      }
    });

    Future.delayed(Duration.zero, () async {

      await Geolocator.requestPermission();

      if(mounted) {
        if(Helper.prefs!.getBool("isAccept") == null) {
          termsAndCondition();
        }
      }

      PackageInfo info = await PackageInfo.fromPlatform();
      
      setState(() {
        packageInfo = info;
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width:  MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: ColorResources.splash,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            
            Positioned(
              top: 50.0,
              left: 0,
              right: 0,
              child: Container(
                child: Image.asset(Images.logo,
                  width: 120.0,
                  height: 120.0,
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).size.height / 3,
              left: 0,
              right: 0,
              child: Container(
                child: Image.asset(
                  Images.splash,
                  height: MediaQuery.of(context).size.height * .4,
                ),
              ),
            ),

            Positioned(
              bottom: 120.0,
              left: 0,
              right: 0,
              child: Text("Poweredby:",
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  color: ColorResources.white,
                  fontSize: Dimensions.fontSizeSmall
                ),
              ),
            ),

            Positioned(
              bottom: 50.0,
              left: 0,
              right: 0,
              child: Container(
                height: 75.0,
                child: Image.asset(Images.logo_inovasi78),
              ),
            ),

            Positioned(
              bottom: 15.0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [    
                  Text("${packageInfo.version}",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      fontWeight: FontWeight.normal,
                      color: ColorResources.white
                    ),
                  ),
                  AppConstants.switchTo == "prod"
                  ? SizedBox(height: 20.0)
                  : SizedBox(height: 3.0),
                  AppConstants.switchTo == "prod" 
                  ? Container() 
                  : Text("DEV", 
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      fontWeight: FontWeight.normal,
                      color: ColorResources.white
                    ),
                  )
                ],
              ),
            ),
            
          ],
        )
      )
    );
  }
}
