
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';

import 'package:saka/views/screens/auth/sign_in.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';

class CheckoutRegistrasiScreen extends StatefulWidget {
  final dynamic productPrice;
  final dynamic adminFee;
  final String? transactionId;
  final String? nameBank;
  final String? paymentChannel;
  final String? noVa;
  final String? guide;

  const CheckoutRegistrasiScreen({Key? key, 
    this.productPrice,
    this.adminFee,
    this.transactionId,
    this.nameBank,
    this.paymentChannel,
    this.noVa,
    this.guide
  }) : super(key: key);

  @override
  _CheckoutRegistrasiScreenState createState() => _CheckoutRegistrasiScreenState();
}

class _CheckoutRegistrasiScreenState extends State<CheckoutRegistrasiScreen> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey =  GlobalKey<FormState>();
  int beginCount = 30;
  bool isAwaiting = false;
  bool isHidePassword = true;
  double? nominal = 0.0;
  double? biayaAdmin = 0.0;

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        nominal = double.parse(widget.productPrice.toString());
        biayaAdmin = double.parse(widget.adminFee.toString());
        return WillPopScope(
          onWillPop: onWillPop,
          child: Scaffold(
            key: globalKey,
            body: Container(
              decoration: const BoxDecoration(
                color: ColorResources.black
              ),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [      
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 180.0,
                          height: 120.0,
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Image.asset("assets/images/logo/logo.png"),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5.0),
                          child: SelectableText("Checkout Registration",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: ColorResources.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorResources.white,
                                  borderRadius: BorderRadius.circular(4.0)
                                ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          top: 16.0,
                                        ),
                                        child: Row(
                                          children: [
                                            SelectableText("ID Transaksi",
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SelectableText("# ${widget.transactionId}",
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeSmall,
                                                    fontWeight: FontWeight.w600
                                                  )
                                                )
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16.0,
                                          top: 10.0,
                                          bottom: 10.0
                                        ),
                                        child: Row(
                                          children: [
                                            SelectableText(getTranslated("REGISTRATION_FEE", context),
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if(nominal != null)
                                                  SelectableText(Helper.formatCurrency(nominal!),
                                                    style: robotoRegular.copyWith(
                                                      fontSize: Dimensions.fontSizeSmall
                                                    )
                                                  )
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
                                        child: Row(
                                          children: [
                                            SelectableText(getTranslated("ADMIN_FEE", context),
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if(biayaAdmin != null)
                                                  SelectableText(Helper.formatCurrency(biayaAdmin!),
                                                    style: robotoRegular.copyWith(
                                                      fontSize: Dimensions.fontSizeSmall
                                                    )
                                                  )
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                                        child: const Divider(
                                          thickness: 2.0,
                                        )
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          bottom: 16.0,
                                          top: 16.0
                                        ),
                                        child: Row(
                                          children: [
                                            SelectableText(getTranslated("TOTAL_PAYMENT", context),
                                              style: robotoRegular.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  if(nominal != null)
                                                    if(biayaAdmin != null)
                                                      SelectableText(Helper.formatCurrency(nominal! + biayaAdmin!),
                                                        style: robotoRegular.copyWith(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: Dimensions.fontSizeSmall
                                                        )
                                                      )
                                                ],
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                      viewAutomate()
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 25.0, bottom: 25.0, left: 16.0, right: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 5.0),
                                    height: 40.0,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        elevation: 0.0,
                                        backgroundColor: ColorResources.primaryOrange
                                      ),
                                      onPressed: () {
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => SignInScreen()),
                                        );
                                      },
                                      child: Text(getTranslated("BACK", context),
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.white,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 5.0),
                                    height: 40.0,
                                    child: TextButton(
                                    style: TextButton.styleFrom(
                                      elevation: 0.0,
                                      backgroundColor: ColorResources.primaryOrange,
                                    ),
                                    onPressed: () { 
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                                    },
                                    child: Text("OK",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.white,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ), 
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget viewAutomate() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: SelectableText(
            "Transfer ke Nomor " + widget.nameBank! + " berikut ini :",
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: ColorResources.black,
              fontWeight: FontWeight.w600,
            )
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          child: SelectableText(widget.noVa!,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: FontWeight.w600,
              color: ColorResources.black
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                height: 40.0,
                child: TextButton(
                  style: TextButton.styleFrom(
                    elevation: 0.0,
                    side: const BorderSide(
                      color:  ColorResources.black,
                      width: 1.0
                    ),
                    backgroundColor: Colors.transparent
                  ),
                  onPressed: () async { 
                    try {
                      await launchUrl(Uri.parse("${AppConstants.baseUrlHelpPayment}/${widget.paymentChannel}"));
                    } catch(e) {
                      debugPrint(e.toString());
                    }
                  },
                  child: Text(getTranslated("METHOD_PAYMENT", context),
                    style: robotoRegular.copyWith(
                      color: ColorResources.black,
                      fontSize: Dimensions.fontSizeSmall
                    )
                  ),
                ), 
              ),
            ),            
            Flexible(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                height: 40.0,
                child: TextButton(
                  style: TextButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(
                      color: ColorResources.black,
                      width: 1.0
                    )
                  ),
                  onPressed: () async { 
                    try {
                      await launchUrl(Uri.parse("${AppConstants.baseUrlPaymentBilling}/${widget.transactionId}"));
                    } catch(e) {
                      debugPrint(e.toString());
                    }
                  },
                  child: Text(getTranslated("SEE_BILL", context),
                    style: robotoRegular.copyWith(
                      color: ColorResources.black,
                      fontSize: Dimensions.fontSizeSmall
                    )
                  ),
                ), 
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            children: [
              ListTile(
                dense: true,
                title: Html(
                  data: widget.guide,
                  style: {
                    "b": Style(fontSize: FontSize.large),
                    "li": Style(fontSize: FontSize.large)
                  },
                ),
              ),
            ],
          ) 
        )
      ],
    );
  }
}
