import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/images.dart';

import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
import 'package:saka/views/screens/radio/radio.dart';

class MediaScreen extends StatefulWidget {
  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
    
            CustomAppBar(title: "Media"),
    
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
    
                    // Card(
                    //   child: ListTile(
                    //     onTap: () {},
                    //     leading: Image.asset(Images.facebook,
                    //       width: 28.0,
                    //       height: 28.0,
                    //     ),
                    //     title: Text("-",
                    //       style: robotoRegular,
                    //     ),
                    //   ),
                    // ),
                    
                    // Card(
                    //   child: ListTile(
                    //     onTap: () {},
                    //     leading: Image.asset(Images.twitter,
                    //       width: 32.0,
                    //       height: 32.0,
                    //     ),
                    //     title: Text("-",
                    //       style: robotoRegular,
                    //     ),
                    //   ),
                    // ),
    
                    Card(
                      child: ListTile(
                        onTap: () async {
                          try {
                            await launchUrl(Uri.parse('https://www.instagram.com/puspotdirga/'));
                          } catch(e) {
                            print(e);
                          }
                        },
                        leading: Image.asset(Images.instagram,
                          width: 28.0,
                          height: 28.0,
                        ),
                        title: Text("Puspotdirga",
                          style: robotoRegular,
                        ),
                      ),
                    ),
    
                    Card(
                      child: ListTile(
                        onTap: () async {
                          try {
                            await launchUrl(Uri.parse('https://www.youtube.com/channel/UCmGTuRzUU7JkEQ5tKGMZwKw/featured'));
                          } catch(e) {
                            print(e);
                          }
                        },
                        leading: Image.asset(Images.youtube,
                          width: 36.0,
                          height: 36.0,
                        ),
                        title: Text("CIGAR TV",
                          style: robotoRegular,
                        ),
                      ),
                    ),
    
                    Card(
                      child: ListTile(
                        onTap: () {
                          NS.push(context, RadioScreen());
                        },
                        leading: Image.asset(Images.radio,
                          width: 35.0,
                          height: 35.0,
                        ),
                        title: Text("AIRMEN FM 107.9 MHZ",
                          style: robotoRegular,
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            )
    
          ],
        ),
      ),
    );
  }
}