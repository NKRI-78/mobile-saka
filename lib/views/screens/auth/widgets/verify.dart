import 'package:flutter/material.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';

import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';

class VerifyScreen extends StatefulWidget {

  final String? accountName;
  final String? accountNumber;
  final int? bankFee;
  final double? productPrice;
  final String? productId;
  final String? transactionId;

  VerifyScreen({
    this.accountName,
    this.accountNumber,
    this.bankFee,
    this.productPrice,
    this.productId,
    this.transactionId
  });

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             
            CustomAppBar(title: "Aktivasi Akun Anda", isBackButtonExist: true),

            Expanded(
              child: ListView(
                children: [

                  Container(
                    margin: EdgeInsets.only(top: 60.0, bottom: 55.0, left: 16.0, right: 16.0),
                    child: Image.asset('assets/images/logo-home-menu.png',
                      width: 120.0,
                      height: 120.0,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    width: double.infinity,
                    child: Center(
                      child: Text("Akun Belum diaktivasi, silahkan aktivasi terlebih dahulu",
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[600]!,
                          width: 1.0
                        )
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 150.0,
                                child: Text(
                                  "Nama",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),
                              Container(
                                width: 8.0,
                                child: Text(
                                  ":",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(widget.accountName!,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.0),
                          Row(
                            children: [
                              Container(
                                width: 150.0,
                                child: Text(
                                  "No Handphone",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),
                              Container(
                                width: 8.0,
                                child: Text(
                                  ":",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(widget.accountNumber!,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.0),
                          Row(
                            children: [
                              Container(
                                width: 150.0,
                                child: Text(
                                  "Biaya Registrasi",
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                              Container(
                                width: 8.0,
                                child: Text(
                                  ":",
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(Helper.formatCurrency(double.parse(widget.productPrice.toString()) + double.parse(widget.bankFee.toString())),
                                    style: TextStyle(
                                      fontSize: 14.0
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: ColorResources.primaryOrange,
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 40.0,
                                  color: ColorResources.white,
                                ),
                                Container(
                                  width: 250.0,
                                  child: Text("Silahkan lakukan pembayaran terlebih dahulu untuk menyelesaikan registrasi Anda.",
                                    softWrap: true,
                                    style: TextStyle(
                                      color: ColorResources.white,
                                      height: 1.5
                                    ),
                                  ),
                                ),
                              ],
                            )
                          )
                        ]
                      ),
                    ),
                  ),

                  SizedBox(height: 30.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ColorResources.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: ColorResources.primaryOrange,
                            width: 1.0
                          )
                        ),
                        child: Material(
                          color: Colors.transparent,                
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            splashColor: ColorResources.primaryOrange,
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              width: 150.0,
                              height: 32.0,
                              child: Container(
                                margin: EdgeInsets.only(top: 6.0),
                                child: Text("Kembali",
                                  textAlign: TextAlign.center,
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 20.0),

                       Container(
                        decoration: BoxDecoration(
                          color: ColorResources.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: ColorResources.primaryOrange,
                            width: 1.0
                          )
                        ),
                        child: Material(
                          color: Colors.transparent,                
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            splashColor: ColorResources.primaryOrange,
                            onTap: () { 
                             
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              width: 150.0,
                              height: 32.0,
                              child: Container(
                                margin: EdgeInsets.only(top: 6.0),
                                child: Text("Pilih Pembayaran",
                                  textAlign: TextAlign.center,
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}