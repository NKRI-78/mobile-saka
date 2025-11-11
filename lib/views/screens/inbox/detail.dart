import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';

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
  State<InboxDetailScreen> createState() => InboxDetailScreenState();
}

class InboxDetailScreenState extends State<InboxDetailScreen> {

  bool expired = false;

  late EcommerceProvider ep;

  Future<void> getData() async {
    if(!mounted) return;
      await ep.howToPayment(channelId: widget.field7!);
  }

  @override
  void initState() {
    super.initState();

    ep = context.read<EcommerceProvider>();

    Future.microtask(() => getData());
  }

  @override 
  void dispose() {
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {

    DateTime targetDate = widget.field4!.isEmpty ? DateTime.now() : DateTime.parse(widget.field4.toString());
    Duration duration = targetDate.difference(DateTime.now());

    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [

          SliverAppBar(
            backgroundColor: ColorResources.brown,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: BackButton(
              color: ColorResources.white,
              onPressed: () {
                NS.pop();
              },
            ),
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Text(widget.subject!,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.bold,
                color: ColorResources.white
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 30.0
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
            
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    Dimensions.paddingSizeDefault, 15.0, 
                    Dimensions.paddingSizeDefault, 20.0
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    mainAxisSize: MainAxisSize.min,
                    children: [
            
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      
                          Text(DateFormat('dd MMM yyyy kk:mm').format(widget.created!), 
                            style: robotoRegular.copyWith(
                              color: ColorResources.black, 
                              fontSize: Dimensions.fontSizeDefault
                            )
                          ),
                      
                          const SizedBox(height: 5.0),
                      
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                      
                              widget.field6 == "-" || widget.type == "default"
                              ? const SizedBox() 
                              : Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
            
                                    Text("ID Transaksi :",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                      ),
                                    ),
            
                                    const SizedBox(width: 5.0),
            
                                    Text(widget.field6.toString(), 
                                      style: robotoRegular.copyWith(
                                        color: ColorResources.black, 
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
            
                                  ],
                                ),
                        
                              widget.field6 == "-" || widget.type == "default"
                              ? const SizedBox() 
                              : InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: widget.field6.toString()));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${widget.field6.toString()}',
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault
                                        ),
                                      )),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.copy,
                                      size: 15.0,
                                    ),
                                  ),
                                ),
                      
                            ],
                          )
                          
                        ],
                      ),
            
                      const SizedBox(height: 8.0),
            
                      Divider(),
            
                      const SizedBox(height: 8.0),
            
                      Text(widget.body.toString(),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black
                        ),
                      ),
            
                      const SizedBox(height: 25.0),
            
                      widget.field3 != "WAITING_PAYMENT" || widget.subject == "Topup berhasil"
                      ? const SizedBox() 
                      : widget.field2.toString() == "gopay" || widget.field2.toString() == "shopee" 
                      || widget.field2.toString() == "ovo" || widget.field2.toString() == "dana"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            expired 
                            ? Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: ColorResources.countdown,
                                  borderRadius: BorderRadius.circular(8.0)
                                ),
                                child: Text("Kedaluwarsa",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.fontSizeLarge
                                  ),
                                ),
                              )
                            : SlideCountdownSeparated(
                                duration: duration,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.white
                                ),
                                decoration: BoxDecoration(
                                  color: ColorResources.purple,
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                ),
                                onDone: () {
                                  setState(() {
                                    expired = true;
                                  });
                                },
                              )
            
                            // Container(
                            //   padding: EdgeInsets.all(5.0),
                            //   decoration: BoxDecoration(
                            //     color: ColorResources.countdown,
                            //     borderRadius: BorderRadius.circular(10.0)
                            //   ),
                            //   child: CountDownText(
                            //     due: DateTime.parse(widget.field4.toString()),
                            //     finishedText: "Kedaluwarsa",
                            //     showLabel: false,
                            //     longDateName: true,
                            //     daysTextLong: " Hari ",
                            //     hoursTextLong: " Jam ",
                            //     minutesTextLong: " Menit ",
                            //     secondsTextLong: " Detik ",
                            //     style: robotoRegular.copyWith(
                            //       color: ColorResources.white,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: Dimensions.fontSizeLarge
                            //     ),
                            //   ),
                            // ) 
            
                          ]
                        )
                      : const SizedBox(),
            
                      const SizedBox(height: 25.0),
                      
                      widget.subject == "Topup berhasil"
                      ? const SizedBox() 
                      : widget.field2.toString() == "gopay" || widget.field2.toString() == "shopee" 
                      || widget.field2.toString() == "ovo" || widget.field2.toString() == "dana" 
                      ? Center(
                          child: CachedNetworkImage(
                            imageUrl: widget.field1.toString(),
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
                        ) 
                      : const SizedBox(),
            
                        if(widget.field2.toString() != "gopay" && widget.field2.toString() != "shopee" 
                        && widget.field2.toString() != "ovo" && widget.field2.toString() != "dana") 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
            
                              widget.field3 != "WAITING_PAYMENT" || widget.subject == "Topup berhasil"
                              ? const SizedBox() 
                              : expired 
                              ? Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: ColorResources.countdown,
                                    borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  
                                  child: Text("Kedaluwarsa",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.fontSizeLarge
                                    ),
                                  ),
                                )
                              : SlideCountdownSeparated(
                                  duration: duration,
                                  decoration: BoxDecoration(
                                    color: ColorResources.purple,
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    fontWeight: FontWeight.bold,
                                    color: ColorResources.white
                                  ),
                                  onDone: () {
                                    setState(() {
                                      expired = true;
                                    });
                                  },
                                ),
            
                              const SizedBox(height: 20.0),
            
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
            
                                  widget.field1 == "-"
                                  ? const SizedBox() 
                                  : Text(widget.field1.toString(),
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeOverLarge,
                                      fontWeight: FontWeight.bold,
                                      color: ColorResources.black
                                    ),
                                  ),
            
                                  const SizedBox(width: 15.0),
            
                                  widget.field1 == "-" || widget.type == "default"
                                  ? const SizedBox() 
                                  : InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: widget.field1.toString()));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('${widget.field1.toString()}',
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                            ),
                                          )),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.copy,
                                              size: 15.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
            
                                ],
                              ),
                                
                            ],
                          ),
                   
                      ]
                    ),
                  ),
            
                  Consumer<EcommerceProvider>(
                    builder: (__, notifier, _) {
                      
                      if(notifier.howToPaymentStatus == HowToPaymentStatus.loading) {
                        return Center(
                          child: SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: CircularProgressIndicator.adaptive()
                          ),
                        );
                      }

                      if(notifier.howToPaymentStatus == HowToPaymentStatus.error) {
                        return const SizedBox();
                      }
            
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          
                          notifier.atm[0].data.isEmpty 
                          ? const SizedBox() 
                          : Container(
                            margin: EdgeInsets.only(
                              top: 16.0,
                              left: 16.0,
                              right: 16.0
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: notifier.atm.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
            
                                    Text(notifier.atm[i].title,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
            
                                    const SizedBox(height: 10.0),
            
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: notifier.atm[i].data.length,
                                      itemBuilder: (BuildContext context, int z) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
            
                                            Text("${notifier.atm[i].data[z].step}.",
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall,
                                              )
                                            ),
            
                                            const SizedBox(width: 4.0),
            
                                            Expanded(
                                              child: Text(notifier.atm[i].data[z].content,
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeSmall,
                                                )
                                              ),
                                            )
            
                                          ],
                                        );
                                        
                                        
                                      },
                                    )
            
                                  ],
                                ); 
                              },
                            ),
                          ),

                          notifier.mbank[0].data.isEmpty 
                          ? const SizedBox() 
                          : Container(
                              margin: EdgeInsets.only(
                                top: 16.0,
                                left: 16.0,
                                right: 16.0
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: notifier.mbank.length,
                                itemBuilder: (BuildContext context, int i) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
            
                                    Text(notifier.mbank[i].title,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
            
                                    const SizedBox(height: 10.0),
            
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: notifier.mbank[i].data.length,
                                      itemBuilder: (BuildContext context, int z) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
            
                                            Text("${notifier.mbank[i].data[z].step}.",
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall,
                                              )
                                            ),
            
                                            const SizedBox(width: 4.0),
            
                                            Expanded(
                                              child: Text(notifier.mbank[i].data[z].content,
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeSmall,
                                                )
                                              ),
                                            )
            
                                          ],
                                        );
                                        
                                      },
                                    )
            
                                  ],
                                ); 
                              },
                            ),
                          ),

                          notifier.emoney[0].data.isEmpty 
                          ? const SizedBox() 
                          : Container(
                            margin: EdgeInsets.only(
                              top: 16.0,
                              left: 16.0,
                              right: 16.0
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: notifier.emoney.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
            
                                    Text(notifier.emoney[i].title,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
            
                                    const SizedBox(height: 10.0),
            
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: notifier.emoney[i].data.length,
                                      itemBuilder: (BuildContext context, int z) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
            
                                            Text("${notifier.emoney[i].data[z].step}.",
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall,
                                              )
                                            ),
            
                                            const SizedBox(width: 4.0),
            
                                            Expanded(
                                              child: Text(notifier.emoney[i].data[z].content,
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeSmall,
                                                )
                                              ),
                                            )
            
                                          ],
                                        );
                                        
                                      },
                                    )
            
                                  ],
                                ); 
                              },
                            ),
                          ),
            
                      
                        ],
                      );
                    },
                  ),
            
                ]
              )
            ),
          ),
        ],
      )
    );
  }

}