import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:date_count_down/date_count_down.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';
import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/currency.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/screens/ecommerce/order/complaint.dart';
import 'package:saka/views/screens/ecommerce/order/tracking.dart';
import 'package:saka/views/screens/ecommerce/product/product_review.dart';

class DetailOrder extends StatefulWidget {
  final String transactionId;

  const DetailOrder({
    required this.transactionId,
    super.key
  });

  @override
  State<DetailOrder> createState() => DetailOrderState();
}

class DetailOrderState extends State<DetailOrder> {
  GlobalKey globalKey = GlobalKey();

  bool btnUnduhResi = true;
  bool icCopyResi = true;

  late EcommerceProvider ep;

  Future<void> getData() async {
    if(!mounted) return;
      await ep.detailOrder(transactionId: widget.transactionId);
  }

  Future<void> takeScreenshot() async {
    setState(() {
      btnUnduhResi = false;
      icCopyResi = false;
    });

    try {

      Future.delayed(Duration(seconds: 1), () async {
        RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        final directory = (await getApplicationDocumentsDirectory()).path;
        String fileName = 'screenshot.png';
        File imgFile = File('$directory/$fileName');
        imgFile.writeAsBytes(pngBytes);

        // await GallerySaver.saveImage(imgFile.path);
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          btnUnduhResi = true;
          icCopyResi = true;
        });
      });
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Screenshot saved!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to take screenshot: $e')));
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Pesanan",
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.bold,
            color: ColorResources.black
          ),
        ),
        leading: BackButton(
          color: ColorResources.black,
          onPressed: () {
            NS.pop();
          },
        ),
      ),
      body: Consumer<EcommerceProvider>(
        builder: (_, notifier, __) {
          if(notifier.detailOrderStatus == DetailOrderStatus.loading) {
            return Center(
              child: SizedBox(
                width: 32.0,
                height: 32.0,
                child: CircularProgressIndicator.adaptive(),
              )
            );
          }
          if(notifier.detailOrderStatus == DetailOrderStatus.error) {
            return Center(
              child: Text("Hmm... Mohon tunggu yaa",
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              )
            );
          }
          return RefreshIndicator.adaptive(
            onRefresh: () {
              return Future.sync(() { 
                getData();
              });
            },
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 16.0,
                right: 16.0
              ),
              itemCount: notifier.detailOrders.length,
              itemBuilder: (BuildContext context, int i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(notifier.detailOrders[i].invoice,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: ColorResources.black
                          ),
                        ),

                        notifier.detailOrders[i].expire == null 
                        ? const SizedBox() 
                        : notifier.orders[i].orderStatus == "WAITING_PAYMENT" 
                        ? Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: ColorResources.countdown,
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: CountDownText(
                              due: DateTime.parse(notifier.detailOrders[i].expire),
                              finishedText: "Kedaluwarsa",
                              showLabel: false,
                              longDateName: true,
                              daysTextLong: " Hari ",
                              hoursTextLong: " Jam ",
                              minutesTextLong: " Menit ",
                              secondsTextLong: " Detik ",
                              style: robotoRegular.copyWith(
                                color: ColorResources.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.fontSizeSmall
                              ),
                            ),
                          )
                        : const SizedBox() 

                      ],
                    ),

                    const SizedBox(height: 12.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(Helper.formatDate(notifier.detailOrders[i].createdAt),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: ColorResources.purple,
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Text(orderStatus(notifier.detailOrders[i].orderStatus),
                            style: robotoRegular.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.fontSizeSmall,
                              color: ColorResources.white,
                            ),
                          )
                        ),

                      ],
                    ),

                    Divider(
                      color: ColorResources.hintColor,
                    ),

                    const SizedBox(height: 15.0),

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        CachedNetworkImage(
                          imageUrl: notifier.detailOrders[i].store.logo,
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover
                                )
                              ),
                            );
                          },
                          placeholder: (BuildContext context, String url) {
                            return Center(
                              child: SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: CircularProgressIndicator.adaptive()
                              )
                            );
                          },
                          errorWidget: (BuildContext context, String url, dynamic error) {
                            return Container(
                              width: 45.0,
                              height: 45.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                  image: NetworkImage('https://dummyimage.com/300x300/000/fff'),
                                  fit: BoxFit.cover
                                )
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 8.0),

                        Text(notifier.detailOrders[i].store.name,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 20.0),

                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: notifier.detailOrders[i].items.length,
                      itemBuilder: (BuildContext context, int z) {
                        return Container(
                          margin: EdgeInsets.only(
                            top: 10.0,
                            bottom: 10.0
                          ),
                          child: Card(
                            elevation: 0.30,
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                          
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                          
                                      CachedNetworkImage(
                                        imageUrl: notifier.detailOrders[i].items[z].product.medias.isEmpty 
                                        ? "https://dummyimage.com/300x300/000/fff" 
                                        : notifier.detailOrders[i].items[z].product.medias.first.path,
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            width: 45.0,
                                            height: 45.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover
                                              )
                                            ),
                                          );
                                        },
                                        placeholder: (BuildContext context, String url) {
                                          return Center(
                                            child: SizedBox(
                                              width: 32.0,
                                              height: 32.0,
                                              child: CircularProgressIndicator.adaptive()
                                            )
                                          );
                                        },
                                        errorWidget: (BuildContext context, String url, dynamic error) {
                                          return Container(
                                            width: 45.0,
                                            height: 45.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              image: DecorationImage(
                                                image: NetworkImage('https://dummyimage.com/300x300/000/fff'),
                                                fit: BoxFit.cover
                                              )
                                            ),
                                          );
                                        },
                                      ),
                          
                                      const SizedBox(width: 12.0),
                          
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                          
                                          SizedBox(
                                            width: 200.0,
                                            child: Text(notifier.detailOrders[i].items[z].product.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeDefault
                                              ),
                                            ),
                                          ),
                          
                                          const SizedBox(height: 5.0),
                          
                                          Text("${Helper.formatCurrency(notifier.detailOrders[i].items[z].product.price)} x ${notifier.detailOrders[i].items[z].qty}",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeSmall,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                          
                                        ],
                                      )
                          
                                    ],
                                  ),
                          
                                  notifier.detailOrders[i].items[z].product.note.isEmpty 
                                  ? const SizedBox()
                                  : const SizedBox(height: 10.0),
                          
                                   notifier.detailOrders[i].items[z].product.note.isEmpty 
                                  ? const SizedBox()
                                  : Text("Catatan : ${notifier.detailOrders[i].items[z].product.note}",
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall
                                    ),
                                  ),
                          
                                ],
                              )
                            )
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20.0),

                    RepaintBoundary(
                      key: globalKey,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0
                        ),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: ColorResources.white
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                            
                                Text("Kurir",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        
                                btnUnduhResi 
                                ? notifier.detailOrders[i].waybill == "-" 
                                ? const SizedBox() 
                                : InkWell(
                                    onTap: () async {
                                      await takeScreenshot();
                                    },
                                    child: Text("Unduh resi",
                                      style: robotoRegular.copyWith(
                                        color: ColorResources.blue,
                                        fontSize: Dimensions.fontSizeSmall
                                      ),
                                    )
                                  ) 
                                : const SizedBox()
                        
                              ],
                            ),
                                        
                            const SizedBox(height: 5.0),
                                        
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                
                                Text("Nama",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                                        
                                Text(notifier.detailOrders[i].courierId.toUpperCase(),
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                )
                                        
                              ],
                            ),
                                        
                            const SizedBox(height: 5.0),
                                        
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                
                                Text("Layanan",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                                        
                                Text(notifier.detailOrders[i].courierService,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                )
                                        
                              ],
                            ),
                                        
                            const SizedBox(height: 5.0),
                                        
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                
                                Text("Biaya",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                                        
                                Text(Helper.formatCurrency(notifier.detailOrders[i].courierPrice),
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                )
                                        
                              ],
                            ),
                        
                            const SizedBox(height: 5.0),
                        
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                
                                Text("Berat",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                                            
                                Text(Helper.gramsToKilograms(double.parse(notifier.detailOrders[i].courierWeight.toString())),
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                )
                                            
                              ],
                            ),
                            
                            const SizedBox(height: 15.0),
                            
                            notifier.detailOrders[i].waybill == "-"  
                            ? const SizedBox() 
                            : const SizedBox(),
                            // BarcodeWidget(
                            //     height: 50.0,
                            //     barcode: Barcode.code128(),
                            //     margin: EdgeInsets.zero,
                            //     padding: EdgeInsets.zero,
                            //     drawText: false,
                            //     data: notifier.detailOrders[i].waybill,
                            //   ),
                            
                            notifier.detailOrders[i].waybill == "-"   
                            ? const SizedBox() 
                            : const SizedBox(height: 15.0),
                            
                            notifier.detailOrders[i].waybill == "-"  
                            ? const SizedBox() 
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                            
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                            
                                    Text("No Resi",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.black
                                      ),
                                    ),
                            
                                    icCopyResi 
                                    ? InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(text: notifier.detailOrders[i].waybill));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(notifier.detailOrders[i].waybill,
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
                                            size: 12.0,
                                          ),
                                        ),
                                      ) 
                                    : const SizedBox()
                            
                                  ],
                                ),
                            
                                Text(notifier.detailOrders[i].waybill,
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.purple,
                                    fontSize: Dimensions.fontSizeSmall,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                            
                              ],
                            ),
                            
                            const SizedBox(height: 8.0),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                            
                                Expanded(
                                  child: Text("Pengirim",
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  
                                      Text(notifier.detailOrders[i].seller.fullname,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.black
                                        ),
                                      ),
                            
                                      const SizedBox(height: 5.0),
                                  
                                      Text(notifier.detailOrders[i].seller.phone,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.black
                                        ),
                                      ),
                            
                                      const SizedBox(height: 5.0),
                                  
                                      Text(notifier.detailOrders[i].seller.address,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeExtraSmall,
                                          color: ColorResources.black
                                        ),
                                      ),
                                  
                                    ],
                                  ),
                                ),
                            
                              ],
                            ),
                            
                            const SizedBox(height: 10.0),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                            
                                Expanded(
                                  child: Text("Penerima",
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  
                                      Text(notifier.detailOrders[i].buyer.fullname,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.black
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 5.0),
                                  
                                      Text(notifier.detailOrders[i].buyer.phone,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.black
                                        ),
                                      ),
                            
                                      const SizedBox(height: 5.0),
                            
                                      Text(notifier.detailOrders[i].buyer.address,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeExtraSmall,
                                          color: ColorResources.black
                                        ),
                                      ),
                                  
                                    ],
                                  ),
                                ),
                            
                              ],
                            ),
                        
                          ],
                        ),
                      ),
                    ),

                    notifier.detailOrders[i].waybill == "-" 
                    ? const SizedBox()
                    : const SizedBox(height: 6.0),

                    Divider(
                      color: ColorResources.hintColor,
                    ),

                    const SizedBox(height: 8.0),

                    Text("Pembayaran",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Text("Metode Pembayaran",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.black
                          ),
                        ),

                        Text(notifier.detailOrders[i].paymentCode.toUpperCase(),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 10.0),

                    notifier.detailOrders[i].paymentCode == "gopay" || notifier.detailOrders[i].paymentCode == "shopee" || notifier.detailOrders[i].paymentCode == "dana" ||  notifier.detailOrders[i].paymentCode == "ovo"
                    ? notifier.detailOrders[i].orderStatus == "DELIVERED" || notifier.detailOrders[i].orderStatus == "REFUND"
                    ? const SizedBox() 
                    : Center(
                        child: CachedNetworkImage(
                          width: 350.0,
                          height: 350.0,
                          imageUrl: notifier.detailOrders[i].paymentAccess,
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
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                        
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [

                              Text("No VA",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: ColorResources.black
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: notifier.detailOrders[i].paymentAccess));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(notifier.detailOrders[i].paymentAccess,
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
                                    size: 12.0,
                                  ),
                                ),
                              ) 

                            ],
                          ),

                          Text(notifier.detailOrders[i].paymentAccess,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                      ],
                    ),

                    const SizedBox(height: 8.0),

                    Divider(
                      color: ColorResources.hintColor,
                    ),

                    const SizedBox(height: 8.0),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Text("Harga",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.black
                          ),
                        ),

                        Text(CurrencyHelper.formatCurrency(notifier.detailOrders[i].totalPrice),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.black
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 8.0),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Text("Biaya Kurir",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.black
                          ),
                        ),

                        Text(CurrencyHelper.formatCurrency(notifier.detailOrders[i].totalCost),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.black
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 8.0),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Text("Admin",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.black
                          ),
                        ),

                        Text(notifier.detailOrders[i].paymentCode == "gopay" || notifier.detailOrders[i].paymentCode == "shopee" || notifier.detailOrders[i].paymentCode == "dana" ||  notifier.detailOrders[i].paymentCode == "ovo"
                        ? CurrencyHelper.formatCurrency(1500)
                        : CurrencyHelper.formatCurrency(6500),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.black
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 8.0),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Text("Total Biaya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.black
                          ),
                        ),

                        Text(CurrencyHelper.formatCurrency(notifier.detailOrders[i].totalPrice + notifier.detailOrders[i].totalCost + (notifier.detailOrders[i].paymentCode == "gopay" || notifier.detailOrders[i].paymentCode == "shopee" || notifier.detailOrders[i].paymentCode == "dana" ||  notifier.detailOrders[i].paymentCode == "ovo"  ? 1500 : 6500)),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.purple
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 45.0),

                    notifier.detailOrders[i].waybill == "-" 
                    ? const SizedBox()
                    : CustomButton(
                        onTap: () {
                          NS.push(context, TrackingScreen(waybill: notifier.detailOrders[i].waybill));
                        },
                        isBorderRadius: true,
                        isBoxShadow: false,
                        btnColor: ColorResources.purple,
                        btnTextColor: ColorResources.white,
                        btnTxt: "Tracking",
                      ),

                    const SizedBox(height: 18.0),

                    notifier.detailOrders[i].orderStatus == "DELIVERED" 
                    ? CustomButton(
                        onTap: notifier.detailOrders[i].isReviewed 
                        ? () {} 
                        : () {
                          showGeneralDialog(
                            context: context,
                            barrierLabel: "Barrier",
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration: const Duration(milliseconds: 700),
                            pageBuilder: (BuildContext context, Animation<double> double, _) {
                              return Center(
                                child: Material(
                                  color: ColorResources.transparent,
                                  child: Container(
                                    margin: const EdgeInsets.all(20.0),
                                    height: 250.0,
                                    decoration: BoxDecoration(
                                      color: ColorResources.white, 
                                      borderRadius: BorderRadius.circular(20.0)
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                                                        
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("Pesanan sudah selesai ?",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeLarge,
                                              fontWeight: FontWeight.bold,
                                              color: ColorResources.black
                                            ),
                                          )
                                        ),
                                                                        
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 20.0,
                                                  bottom: 20.0
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Expanded(child: SizedBox()),
                                                    Expanded(
                                                      flex: 5,
                                                      child: CustomButton(
                                                        isBorderRadius: true,
                                                        isBoxShadow: false,
                                                        isBorder: true,
                                                        btnBorderColor: ColorResources.black,
                                                        fontSize: Dimensions.fontSizeSmall,
                                                        btnColor: ColorResources.white,
                                                        btnTextColor: ColorResources.black,
                                                        onTap: () {
                                                          NS.pop();
                                                        }, 
                                                        btnTxt: "Batal"
                                                      ),
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Consumer<EcommerceProvider>(
                                                        builder: (_, notifier, __) {
                                                          return CustomButton(
                                                            isBorderRadius: true,
                                                            isBoxShadow: false,
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            btnColor: ColorResources.success,
                                                            btnTextColor: ColorResources.white,
                                                            onTap: () async {
                                                              NS.push(context, ProductReviewScreen(transactionId: notifier.detailOrders[i].transactionId))
                                                              .then((_) async {
                                                                NS.pop();
                                                                Future.delayed(Duration(seconds: 1), () async {
                                                                  await ep.detailOrder(transactionId: widget.transactionId);
                                                                });
                                                              });
                                                            }, 
                                                            btnTxt: "Ulas"
                                                          );
                                                        },
                                                      )
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ) 
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              );
                            },
                            transitionBuilder: (_, anim, __, child) {
                              Tween<Offset> tween;
                              if (anim.status == AnimationStatus.reverse) {
                                tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
                              } else {
                                tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
                              }
                              return SlideTransition(
                                position: tween.animate(anim),
                                child: FadeTransition(
                                  opacity: anim,
                                  child: child,
                                ),
                              );
                            },
                          );
                        },
                        isBorderRadius: true,
                        isBoxShadow: false,
                        btnColor: notifier.detailOrders[i].isReviewed 
                        ? ColorResources.hintColor 
                        : ColorResources.green,
                        btnTextColor: ColorResources.white,
                        btnTxt: "Selesai",
                      )
                    : const SizedBox(),

                    const SizedBox(height: 10.0),

                    notifier.detailOrders[i].orderStatus == "DELIVERED" 
                    ? CustomButton(
                        isBorder: false,
                        isBorderRadius: true,
                        isBoxShadow: false,
                        btnColor: notifier.detailOrders[i].isReviewed 
                        ? ColorResources.hintColor
                        :ColorResources.redOnboarding,
                        btnTxt: "Komplain",
                        onTap: notifier.detailOrders[i].isReviewed  
                        ? () {} 
                        : () async {
                          showGeneralDialog(
                            context: context,
                            barrierLabel: "Barrier",
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration: const Duration(milliseconds: 700),
                            pageBuilder: (BuildContext context, Animation<double> double, _) {
                              return Center(
                                child: Material(
                                  color: ColorResources.transparent,
                                  child: Container(
                                    margin: const EdgeInsets.all(20.0),
                                    height: 250.0,
                                    decoration: BoxDecoration(
                                      color: ColorResources.white, 
                                      borderRadius: BorderRadius.circular(20.0)
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                                                        
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("Apa kamu yakin ingin komplain ?",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeLarge,
                                              fontWeight: FontWeight.bold,
                                              color: ColorResources.black
                                            ),
                                          )
                                        ),
                                                                        
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 20.0,
                                                  bottom: 20.0
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Expanded(child: SizedBox()),
                                                    Expanded(
                                                      flex: 5,
                                                      child: CustomButton(
                                                        isBorderRadius: true,
                                                        isBoxShadow: false,
                                                        fontSize: Dimensions.fontSizeSmall,
                                                        isBorder: true,
                                                        btnBorderColor: Colors.black,
                                                        btnColor: ColorResources.white,
                                                        btnTextColor: ColorResources.black,
                                                        onTap: () {
                                                          NS.pop();
                                                        }, 
                                                        btnTxt: "Batal"
                                                      ),
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Consumer<EcommerceProvider>(
                                                        builder: (_, notifier, __) {
                                                          return CustomButton(
                                                            isBorderRadius: true,
                                                            isBoxShadow: false,
                                                            isLoading: notifier.cancelOrderStatus == CancelOrderStatus.loading 
                                                            ? true 
                                                            : false,
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            btnColor: ColorResources.success,
                                                            btnTextColor: ColorResources.white,
                                                            onTap: () async {
                                                              NS.push(context, ComplaintScreen());
                                                            }, 
                                                            btnTxt: "Ya"
                                                          );
                                                        },
                                                      )
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ) 
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              );
                            },
                            transitionBuilder: (_, anim, __, child) {
                              Tween<Offset> tween;
                              if (anim.status == AnimationStatus.reverse) {
                                tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
                              } else {
                                tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
                              }
                              return SlideTransition(
                                position: tween.animate(anim),
                                child: FadeTransition(
                                  opacity: anim,
                                  child: child,
                                ),
                              );
                            },
                          );
                        },
                      ) 
                    : const SizedBox(), 
                   
                    notifier.detailOrders[i].orderStatus == "PAID"
                    ? CustomButton(
                        onTap: () async {
                          showGeneralDialog(
                            context: context,
                            barrierLabel: "Barrier",
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration: const Duration(milliseconds: 700),
                            pageBuilder: (BuildContext context, Animation<double> double, _) {
                              return Center(
                                child: Material(
                                  color: ColorResources.transparent,
                                  child: Container(
                                    margin: const EdgeInsets.all(20.0),
                                    height: 250.0,
                                    decoration: BoxDecoration(
                                      color: ColorResources.white, 
                                      borderRadius: BorderRadius.circular(20.0)
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                                                        
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("Batalkan pesanan ?",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeLarge,
                                              fontWeight: FontWeight.bold,
                                              color: ColorResources.black
                                            ),
                                          )
                                        ),
                                                                        
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 20.0,
                                                  bottom: 20.0
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Expanded(child: SizedBox()),
                                                    Expanded(
                                                      flex: 5,
                                                      child: CustomButton(
                                                        isBorderRadius: true,
                                                        isBoxShadow: false,
                                                        fontSize: Dimensions.fontSizeSmall,
                                                        isBorder: true,
                                                        btnBorderColor: Colors.black,
                                                        btnColor: ColorResources.white,
                                                        btnTextColor: ColorResources.black,
                                                        onTap: () {
                                                          NS.pop();
                                                        }, 
                                                        btnTxt: "Batal"
                                                      ),
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Consumer<EcommerceProvider>(
                                                        builder: (_, notifier, __) {
                                                          return CustomButton(
                                                            isBorderRadius: true,
                                                            isBoxShadow: false,
                                                            isLoading: notifier.cancelOrderStatus == CancelOrderStatus.loading 
                                                            ? true 
                                                            : false,
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            btnColor: ColorResources.success,
                                                            btnTextColor: ColorResources.white,
                                                            onTap: () async {
                                                              await ep.cancelOrder(transactionId: notifier.detailOrders[i].transactionId);
                                                            }, 
                                                            btnTxt: "Ya"
                                                          );
                                                        },
                                                      )
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ) 
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              );
                            },
                            transitionBuilder: (_, anim, __, child) {
                              Tween<Offset> tween;
                              if (anim.status == AnimationStatus.reverse) {
                                tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
                              } else {
                                tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
                              }
                              return SlideTransition(
                                position: tween.animate(anim),
                                child: FadeTransition(
                                  opacity: anim,
                                  child: child,
                                ),
                              );
                            },
                          );
                        },
                        isBorder: false,
                        isBoxShadow: false,
                        isBorderRadius: true,
                        btnColor: ColorResources.error,
                        btnTxt: "Batalkan pesanan",
                      )
                    : const SizedBox()

                  ],
                );
              },
            ),
          );
        },
      )
    );
  }

  String orderStatus(String val) {
    String orderStatus = "";

    switch (val) {
      case "REFUND":
        orderStatus = "Batal"; 
      break;
      case "WAITING_PAYMENT":
        orderStatus = "Belum bayar"; 
      break;
      case "PAID":
        orderStatus = "Dibayar"; 
      break;
      case "PACKING":
        orderStatus = "Dikemas"; 
      break;
      case "ON PROCESS": 
        orderStatus = "Dikirim";
      break;
      case "DELIVERED": 
        orderStatus = "Selesai";
      break;
      default:
    }

    return orderStatus;
  }

}