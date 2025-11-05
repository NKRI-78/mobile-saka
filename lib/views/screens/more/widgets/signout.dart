import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/views/screens/auth/sign_in.dart';
import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/auth/auth.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class SignOutConfirmationDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge, 
              vertical: 50.0
            ),
            child: Text(getTranslated('WANT_TO_SIGN_OUT', context), 
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall
              ),
              textAlign: TextAlign.center
            ),
          ),
          Divider(
            height: 0.0, 
            color: ColorResources.hintColor
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
           
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorResources.brown, 
                    ),
                    child: Text(getTranslated('NO', context), style: robotoRegular.copyWith(
                      color: ColorResources.white,
                      fontSize: Dimensions.fontSizeSmall
                    )),
                  ),
                )
              ),

              Expanded(
                child: InkWell(
                onTap: () {
                  Provider.of<AuthProvider>(context, listen: false).logout().then((condition) {
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInScreen()), (route) => false);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorResources.primaryOrange,
                  ),
                  child: Text(getTranslated('YES', context), style: robotoRegular.copyWith(
                    color: ColorResources.white,
                    fontSize: Dimensions.fontSizeSmall
                  )),
                ),
              )
            ),

            ]
          ),
        ]
      ),
    );
  }
}
