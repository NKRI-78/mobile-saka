
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/data/models/user/user.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/auth/auth.dart';
import 'package:saka/providers/localization/localization.dart';

import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';

import 'package:saka/views/basewidgets/dialog/animated/animated.dart';
import 'package:saka/views/basewidgets/dialog/language/language.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/views/screens/auth/sign_up.dart';
import 'package:saka/views/screens/auth/forget_password.dart';

class SignInScreen extends StatefulWidget {
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  late AuthProvider ap;

  late TextEditingController phoneNumberC;
  late TextEditingController passwordC;

  bool passwordObscure = false;

  Future<void> login(BuildContext context) async {
    String phone = phoneNumberC.text;
    String password = passwordC.text;
    
    if(phone.trim().isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated("PHONE_MUST_BE_REQUIRED", context), "", ColorResources.error); 
      return;
    } 
    // if(phone.length <= 10) {
    //   ShowSnackbar.snackbar(context, getTranslated("PHONE_NUMBER_10_REQUIRED", context), "", ColorResources.error);
    //   return;
    // }
    if(password.trim().isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated("PASSWORD_MUST_BE_REQUIRED", context), "", ColorResources.error); 
      return;
    }
    if(password.trim().length < 6) {
      ShowSnackbar.snackbar(context, getTranslated("PASSWORD_6_REQUIRED", context), "", ColorResources.error); 
      return;
    }
    UserData userData = UserData();
    userData.phoneNumber = phone;
    userData.password = password;
    
    await context.read<AuthProvider>().login(context, userData);
  }

  @override 
  void initState() {
    super.initState();  
    
    phoneNumberC = TextEditingController();
    passwordC = TextEditingController();

    if(mounted) { 
    //   NewVersionPlus newVersion = NewVersionPlus(
    //     androidId: 'com.inovasi78.saka',
    //     iOSId: 'com.inovatif78.saka'
    //   );
    //   Future.delayed(Duration.zero, () async {
    //     VersionStatus? vs = await newVersion.getVersionStatus();
    //     if(vs!.canUpdate) {
    //       NS.push(context, const UpdateScreen());
    //     } 
    //   });
    }
  }

  @override 
  void dispose() {
    phoneNumberC.dispose();
    passwordC.dispose();

    super.dispose();
  }

  // Future<void> googleSignInMethod() async {
  //   await ap.signInWithGoogle(context);
  // }

  // Future<void> fbSignInMethod() async {
  //   await ap.signInWithFb(context);
  // } 

  @override
  Widget build(BuildContext context) {

    ap = context.read<AuthProvider>();

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/back-login.jpg')
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
        
                Positioned(
                  top: 50.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 150.0,
                    child: Image.asset('assets/images/logo.png')
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: ColorResources.splash,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0), 
                      topRight: Radius.circular(20.0)
                    )
                  ),
                  child: ListView(
                    children: [
                      
                      Container(
                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                        padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    child: TextField(
                                      controller: phoneNumberC,
                                      style: robotoRegular.copyWith(
                                        color: ColorResources.brown,
                                        fontSize: Dimensions.fontSizeSmall
                                      ),
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: ColorResources.brown,
                                      decoration: InputDecoration(
                                        hintText: "Ex : 08xxxxxxxx",
                                        hintStyle: robotoRegular.copyWith(
                                          color: ColorResources.brown,
                                          fontSize: Dimensions.fontSizeSmall
                                        ),
                                        prefixIcon: Icon(
                                          Icons.phone_android,
                                          color: ColorResources.brown,
                                        ),
                                        fillColor: ColorResources.white,
                                        filled: true,
                                        isDense: true,
                                        enabledBorder: OutlineInputBorder(      
                                          borderSide: BorderSide(color: ColorResources.brown),   
                                        ),  
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorResources.brown),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorResources.brown),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
        
                            Container(
                              margin: EdgeInsets.only(top: 15.0),
                              child: Column(
                                children: [
                                  StatefulBuilder(
                                    builder: (BuildContext context, Function setState) {
                                      return TextField(
                                        controller: passwordC,
                                        obscureText: passwordObscure,
                                        style: robotoRegular.copyWith(
                                          color: ColorResources.brown,
                                          fontSize: Dimensions.fontSizeSmall
                                        ),
                                        cursorColor: ColorResources.brown,
                                        decoration: InputDecoration(
                                          hintText: "Enter your password",
                                          suffixIcon: InkWell(
                                            onTap: () => setState(() => passwordObscure = !passwordObscure), 
                                            child: Icon(
                                              passwordObscure 
                                              ? Icons.visibility_off 
                                              : Icons.visibility,
                                              color: ColorResources.brown
                                            ),
                                          ),
                                          hintStyle: robotoRegular.copyWith(
                                            color: ColorResources.brown,
                                            fontSize: Dimensions.fontSizeSmall
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: ColorResources.brown,
                                          ),
                                          fillColor: ColorResources.white,
                                          filled: true,
                                          isDense: true,
                                          enabledBorder: OutlineInputBorder(      
                                            borderSide: BorderSide(color: ColorResources.brown),   
                                          ),  
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: ColorResources.brown),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: ColorResources.brown),
                                          ),
                                        ),
                                        textInputAction: TextInputAction.next,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
        
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 15.0),
                              child: TextButton(
                                onPressed: () => login(context),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  backgroundColor: ColorResources.brown
                                ),
                                child: authProvider.loginStatus == LoginStatus.loading 
                                ? Loader(
                                    color: ColorResources.white,
                                  )
                                : Text(getTranslated("SIGN_IN", context),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.white,
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),
                            ),
        
                            Container(
                              margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showAnimatedDialog(context, LanguageDialog());
                                    },
                                    child: Consumer<LocalizationProvider>(
                                      builder: (BuildContext context, LocalizationProvider localizationProvider, Widget? child) {
                                        return Text("${getTranslated("CHOOSE_LANGUAGE", context)} - ${localizationProvider.locale}",
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.white,
                                            fontSize: Dimensions.fontSizeSmall
                                          ), 
                                        );
                                      },
                                    )
                                  ),
                                  InkWell(
                                    onTap: () { 
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => ScreenForgetPassword())
                                      );
                                    },
                                    child: Text(getTranslated("FORGET_PASSWORD", context),
                                      style: robotoRegular.copyWith(
                                        color: ColorResources.white,
                                        fontSize: Dimensions.fontSizeSmall
                                      )
                                    )
                                  )
                                ],
                              )
                            ),
                                
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10.0, right: 20.0),
                                      child: Divider(
                                        color: ColorResources.brown,
                                        height: 36.0,
                                      )
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
                                    child: Text(getTranslated("CREATE_ACCOUNT", context),
                                      style: robotoRegular.copyWith(
                                        color: ColorResources.brown,
                                        fontSize: Dimensions.fontSizeSmall
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20.0, right: 10.0),
                                      child: Divider(
                                        color: ColorResources.brown,
                                        height: 36.0,
                                      )
                                    ),
                                  ),
                                ]
                              ),
                            ),
        
                            // if(Platform.isAndroid)
                            //   Container(
                            //     margin: const EdgeInsets.all(Dimensions.marginSizeDefault),
                            //     child: Row(
                            //       children: [
                            //         Expanded(
                            //           child: Container(
                            //             height: 1,
                            //             width: 10,
                            //             color: ColorResources.gainsBoro,
                            //           ),
                            //         ),
                            //         Text(getTranslated("OR_SIGN_IN_WITH", context),
                            //           style: robotoRegular.copyWith(
                            //             color: ColorResources.white,
                            //             fontSize: Dimensions.fontSizeSmall
                            //           ),
                            //         ),
                            //         Expanded(
                            //           child: Container(
                            //             height: 1,
                            //             width: 10,
                            //             color: ColorResources.gainsBoro,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
        
                            // if(Platform.isAndroid)
                            //   Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     mainAxisSize: MainAxisSize.max,
                            //     children: [
                                  
                            //       InkWell(
                            //         onTap: () async {
                            //           await googleSignInMethod();
                            //         },
                            //         child: Container(
                            //           height: 30.0,
                            //           padding: const EdgeInsets.all(8.0),
                            //           decoration: BoxDecoration(
                            //             color: ColorResources.white,
                            //             borderRadius: BorderRadius.circular(6.0)
                            //           ),
                            //           child: Image.asset('assets/icons/google.png',
                            //           ),
                            //         )
                            //       ),
                              
                            //       const SizedBox(width: 6.0),
                                                                
                            //       InkWell(
                            //         onTap: () async {
                            //           await fbSignInMethod();
                            //         },
                            //         child: Container(
                            //           width: 30.0,
                            //           height: 30.0,
                            //           padding: const EdgeInsets.all(8.0),
                            //           decoration: BoxDecoration(
                            //             color: ColorResources.white,
                            //             borderRadius: BorderRadius.circular(6.0)
                            //           ),
                            //           child: Image.asset('assets/icons/facebook.png',
                            //           ),
                            //         )
                            //       ),
                                
                            //     ],
                            //   ),      
        
                          ],
                        ),
                      )
        
                    ],
                  ),
                )
        
              ],
            ),
          );
        },
      ) 
    );
  } 
}