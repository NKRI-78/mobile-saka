import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

import 'package:saka/providers/ppob/ppob.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/exceptions.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/color_resources.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
import 'package:saka/views/screens/ppob/confirm_payment.dart';

class VoucherPulsaByPrefixScreen extends StatefulWidget {
  const VoucherPulsaByPrefixScreen({Key? key}) : super(key: key);

  @override
  _VoucherPulsaByPrefixScreenState createState() => _VoucherPulsaByPrefixScreenState();
}

class _VoucherPulsaByPrefixScreenState extends State<VoucherPulsaByPrefixScreen> {

  late TextEditingController getC;
  
  FlutterContactPicker cp = FlutterContactPicker();
  Contact? contact;
  
  Timer? debounce;
  int? selected;
  String? phoneNumber;
  String? nominal;
  
  phoneNumberChange() {
    if(getC.text.length >= 10) {
      if (getC.text.startsWith('0')) {
        phoneNumber = '62' + getC.text.replaceFirst(RegExp(r'0'), '');
      } else {
        phoneNumber = phoneNumber;
      }
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        context.read<PPOBProvider>().getVoucherPulsaByPrefix(context, int.parse((phoneNumber!)));
      });
    } else {
       context.read<PPOBProvider>().getVoucherPulsaByPrefix(context, 0);
    }
  }

  @override 
  void dispose() {
    super.dispose();
    debounce?.cancel();

    getC.removeListener(phoneNumberChange);
    getC.dispose();
  }

  @override 
  void initState() {
    super.initState();   

    getC = TextEditingController();

    getC.addListener(phoneNumberChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            CustomAppBar(title: getTranslated("TOPUP_PULSA", context), isBackButtonExist: true),
            
            Container(
              height: 60.0,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 5.0),
              child: Card(
                color: ColorResources.white,
                elevation: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      child: TextField(
                        controller: getC,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: ColorResources.black
                        ),
                        decoration: InputDecoration(
                          hintText: getTranslated("PHONE_NUMBER", context),
                          hintStyle: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall
                          ),
                          fillColor: ColorResources.white,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.all(12.0)
                        ),
                        onSubmitted: (String val) => setState(() => getC.text),
                        keyboardType: TextInputType.number,
                      )
                    ),
                    InkWell(
                      onTap: () async {
                        Contact? c = await cp.selectContact();
                        if(c != null) {
                          setState(() {
                            getC.text = c.phoneNumbers![0].replaceAll(RegExp("[()+\\s-]+"), "");
                          });
                          phoneNumberChange();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: const Icon(
                          Icons.contacts,
                          color: ColorResources.black
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  Consumer<PPOBProvider>(
                    builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                      if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.loading) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: const Center(
                            child: SizedBox(
                              width: 18.0,
                              height: 18.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryOrange),
                              )
                            )
                          ),
                        );
                      }
                      if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.empty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: Text(getTranslated("DATA_NOT_FOUND", context),
                              style: robotoRegular.copyWith(
                                color: ColorResources.black
                              ),
                            ),
                          ),
                        );
                      }
                      if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.error) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                              style: robotoRegular.copyWith(
                                color: ColorResources.black
                              ),
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: ppobProvider.listVoucherPulsaByPrefixData.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2 / 1
                        ),
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int i) {
                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: Card(
                                    color: ColorResources.white,
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 0.5,
                                        color: selected == i ? ColorResources.purple : Colors.transparent
                                      )
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        try {
                                          if(getC.text.length <= 11) {
                                            throw CustomException("PHONE_NUMBER_10_REQUIRED");
                                          }
                                          setState(() => selected = i);
                                          getC.removeListener(phoneNumberChange);
                                          showModalBottomSheet( 
                                            isScrollControlled: true,       
                                            isDismissible: false,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                            ),
                                            context: context,
                                            builder: (ctx) => SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(getTranslated("CUSTOMER_INFORMATION", context),
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                        const SizedBox(height: 12.0),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(getTranslated("PHONE_NUMBER", context),
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeExtraSmall
                                                              ),
                                                            ),
                                                            Text(getC.text,
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeExtraSmall
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(height: 8.0),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(ppobProvider.listVoucherPulsaByPrefixData[i].category!,
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeExtraSmall
                                                              ),
                                                            ),
                                                            Text(Helper.formatCurrency(double.parse(ppobProvider.listVoucherPulsaByPrefixData[i].price.toString())),
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeExtraSmall
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      top: 30.0,
                                                      bottom: 30.0
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        SizedBox(
                                                          width: 140.0,
                                                          child:TextButton(
                                                            style: TextButton.styleFrom(
                                                              elevation: 0.0,
                                                              backgroundColor: ColorResources.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                                side: BorderSide.none
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              WidgetsBinding.instance.addPostFrameCallback((_) => getC.addListener(phoneNumberChange));
                                                              Navigator.of(ctx).pop();
                                                            },
                                                            child: Text(getTranslated("CHANGE", context),
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                color: ColorResources.purple
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 140.0,
                                                          child: TextButton(
                                                            style: TextButton.styleFrom(
                                                              elevation: 0.0,
                                                              backgroundColor: ColorResources.purple,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                                side: BorderSide.none
                                                              )
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(context,
                                                                MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                                                                  type: "pulsa",
                                                                  description: ppobProvider.listVoucherPulsaByPrefixData[i].description,
                                                                  nominal : ppobProvider.listVoucherPulsaByPrefixData[i].price,
                                                                  provider: ppobProvider.listVoucherPulsaByPrefixData[i].category!.toLowerCase(),
                                                                  accountNumber: getC.text,
                                                                  productId: ppobProvider.listVoucherPulsaByPrefixData[i].productId,
                                                                )),
                                                              );
                                                            },
                                                            child: Text(getTranslated("CONFIRM", context),
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                color: ColorResources.white
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        } on CustomException catch(e) {
                                          Fluttertoast.showToast(
                                            msg: getTranslated(e.toString(), context),
                                            backgroundColor: ColorResources.error
                                          );
                                        } catch(e) {
                                          debugPrint(e.toString());
                                        }
                                      },
                                      child: Container(
                                        width: 100.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius .circular(4.0)
                                        ),
                                        child: Center(
                                          child: Text(Helper.formatCurrency(double.parse(ppobProvider.listVoucherPulsaByPrefixData[i].price.toString())),
                                            style: robotoRegular.copyWith(
                                              color: selected == i ? ColorResources.purple : ColorResources.dimGrey,
                                              fontSize: Dimensions.fontSizeExtraSmall
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ),
                              )
                            ]
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),

          ]
        ),
      )
    );
  }
}