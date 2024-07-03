import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:saka/providers/membernear/membernear.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';
 
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/custom_themes.dart';

class MemberNearScreen extends StatefulWidget {

  @override
  _MemberNearScreenState createState() => _MemberNearScreenState();
}

class _MemberNearScreenState extends State<MemberNearScreen> {
  late MembernearProvider mp;

  Completer<GoogleMapController> mapsC = Completer();

  Future<void> getData() async {
    if(mounted) {
      mp.getMembernear(context);
    }
  }

  @override 
  void initState() {
    super.initState();

    mp = context.read<MembernearProvider>();

    getData();
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
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: ColorResources.brown,
        title: Text(getTranslated("MEMBER_NEARS", context),
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: 30.0,
          bottom: 50.0
        ),
        children: [

          Stack(
            clipBehavior: Clip.none,
            children: [

              // Align(
              //   alignment: Alignment.center,
              //   child: Container(
              //     margin: EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       mainAxisSize: MainAxisSize.max,
              //       children: [
              //         SizedBox.shrink(),
              //         InkWell(
              //           onTap: () {
              //             Navigator.push(context, MaterialPageRoute(builder: (context) {
              //               return PlacePicker(
              //                 apiKey: AppConstants.apiKeyGmaps,
              //                 useCurrentLocation: true,
              //                 onPlacePicked: (result) async {        
              //                   await context.read<MembernearProvider>().updateMembernear(context, result);              
              //                   Navigator.of(context).pop();
              //                 },
              //                 autocompleteLanguage: "id",
              //                 initialPosition: LatLng(0.0, 0.0),
              //               );
              //             }));
              //           },
              //           child: Text(getTranslated("SET_LOCATION", context),
              //             style: robotoRegular.copyWith(
              //               color: ColorResources.primaryOrange,
              //               fontSize: Dimensions.fontSizeSmall
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),

              Consumer<MembernearProvider>(
                builder: (BuildContext context, MembernearProvider val, Widget? child) {
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: 200.0,
                      margin: EdgeInsets.only(
                        top: 60.0, 
                        left: 16.0, 
                        right: 16.0
                      ),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                        myLocationEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            double.tryParse(Helper.prefs!.getString("lat").toString()) ?? 0.0, 
                            double.tryParse(Helper.prefs!.getString("lng").toString()) ?? 0.0
                          ),
                          zoom: 15.0,
                        ),
                        markers: Set.from(val.markers),
                        onMapCreated: (GoogleMapController controller) {
                          mapsC.complete(controller);
                          val.googleMapC = controller;
                        },
                      ),
                    )
                  );
                },
              ),

              Consumer<MembernearProvider>(
                builder: (BuildContext context, MembernearProvider membernearProvider, Widget? child) {
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: 90.0,
                      margin: EdgeInsets.only(top: 260.0, left: 16.0, right: 16.0),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: ColorResources.white
                        ),
                        child: Text(membernearProvider.membernearAddress,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall
                          )
                        ),
                      )
                    )
                  ); 
                },
              ),
            ],
          ),

          Consumer<MembernearProvider>(
            builder: (BuildContext context, MembernearProvider membernearProvider, Widget? child) {
              if(membernearProvider.membernearStatus == MembernearStatus.loading) {
                return Container(
                  margin: EdgeInsets.only(top: 150.0),
                  child: Loader(
                    color: ColorResources.primaryOrange,
                  ),
                );
              }
              if(membernearProvider.membernearStatus == MembernearStatus.empty) {
                return Container(
                  margin: EdgeInsets.only(top: 150.0),
                  child: Center(
                    child: Text(getTranslated("NO_MEMBER_AVAILABLE", context),
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall
                      ),
                    ),
                  ),
                );
              }
              if(membernearProvider.membernearStatus == MembernearStatus.error) {
                return Container(
                  margin: EdgeInsets.only(top: 150.0),
                  child: Center(
                    child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall
                      ),
                    ),
                  ),
                );
              }
            
              return Container(
                margin: EdgeInsets.only(
                  top: 30.0, 
                  left: 16.0, 
                  right: 16.0
                ),
                width: double.infinity,
                height: 300.0,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.2 / 1.5,
                    mainAxisSpacing: 10.0,
                  ), 
                  padding: EdgeInsets.only(
                    top: 20.0,
                    bottom: 60.0
                  ),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: membernearProvider.membernearData.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                      margin: EdgeInsets.only(top: 5.0, left: i == 0 ? 6.0 : 5.0, right: 5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: CachedNetworkImage(
                              imageUrl: "${membernearProvider.membernearData[i].avatarUrl}",
                              imageBuilder: (BuildContext context, ImageProvider imageProvider) => CircleAvatar(
                                radius: 30.0,
                                backgroundImage: imageProvider, 
                              ),
                              placeholder: (BuildContext context, String url) => CircleAvatar(
                                backgroundColor: ColorResources.white,
                                radius: 30.0,
                                child: Loader(
                                  color: ColorResources.primaryOrange,
                                ),
                              ),
                              errorWidget: (BuildContext context, String url, dynamic error) => Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorResources.black,
                                    width: 0.5
                                  ),
                                  borderRadius: BorderRadius.circular(50.0)
                                ),
                                child: SvgPicture.asset('assets/images/svg/user.svg',
                                  width: 48.0,
                                  height: 48.0,
                                ),
                              )
                            ),
                          ),
                          Container(
                            width: 100.0,
                            margin: EdgeInsets.only(top: 4.0),
                            child: Text(membernearProvider.membernearData[i].fullname,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                          ),
                          Container(
                            width: 90.0,
                            child: Text('+- ${double.parse(membernearProvider.membernearData[i].distance) != 0.0 
                              ? double.parse(membernearProvider.membernearData[i].distance) > 1000 
                              ? (double.parse(membernearProvider.membernearData[i].distance) / 1000).toStringAsFixed(1) 
                              : double.parse(membernearProvider.membernearData[i].distance).toStringAsFixed(1) : 0} ${double.parse(membernearProvider.membernearData[i].distance) != 0.0 ? double.parse(membernearProvider.membernearData[i].distance) > 1000 
                              ? 'KM' 
                              : 'Meters' : 0}',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                color:Theme.of(context).hintColor,
                                fontSize: Dimensions.fontSizeSmall
                              )
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
    
        ],
      ),
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