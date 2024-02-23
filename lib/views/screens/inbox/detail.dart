import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/helper.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/button/custom.dart';

class InboxDetailScreen extends StatefulWidget {
  final String? inboxId;
  final String? recepientId; 
  final String? senderId;
  final String? subject;
  final String? body;
  final String? type;
  final String? typeInbox;
  final String? field1;
  final String? field2;
  final String? field3;
  final String? field4;
  final String? field5;
  final String? field6;
  final String? field7;
  final bool? read;
  final DateTime? created;
  final DateTime? updated;

  const InboxDetailScreen({
    required this.inboxId,
    required this.recepientId, 
    required this.senderId,
    required this.subject,
    required this.body,
    required this.type,
    required this.typeInbox,
    required this.field1,
    required this.field2,
    required this.field3,
    required this.field4,
    required this.field5,
    required this.field6,
    required this.field7,
    required this.read,
    required this.created,
    required this.updated,
    Key? key
  }) : super(key: key);

  @override
  State<InboxDetailScreen> createState() => _InboxDetailScreenState();
}

class _InboxDetailScreenState extends State<InboxDetailScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

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
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [

          SliverAppBar(
            backgroundColor: ColorResources.primaryOrange,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: CupertinoNavigationBarBackButton(
              color: ColorResources.white,
              onPressed: () {
                NS.pop(context);
              },
            ),
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Text(widget.subject!,
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w600,
                color: ColorResources.white
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([

              Container(
                padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault, 15.0, 
                  Dimensions.paddingSizeDefault, 20.0
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [

                    Text(DateFormat('dd MMM yyyy kk:mm').format(widget.created!.toLocal()), 
                      style: poppinsRegular.copyWith(
                        color: ColorResources.black, 
                        fontSize: Dimensions.fontSizeDefault
                      )
                    ),
                    
                    if(widget.type == "payment.waiting" || widget.type == "default" || widget.type == "purchase.success" || widget.type == "payment.paid" || widget.type == "payment.expired" || widget.type == "order.seller.new" || widget.type == "order.seller.delivered" || widget.type == "order.buyer.delivered" || widget.type == "order.buyer.shipping")
                      Container(
                        margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall),
                        decoration: BoxDecoration(
                          color: ColorResources.white,
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if(widget.type == "payment.waiting" || widget.type == "purchase.success" || widget.type == "payment.paid" || widget.type == "order.seller.new" || widget.type == "order.buyer.delivered" || widget.type == "order.seller.delivered" || widget.type == "order.buyer.shipping")
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text("Nomor Transaksi",
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.black, 
                                        fontSize: Dimensions.fontSizeDefault
                                      )
                                    ),
                                    SelectableText("${widget.field1}",
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.black, 
                                        fontSize: Dimensions.fontSizeDefault
                                      )
                                    ),
                                  ]
                                ),
                                if(widget.type == "payment.waiting" || widget.type == "purchase.success" || widget.type == "payment.paid" || widget.type == "order.seller.new" || widget.type == "order.buyer.delivered" || widget.type == "order.seller.delivered" || widget.type == "order.buyer.shipping")
                                  const SizedBox(height: 5.0),
                                if(widget.type == "payment.waiting" || widget.type == "purchase.success" || widget.type == "payment.paid" || widget.type == "order.seller.new" || widget.type == "order.buyer.delivered" || widget.type == "order.seller.delivered" || widget.type == "order.buyer.shipping")
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Nominal",
                                        style: poppinsRegular.copyWith(
                                          color: ColorResources.black, 
                                          fontSize: Dimensions.fontSizeDefault
                                        )
                                      ),
                                      if(widget.field2 != null || widget.field2 != "")
                                        Text(Helper.formatCurrency(double.parse(widget.field2.toString())),
                                          style: poppinsRegular.copyWith(
                                            color: ColorResources.black, 
                                            fontSize: Dimensions.fontSizeDefault
                                          )
                                        ),
                                    ]
                                  ),
                                if(widget.type == "default")
                                  const SizedBox(height: 5.0),
                                if(widget.type == "default") 
                                  SelectableText(widget.subject!,
                                    style: poppinsRegular.copyWith(
                                      color: ColorResources.black, 
                                      fontSize: Dimensions.fontSizeDefault,
                                    )
                                  ),
                                if(widget.type == "payment.waiting" || widget.type == "purchase.success" || widget.type == "payment.paid" || widget.type == "payment.expired" || widget.type == "order.seller.new" || widget.type == "order.seller.delivered" || widget.type == "order.buyer.delivered" || widget.type == "order.buyer.shipping")
                                  const SizedBox(height: 5.0),
                                if(widget.type == "payment.waiting" || widget.type == "purchase.success" || widget.type == "payment.paid" || widget.type == "payment.expired" || widget.type == "order.seller.new" || widget.type == "order.seller.delivered" || widget.type == "order.buyer.delivered" || widget.type == "order.buyer.shipping") 
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Status",
                                        style: poppinsRegular.copyWith(
                                          color: ColorResources.black, 
                                          fontSize: Dimensions.fontSizeDefault
                                        )
                                      ),
                                      SelectableText("${widget.subject}",
                                        style: poppinsRegular.copyWith(
                                          color: ColorResources.black, 
                                          fontSize: Dimensions.fontSizeDefault
                                        )
                                      ),
                                    ]
                                  ),
                                if(widget.type == "payment.waiting" || widget.type == "default" || widget.type == "purchase.success" || widget.type == "payment.paid" || widget.type == "payment.expired" || widget.type == "order.seller.new" || widget.type == "order.seller.delivered" || widget.type == "order.buyer.delivered" || widget.type == "order.buyer.shipping")
                                  const SizedBox(height: 10.0),
                                if(widget.type == "payment.waiting" || widget.type == "default" || widget.type == "purchase.success" || widget.type == "payment.paid" || widget.type == "payment.expired" || widget.type == "order.seller.new" || widget.type == "order.seller.delivered" || widget.type == "order.buyer.delivered" || widget.type == "order.buyer.shipping")
                                  GestureDetector(
                                    onTap: widget.type == "default" 
                                    ? () async {
                                        try {
                                          await launch(widget.body!);
                                        } catch(e, stacktrace) {
                                          debugPrint(stacktrace.toString());
                                        } 
                                      } 
                                    : () {},
                                    child:  widget.body!.startsWith("https://") || widget.body!.startsWith("http://")  
                                    ? Text(widget.body!, 
                                        style: poppinsRegular.copyWith(
                                          color: ColorResources.primaryOrange, 
                                          fontSize: Dimensions.fontSizeDefault
                                       )
                                      )
                                    : SelectableText(widget.body!, 
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.black, 
                                        fontSize: Dimensions.fontSizeDefault
                                      )
                                    ),
                                  ),
                                if(widget.type == "payment.waiting" || widget.type == "purchase.success") 
                                  if(widget.field6!.isNotEmpty)
                                    SelectableText(widget.field6!, 
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.black, 
                                        fontSize: Dimensions.fontSizeDefault
                                      )
                                    ),
                              
                                if(widget.type == "payment.waiting")
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: Dimensions.marginSizeDefault, 
                                      left: Dimensions.marginSizeExtraSmall, 
                                      right: Dimensions.marginSizeExtraSmall
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if(widget.field5!.contains("://") && widget.field4! != 'topup')
                                          CustomButton(
                                            btnColor: ColorResources.primaryOrange,
                                            onTap: () async {
                                              if(widget.field5!.isNotEmpty) {
                                                launch(widget.field5.toString());
                                              } else {
                                                ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
                                              }
                                            }, 
                                            height: 35.0,
                                            isBoxShadow: false,
                                            isBorderRadius: true,
                                            btnTxt: getTranslated("SEE_BILL", context)
                                          ),
                                        if(widget.field5!.contains("://") && widget.field4! != "topup")
                                          const SizedBox(height: 12.0),
                                        if(widget.field5!.contains("://") && widget.field4 != "topup")
                                          if(widget.field5!.split("://")[1].split("/")[0] != "linkaja.id" && widget.field5!.split("://")[1].split("/")[0] != "wsa.wallet.airpay.co.id") 
                                            CustomButton(
                                              btnColor: ColorResources.primaryOrange,
                                              onTap: () async {
                                                try {
                                                  await launch("${AppConstants.baseUrlHelpInboxPayment}/${widget.field1.toString()}");
                                                } catch(e, stacktrace) {
                                                  debugPrint(stacktrace.toString());
                                                }
                                              }, 
                                              height: 35.0,
                                              isBoxShadow: false,
                                              isBorderRadius: true,
                                              btnTxt: getTranslated("HOW_TO_PAYMENT", context)
                                            ),
                                        ]
                                      ),
                                    )
                            ]
                          ),
                        ),
                      )
                    ]
                  ),
                ),

              ]
            )
          ),
        ],
      )
    );
  }
}