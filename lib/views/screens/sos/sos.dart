import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/sos/sos.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/box_shadow.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/images.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/screens/dashboard/dashboard.dart';
import 'package:saka/views/screens/sos/detail.dart';

class SosScreen extends StatefulWidget {
  final bool isBacButtonExist;
  const SosScreen({Key? key, this.isBacButtonExist = true}) : super(key: key);

  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  void getData() {
    if(mounted) {
      context.read<SosProvider>().initSosList();
    }
  }

  Future<bool> onWillPop() {
    NS.pop(context);
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override 
  void dispose() {
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: ColorResources.brown,
          title: Text("SOS",
            style: robotoRegular.copyWith(
              color: ColorResources.white,
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.w600
            ),
          ),
          leading: CupertinoNavigationBarBackButton(
            color: ColorResources.white,
            onPressed: () {
              NS.push(context, DashboardScreen());
            },
          )
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.zero,
          children: [
            
            Stack(
              clipBehavior: Clip.none,
              children: [

                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        getSosList(context, getTranslated("AMBULANCE", context), Images.ambulance, "${getTranslated("I_NEED_HELP_AMBULANCE", context)} ${getTranslated("AMBULANCE", context)}" ),
                        SizedBox(height: 10.0),
                        getSosList(context, getTranslated("ACCIDENT", context), Images.strike, "${getTranslated("I_NEED_HELP", context)} ${getTranslated("ACCIDENT", context)}"),
                        SizedBox(height: 10.0),
                        getSosList(context, getTranslated("WILDFIRE", context), Images.fire, "${getTranslated("I_NEED_HELP", context)} ${getTranslated("WILDFIRE", context)}" ),
                        SizedBox(height: 10.0),
                        getSosList(context, getTranslated("DISASTER", context), Images.disaster, "${getTranslated("I_NEED_HELP", context)} ${getTranslated("DISASTER", context)} "),
                      ],
                    ),
                  ),
                )

              ],
            ),

          ],
        )
      )
    );     
  }
}

Widget getSosList(BuildContext context, String label, String images, String content) {
  return Container(
    width: double.infinity,
    height: 80.0,
    decoration: BoxDecoration(
      color: ColorResources.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: boxShadow
    ),
    margin: EdgeInsets.only(
      top: 10.0, 
      left: 16.0, 
      right: 16.0
    ),
    child: Material(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {
          NS.push(context, SosDetailScreen(
            label: label, 
            content: content
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0
                ),
                child: Image.asset(images,
                  height: 30.0,
                  width: 30.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                    style: robotoRegular.copyWith(
                      color: ColorResources.primaryOrange,
                      fontSize: Dimensions.fontSizeSmall
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(content,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall
                    ),
                  )  
                ],
              ),
            ],
          ),
        ),
      ),
    )
  );
}
