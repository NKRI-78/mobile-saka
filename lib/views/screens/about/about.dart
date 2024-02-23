import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_Resources.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/pdf.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/images.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';  

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  String? pathAboutUsPDF = "";

  @override
  void initState() {
    super.initState();
    fromAsset('assets/pdf/about-us.pdf', 'about-us.pdf').then((f) {
      setState(() {
        pathAboutUsPDF = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      ByteData data = await rootBundle.load(asset);
      Uint8List bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Builder( 
      builder: (BuildContext context) {
        return buildUI();
      },
    ); 
  }  

  Widget buildUI() {
    return Scaffold(
      key: globalKey,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            CustomAppBar(title: getTranslated("ABOUT_US", context)),

            Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 40.0),
                    child: Container(
                      height: 100.0,
                      child: Image.asset(Images.logo)
                    ) 
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 16.0, 
                left: 16.0, 
                right: 16.0
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ColorResources.primaryOrange
                ),
                onPressed: () { 
                  if (pathAboutUsPDF != null || pathAboutUsPDF!.isNotEmpty) {
                    NS.push(context, PDFScreen(
                      path: pathAboutUsPDF!,
                      title: getTranslated("ABOUT_US", context),
                    ));
                  }
                }, 
                child: Text(getTranslated("ABOUT_US", context),
                  style: robotoRegular.copyWith(
                    color: ColorResources.white,
                    fontSize: Dimensions.fontSizeDefault
                  ),
                ),
              )
            ),

          ],
        ),
      ) 
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