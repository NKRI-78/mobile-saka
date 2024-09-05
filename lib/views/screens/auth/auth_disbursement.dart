import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/auth/auth.dart';

import 'package:saka/utils/box_shadow.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/textfield/password.dart';

class AuthDisbursementScreen extends StatefulWidget {
  @override
  _AuthDisbursementScreenState createState() => _AuthDisbursementScreenState();
}

class _AuthDisbursementScreenState extends State<AuthDisbursementScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController passwordC;
  late FocusNode passFn;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    passwordC = TextEditingController();
    passFn = FocusNode();
  }

  @override 
  void dispose() {
    super.dispose();
    passwordC.dispose();
  }

  Future<void> signIn(BuildContext context) async {
    try {
      if(passwordC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(getTranslated("PASSWORD_MUST_BE_REQUIRED", context), "", ColorResources.error);
        return;
      }
      await context.read<AuthProvider>().authDisbursement(context, passwordC.text);
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      key: globalKey,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 250.0, bottom: 0.0, left: 0.0, right: 0.0),
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [

                Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.marginSizeDefault, 
                    right: Dimensions.marginSizeDefault, 
                    bottom: Dimensions.marginSizeDefault
                  ),
                  child: CustomPasswordTextField(
                    textInputAction: TextInputAction.done,
                    focusNode: passFn,
                    controller: passwordC
                  )
                ),

                Container(
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0, 
                    bottom: 10.0, 
                    top: 15.0
                  ),
                  child: TextButton(
                  onPressed: () => signIn(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: ColorResources.brown
                  ),
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: boxShadow,
                      borderRadius: BorderRadius.circular(10.0)),
                      child: Consumer<AuthProvider>(
                        builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
                          return authProvider.authDisbursementStatus == AuthDisbursementStatus.loading 
                          ? Loader(
                              color: ColorResources.white,
                            )
                          : Text(getTranslated('SIGN_IN', context),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.white,
                              )
                            );
                        } 
                      )
                    ),
                  )  
                ),

                Container(
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0, 
                    bottom: 16.0, 
                    top: 5.0
                  ),
                  child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: ColorResources.brown
                  ),
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: boxShadow,
                      borderRadius: BorderRadius.circular(10.0)),
                      child: Text(getTranslated('BACK', context),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        )
                      )
                    ),
                  )  
                ),

              ],
            ),
          ),
        )

      ),
    );
  }
}