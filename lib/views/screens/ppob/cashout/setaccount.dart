import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/providers/ppob/ppob.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
import 'package:saka/views/basewidgets/textfield/textfield.dart';

class CashoutSetAccountScreen extends StatelessWidget {
  final String? title;

  CashoutSetAccountScreen({Key? key, this.title}) : super(key: key);

  final TextEditingController paymentAccount = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();

  Future saveAccountPayment(BuildContext context) async {
    try {
      if(paymentAccount.text.trim().isEmpty) {
        ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
          SnackBar(
            backgroundColor: ColorResources.error,
            content: Text(getTranslated("PAYMENT_ACCOUNT_IS_REQUIRED", context),
              style: robotoRegular,
            )
          )
        );
        return;
      }
      await Provider.of<PPOBProvider>(context, listen: false).setAccountPaymentMethod(paymentAccount.text);
     int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    } catch(e) {
      debugPrint(e.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          CustomAppBar(title: title!, isBackButtonExist: true),

          Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                CustomTextField(
                  controller: paymentAccount,
                  hintText: title == "Bank Transfer" ? getTranslated("YOUR_ACCOUNT_BANK", context) : getTranslated("PHONE_NUMBER", context),
                  focusNode: FocusNode(),
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 10.0),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.primaryOrange
                    ),
                    onPressed: () { 
                      saveAccountPayment(context); 
                    }, 
                    child: Text(getTranslated("SAVE_ACCOUNT", context),
                      style: robotoRegular.copyWith(
                        color: ColorResources.white,
                        fontSize: Dimensions.fontSizeSmall
                      ),
                    )
                  ),
                )

              ],
            )
          )      

        ],
      ),
    );
  }
}