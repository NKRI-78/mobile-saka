import 'package:flutter/material.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class PaymentReceiptVaScreen extends StatefulWidget {
  @override
  State<PaymentReceiptVaScreen> createState() => PaymentReceiptVaScreenState();
}

class PaymentReceiptVaScreenState extends State<PaymentReceiptVaScreen> {
  final Map<String, dynamic> transactionData = {
    "message": "success",
    "data": {
      "orderId": "TEST-PAYMENT-VA-000001",
      "grossAmount": "500",
      "ChannelId": 2,
      "transactionStatus": "pending",
      "transactionId": "6ca11beb-a893-4bd4-bce1-54039f2279bb",
      "expire": "2024-09-06 17:02:43",
      "app": "MHS",
      "data": {
        "bank": "mandiri",
        "billKey": "47892570276",
        "vaNumber": "7001247892570276",
        "paymentType": "echannel",
        "billerCode": "70012"
      },
      "channel": {
        "id": 2,
        "paymentType": "VIRTUAL_ACCOUNT",
        "name": "Mandiri",
        "nameCode": "mandiri",
        "logo": null,
        "fee": null,
        "platform": "MIDTRANS",
        "howToUseUrl": null,
        "createdAt": "2024-06-26T00:00:00.000Z",
        "updatedAt": "2024-06-26T00:00:00.000Z",
        "deletedAt": null
      },
      "callbackUrl": "https"
    }
  };

  @override
  Widget build(BuildContext context) {
    final data = transactionData['data'] as Map<String, dynamic>;
    final channel = data['channel'] as Map<String, dynamic>;
    final paymentData = data['data'] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildDataRow('Order ID', data['orderId']),
            buildDataRow('Transaction Status', data['transactionStatus']),
            buildDataRow('Transaction ID', data['transactionId']),
            buildDataRow('Expire At', data['expire']),
            Divider(),
            const SizedBox(height: 5.0),
            Text('Payment Information',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge
              )
            ),
            const SizedBox(height: 5.0),
            buildDataRow('Bank', paymentData['bank']),
            buildDataRow('Bill Key', paymentData['billKey']),
            buildDataRow('VA Number', paymentData['vaNumber']),
            buildDataRow('Biller Code', paymentData['billerCode']),
            Divider(),
            const SizedBox(height: 5.0),
            Text('Channel Information',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge
              )
            ),
            const SizedBox(height: 5.0),
            buildDataRow('Payment Type', channel['paymentType']),
            buildDataRow('Name', channel['name']),
            buildDataRow('Platform', channel['platform']),
          ],
        ),
      ),
    );
  }

  Widget buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.bold
            ),
          ),
          Flexible(
            child: Text(value,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall
              ),
            ),
          ),
        ],
      ),
    );
  }
}
