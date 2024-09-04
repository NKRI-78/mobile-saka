import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/ppob/ppob.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/exceptions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
import 'package:saka/views/basewidgets/separator/separator.dart';
import 'package:saka/views/screens/ppob/confirm_payment.dart';

class DetailVoucherEmoneyScreen extends StatefulWidget {
  final String? type;

  const DetailVoucherEmoneyScreen({Key? key, 
    this.type
  }) : super(key: key);

  @override
  _DetailVoucherEmoneyScreenState createState() => _DetailVoucherEmoneyScreenState();
}

class _DetailVoucherEmoneyScreenState extends State<DetailVoucherEmoneyScreen> {
 
  late PPOBProvider ppobP;

  late TextEditingController getC;

  int? selected;

  FlutterContactPicker cp = FlutterContactPicker();
  Contact? contact;

  @override 
  void initState() {
    super.initState();

    ppobP = context.read<PPOBProvider>();

    getC = TextEditingController();

    if(mounted) {
      ppobP.getListEmoney(context, widget.type!);
    }
  }

  @override 
  void dispose() {
    getC.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            CustomAppBar(title: widget.type!, isBackButtonExist: true),
            
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
                    GestureDetector(
                      onTap: () async {
                        Contact? c = await cp.selectContact();
                        if(c != null) {
                          setState(() {
                            getC.text = c.phoneNumbers![0].replaceAll(RegExp("[()+\\s-]+"), "");
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: const Icon(
                          Icons.contacts,
                          color: ColorResources.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.loading) {
                  return const Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryOrange,
                        )
                      )
                    )
                  ));
                }
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.empty) {
                  return Expanded(
                    child: Center(
                      child: Text(getTranslated("DATA_NOT_FOUND", context),
                        style: robotoRegular,
                      ),
                    ),
                  );
                }
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.error) {
                  return Expanded(
                    child: Center(
                      child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                        style: robotoRegular,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: StatefulBuilder(
                    builder: (BuildContext context, Function s) {
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: ppobProvider.listTopUpEmoney.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
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
                                  height: 80.0,
                                  child: Card(
                                    elevation: 0.0,
                                    color: ColorResources.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: selected == i ? ColorResources.purpleLight : Colors.transparent,
                                        width: 0.5
                                      )
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                      try {
                                        if(getC.text.length <= 11) {
                                          throw CustomException(getTranslated("PHONE_NUMBER_10_REQUIRED", context));
                                        }
                                        s(() => selected = i);
                                        showMaterialModalBottomSheet(        
                                          isDismissible: false,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                          ),
                                          context: context,
                                            builder: (ctx) => SingleChildScrollView(
                                              child: SizedBox(
                                                height: 340.0,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(getTranslated("CUSTOMER_INFORMATION", context),
                                                            softWrap: true,
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
                                                              Text(ppobProvider.listTopUpEmoney[i].description!,
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              ),
                                                              Text(Helper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())),
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20.0),
                                                    Container(
                                                      width: double.infinity,
                                                      color: Colors.blueGrey[50],
                                                      height: 8.0,
                                                    ),
                                                    const SizedBox(height: 12.0),
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            child: Text(getTranslated("DETAIL_PAYMENT", context),
                                                              softWrap: true,
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                fontWeight: FontWeight.w600
                                                              ),
                                                            )
                                                          ),
                                                          const SizedBox(height: 12.0),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(getTranslated("VOUCHER_PRICE", context),
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              ),
                                                              Text(Helper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())),
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10.0),
                                                          MySeparatorDash(
                                                            color: Colors.blueGrey[50]!,
                                                            height: 3.0,
                                                          ),
                                                          const SizedBox(height: 12.0),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(getTranslated("TOTAL_PAYMENT", context),
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeSmall,
                                                                  fontWeight: FontWeight.w600
                                                                ),
                                                              ),
                                                              Text(Helper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())),
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeExtraSmall,
                                                                  fontWeight: FontWeight.w600
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 50.0),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        SizedBox(
                                                          width: 140.0,
                                                          child: TextButton(
                                                            style: TextButton.styleFrom(
                                                              elevation: 0.0,
                                                              backgroundColor: ColorResources.white,
                                                              shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              side: BorderSide.none
                                                            ),
                                                            ),
                                                            onPressed: () {
                                                              s(() { selected = null; });
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
                                                              Navigator.push(ctx,
                                                                MaterialPageRoute(builder: (ctx) => ConfirmPaymentScreen(
                                                                  type: "emoney",
                                                                  description: ppobProvider.listTopUpEmoney[i].description,
                                                                  nominal : ppobProvider.listTopUpEmoney[i].price,
                                                                  provider: ppobProvider.listTopUpEmoney[i].category!.toLowerCase(),
                                                                  accountNumber: getC.text,
                                                                  productId: ppobProvider.listTopUpEmoney[i].productId,
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
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        } on CustomException catch(e) {
                                          Fluttertoast.showToast(
                                            msg: e.toString(),
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
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(Helper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].name!)),
                                                style: robotoRegular.copyWith(
                                                  color: selected == i ? ColorResources.purple : ColorResources.dimGrey,
                                                  fontSize: Dimensions.fontSizeSmall
                                                ),
                                              ),
                                            )
                                          ],
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
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}