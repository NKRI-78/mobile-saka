import 'dart:async';

import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/currency.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/views/basewidgets/button/bounce.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => TopupScreenState();
}

class TopupScreenState extends State<TopupScreen> {

  late EcommerceProvider ep;

  Timer? debounce;

  List<Map<String, dynamic>> denoms = [
    {
      "id": 1,
      "price": 10000
    },
    {
      "id": 2,
      "price": 20000
    },
    {
      "id": 3,
      "price": 50000
    },
    {
      "id": 4,
      "price": 100000
    },
    {
      "id": 5,
      "price": 250000
    },
    {
      "id": 6,
      "price": 500000
    }
  ];
  
  @override 
  void initState() {
    super.initState();

    ep = context.read<EcommerceProvider>(); 
  }

  @override 
  void dispose() {
    debounce?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: kElevationToShadow[1]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Consumer<EcommerceProvider>(
              builder: (_, notifier, __) {
                return notifier.channelId != -1 
                ? Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0
                    ),
                    child: Bouncing(
                    onPress: () async {
                      await notifier.getPaymentChannel(
                        context: context,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                          width: 3.0,
                          style: BorderStyle.solid,
                          color: const Color(0xFFD9D9D9)
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                        
                            Expanded(
                              flex: 4,
                              child: CachedNetworkImage(
                                imageUrl: notifier.paymentLogo,
                                imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                  return Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: imageProvider)
                                    ),
                                  );
                                },
                                errorWidget: (BuildContext context, String url, dynamic error) {
                                  return Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('assets/images/default_image.png'))
                                    ),
                                  ); 
                                },
                              )
                            ),

                            Expanded(
                              flex: 1,
                              child: const SizedBox(),
                            ),
                        
                            Expanded(
                              flex: 12,
                              child: Text(notifier.getPaymentChannelStatus == GetPaymentChannelStatus.loading 
                              ? "Mohon tunggu..."
                              : notifier.paymentName,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.black
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xffC5C3C3)
                              )
                            )
                        
                          ]),
                        ),
                      ),
                    )
                  )
                : Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0
                    ),
                    child: Bouncing(
                    onPress: () async {
                      await ep.getPaymentChannel(
                        context: context,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                          width: 3.0,
                          style: BorderStyle.solid,
                          color: const Color(0xFFD9D9D9)
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                        
                            Expanded(
                              flex: 4,
                              child: Icon(
                                Icons.payment,
                                color: ColorResources.purple,
                              )
                            ),
                        
                            Expanded(
                              flex: 12,
                              child: Text(notifier.getPaymentChannelStatus == GetPaymentChannelStatus.loading 
                              ? "Mohon tunggu..."
                              : "Pilih Pembayaran",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.purple
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: ColorResources.purple
                              )
                            )
                        
                          ],
                        ),
                      ),
                    ),
                  )
                );
              },
            ),

            Consumer<EcommerceProvider>(
              builder: (__, notifier, _) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                    right: 10.0,
                    bottom: 15.0
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Jumlah yang dipilih",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black
                        ),
                      ),

                      Text(CurrencyHelper.formatCurrency(notifier.selectedTopupPrice),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.black
                        ),
                      ),

                    ],
                  ) 
                );
              },
            ),

            Consumer<EcommerceProvider>(
              builder: (__, notifier, _) {
                return CustomButton(
                  onTap: () async {
                    if(notifier.selectedTopupPrice == 0) {
                      ShowSnackbar.snackbar("Anda belum memilih Denom", "", ColorResources.error);
                      return;
                    }

                    if(notifier.channelId == -1) {
                      ShowSnackbar.snackbar("Anda belum memilih Metode Pembayaran", "", ColorResources.error);
                      return;
                    }

                    await notifier.payTopup();
                  },
                  isLoading: notifier.payStatus == PayStatus.loading 
                  ? true 
                  : false,
                  isBorderRadius: true,
                  isBorder: false,
                  isBoxShadow: false,
                  btnTxt: "Selanjutnya",
                );
              },
            ),

          ],        
        )
      ),
      body: Consumer<EcommerceProvider>(
        builder: (__, notifier, _) {
          return CustomScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()
            ),
            slivers: [
      
              SliverAppBar(
                title: Text("Isi Saldo",
                  style: robotoRegular.copyWith(
                    color: ColorResources.black,
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.bold
                  ),
                ),
                leading: CupertinoNavigationBarBackButton(
                  color: Colors.black,
                  onPressed: () {
                    NS.pop();
                  },
                ),
              ),
              
              SliverPadding(
                padding: EdgeInsets.only(
                  top: 80.0,
                  bottom: 20.0,
                  left: 15.0,
                  right: 15.0
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3.0 / 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int i) {
                      return Material(
                        color: notifier.selectedTopupId == denoms[i]["id"] 
                        ? ColorResources.purpleDark
                        : ColorResources.purple,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            int id = denoms[i]["id"];
                            int price = denoms[i]["price"];
      
                            ep.selectTopup(
                              id: id,
                              price: price
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Text("${CurrencyHelper.formatCurrency(denoms[i]["price"])}",
                              style: robotoRegular.copyWith(
                                color: Colors.white, 
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: denoms.length,
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0
                ),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 30.0,
                      bottom: 20.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: TextField(
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: ColorResources.black
                      ),
                      controller: ep.amountC,
                      onChanged: (String? val) {
                        if (debounce?.isActive ?? false) debounce?.cancel();
                          debounce = Timer(const Duration(milliseconds: 2000), () {

                            String numericString = val!.replaceAll(RegExp(r'[^0-9]'), '');
                            int? value = int.tryParse(numericString);

                            if(value != null) {
                              if(value < 10000) {

                                String formattedText = NumberFormat.currency(
                                  locale: 'id',
                                  symbol: 'Rp',
                                  decimalDigits: 0,
                                  customPattern: 'Rp #,##0'
                                ).format(10000);

                                ep.amountC.text = formattedText;

                                ep.onManualTopup(
                                  price: int.parse(formattedText.replaceAll(RegExp(r'[^0-9]'), ''))
                                );
                                
                                ep.amountC.selection = TextSelection.fromPosition(
                                  TextPosition(offset: ep.amountC.text.length),
                                );

                              } else {

                                String formattedText = NumberFormat.currency(
                                  locale: 'id',
                                  symbol: 'Rp',
                                  decimalDigits: 0,
                                  customPattern: 'Rp #,##0'
                                ).format(value);

                                ep.onManualTopup(
                                  price: int.parse(formattedText.replaceAll(RegExp(r'[^0-9]'), ''))
                                );

                              }
                            }

                          });
                      },
                      inputFormatters: [
                        CurrencyTextInputFormatter.currency(
                          locale: 'id',
                          decimalDigits: 0,
                          symbol: 'Rp ',
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: "Masukan Nominal Minimal : Rp 10.000",
                        hintStyle: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorResources.black
                          )
                        )
                      ),
                    )
                  )
                )
              ),
      
            ],
          );
        },
      )
    );
  }
}