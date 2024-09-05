import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/data/models/user/user.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/auth/auth.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  
  bool passwordOldObscure = false;
  bool passwordNewObscure = false;
  bool passwordConfirmObscure = false;

  TextEditingController passwordOldC = TextEditingController();
  TextEditingController passwordNewC = TextEditingController();
  TextEditingController passwordConfirmC = TextEditingController();

  Future<void> changePassword() async {
    UserData userData = UserData();
    userData.password = passwordOldC.text;
    userData.passwordNew = passwordNewC.text;
    userData.passwordConfirm = passwordConfirmC.text;

    if(passwordOldC.text.trim().isEmpty) {
      ShowSnackbar.snackbar(getTranslated("PASSWORD_OLD_IS_REQUIRED", context), "", ColorResources.error);
      return;
    }
    if(passwordNewC.text.trim().isEmpty) {
      ShowSnackbar.snackbar(getTranslated("PASSWORD_NEW_IS_REQUIRED", context), "", ColorResources.error);
      return;
    }
    if(passwordNewC.text.trim().length < 6) {
      ShowSnackbar.snackbar(getTranslated("PASSWORD_NEW_6_REQUIRED", context), "", ColorResources.error);
      return;
    }
    if(passwordConfirmC.text.trim().isEmpty) {
      ShowSnackbar.snackbar(getTranslated("PASSWORD_CONFIRM_IS_REQUIRED", context), "", ColorResources.error);
      return;
    }
    if(passwordNewC.text != passwordConfirmC.text) {
      ShowSnackbar.snackbar(getTranslated("PASSWORD_CONFIRM_DOES_NOT_MATCH", context), "", ColorResources.error);
      return;
    }

    await context.read<AuthProvider>().changePassword(context, userData);
    ShowSnackbar.snackbar(getTranslated("UPDATE_PASSWORD_SUCCESS", context), "", ColorResources.success);  
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {

    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(getTranslated("CHANGE_PASSWORD", context),
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontWeight: FontWeight.w600,
            fontSize: Dimensions.fontSizeSmall
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
              height: 150.0,
              color: ColorResources.brown,
            ),
            clipper: CustomClipPath(),
          ),
    
          Container(
            margin: EdgeInsets.only(top: 30.0),
            height: 250.0,
            child: Card(
              elevation: 3.0,
              child: Container(
                margin: EdgeInsets.only(
                  top: 20.0, 
                  left: 16.0, 
                  right: 16.0
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
    
                    StatefulBuilder(
                      builder: (BuildContext context, Function setState) {
                        return TextField(
                          controller: passwordOldC,
                          obscureText: passwordOldObscure,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.black
                          ),
                          decoration: InputDecoration(
                            hintText: getTranslated("OLD_PASSWORD", context),
                            hintStyle: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                            contentPadding: EdgeInsets.only(
                              top: 15.0
                            ),
                            isDense: true,
                            enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color: ColorResources.brown),   
                            ),  
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorResources.brown),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorResources.brown),
                            ),
                            suffixIcon: InkWell(
                              onTap: () => setState(() => passwordOldObscure = !passwordOldObscure),
                              child: Icon(
                                passwordOldObscure ? Icons.visibility_off : Icons.visibility,
                                color: ColorResources.brown,
                              ),
                            )
                          ),
                        );
                      },
                    ),
    
                    SizedBox(height: 20.0),
    
                    StatefulBuilder(
                      builder: (BuildContext context, Function setState) {
                        return TextField(
                          controller: passwordNewC,
                          obscureText: passwordNewObscure,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall
                          ),
                          decoration: InputDecoration(
                            hintText: "${getTranslated("ENTER_YOUR_NEW_PASSWORD", context)}",
                            hintStyle: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall
                            ),
                            contentPadding: EdgeInsets.only(
                              top: 15.0
                            ),
                            isDense: true,
                            enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color: ColorResources.brown),   
                            ),  
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorResources.brown),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorResources.brown),
                            ),
                            suffixIcon: InkWell(
                              onTap: () => setState(() => passwordNewObscure = !passwordNewObscure),
                              child: Icon(
                                passwordNewObscure ? Icons.visibility_off : Icons.visibility,
                                color: ColorResources.brown,
                              ),
                            )
                          ),
                        );
                      },
                    ),
    
                    SizedBox(height: 20.0),
    
                    StatefulBuilder(
                      builder: (BuildContext context, Function setState) {
                        return TextField(
                          controller: passwordConfirmC,
                          obscureText: passwordConfirmObscure,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall
                          ),
                          decoration: InputDecoration(
                            hintText: getTranslated("CONFIRM_YOUR_NEW_PASSWORD", context),
                            hintStyle: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall
                            ),
                            contentPadding: EdgeInsets.only(
                              top: 15.0
                            ),
                            isDense: true,
                            enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color: ColorResources.brown),   
                            ),  
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorResources.brown),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorResources.brown),
                            ),
                            suffixIcon: InkWell(
                              onTap: () => setState(() => passwordConfirmObscure = !passwordConfirmObscure),
                              child: Icon(
                                passwordConfirmObscure ? Icons.visibility_off : Icons.visibility,
                                color: ColorResources.brown,
                              ),
                            )
                          ),
                        );
                      },
                    ),
    
                  ],
                ),
              ),
            ),
          ),
    
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 30.0, left: 10.0, right: 10.0),
              height: 40.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  backgroundColor: ColorResources.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  )
                ),
                onPressed: changePassword, 
                child: Text(getTranslated("SAVE", context),
                  style: robotoRegular.copyWith(
                    color: ColorResources.white,
                    fontSize: Dimensions.fontSizeSmall
                  ),
                )
              ),
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
