import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/views/screens/dashboard/dashboard.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

class CheckoutProductScreen extends StatefulWidget {
  final String paymentChannel;
  final String paymentCode;
  final String paymentRefId;
  final String paymentGuide;
  final String paymentAdminFee;
  final String paymentStatus;
  final String nameBank;
  final String refNo;
  final String billingUid;
  final double amount;

  const CheckoutProductScreen({
    Key? key,
    required this.paymentChannel,
    required this.paymentCode,
    required this.paymentRefId,
    required this.paymentGuide,
    required this.paymentAdminFee,
    required this.paymentStatus,
    required this.nameBank,
    required this.refNo,
    required this.billingUid,
    required this.amount,
  }) : super(key: key);
  @override
  _CheckoutProductScreenState createState() => _CheckoutProductScreenState();
}

class _CheckoutProductScreenState extends State<CheckoutProductScreen> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Future<bool> onWillPop() {
    NS.pushReplacement(context, DashboardScreen());
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return buildUI();
  }

  Widget buildUI() {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: globalKey,
        backgroundColor: ColorResources.backgroundColor,
        appBar: AppBar(
          backgroundColor: ColorResources.primaryOrange,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0.0,
          title: Text("Checkout Pembayaran",
            style: robotoRegular.copyWith(
              color: ColorResources.white,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            ListView(
              physics: const BouncingScrollPhysics(), 
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, 
                    top: 16.0, bottom: 5.0
                  ),
                  child: Row(
                    children: [
                      SelectableText("ID Transaksi #",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(widget.refNo,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Colors.green[900]
                              )
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 5.0),
                  child: Row(
                    children: [
                      SelectableText("Total Tagihan",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(Helper.formatCurrency(widget.amount),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault
                              )
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5.0),
                  child: Row(
                    children: [
                      SelectableText("Biaya Admin",
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          SelectableText(Helper.formatCurrency(double.parse(widget.paymentAdminFee)),
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)
                          )
                        ],
                      )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                  child: Row(
                    children: [
                      SelectableText("Total Pembayaran",
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.w600, 
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(Helper.formatCurrency(widget.amount + double.parse(widget.paymentAdminFee)),
                              style: robotoRegular.copyWith(
                                fontWeight: FontWeight.w600, 
                                fontSize: Dimensions.fontSizeDefault
                              )
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              Container(
                child: viewOtomatis()
              ),
            ]
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70.0,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
              decoration: const BoxDecoration(
                color: ColorResources.white,
              ),
              child: SizedBox(
                height: 55.0,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: ColorResources.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  ),
                  child: Center(
                    child: SelectableText("Selesaikan Pembayaran",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault, 
                        color: ColorResources.white
                      )
                    ),
                  ),
                  onPressed: () {
                    NS.pushReplacement(context, DashboardScreen());
                  } 
                ),
              )
            )
          )
        ]
      ),
    ),
    );
  }

  Widget viewOtomatis() {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(
        left: 16.0, right: 16.0, bottom: 80.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5.0, top: 25.0, left: 10.0, right: 10.0),
            child: SelectableText("Transfer ke Nomor ${widget.nameBank}",
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              )
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            child: SelectableText(
              widget.paymentCode,
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
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                  height: 50.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      elevation: 3.0,
                      backgroundColor: ColorResources.yellow,
                    ),
                    onPressed: () async { 
                      try {
                        await launch(("${AppConstants.baseUrlHelpPayment}/${widget.paymentChannel}"));
                      } catch(e) {
                        debugPrint(e.toString());
                      }
                    },
                    child: Text("Cara Pembayaran",
                      style: robotoRegular.copyWith(
                        color: ColorResources.black
                      )
                    ),
                  ), 
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, 
                    left: 10.0, right: 10.0
                  ),
                  height: 50.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      elevation: 3.0,
                      backgroundColor: ColorResources.yellow,
                    ),
                    onPressed: () async { 
                      try {
                        await launch("${AppConstants.baseUrlPaymentBilling}/${widget.refNo}");
                      } catch(e, stacktrace) {
                        debugPrint(stacktrace.toString());
                      }
                    },
                    child: Text("Lihat Tagihan",
                      style: robotoRegular.copyWith(
                        color: ColorResources.black
                      )
                    ),
                  ), 
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0, left: 12.0, bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Petunjuk Pembayaran",
                  style: robotoRegular.copyWith(
                    color: ColorResources.black
                  ),
                ),
                Html(
                  style: {
                    'body': Style(
                      margin: Margins.zero
                    )
                  },
                  data: widget.paymentGuide
                ),
              ],
            )    
          )
        ],
      ),
    );
  }
}