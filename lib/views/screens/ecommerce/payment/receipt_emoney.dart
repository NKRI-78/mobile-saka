import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:saka/data/models/ecommerce/payment/response_emoney.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/currency.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/screens/dashboard/dashboard.dart';

class PaymentReceiptEmoney extends StatefulWidget {
  final int amount;
  final int cost;
  final String type;
  final ResponseMidtransEmoneyData responseMidtransEmoneyData;

  PaymentReceiptEmoney({
    required this.amount,
    required this.cost,
    required this.type,
    required this.responseMidtransEmoneyData
  });

  @override
  State<PaymentReceiptEmoney> createState() => PaymentReceiptEmoneyState();
}

class PaymentReceiptEmoneyState extends State<PaymentReceiptEmoney> {

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        NS.push(context, DashboardScreen());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Info Pembayaran',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: ColorResources.black
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text('Order ID : ${widget.responseMidtransEmoneyData.data.orderId}',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault
              ),
            ),
            Text('Jenis Pembayaran : ${widget.type.toUpperCase()}',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault
              ),
            ),
            Text('Jumlah Pembelian : ${CurrencyHelper.formatCurrency(widget.amount)}',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault
              ),
            ),
            widget.cost == 0 
            ? const SizedBox() 
            : Text('Biaya Kurir : ${CurrencyHelper.formatCurrency(widget.cost)}',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              ),
            Text('Admin : ${CurrencyHelper.formatCurrency(widget.responseMidtransEmoneyData.data.channel.fee)}',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault
              ),
            ),
            Text('Total Pembayaran : ${CurrencyHelper.formatCurrency(widget.responseMidtransEmoneyData.data.totalAmount)}',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault
              ),
            ),
            
            SizedBox(height: 20.0),
  
            Center(
              child: CachedNetworkImage(
                imageUrl: widget.responseMidtransEmoneyData.data.data.actions[0].url,
                errorWidget: (context, url, error) {
                  return Center(
                    child: Image.network('https://dummyimage.com/300x300/000/fff')
                  );
                },
                placeholder: (context, url) {
                  return Center(
                    child: CircularProgressIndicator()
                  );
                },
              )
            ),
  
            const SizedBox(height: 25.0),
  
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
  
                Expanded(
                  flex: 4,
                  child: CustomButton(
                    onTap: () {
                      NS.pushReplacement(context, DashboardScreen());
                    },
                    isBorderRadius: true,
                    isBoxShadow: false,
                    btnColor: ColorResources.purple,
                    btnTxt: "Halaman utama",
                  )
                ),
  
                Expanded(
                  flex: 1,
                  child: const SizedBox(),
                ),
  
                Expanded(
                  flex: 4,
                  child: CustomButton(
                    onTap: () async {
                      await launchUrl(Uri.parse(widget.responseMidtransEmoneyData.data.data.actions[1].url));
                    },
                    isBorderRadius: true,
                    isBoxShadow: false,
                    btnColor: Color(0xFF00AA13),
                    btnTxt: "Bayar via aplikasi",
                  )
                ),
  
              ],
            ),
            
          ],
        ),
      )),
    );
  }
}
