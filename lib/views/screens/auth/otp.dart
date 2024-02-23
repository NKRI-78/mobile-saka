import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/views/screens/auth/sign_in.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/providers/auth/auth.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

class OtpScreen extends StatefulWidget {
  final Key? key;
  OtpScreen({
    required this.key
  });

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  bool loading = true;

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(mounted) {
        setState(() {
          Provider.of<AuthProvider>(context, listen: false).changeEmailName = prefs.getString("email_otp")!; 
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.bgGrey,
      body: Consumer<AuthProvider>(
        builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Verifikasi Alamat E-mail',
                    style: robotoRegular.copyWith(
                      fontWeight: FontWeight.w600, 
                      fontSize: Dimensions.fontSizeSmall
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  child: RichText(
                    text: TextSpan(
                      text: "Mohon masukkan 4 digit kode telah dikirim ke Alamat E-mail ",
                      children: [
                        TextSpan(
                          text: loading ? "..." : authProvider.changeEmailName,
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeSmall
                          )
                        ),
                      ],
                      style: robotoRegular.copyWith(
                        color: ColorResources.black,
                        fontSize: Dimensions.fontSizeSmall
                      )
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.0
                ),
                authProvider.changeEmail ? Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
                    child: PinCodeTextField(
                      appContext: context,
                      backgroundColor: Colors.transparent,
                      pastedTextStyle: robotoRegular.copyWith(
                        color: ColorResources.success,
                        fontSize: Dimensions.fontSizeSmall
                      ),
                      textStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall
                      ),
                      length: 4,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        inactiveColor: ColorResources.blueGrey,
                        inactiveFillColor: ColorResources.white,
                        selectedFillColor: ColorResources.white,
                        activeFillColor: ColorResources.white,
                        selectedColor: Colors.transparent,
                        activeColor: ColorResources.primaryOrange,
                        borderWidth: 1.5,
                        fieldHeight: 50.0,
                        fieldWidth: 50.0,
                      ),
                      cursorColor: ColorResources.primaryOrange,
                      animationDuration: Duration(milliseconds: 100),
                      enableActiveFill: true,
                      keyboardType: TextInputType.text,
                      onCompleted: (v) {
                        authProvider.otpCompleted(v);
                      },
                      onChanged: (value) {

                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    )
                  ),
                ) : Container(),
                
                authProvider.changeEmail 
                ? Container() 
                : Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextFormField(
                    onChanged: (val) {
                      authProvider.emailCustomChange(val);
                    },
                    initialValue: authProvider.changeEmailName,
                    decoration: InputDecoration(
                      fillColor: ColorResources.white,
                      filled: true,
                      hintText: authProvider.changeEmailName,
                      hintStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall
                    )
                  ),
                ),
                authProvider.changeEmail ? Container() : Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 16.0, right: 16.0),
                          width: double.infinity,
                          height: 50.0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: ColorResources.primaryOrange,
                                width: 1.0
                              )
                            ),
                              backgroundColor: ColorResources.white,
                            ),
                            child: Text(getTranslated("CANCEL", context),
                              style: robotoRegular.copyWith(
                                color: ColorResources.primaryOrange,
                                fontSize: Dimensions.fontSizeSmall,
                                fontWeight: FontWeight.w600
                              )
                            ),
                            onPressed: () {
                              authProvider.cancelCustomEmail();
                            }
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 16.0, right: 16.0),
                          width: double.infinity,
                          height: 50.0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: ColorResources.primaryOrange,
                                width: 1.0
                              )
                            ),
                              backgroundColor: ColorResources.white,
                            ),
                            child: authProvider.applyChangeEmailOtpStatus == ApplyChangeEmailOtpStatus.loading 
                            ? SizedBox(
                                width: 18.0,
                                height: 18.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryOrange),
                                ),
                              ) 
                            : Text('Apply',
                              style: robotoRegular.copyWith(
                                color: ColorResources.primaryOrange,
                                fontSize: Dimensions.fontSizeSmall,
                                fontWeight: FontWeight.w600
                              )
                            ),
                            onPressed: () {
                              authProvider.applyChangeEmailOtp(context, globalKey);
                            }
                          ),
                        ),
                      )
                    ],
                  ),
                ), 
                authProvider.whenCompleteCountdown == "start" ? Container(
                  margin: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 35.0),
                  alignment: Alignment.centerRight,
                  child: CircularCountDownTimer(
                    duration: 120,
                    initialDuration: 0,
                    width: 40.0,
                    height: 40.0,
                    ringColor: Colors.transparent,
                    ringGradient: null,
                    fillColor: ColorResources.primaryOrange.withOpacity(0.4),
                    fillGradient: null,
                    backgroundColor: ColorResources.primaryOrange,
                    backgroundGradient: null,
                    strokeWidth: 10.0,
                    strokeCap: StrokeCap.round,
                    textStyle: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: ColorResources.white,
                      fontWeight: FontWeight.w600
                    ),
                    textFormat: CountdownTextFormat.S,
                    isReverse: true,
                    isReverseAnimation: true,
                    isTimerTextShown: true,
                    autoStart: true,
                    onStart: () {},
                    onComplete: () {
                      authProvider.completeCountDown();
                    },
                  ),
                ) : Container(),
                SizedBox(
                  height: 5.0,
                ),
                authProvider.whenCompleteCountdown == "completed" ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getTranslated("DID_NOT_RECEIVE_CODE", context),
                      style: robotoRegular.copyWith(
                        color: ColorResources.black,
                        fontSize: Dimensions.fontSizeSmall
                      ),
                    ),
                    TextButton(
                      onPressed: () => authProvider.resendOtpCall(context, globalKey),
                      child: authProvider.resendOtpStatus == ResendOtpStatus.loading 
                      ? SizedBox(
                        width: 12.0,
                        height: 12.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryOrange),
                        ),
                      )
                      : Text(getTranslated("RESEND", context),
                        style: robotoRegular.copyWith(
                          color: ColorResources.primaryOrange,
                          fontSize: Dimensions.fontSizeSmall
                        ),
                      )
                    )
                  ],
                ) : Container(),
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  width: double.infinity,
                  height: 50.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                      backgroundColor: ColorResources.primaryOrange,
                    ),
                    child: authProvider.verifyOtpStatus == VerifyOtpStatus.loading 
                    ? Loader(
                        color: ColorResources.white,
                      )
                    : Text('Verify',
                      style: robotoRegular.copyWith(
                        color: ColorResources.white,
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w600
                      )
                    ) ,
                    onPressed: () => authProvider.verifyOtp(context)
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextButton(
                    child: Text(getTranslated("BACK", context),
                      style: robotoRegular.copyWith(
                        color: ColorResources.primaryOrange,
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => SignInScreen())
                    )
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextButton(
                    child: Text(getTranslated("CHANGE_EMAIL", context),
                      style: robotoRegular.copyWith(
                        color: ColorResources.primaryOrange,
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    onPressed: () => authProvider.changeEmailCustom()
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }
}