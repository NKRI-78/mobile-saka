import 'package:flutter/material.dart';
// import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart' as fad;
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/providers/sos/sos.dart';

import 'package:saka/utils/images.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/localization/language_constraints.dart';

class SosDetailScreen extends StatefulWidget {
  final String label;
  final String content;
  final String obj;

  SosDetailScreen({
    required this.label,
    required this.content,
    required this.obj
  });

  @override
  State<SosDetailScreen> createState() => _SosDetailScreenState();
}

class _SosDetailScreenState extends State<SosDetailScreen> {
  
  late Location location;

  @override
  void initState() {
    location = Location();
    super.initState();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ColorResources.white,  
          ),
        ),
        backgroundColor: ColorResources.brown,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [

          ClipPath(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 160.0,
              color: ColorResources.brown,
            ),
            clipper: CustomClipPath(),
          ),

          Container(
            margin: EdgeInsets.only(top: 130.0),
            alignment: Alignment.center,
            child: ListView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.zero,
              children: [
                
                Center(
                  child: Text("SOS (${widget.label})",
                    style: robotoRegular.copyWith(
                      color: ColorResources.primaryOrange,
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.w600
                    )
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  width: 80.0,
                  height: 80.0,
                  child: Image.asset(Images.sos_detail),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                  child: Text( getTranslated(widget.content, context),
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: ConfirmationSlider(
                    foregroundColor: ColorResources.brown,
                    text: getTranslated("SLIDE_TO_CONFIRM", context),
                    onConfirmation: () async {
                      // bool isActive = await location.serviceEnabled();
                      // if(!isActive) {
                      //   AndroidIntent intent = AndroidIntent(
                      //     action: 'android.settings.LOCATION_SOURCE_SETTINGS'
                      //   );
                      //   intent.launch();
                      // } else {
                        fad.showAnimatedDialog(
                          barrierDismissible: true,
                          context: context, 
                          builder: (BuildContext context) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    left: 25.0,
                                    right: 25.0
                                  ),
                                  child: fad.CustomDialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0.0,
                                    minWidth: 180.0,
                                    child: Transform.rotate(
                                      angle: 0.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color: ColorResources.white,
                                            width: 1.0
                                          )
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Transform.rotate(
                                                  angle: 56.5,
                                                  child: Container(
                                                    margin: const EdgeInsets.all(5.0),
                                                    height: 270.0,
                                                    decoration: BoxDecoration(
                                                      color: ColorResources.white,
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(
                                                      top: 10.0,
                                                      left: 25.0,
                                                      right: 25.0,
                                                      bottom: 10.0
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [

                                                        Image.asset("assets/imagesv2/ambulance.png",
                                                          width: 50.0,
                                                          height: 50.0,
                                                        ),
                                          
                                                        const SizedBox(height: 15.0),
                                                        
                                                        Text(getTranslated("AGREEMENT_SOS", context),
                                                          textAlign: TextAlign.center,
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeDefault,
                                                            color: ColorResources.black
                                                          )
                                                        ),
                                          
                                                        const SizedBox(height: 8.0),
                                          
                                                        Text(getTranslated("INFO_SOS", context),
                                                          textAlign: TextAlign.center,
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            color: ColorResources.black
                                                          )
                                                        ),
                                          
                                                        const SizedBox(height: 15.0),
                                          
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                          
                                                            Expanded(
                                                              child: CustomButton(
                                                                isBorderRadius: true,
                                                                isBoxShadow: true,
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                btnColor: ColorResources.error,
                                                                isBorder: false,
                                                                onTap: () {
                                                                  Navigator.of(context).pop();
                                                                }, 
                                                                btnTxt: getTranslated("CANCEL", context)
                                                              ),
                                                            ),
                                          
                                                            const SizedBox(width: 8.0),
                                          
                                                            Expanded(
                                                              child: CustomButton(
                                                                isBorderRadius: true,
                                                                isBoxShadow: true,
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                btnColor: ColorResources.success,
                                                                onTap: () async {
                                                                  await context.read<SosProvider>().sendSos(
                                                                    context, 
                                                                    label: widget.label,
                                                                    content: widget.content,
                                                                    obj: widget.obj
                                                                  );
                                                                }, 
                                                                btnTxt: context.watch<SosProvider>().sosStatus == SosStatus.loading  
                                                                ? "..." 
                                                                : getTranslated("CONTINUE", context)
                                                              ),
                                                            )
                                          
                                                          ],
                                                        ),
                                          
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ) 
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ); 
                          }
                        );
                      }
                    // },
                  ),
                )
              ] 
            ),  
          )

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