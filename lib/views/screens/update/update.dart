import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/screens/dashboard/dashboard.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override 
  void initState() {
    super.initState();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: ColorResources.backgroundColor,
          key: globalKey,
          appBar: AppBar(
            backgroundColor: ColorResources.backgroundColor,
            elevation: 0.0,
            leading: CupertinoNavigationBarBackButton(
              color: ColorResources.brown,
              onPressed: () {
                NS.push(context, DashboardScreen());
              },
            ),
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
      
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
      
                        Image.asset("assets/images/update/update.jpg",
                          width: 250.0,
                          height: 250.0,
                        ),
      
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("NEW VERSION AVAILABLE",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w600,
                                color: ColorResources.black
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            if(Platform.isAndroid)
                              Text("Versi terbaru Saka tersedia di Google Play Store",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.black
                                ),
                              ),
                            if(Platform.isIOS)
                              Text("Versi terbaru Saka tersedia di App Store",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.black
                                ),
                              ),
                          ]
                        ),
                      ],
                    ),
                  ),
      
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      onTap: () async {
                        final newVersion = NewVersionPlus(
                          androidId: 'com.inovasi78.saka',
                          iOSId: 'com.inovatif78.saka'
                        );
                        if(Platform.isAndroid) {
                          newVersion.launchAppStore("https://play.google.com/store/apps/details?id=com.inovasi78.saka");
                        } else {
                          newVersion.launchAppStore("https://apps.apple.com/id/app/saka-dirgantara/id1625616956");
                        }
                      },
                      isBorderRadius: false,
                      isBorder: false,
                      isBoxShadow: false,
                      btnColor: ColorResources.brown,
                      btnTxt: "Update",
                    )
                  )
      
                ],
              );
            },
          )
        ),
      ),
    );
  }
}