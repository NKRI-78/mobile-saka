import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:timelines/timelines.dart' as t;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/data/models/store/shipping_tracking.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/box_shadow.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

class DetailBuyerTransactionScreen extends StatefulWidget {
  final String typeUser;
  final String status;

  const DetailBuyerTransactionScreen({
    Key? key,
    required this.typeUser,
    required this.status})
    : super(key: key);
  @override
  _DetailBuyerTransactionScreenState createState() => _DetailBuyerTransactionScreenState();
}

class _DetailBuyerTransactionScreenState extends State<DetailBuyerTransactionScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Color completeColor = const Color(0xff5e6172);
  Color inProgressColor = const Color(0xff5ec792);
  Color todoColor = const Color(0xffd1d2d7);

  List<String> processes = [
    'Paid',
    'Packed',
    'Pickup',
    'Shipped',
    'Delivered',
    'Completed'
  ];

  Color getColor(int index, int processIndex) {
    if (index == processIndex) {
      return inProgressColor;
    } else if (index < processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  Future<void> getData() async {
    if(mounted) {
      await context.read<StoreProvider>().getTransactionPaidSingle(context, Helper.prefs!.getString("idTrx")!, widget.typeUser);
    }
  }

  @override
  void initState() {
    super.initState();

    getData();
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
      appBar: AppBar( 
        centerTitle: true,
        title: Text("Detail Transaksi",
          style: robotoRegular.copyWith(
            color: ColorResources.white, 
            fontWeight: FontWeight.w600
          ),
        ),
        elevation: 0.0,
        backgroundColor: ColorResources.primaryOrange,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.white,
          onPressed: () {
            NS.pop(context);
          },
        )
      ),
      body: context.watch<StoreProvider>().transactionPaidSingleStatus == TransactionPaidSingleStatus.loading
        ? const Loader(
            color: ColorResources.primaryOrange,
          )
        : Stack(
            clipBehavior: Clip.none,
            children: [
            RefreshIndicator(
              backgroundColor: ColorResources.primaryOrange,
              color: ColorResources.white,
              onRefresh: () {
                return context.read<StoreProvider>().getTransactionPaidSingle(context, Helper.prefs!.getString("idTrx")!, widget.typeUser);
              },
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 12.0, bottom: 5.0, 
                      left: 16.0, right: 16.0
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status Pesanan",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    )
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 5.0, 
                      left: 16.0, right: 16.0
                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ORDER #",
                            style: robotoRegular.copyWith(
                              color: ColorResources.primaryOrange,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                          const SizedBox(width: 8.0),
                          SelectableText(context.read<StoreProvider>().tps.id.toString(),
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("INVOICE #",
                            style: robotoRegular.copyWith(
                              color: ColorResources.primaryOrange,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                          const SizedBox(width: 8.0),
                          SelectableText(context.read<StoreProvider>().tps.invoiceNo!.toString(),
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ],
                      ),
                    ],
                  )
                ),
                FutureBuilder<ShippingTrackingModel?>(
                  future: context.read<StoreProvider>().getShippingTracking(context, context.read<StoreProvider>().tps.id!),
                  builder: (BuildContext context, AsyncSnapshot<ShippingTrackingModel?> snapshot) {
                    if (snapshot.hasData) {
                      ShippingTrackingModel shippingTrackingModel = snapshot.data!;
                      return Container(
                        margin: const EdgeInsets.only(top: 15.0),
                        height: 120.0,
                        child: t.Timeline.tileBuilder(
                          theme: t.TimelineThemeData(
                            direction: Axis.horizontal,
                            connectorTheme: const t.ConnectorThemeData(
                              space: 30.0,
                              thickness: 5.0,
                            ),
                          ),
                          builder: t.TimelineTileBuilder.connected(
                            connectionDirection: t.ConnectionDirection.before,
                            itemExtentBuilder: (_, __) => MediaQuery.of(context).size.width / processes.length,
                            oppositeContentsBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Image.asset('assets/images/icons/ic-status-transaction-$index.png',
                                  width: 30.0,
                                  color: getColor(index, shippingTrackingModel.data!.orderStatusInfos!.length - 1),
                                ),
                              );
                            },
                            contentsBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(processes[index],
                                  style: robotoRegular.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: getColor(index, shippingTrackingModel.data!.orderStatusInfos!.length - 1
                                  ),
                                )),
                              );
                            },
                            indicatorBuilder: (_, index) {
                              dynamic color;
                              dynamic child;
                              if (index == shippingTrackingModel.data!.orderStatusInfos!.length - 1) {
                                color = inProgressColor;
                                child = const Icon(
                                  Icons.check,
                                  color: ColorResources.white,
                                  size: 15.0,
                                );
                              } else if (index < shippingTrackingModel.data!.orderStatusInfos!.length - 1) {
                                color = completeColor;
                                child = const Icon(
                                  Icons.check,
                                  color: ColorResources.white,
                                  size: 15.0,
                                );
                              } else {
                                color = todoColor;
                              }
                              if (index <= shippingTrackingModel.data!.orderStatusInfos!.length - 1) {
                                return Stack(
                                  children: [
                                    CustomPaint(
                                      size: const Size(30.0, 30.0),
                                      painter: _BezierPainter(
                                        color: color,
                                        drawStart: index > 0,
                                        drawEnd: index < shippingTrackingModel.data!.orderStatusInfos!.length - 1,
                                      ),
                                    ),
                                    t.DotIndicator(
                                      size: 30.0,
                                      color: color,
                                      child: child,
                                    ),
                                  ],
                                );
                              } else {
                                return Stack(
                                  children: [
                                    CustomPaint(
                                      size: const Size(15.0, 15.0),
                                      painter: _BezierPainter(
                                        color: color,
                                        drawEnd: index < shippingTrackingModel.data!.orderStatusInfos!.length - 1,
                                      ),
                                    ),
                                    t.OutlinedDotIndicator(
                                      borderWidth: 4.0,
                                      color: color,
                                    ),
                                  ],
                                );
                              }
                            },
                            connectorBuilder: (_, index, type) {
                              if (index > 0) {
                                if (index == shippingTrackingModel.data!.orderStatusInfos!.length - 1) {
                                  final prevColor = getColor(index - 1, shippingTrackingModel.data!.orderStatusInfos!.length - 1);
                                  final color = getColor(index, shippingTrackingModel.data!.orderStatusInfos!.length - 1);
                                  List<Color> gradientColors;
                                  if (type == t.ConnectorType.start) {
                                    gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
                                  } else {
                                    gradientColors = [
                                      prevColor,
                                      Color.lerp(prevColor, color, 0.5)!
                                    ];
                                  }
                                  return t.DecoratedLineConnector(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: gradientColors,
                                      ),
                                    ),
                                  );
                                } else {
                                  return t.SolidLineConnector(
                                    color: getColor(index, shippingTrackingModel.data!.orderStatusInfos!.length - 1),
                                  );
                                }
                              } else {
                                return null;
                              }
                            },
                            itemCount: processes.length,
                          ),
                        ),
                      );
                    }
                    return const SizedBox(
                      height: 100.0,
                      child: Loader(
                        color: ColorResources.primaryOrange,
                      ),
                    );
                  },
                ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10.0, bottom: 5.0, 
                  left: 16.0, right: 16.0
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Toko ",
                          style: robotoRegular.copyWith(
                            color: ColorResources.primaryOrange,
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeDefault,
                          )
                        ),
                        Text(context.read<StoreProvider>().tps.store!.name!,
                          style: robotoRegular.copyWith(
                            color: ColorResources.primaryOrange,
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeDefault,
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                   
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: context.read<StoreProvider>().tps.products!.length,
                      itemBuilder: (BuildContext context, int i) {
                        return  Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 0.5,
                              color: ColorResources.grey,
                            )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 60.0,
                                    height: 60.0,
                                    child: Stack(
                                      children: [
                                        context.read<StoreProvider>().tps.products![i].product!.pictures!.isEmpty 
                                        ? const SizedBox()
                                        : Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12.0),
                                            child: CachedNetworkImage(
                                              imageUrl: "${context.read<StoreProvider>().tps.products![i].product!.pictures!.first.path}",
                                              fit: BoxFit.cover,
                                              placeholder: (BuildContext context, dynamic url) => Center(
                                                child: Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.grey[100]!,
                                                child: Container(
                                                  color: ColorResources.white,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              )),
                                              errorWidget: (BuildContext context, String url, dynamic error) {
                                                return Center(
                                                    child: Image.asset(
                                                    "assets/images/logo/saka.png",
                                                    fit: BoxFit.cover,
                                                  )
                                                );
                                              }
                                            ),
                                          )
                                        ),
                                        // context.read<StoreProvider>().tps.products![i].product!.discount != null
                                        // ? Align(
                                        //     alignment: Alignment.topLeft,
                                        //     child: Container(
                                        //       height: 20.0,
                                        //       width: 25.0,
                                        //       padding: const EdgeInsets.all(5.0),
                                        //       decoration: const BoxDecoration(
                                        //         borderRadius: BorderRadius.only(
                                        //           bottomRight: Radius.circular(12.0),
                                        //           topLeft: Radius.circular(12.0)
                                        //         ),
                                        //         color: ColorResources.error
                                        //       ),
                                        //       child: Center(
                                        //         child: Text(context.read<StoreProvider>().tps.products![i].product!.discount!.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                        //           style: robotoRegular.copyWith(
                                        //             color: ColorResources.white,
                                        //             fontSize: Dimensions.fontSizeDefault,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   )
                                        // : Container()
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        context.read<StoreProvider>().tps.products![i].product!.name!.length > 75
                                        ? Text(context.read<StoreProvider>().tps.products![i].product!.name!.substring(0, 80) + "...",
                                            maxLines: 2,
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                            ),
                                          )
                                        : Text(context.read<StoreProvider>().tps.products![i].product!.name!,
                                            maxLines: 2,
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(context.read<StoreProvider>().tps.products![i].quantity.toString() + " barang " + "(" + (context.read<StoreProvider>().tps.products![i].product!.weight! * context.read<StoreProvider>().tps.products![i].quantity!).toString() + " gr)",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: ColorResources.primaryOrange,
                                          )
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(Helper.formatCurrency(context.read<StoreProvider>().tps.products![i].product!.price!),
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.black,
                                            fontWeight: FontWeight.w600,
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Belanja",
                                        style: robotoRegular.copyWith(
                                          color: ColorResources.black,
                                          fontSize: Dimensions.fontSizeDefault,
                                        )
                                      ),
                                      const SizedBox(height: 8),
                                      Text(Helper.formatCurrency(context.read<StoreProvider>().tps.products![i].product!.price! * context.read<StoreProvider>().tps.products![i].quantity!),
                                        style: robotoRegular.copyWith(
                                          color: ColorResources.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: Dimensions.fontSizeDefault,
                                        )
                                      ),
                                    ],
                                  ),
                                  widget.status == "DELIVERED"
                                  ? SizedBox(
                                      height: 40.0,
                                      width: 80.0,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          backgroundColor: ColorResources.primaryOrange,
                                        ),
                                        child: Center(
                                          child: Text("Beli Lagi",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: ColorResources.white
                                            )
                                          )
                                        ),
                                        onPressed: () async {
                                          if (context.read<StoreProvider>().tps.products![i].product!.stock! < 1) {
                                            ShowSnackbar.snackbar(context, "Stock Barang Habis", "", ColorResources.success);
                                            return;
                                          } else {
                                            await context.read<StoreProvider>().postAddCart(context, context.read<StoreProvider>().tps.products![i].productId!, context.read<StoreProvider>().tps.products![i].product!.minOrder!);
                                          }
                                        }
                                      )
                                    )
                                  : Container()
                                ],
                              ),
                            ],
                          ),
                        ); 
                      },
                    )
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Detail Pengiriman",
                      style: robotoRegular.copyWith(
                        color: ColorResources.black,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fontSizeDefault,
                      )
                    ),
                    if(context.read<StoreProvider>().tps.wayBill != null)
                      const SizedBox(height: 15.0),
                    if(context.read<StoreProvider>().tps.wayBill != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text("No. Resi",
                              style: robotoRegular.copyWith(
                                color: ColorResources.black,
                                fontSize: Dimensions.fontSizeDefault,
                              )
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                  context.read<StoreProvider>().tps.wayBill!,
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeDefault,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("Toko",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.read<StoreProvider>().tps.store!.name!,
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault,
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("Asal",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.read<StoreProvider>().tps.store!.city!,
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault,
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("Pembeli",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.read<StoreProvider>().tps.user!.fullname!,
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault,
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("Tujuan",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ),
                        Expanded(
                          child: Text(context.read<StoreProvider>().tps.destShippingAddress!.city!,
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("Kurir",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ),
                        Expanded(
                          child: Text("${context.read<StoreProvider>().tps.deliveryCost!.serviceName!} - ${context.read<StoreProvider>().tps.deliveryCost!.courierName!}",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
              FutureBuilder<ShippingTrackingModel?>(
                future: context.read<StoreProvider>().getShippingTracking(context, context.read<StoreProvider>().tps.id!),
                builder: (BuildContext context, AsyncSnapshot<ShippingTrackingModel?> snapshot) {
                if (snapshot.hasData) {
                  final ShippingTrackingModel shippingTrackingModel = snapshot.data!;
                  if(shippingTrackingModel.data!.wayBillDelivery?.manifests == null || shippingTrackingModel.data!.wayBillDelivery!.manifests!.isEmpty) {
                    return Container();
                  }
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 6.0, right: 6.0),
                        child: Timeline.builder(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int i) {
                            return TimelineModel(
                              Container(
                                margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 8.0),
                                        Text(shippingTrackingModel.data!.wayBillDelivery!.manifests![i].description!),
                                        const SizedBox(height: 8.0),
                                        Text(DateFormat('dd MMMM yyyy kk:mm').format(shippingTrackingModel.data!.wayBillDelivery!.manifests![i].date!)),
                                        const SizedBox(height: 8.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              iconBackground: ColorResources.primaryOrange,
                              position: TimelineItemPosition.right,
                              isFirst: i == 0,
                              isLast: i == shippingTrackingModel.data!.wayBillDelivery!.manifests!.length,
                              icon: const Icon(
                                Icons.local_shipping,
                                color: ColorResources.white,
                              )
                            );
                          },
                          itemCount: shippingTrackingModel.data!.wayBillDelivery!.manifests!.length,
                          physics: const BouncingScrollPhysics(),
                          position: TimelinePosition.Left
                        ),
                      ),
                    ],
                  );
                } 
                return const SizedBox(
                  height: 100.0,
                  child: Loader(
                    color: ColorResources.primaryOrange
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Informasi Pembayaran",
                    style: robotoRegular.copyWith(
                      color: ColorResources.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    )
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Harga Barang",
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontSize: Dimensions.fontSizeDefault,
                          )
                        ),
                        Text(Helper.formatCurrency(context.read<StoreProvider>().tps.totalProductPrice!),
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ]
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ongkos Kirim",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                          Text( Helper.formatCurrency(context.read<StoreProvider>().tps.deliveryCost!.price!),
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ]
                      ),
                    ),
                  ],
                )
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 10.0, left: 16.0,
                  right: 16.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total bayar",
                      style: robotoRegular.copyWith(
                        color: ColorResources.black,
                        fontSize: Dimensions.fontSizeDefault,
                      )
                    ),
                    Text(Helper.formatCurrency(context.read<StoreProvider>().tps.totalProductPrice!),
                      style: robotoRegular.copyWith(
                        color: ColorResources.black,
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.w600
                      )
                    ),
                  ]
                ),
              ),
              SizedBox(
                height: widget.status == "DELIVERED" ? 60 : 10,
              )
            ],
          ),
        ),
        widget.status == "DELIVERED" 
        ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 60.0,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: ColorResources.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
              boxShadow: boxShadow
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: CustomButton(
                onTap: () async {
                  await context.read<StoreProvider>().postOrderDone(context, Helper.prefs!.getString("idTrx")!);
                },
                height: 32.0,
                isBoxShadow: false,
                isBorderRadius: true,
                isBorder: false,
                isLoading: context.watch<StoreProvider>().postOrderDoneStatus == PostOrderDoneStatus.loading ? true : false,
                btnColor: ColorResources.success,
                btnTxt: "Barang Diterima",
              ),
            ),
          )
        )
        : Container()
        ],
      )
    );
  }


  modalTrackingKurir(String idOrder) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.96,
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: ColorResources.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)
                )
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                NS.pop(context);
                              },
                              child: const Icon(Icons.close)),
                            Container(
                              margin: const EdgeInsets.only(left: 16.0),
                              child: Text("Detail Status Pengiriman",
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.black
                                )
                              )
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 3.0,
                      ),
                      Expanded(
                        flex: 40,
                        child: FutureBuilder<ShippingTrackingModel?>(
                          future: context.read<StoreProvider>().getShippingTracking(context, idOrder),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final ShippingTrackingModel shippingTrackingModel = snapshot.data!;
                              if (shippingTrackingModel.data == null) {
                                return const Center(
                                  child: Text("Terjadi kesalahan dalam pengambilan data"),
                                );
                              }
                              return ListView(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: [
                                  Timeline.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int i) {
                                        return TimelineModel(
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 8.0, 
                                                bottom: 8.0
                                              ),
                                              child: Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0)
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(
                                                        height: 8.0,
                                                      ),
                                                      Text(shippingTrackingModel.data!.orderStatusInfos![i].progress!),
                                                      const SizedBox(
                                                        height: 8.0,
                                                      ),
                                                      Text(shippingTrackingModel.data!.orderStatusInfos![i].handledBy!),
                                                      const SizedBox(
                                                        height: 8.0,
                                                      ),
                                                      Text(DateFormat('dd MMMM yyyy').format(DateTime.parse(shippingTrackingModel.data!.orderStatusInfos![i].date!))),
                                                      const SizedBox(
                                                        height: 8.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            iconBackground: ColorResources.primaryOrange,
                                            position: TimelineItemPosition.right,
                                            isFirst: i == 0,
                                            isLast: i == shippingTrackingModel.data!.orderStatusInfos!.length,
                                            icon: const Icon(
                                              Icons.local_shipping,
                                              color: ColorResources.white,
                                            )
                                          );
                                      },
                                      itemCount: shippingTrackingModel.data!.orderStatusInfos!.length,
                                      physics: const BouncingScrollPhysics(),
                                      position: TimelinePosition.Left)
                                ],
                              );
                            }
                            return const Loader(
                              color: ColorResources.primaryOrange,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
            )
          );
      },
    );
  }
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    dynamic angle;
    dynamic offset1;
    dynamic offset2;

    dynamic path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius)
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius, radius) 
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.drawStart != drawStart || oldDelegate.drawEnd != drawEnd;
  }
}