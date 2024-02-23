import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/providers/ppob/ppob.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';

class TokenListrikScreen extends StatefulWidget {
  const TokenListrikScreen({Key? key}) : super(key: key);

  @override
  _TokenListrikScreenState createState() => _TokenListrikScreenState();
}

class _TokenListrikScreenState extends State<TokenListrikScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController noMeterC;

  int? selected;
  Timer? debounce;
  FocusNode focusNode = FocusNode();

  void noMeterPelangganListener() {
    if(noMeterC.text.length <= 9) {
      if(debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        Provider.of<PPOBProvider>(context, listen: false).getListPricePLNPrabayar(context);
      });
    } 
  }

  @override
  void initState() {
    super.initState();
    noMeterC = TextEditingController();  
    noMeterC.addListener(noMeterPelangganListener);
  }

  @override
  void dispose() {
    debounce?.cancel();
    noMeterC.removeListener(noMeterPelangganListener);
    noMeterC.dispose();
    super.dispose();
  }

  Future<void> postInquiryPLNPrabayarStatus({
    required String productId,
    required double price
  }) async {
    try { 
      await Provider.of<PPOBProvider>(context, listen: false).postInquiryPLNPrabayarStatus(
        context,
        accountNumber: noMeterC.text,
        productId: productId,
        price: price.toString()
      );
    } on Exception catch(_) { } 
      catch(e, stackrace) {
      debugPrint(stackrace.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorResources.bgGrey,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const CustomAppBar(title: "Token Listrik", isBackButtonExist: true),

            Container(
              color: ColorResources.white,
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              height: 140.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    margin: const EdgeInsets.only(top: 10.0, left: 14.0),
                    child: Text(getTranslated("METER_NUMBER", context),
                      style: robotoRegular.copyWith(
                        color: ColorResources.black,
                        fontSize: Dimensions.fontSizeSmall
                      ),
                    ),
                  ),

                  Form(
                    key: formKey,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8.0, left: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: TextFormField(
                        controller: noMeterC,
                        focusNode: focusNode,
                        keyboardType: TextInputType.number,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: ColorResources.black 
                        ),
                        decoration: InputDecoration(
                          errorMaxLines: 1,
                          hintText: "Contoh 1234567890",
                          hintStyle: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color:ColorResources.hintColor
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, 
                            horizontal: 22.0
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            style: BorderStyle.none, width: 0),
                          ),
                          isDense: true
                        ),
                      ),
                    ),
                  ), 

                ],
              ),
            ),
            
            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                if(ppobProvider.listPricePLNPrabayarStatus == ListPricePLNPrabayarStatus.loading) {
                  return const Expanded(
                    child: Center(
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
                if(ppobProvider.listPricePLNPrabayarStatus == ListPricePLNPrabayarStatus.empty) {
                  return Container();
                }
                return Expanded(
                  child: GridView.builder(
                    itemCount: ppobProvider.listPricePLNPrabayarData.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1/1,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
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
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    width: 0.5,
                                    color: selected == i 
                                    ? ColorResources.purpleDark 
                                    : Colors.transparent
                                  )
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() => selected = i);
                                    await postInquiryPLNPrabayarStatus(
                                      productId: ppobProvider.listPricePLNPrabayarData[i].productId!,
                                      price: ppobProvider.listPricePLNPrabayarData[i].price!
                                    );
                                  },
                                  child: Container(
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(NumberFormat("###,000", "id_ID").format(ppobProvider.listPricePLNPrabayarData[i].price),
                                            style: robotoRegular.copyWith(
                                              color: selected == i 
                                              ? ColorResources.purpleDark 
                                              : ColorResources.dimGrey.withOpacity(0.8),
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          )
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
                  ),
                );
              },
            ), 

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                return ppobProvider.payPLNPrabayarStatus == PayPLNPrabayarStatus.loading 
                ? Container(
                    width: double.infinity,
                    color: ColorResources.white,
                    height: 60.0,
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(
                      child: SizedBox(
                        width: 16.0,
                        height: 16.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.hintColor),
                        ),
                      ),
                    ),
                  )  
                : const SizedBox();
              },
            )

          ],
        ),
      ),
    );
  }
}