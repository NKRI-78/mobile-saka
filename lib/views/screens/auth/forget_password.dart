import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saka/data/models/user/user.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/auth/auth.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/custom_themes.dart';

class ScreenForgetPassword extends StatefulWidget {
  @override
  State<ScreenForgetPassword> createState() => _ScreenForgetPasswordState();
}

class _ScreenForgetPasswordState extends State<ScreenForgetPassword> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController emailC;

  Future<void> forgotPassword(BuildContext context) async {
    UserData userData = UserData();
    String email = emailC.text;
    if(email.trim().isEmpty) {
      return;
    }
    userData.emailAddress = email;
    await Provider.of<AuthProvider>(context, listen: false).forgetPassword(context, email);
  } 

  @override 
  void initState() {
    super.initState();
    emailC = TextEditingController();
  }

  @override 
  void dispose() {
    emailC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.brown,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: ColorResources.brown,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: ColorResources.white
        ),
      ),
      body: Form(
        key: formKey,
        child: Container(
          margin: EdgeInsets.only(
            left: 16.0, 
            right: 16.0
          ),
          child: Stack(
            children: [

              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 90.0),
                  child: Text(getTranslated("FORGET_PASSWORD", context),
                    style: robotoRegular.copyWith(
                      color: ColorResources.white,
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(bottom: 100.0),
                  child: Text(getTranslated("PLEASE_ENTER_YOUR_REGISTERED_EMAIL_ADDRESS", context),
                    style: robotoRegular.copyWith(
                      color: ColorResources.white,
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  decoration: BoxDecoration(
                    color: ColorResources.white,
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: TextFormField(
                    controller: emailC,
                    decoration: InputDecoration(
                      fillColor: ColorResources.white,
                      hintText: getTranslated("ENTER_YOUR_EMAIL", context),
                      hintStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: ColorResources.black
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall
                    )
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 160.0),
                  child: Consumer<AuthProvider>(
                    builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
                      return Container(
                        width: double.infinity,
                        height: 50.0,
                        child: TextButton( 
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor:  ColorResources.primaryOrange
                          ),
                          child: authProvider.forgotPasswordStatus == ForgotPasswordStatus.loading 
                          ? Loader(
                            color: ColorResources.white,
                          )
                          : Text('Submit',
                            style: robotoRegular.copyWith(
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeSmall,
                            )
                          ),
                          onPressed: () => forgotPassword(context)
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
