import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/appbar/expanded_appbar.dart';
import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/dialog/animated/animated.dart' as fad;

import 'package:saka/views/screens/auth/change_password.dart';
import 'package:saka/views/screens/setting/widgets/language_dialog.dart';

import 'package:saka/localization/language_constraints.dart';

class SettingScreen extends StatefulWidget {

  @override
  _SettingscreenState createState() => _SettingscreenState();
}

class _SettingscreenState extends State<SettingScreen> {
  
  @override
  Widget build(BuildContext context) {

    return CustomExpandedAppBar(
      title: getTranslated('SETTINGS', context), 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [

          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.zero,
              children: [

                // Consumer<PPOBProvider>(
                //   builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [

                //         ppobProvider.getGlobalPaymentMethodName != "" 
                //         && ppobProvider.getGlobalPaymentAccount != ""
                //         ? Container(
                //             margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                //             child: Row(
                //               children: [
                //                 Container(
                //                   child: Text(getTranslated("DESTINATION_CASHOUT", context),
                //                     style: robotoRegular.copyWith(
                //                       fontSize: Dimensions.fontSizeSmall
                //                     ),
                //                   ),
                //                 ),
                //                 SizedBox(
                //                   width: 10.0,
                //                 ),
                //                 Text("${ppobProvider.getGlobalPaymentMethodName} - ${ppobProvider.getGlobalPaymentAccount}",
                //                   style: robotoRegular.copyWith(
                //                     fontSize: Dimensions.fontSizeSmall
                //                   ),
                //                 ),
                //                 SizedBox(width: 10.0),
                //                 InkWell(
                //                   onTap: () {
                //                     ppobProvider.removePaymentMethod();
                //                   },
                //                   child: Icon(
                //                     Icons.remove_circle,
                //                     color: ColorResources.white,
                //                   ),
                //                 )
                //               ],
                //             )
                //           )
                //         : Container(
                //           margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Row(
                //                 children: [
                //                   Text(getTranslated("DESTINATION_CASHOUT", context),
                //                     style: robotoRegular.copyWith(
                //                       fontSize: Dimensions.fontSizeSmall
                //                     ),
                //                   ),
                //                   SizedBox(
                //                     width: 10.0,
                //                   ),
                //                   ElevatedButton(
                //                     style: ElevatedButton.styleFrom(
                //                       primary: ColorResources.primaryOrange,
                //                       shape: RoundedRectangleBorder(
                //                         borderRadius: BorderRadius.circular(10.0)
                //                       )
                //                     ),
                //                     onPressed: () {
                //                       Navigator.push(context, MaterialPageRoute(builder: (context) => ListTileComponent(
                //                         title: "Bank Transfer",
                //                         items: ppobProvider.bankDisbursement
                //                       )));
                //                     }, 
                //                     child: Text("Bank Transfer",
                //                       style: robotoRegular.copyWith(
                //                         fontSize: Dimensions.fontSizeSmall,
                //                         color: ColorResources.white
                //                       ),
                //                     )
                //                   ),
                //                   SizedBox(
                //                     width: 10.0,
                //                   ),
                //                   ElevatedButton(
                //                     style: ElevatedButton.styleFrom(
                //                       primary: ColorResources.primaryOrange,
                //                       shape: RoundedRectangleBorder(
                //                         borderRadius: BorderRadius.circular(10.0)
                //                       )
                //                     ),
                //                     onPressed: () {
                //                       Navigator.push(context, MaterialPageRoute(builder: (context) => ListTileComponent(
                //                         title: getTranslated("E_MONEY", context),
                //                         items: ppobProvider.emoneyDisbursement
                //                       )));
                //                     }, 
                //                     child: Text(getTranslated("E_MONEY", context),
                //                       style: robotoRegular.copyWith(
                //                         fontSize: Dimensions.fontSizeSmall,
                //                         color: ColorResources.white
                //                       ),
                //                     )
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           )
                //         ),

                //       ],
                //     );
                //   },
                // ),

                Container(
                  margin: EdgeInsets.only(
                    top: Dimensions.marginSizeExtraLarge, 
                    left: Dimensions.marginSizeDefault, 
                    right: Dimensions.marginSizeDefault, 
                    bottom: Dimensions.marginSizeDefault
                  ),
                  child: GestureDetector(
                    onTap: () => fad.showAnimatedDialog(context, LanguageDialog()),
                    child: Text("${getTranslated('CHOOSE_LANGUAGE', context)}",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault
                      )
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(
                    top: Dimensions.marginSizeDefault, 
                    left: Dimensions.marginSizeDefault, 
                    right: Dimensions.marginSizeDefault, 
                  ),
                  child: GestureDetector(
                    onTap: () =>  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                    ),
                    child: Text(getTranslated("CHANGE_PASSWORD", context),
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault
                      ),
                    ),
                  ),
                ),

                if(Platform.isIOS)
                  Container(
                    margin: const EdgeInsets.only(
                      top: Dimensions.marginSizeLarge, 
                      left: Dimensions.marginSizeDefault, 
                      right: Dimensions.marginSizeDefault
                    ),
                    child: CustomButton(
                      onTap: () {
                        showAnimatedDialog(
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
                                  child: CustomDialog(
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
                                                    height: 190.0,
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
                                                        
                                                        const SizedBox(height: 45.0),

                                                        Text(getTranslated("ACCOUNT_DELETION", context),
                                                          textAlign: TextAlign.center,
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeDefault,
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
                                                                btnColor: ColorResources.error,
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
                                                                btnColor: ColorResources.success,
                                                                onTap: () {
                                                                  showAnimatedDialog(
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
                                                                          child: CustomDialog(
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
                                                                                            height: 190.0,
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
                                                                                                
                                                                                                const SizedBox(height: 45.0),

                                                                                                Text(getTranslated("TAKE_TIME_24", context),
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: robotoRegular.copyWith(
                                                                                                    fontSize: Dimensions.fontSizeDefault,
                                                                                                    color: ColorResources.black
                                                                                                  )
                                                                                                ),
                                                                                              
                                                                                                const SizedBox(height: 15.0),

                                                                                                CustomButton(
                                                                                                  isBorderRadius: true,
                                                                                                  isBoxShadow: true,
                                                                                                  btnColor: ColorResources.success,
                                                                                                  onTap: () {
                                                                                                    Navigator.of(context, rootNavigator: true).pop();
                                                                                                    Navigator.pop(context);
                                                                                                  }, 
                                                                                                  btnTxt: getTranslated("CONTINUE", context)
                                                                                                )
                                                                                  
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
                                                                  });
                                                                }, 
                                                                btnTxt: getTranslated("CONTINUE", context)
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
                      }, 
                      isBorderRadius: true,
                      btnColor: ColorResources.error,
                      btnTxt: "Account Deletion"
                    ),
                  )
              ],
            )
          ),

        ]
      )
    );
  }
}
