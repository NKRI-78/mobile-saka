import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:timelines/timelines.dart' as t;
import 'package:shimmer/shimmer.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/data/models/store/shipping_tracking.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/box_shadow.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

class DetailSellerTransactionScreen extends StatefulWidget {
  final String typeUser;
  final String status;

  const DetailSellerTransactionScreen({
    Key? key,
    required this.typeUser,
    required this.status})
    : super(key: key);
  @override
  _DetailSellerTransactionScreenState createState() => _DetailSellerTransactionScreenState();
}

class _DetailSellerTransactionScreenState extends State<DetailSellerTransactionScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
      context.read<StoreProvider>().getTransactionPaidSingle(context, Helper.prefs!.getString("idTrx")!, widget.typeUser);
    }
    if(mounted) {
      context.read<StoreProvider>().getPickupTimeslots(context);
    }
    if(mounted) {
      context.read<StoreProvider>().getDimenstionSize(context);
    }
    if(mounted) {
      context.read<StoreProvider>().getApproximatelyVolumes(context);
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
        backgroundColor: ColorResources.primaryOrange,
        iconTheme: const IconThemeData(color: ColorResources.white),
        elevation: 0.0,
      ),
      body: context.watch<StoreProvider>().transactionPaidSingleStatus == TransactionPaidSingleStatus.loading
      ? const Center(
          child: Loader(
            color: ColorResources.primaryOrange,
          ),
        )
      : Stack(
          children: [
          RefreshIndicator(
            backgroundColor: ColorResources.primaryOrange,
            color: ColorResources.white,
            onRefresh: () {
              return context.read<StoreProvider>().getTransactionPaidSingle(context, Helper.prefs!.getString("idTrx")!, widget.typeUser);
            },
            child: ListView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 5.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status Pesanan",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      )
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SelectableText(context.read<StoreProvider>().tps.id.toString(),
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault,
                                )
                              ),
                            ],
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SelectableText(context.read<StoreProvider>().tps.invoiceNo.toString(),
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault,
                                )
                              ),
                            ],
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
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Image.asset(
                                  'assets/images/icons/ic-status-transaction-$index.png',
                                  width: 30.0,
                                  color: getColor(index, shippingTrackingModel.data!.orderStatusInfos!.length - 1),
                                ),
                              );
                            },
                            contentsBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(processes[index],
                                  style: robotoRegular.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                    color: getColor(index, shippingTrackingModel.data!.orderStatusInfos!.length - 1
                                  ),
                                )),
                              );
                            },
                            indicatorBuilder: (_, index) {
                              Color? color;
                              Widget? child;
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
                  padding: const EdgeInsets.only(
                    top: 16.0, bottom: 16.0, 
                    left: 8.0, right: 8.0
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: context.read<StoreProvider>().tps.products!.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(    
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.grey,
                          )
                        ),
                        padding: const EdgeInsets.all(16.0),
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
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
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
                                            placeholder: (BuildContext context, String url) => Center(
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.grey[100]!,
                                                child: Container(
                                                  color: ColorResources.white,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              )
                                            ),
                                            errorWidget: (BuildContext context, String url, dynamic error) {
                                              return Center(
                                                  child: Image.asset("assets/images/logo/saka.png",
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
                                      //       decoration: BoxDecoration(
                                      //         borderRadius: const BorderRadius.only(
                                      //           bottomRight:Radius.circular(12.0),
                                      //           topLeft: Radius.circular(12.0)
                                      //         ),
                                      //           color: Colors.red[900]
                                      //         ),
                                      //       child: Center(
                                      //         child: Text(    context.read<StoreProvider>().tps.products![i].product!.discount!.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                      //           style: robotoRegular.copyWith(
                                      //             color: ColorResources.white,
                                      //             fontSize: 10.0,
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
                                      Text(context.read<StoreProvider>().tps.products![i].quantity.toString() + " barang " +  "(" + (context.read<StoreProvider>().tps.products![i].product!.weight! *     context.read<StoreProvider>().tps.products![i].quantity!).toString() + " gr)",
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.primaryOrange
                                        )
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(Helper.formatCurrency(context.read<StoreProvider>().tps.products![i].sellerPrice!),
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
                            Divider(
                              thickness: 2.0,
                              color: Colors.grey[100],
                            ),
                            const SizedBox(height: 8.0),
                            Text("Total Belanja",
                              style: robotoRegular.copyWith(
                                color: ColorResources.black,
                                fontSize: 12.0,
                              )
                            ),
                            const SizedBox(height: 8.0),
                            Text(Helper.formatCurrency(context.read<StoreProvider>().tps.products![i].sellerPrice! * context.read<StoreProvider>().tps.products![i].quantity!),
                              style: robotoRegular.copyWith(
                                color: ColorResources.black,
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeSmall,
                              )
                            ),
                          ],
                        ),
                      ); 
                    },
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
                          fontSize: 15.0,
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
                                fontSize: 14,
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
                                fontSize: 14,
                              )
                            ),
                          ),
                          Expanded(
                            child: Text("${context.read<StoreProvider>().tps.deliveryCost!.serviceName} - ${context.read<StoreProvider>().tps.deliveryCost!.courierName!}",
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
                  future: Provider.of<StoreProvider>(context, listen: false).getShippingTracking(context, context.read<StoreProvider>().tps.id!),
                  builder: (BuildContext context, AsyncSnapshot<ShippingTrackingModel?> snapshot) {
                    if (snapshot.hasData) {
                      final ShippingTrackingModel shippingTrackingModel = snapshot.data!;
                      if(shippingTrackingModel.data!.wayBillDelivery!.manifests == null || shippingTrackingModel.data!.wayBillDelivery!.manifests!.isEmpty) {
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
                        color: ColorResources.primaryOrange,
                      ),
                    );
                  },
                ),
                Padding(
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
                        const SizedBox(height: 8.0),
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
                              Text(Helper.formatCurrency(context.read<StoreProvider>().tps.sellerProductPrice!),
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault
                                )
                              ),
                            ]
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ongkos Kirim",
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault,
                                )
                              ),
                              SizedBox(
                                child: Text(Helper.formatCurrency(context.read<StoreProvider>().tps.deliveryCost!.price!),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )
                                ),
                              )
                            ]
                          ),
                        ),
                      ],
                    )
                  ),
                SizedBox(
                  height: widget.status == "RECEIVED"
                  ? 60.0
                  : widget.status == "PACKING"
                  ? 110.0
                  : 10.0,
                )
              ],
            ),
          ),
          widget.status == "RECEIVED"
          ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60.0,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: ColorResources.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
                boxShadow: boxShadow
              ),
              child: CustomButton(
                onTap: () async {
                  await context.read<StoreProvider>().postOrderPacking(context, Helper.prefs!.getString("idTrx")!);
                },
                height: 32.0,
                btnColor: ColorResources.success,
                isBoxShadow: false,
                isBorder: false,
                isBorderRadius: true,
                isLoading: context.watch<StoreProvider>().postOrderPickingStatus == PostOrderPickingStatus.loading 
                ? true 
                : false,
                btnTxt: "Konfirmasi Pesanan",
              )
            )
          )
          : widget.status == "PACKING"
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60.0,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  boxShadow: boxShadow
                ),
                child: CustomButton(
                onTap: () async {
                  await context.read<StoreProvider>().bookingCourier(context, Helper.prefs!.getString("idTrx")!, context.read<StoreProvider>().tps.deliveryCost!.courierId!);
                },
                height: 32.0,
                btnColor: ColorResources.success,
                isBoxShadow: false,
                isBorder: false,
                isBorderRadius: true,
                isLoading: context.watch<StoreProvider>().bookingCourierStatus == BookingCourierStatus.loading 
                ? true 
                : false,
                btnTxt: "Pesan Kurir",
              )
                
                //  GestureDetector(
                //   onTap: () async {
                //     if(context.read<StoreProvider>().tps.deliveryCost!.courierId == "jne") {
                //       await context.read<StoreProvider>().bookingCourier(context, Helper.prefs!.getString("idTrx")!, context.read<StoreProvider>().tps.deliveryCost!.courierId!);
                //     } else if(context.read<StoreProvider>().tps.deliveryCost!.courierId == "ninja") {
                //       showAnimatedDialog(
                //         context: context, 
                //         barrierDismissible: true,
                //         builder: (BuildContext context) {
                //           return Dialog(
                //             child: SingleChildScrollView(
                //               child: Container(
                //                 padding: const EdgeInsets.all(16.0),
                //                 decoration: const BoxDecoration(
                //                   color: ColorResources.white,
                //                 ),
                //                 child: Column(
                //                   mainAxisSize: MainAxisSize.min,
                //                   children: [
                //                     Container(
                //                       width: 300.0,
                //                       padding: const EdgeInsets.all(5.0),
                //                       decoration: BoxDecoration(
                //                         border: Border.all(
                //                           color: Colors.grey,
                //                           width: 0.5,
                //                         )
                //                       ),
                //                       child: Column(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: [
                //                           Container(
                //                             margin: const EdgeInsets.only(left: 10.0, top: 5.0),
                //                             child: Text("Pickup",
                //                               style: robotoRegular.copyWith(
                //                                 fontWeight: FontWeight.w600
                //                               ),
                //                             ),
                //                           ),
                //                           Container(
                //                             margin: const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                //                             child: Row(
                //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                               children: [
                //                                 const Flexible(
                //                                   flex: 2,
                //                                   child: Text("Date :",
                //                                     style: robotoRegular,
                //                                   ),
                //                                 ),
                //                                 Flexible(
                //                                   flex: 3,
                //                                   child: Consumer<StoreProvider>(
                //                                     builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                //                                       return DateTimePicker(
                //                                         initialValue: storeProvider.dataDatePickup,
                //                                         expands: false,
                //                                         firstDate: DateTime(2000),
                //                                         lastDate: DateTime(2100),
                //                                         style: robotoRegular,
                //                                         decoration: const InputDecoration(
                //                                           labelStyle: robotoRegular,
                //                                           hintStyle: robotoRegular,
                //                                           isDense: true,
                //                                           contentPadding: EdgeInsets.only(bottom: 0.0, top: 0.0, left: 0.0, right: 0.0),
                //                                           floatingLabelBehavior: FloatingLabelBehavior.never
                //                                         ),
                //                                         onChanged: (val) { 
                //                                           storeProvider.changeDatePickup(val);
                //                                         },
                //                                         onSaved: (val) {
                //                                           storeProvider.changeDatePickup(val!);
                //                                         },  
                //                                       );                                         
                //                                     },
                //                                   ) 
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                //                             child: Row(
                //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                               children: [
                //                                 const Expanded(
                //                                   flex: 2,
                //                                   child: Text("Timeslots :",
                //                                     style: robotoRegular,
                //                                   ),
                //                                 ),
                //                                 Expanded(
                //                                   flex: 3,
                //                                   child: Consumer<StoreProvider>(
                //                                     builder:(BuildContext context, StoreProvider storeProvider, Widget? child) {
                //                                       if(storeProvider.pickupTimeslotsStatus == PickupTimeslotsStatus.loading) {
                //                                         return Shimmer.fromColors(
                //                                           baseColor: Colors.grey[200]!, 
                //                                           highlightColor: Colors.grey[300]!,
                //                                           child: Container(
                //                                             margin: const EdgeInsets.only(top: 5.0),
                //                                             decoration: BoxDecoration(
                //                                               color: ColorResources.white,
                //                                               borderRadius: BorderRadius.circular(10.0)
                //                                             ),
                //                                             width: 300.0,
                //                                             height: 40.0,
                //                                             child: Container(),
                //                                           ),
                //                                         );
                //                                       }                    
                //                                       return Container(
                //                                         width: 120.0,
                //                                         margin: const EdgeInsets.only(bottom: 18.0),
                //                                         child: CustomDropDownFormField(
                //                                           titleText: 'Timeslots',
                //                                           hintText: 'Timeslots',
                //                                           value: storeProvider.dataPickupTimeslots,
                //                                           filled: false,
                //                                           onSaved: (val) {
                //                                             storeProvider.changePickupTimeSlots(val);
                //                                           },
                //                                           onChanged: (val) {  
                //                                             storeProvider.changePickupTimeSlots(val);
                //                                           },
                //                                           dataSource: storeProvider.pickupTimeslots,
                //                                           textField: 'name',
                //                                           valueField: 'name',
                //                                         ),
                //                                       );                          
                //                                     },
                //                                   )
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       )
                //                     ),
                //                     Container(
                //                       width: 300.0,
                //                       margin: const EdgeInsets.only(top: 8.0),
                //                       padding: const EdgeInsets.all(5.0),
                //                       decoration: BoxDecoration(
                //                         border: Border.all(
                //                           color: Colors.grey,
                //                           width: 0.5,
                //                         )
                //                       ),
                //                       child: Column(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: [
                //                           Container(
                //                             margin: const EdgeInsets.only(left: 10.0, top: 5.0),
                //                             child: Text("Delivery",
                //                               style: robotoRegular.copyWith(
                //                                 fontWeight: FontWeight.w600
                //                               ),
                //                             ),
                //                           ),
                //                           Container(
                //                             margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                //                             child: Row(
                //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                               children: [
                //                                 const Expanded(
                //                                   flex: 2,
                //                                   child: Text("Timeslots :",
                //                                     style: robotoRegular,
                //                                   ),
                //                                 ),
                //                                 Expanded(
                //                                   flex: 3,
                //                                   child: Consumer<StoreProvider>(
                //                                     builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                //                                       if(storeProvider.pickupTimeslotsStatus == PickupTimeslotsStatus.loading) {
                //                                         return Shimmer.fromColors(
                //                                           baseColor: Colors.grey[200]!, 
                //                                           highlightColor: Colors.grey[300]!,
                //                                           child: Container(
                //                                             margin: const EdgeInsets.only(top: 5.0),
                //                                             decoration: BoxDecoration(
                //                                               color: ColorResources.white,
                //                                               borderRadius: BorderRadius.circular(10.0)
                //                                             ),
                //                                             width: 300.0,
                //                                             height: 40.0,
                //                                             child: Container(),
                //                                           ),
                //                                         );
                //                                       }       
                //                                       return Container(
                //                                         width: 140.0,
                //                                         margin: const EdgeInsets.only(bottom: 18.0),
                //                                         child: CustomDropDownFormField(
                //                                           titleText: 'Delivery Timeslots',
                //                                           hintText: 'Delivery Timeslots',
                //                                           value: storeProvider.dataDeliveryTimeslots,
                //                                           filled: false,
                //                                           onSaved: (val) {
                //                                             storeProvider.changeDeliveryTimeSlots(val);
                //                                           },
                //                                           onChanged: (val) {  
                //                                             storeProvider.changeDeliveryTimeSlots(val);
                //                                           },
                //                                           dataSource: storeProvider.pickupTimeslots,
                //                                           textField: 'name',
                //                                           valueField: 'name',
                //                                         ),
                //                                       );                          
                //                                     },
                //                                   )
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                //                             child: Row(
                //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                               children: [
                //                                 const Expanded(
                //                                   flex: 2,
                //                                   child: Text("Approx Volumes :",
                //                                     style: robotoRegular,
                //                                   ),
                //                                 ),
                //                                 Expanded(
                //                                   flex: 3,
                //                                   child: Consumer<StoreProvider>(
                //                                     builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                //                                       if(storeProvider.pickupTimeslotsStatus == PickupTimeslotsStatus.loading) {
                //                                         return Shimmer.fromColors(
                //                                           baseColor: Colors.grey[200]!, 
                //                                           highlightColor: Colors.grey[300]!,
                //                                           child: Container(
                //                                             margin: const EdgeInsets.only(top: 5.0),
                //                                             decoration: BoxDecoration(
                //                                               color: ColorResources.white,
                //                                               borderRadius: BorderRadius.circular(10.0)
                //                                             ),
                //                                             width: 300.0,
                //                                             height: 40.0,
                //                                             child: Container(),
                //                                           ),
                //                                         );
                //                                       }                    
                //                                       return Container(
                //                                         margin: const EdgeInsets.only(bottom: 18.0),
                //                                         child: CustomDropDownFormField(
                //                                           titleText: 'Approx Volumes',
                //                                           hintText: 'Approx Volumes',
                //                                           value: storeProvider.dataApproximatelyVolumes,
                //                                           filled: false,
                //                                           onSaved: (val) {
                //                                             storeProvider.changeApproximatelyVolumes(val);
                //                                           },
                //                                           onChanged: (val) {  
                //                                             storeProvider.changeApproximatelyVolumes(val);
                //                                           },
                //                                           dataSource: storeProvider.approximatelyVolumes,
                //                                           textField: 'name',
                //                                           valueField: 'name',
                //                                         ),
                //                                       );                          
                //                                     },
                //                                   )
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       )
                //                     ),  
                //                     Container(
                //                       width: 300.0,
                //                       margin: const EdgeInsets.only(top: 8.0),
                //                       padding: const EdgeInsets.all(5.0),
                //                       decoration: BoxDecoration(
                //                         border: Border.all(
                //                           color: Colors.grey,
                //                           width: 0.5,
                //                         )
                //                       ),
                //                       child: Column(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: [
                //                           Container(
                //                             margin: const EdgeInsets.only(left: 10.0, top: 5.0),
                //                             child: Text("Dimensions",
                //                               style: robotoRegular.copyWith(
                //                                 fontWeight: FontWeight.w600
                //                               ),
                //                             ),
                //                           ),
                //                           Container(
                //                             margin: const EdgeInsets.only(left: 14.0, right: 14.0),
                //                             child: Row(
                //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                               children: [
                //                                 const Expanded(
                //                                   flex: 2,
                //                                   child: Text("Size",
                //                                     style: robotoRegular,
                //                                   ),
                //                                 ),
                //                                 Expanded(
                //                                   flex: 3,
                //                                   child: Consumer<StoreProvider>(
                //                                     builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                //                                       if(storeProvider.pickupTimeslotsStatus == PickupTimeslotsStatus.loading) {
                //                                         return Shimmer.fromColors(
                //                                           baseColor: Colors.grey[200]!, 
                //                                           highlightColor: Colors.grey[300]!,
                //                                           child: Container(
                //                                             margin: const EdgeInsets.only(top: 5.0),
                //                                             decoration: BoxDecoration(
                //                                               color: ColorResources.white,
                //                                               borderRadius: BorderRadius.circular(10.0)
                //                                             ),
                //                                             width: 300.0,
                //                                             height: 40.0,
                //                                             child: Container(),
                //                                           ),
                //                                         );
                //                                       }                    
                //                                       return Container(
                //                                         margin: const EdgeInsets.only(bottom: 18.0),
                //                                         child: CustomDropDownFormField(
                //                                           titleText: 'Size',
                //                                           hintText: 'Size',
                //                                           value: storeProvider.dataDimensionsSize,
                //                                           filled: false,
                //                                           onSaved: (val) {
                //                                             storeProvider.changeDimensionsSize(val);
                //                                           },
                //                                           onChanged: (val) {  
                //                                             storeProvider.changeDimensionsSize(val);
                //                                           },
                //                                           dataSource: storeProvider.dimensionsSize,
                //                                           textField: 'name',
                //                                           valueField: 'name',
                //                                         ),
                //                                       );                          
                //                                     },
                //                                   )
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             margin: const EdgeInsets.only(top: 4.0, left: 14.0, right: 14.0),
                //                             child: Row(
                //                               children: [
                //                                 const Expanded(
                //                                   flex: 2,
                //                                   child: Text("Height",
                //                                     style: robotoRegular,
                //                                   ),
                //                                 ),
                //                                 Expanded(
                //                                   flex: 3,
                //                                   child: Container(
                //                                     width: double.infinity,
                //                                     decoration: BoxDecoration(
                //                                       color: Theme.of(context).colorScheme.secondary,
                //                                       borderRadius: BorderRadius.circular(6.0),
                //                                       boxShadow: [
                //                                         BoxShadow(
                //                                           color: Colors.grey.withOpacity(0.1), 
                //                                           spreadRadius: 1.0, 
                //                                           blurRadius: 3.0, 
                //                                           offset: const Offset(0.0, 1.0)
                //                                         )
                //                                       ],
                //                                     ),
                //                                     child: Consumer<StoreProvider>(
                //                                       builder: (BuildContext context, StoreProvider warungProvider, Widget? child) {
                //                                         return TextFormField(
                //                                           onChanged: (val) {
                //                                             if(val != "") {
                //                                               warungProvider.changeDimensionsHeight(int.parse(val));
                //                                             }
                //                                           },
                //                                           cursorColor: ColorResources.black,
                //                                           maxLines: 1,
                //                                           keyboardType: TextInputType.number,
                //                                           initialValue: null,
                //                                           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //                                           decoration: InputDecoration(
                //                                             hintText: '',
                //                                             contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                //                                             isDense: true,
                //                                             hintStyle: robotoRegular.copyWith(
                //                                               color: Theme.of(context).hintColor
                //                                             ),
                //                                             suffix: const Text("CM",
                //                                               style: robotoRegular,
                //                                             ),
                //                                             errorStyle: robotoRegular.copyWith(height: 1.5),
                //                                             focusedBorder: const OutlineInputBorder(
                //                                               borderSide: BorderSide(
                //                                                 color: Colors.grey,
                //                                                 width: 0.5
                //                                               ),
                //                                             ),
                //                                             enabledBorder: const OutlineInputBorder(
                //                                               borderSide: BorderSide(
                //                                                 color: Colors.grey,
                //                                                 width: 0.5
                //                                               ),
                //                                             ),
                //                                           ),
                //                                         );                                                  
                //                                       },
                //                                     )                                                    
                //                                   )
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             margin: const EdgeInsets.only(top: 8.0, left: 14.0, right: 14.0),
                //                             child: Row(
                //                               children: [
                //                                 const Expanded(
                //                                   flex: 2,
                //                                   child: Text("Length :",
                //                                     style: robotoRegular,
                //                                   ),
                //                                 ),
                //                                 Expanded(
                //                                   flex: 3,
                //                                   child: Container(
                //                                     width: double.infinity,
                //                                     decoration: BoxDecoration(
                //                                       color: Theme.of(context).colorScheme.secondary,
                //                                       borderRadius: BorderRadius.circular(6.0),
                //                                       boxShadow: [
                //                                         BoxShadow(
                //                                           color: Colors.grey.withOpacity(0.1), 
                //                                           spreadRadius: 1.0, 
                //                                           blurRadius: 3.0, 
                //                                           offset: const Offset(0.0, 1.0)
                //                                         )
                //                                       ],
                //                                     ),
                //                                     child: Consumer<StoreProvider>(
                //                                       builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                //                                         return TextFormField(
                //                                           onChanged: (val) {
                //                                             if(val != "") {
                //                                               storeProvider.changeDimensionsLength(int.parse(val));
                //                                             }
                //                                           },
                //                                           cursorColor: ColorResources.black,
                //                                           maxLines: 1,
                //                                           keyboardType: TextInputType.number,
                //                                           initialValue: null,
                //                                           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //                                           decoration: InputDecoration(
                //                                             hintText: '',
                //                                             contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                //                                             isDense: true,
                //                                             hintStyle: robotoRegular.copyWith(
                //                                               color: Theme.of(context).hintColor
                //                                             ),
                //                                             suffix: const Text("CM",
                //                                               style: robotoRegular,
                //                                             ),
                //                                             errorStyle: robotoRegular.copyWith(height: 1.5),
                //                                             focusedBorder: const OutlineInputBorder(
                //                                               borderSide: BorderSide(
                //                                                 color: Colors.grey,
                //                                                 width: 0.5
                //                                               ),
                //                                             ),
                //                                             enabledBorder: const OutlineInputBorder(
                //                                               borderSide: BorderSide(
                //                                                 color: Colors.grey,
                //                                                 width: 0.5
                //                                               ),
                //                                             ),
                //                                           ),
                //                                         );
                //                                       },
                //                                     )
                //                                   )
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             margin: const EdgeInsets.only(top: 8.0, left: 14.0, right: 14.0),
                //                             child: Row(
                //                               children: [
                //                                 const Expanded(
                //                                   flex: 2,
                //                                   child: Text("Width",
                //                                     style: robotoRegular,
                //                                   ),
                //                                 ),
                //                                 Expanded(
                //                                   flex: 3,
                //                                   child: Consumer<StoreProvider>(
                //                                     builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                //                                       return TextFormField(
                //                                         onChanged: (val) {
                //                                           if(val != "") {
                //                                             storeProvider.changeDimensionsWidth(int.parse(val));
                //                                           }
                //                                         },
                //                                         cursorColor: ColorResources.black,
                //                                         maxLines: 1,
                //                                         keyboardType: TextInputType.number,
                //                                         initialValue: null,
                //                                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //                                         decoration: InputDecoration(
                //                                           hintText: '',
                //                                           contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                //                                           isDense: true,
                //                                           hintStyle: robotoRegular.copyWith(
                //                                             color: Theme.of(context).hintColor
                //                                           ),
                //                                           suffix: const Text("CM",
                //                                             style: robotoRegular,
                //                                           ),
                //                                           errorStyle: robotoRegular.copyWith(height: 1.5),
                //                                           focusedBorder: const OutlineInputBorder(
                //                                             borderSide: BorderSide(
                //                                               color: Colors.grey,
                //                                               width: 0.5
                //                                             ),
                //                                           ),
                //                                           enabledBorder: const OutlineInputBorder(
                //                                             borderSide: BorderSide(
                //                                               color: Colors.grey,
                //                                               width: 0.5
                //                                             ),
                //                                           ),
                //                                         ),
                //                                       );                                                   
                //                                     },
                //                                   )
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                     Container(
                //                       width: double.infinity,
                //                       margin: const EdgeInsets.only(top: 8.0, left: 13.0, right: 13.0),
                //                       child: TextButton(
                //                         onPressed: () async{
                //                           try {
                //                             if(Provider.of<StoreProvider>(context,listen: false).dataPickupTimeslots.isEmpty || Provider.of<StoreProvider>(context,listen: false).dataPickupTimeslots == "") {
                //                               Fluttertoast.showToast(
                //                                 backgroundColor: ColorResources.error,
                //                                 textColor: ColorResources.white,
                //                                 fontSize: Dimensions.fontSizeDefault,
                //                                 msg: "Pickup Timeslots is Required",
                //                               );
                //                               return;
                //                             }
                //                             if(Provider.of<StoreProvider>(context,listen: false).dataDeliveryTimeslots.isEmpty || Provider.of<StoreProvider>(context,listen: false).dataDeliveryTimeslots == "") {
                //                               Fluttertoast.showToast(
                //                                 backgroundColor: ColorResources.error,
                //                                 textColor: ColorResources.white,
                //                                 fontSize: Dimensions.fontSizeDefault,
                //                                 msg: "Delivery Timeslots is Required",
                //                               );
                //                               return;
                //                             }
                //                             if(Provider.of<StoreProvider>(context,listen: false).dataDimensionsSize.isEmpty || Provider.of<StoreProvider>(context,listen: false).dataDimensionsSize == "") {
                //                               Fluttertoast.showToast(
                //                                 backgroundColor: ColorResources.error,
                //                                 textColor: ColorResources.white,
                //                                 fontSize: Dimensions.fontSizeDefault,
                //                                 msg: "Dimensions Size is Required",
                //                               );
                //                               return;
                //                             }
                //                             if(Provider.of<StoreProvider>(context,listen: false).dataDimensionsHeight == 0 || Provider.of<StoreProvider>(context,listen: false).dataDimensionsHeight == 0) {
                //                               Fluttertoast.showToast(
                //                                 backgroundColor: ColorResources.error,
                //                                 textColor: ColorResources.white,
                //                                 fontSize: Dimensions.fontSizeDefault,
                //                                 msg: "Dimensions Height is Required",
                //                               );
                //                               return;
                //                             }
                //                              if(Provider.of<StoreProvider>(context,listen: false).dataDimensionsLength == 0 || Provider.of<StoreProvider>(context,listen: false).dataDimensionsLength == 0) {
                //                               Fluttertoast.showToast(
                //                                 backgroundColor: ColorResources.error,
                //                                 textColor: ColorResources.white,
                //                                 fontSize: Dimensions.fontSizeDefault,
                //                                 msg: "Dimensions Length is Required",
                //                               );
                //                               return;
                //                             }
                //                              if(Provider.of<StoreProvider>(context,listen: false).dataDimensionsWidth == 0 || Provider.of<StoreProvider>(context,listen: false).dataDimensionsWidth == 0) {
                //                               Fluttertoast.showToast(
                //                                 backgroundColor: ColorResources.error,
                //                                 textColor: ColorResources.white,
                //                                 fontSize: Dimensions.fontSizeDefault,
                //                                 msg: "Dimensions Width is Required",
                //                               );
                //                               return;
                //                             }
                //                             if(Provider.of<StoreProvider>(context,listen: false).dataApproximatelyVolumes.isEmpty || Provider.of<StoreProvider>(context,listen: false).dataApproximatelyVolumes == "") {
                //                               Fluttertoast.showToast(
                //                                 backgroundColor: ColorResources.error,
                //                                 textColor: ColorResources.white,
                //                                 fontSize: Dimensions.fontSizeDefault,
                //                                 msg: "Approximately Volumes is Required",
                //                               );
                //                               return;
                //                             }
                //                             await context.read<StoreProvider>().bookingCourier(context, Helper.prefs!.getString("idTrx")!, context.read<StoreProvider>().tps.deliveryCost!.courierId!);
                //                           } catch(e, stacktrace) {
                //                             debugPrint(stacktrace.toString());
                //                           }
                //                         }, 
                //                         style: TextButton.styleFrom(
                //                           backgroundColor: ColorResources.primaryOrange
                //                         ),
                //                         child: Text("Submit", 
                //                           style: robotoRegular.copyWith(
                //                             color: ColorResources.white
                //                           )
                //                         )
                //                       ),
                //                     )
                //                   ],
                //                 )
                //               ),
                //             ),
                //           );
                //         }
                //       );
                //     }
                //   },
                //   child: Container(
                //     height: 50.0,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       borderRadius:  BorderRadius.circular(10.0),
                //       color: ColorResources.primaryOrange),
                //     child: Center(
                //       child: Text("Booking Courier",
                //         style: robotoRegular.copyWith(
                //           color: ColorResources.white,
                //           fontSize: Dimensions.fontSizeDefault
                //         ),
                //       ),
                //     ),
                //   ),
                // )

              )
            )
          : Container()
        ],
      )
    );
  }

  void modalTrackingKurir(String idOrder) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
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
                      padding: const EdgeInsets.only(
                        top: 16.0, bottom: 8.0,
                        left: 16.0, right: 16.0, 
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              NS.pop(context);
                            },
                            child: const Icon(Icons.close)
                          ),
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
                        future: Provider.of<StoreProvider>(context, listen: false).getShippingTracking(context, idOrder),
                        builder: (BuildContext context, AsyncSnapshot<ShippingTrackingModel?> snapshot) {
                          if (snapshot.hasData) {
                            final ShippingTrackingModel shippingTrackingModel = snapshot.data!;
                            List<TimelineModel> items = [];
                            for (Manifest manifest in shippingTrackingModel.data!.wayBillDelivery!.manifests!) {
                              int i = shippingTrackingModel.data!.wayBillDelivery!.manifests!.indexOf(manifest);
                              items.add(
                                TimelineModel(
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
                                            Text(manifest.description!),
                                            const SizedBox(height: 8.0),
                                            Text(DateFormat('dd MMMM yyyy').format(manifest.date!)),
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
                                )
                              );
                            } 
                            return ListView(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: [
                                Timeline(
                                  children: items,
                                )
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
    this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color? color;
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
      ..color = color!;

    final radius = size.width / 2;

    double angle;
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