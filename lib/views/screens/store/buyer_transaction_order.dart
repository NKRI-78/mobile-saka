import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:badges/badges.dart' as badges;

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/constant.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/views/screens/store/review_product.dart';
import 'package:saka/views/screens/store/buyer_detail_order_transaction.dart';

import 'package:saka/data/models/store/transaction_unpaid.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/providers/store/store.dart'; 

import 'package:saka/views/basewidgets/button/custom.dart';

class TransactionOrderScreen extends StatefulWidget {
  final int index;

  const TransactionOrderScreen({
    Key? key,
    required this.index,
  }) : super(key: key);
  @override
  _TransactionOrderScreenState createState() => _TransactionOrderScreenState();
}

class _TransactionOrderScreenState extends State<TransactionOrderScreen> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late TabController tabC;

  int index = 0;

  int id = -1;
  
  Future<void> getData() async {
    if(mounted) {
      await context.read<StoreProvider>().getTransactionUnpaid(context);
    }  
    if(mounted) {
      await context.read<StoreProvider>().getReviewProductList(context);
    }  
    if(mounted) {
      await context.read<StoreProvider>().getTransactionBuyerPaidPacking(context);
    }  
    if(mounted) {
      await context.read<StoreProvider>().getTransactionBuyerPaidPickup(context);
    } 
    if(mounted) {
      await context.read<StoreProvider>().getTransactionBuyerPaidShipping(context);
    }  
    if(mounted) {
      await context.read<StoreProvider>().getTransactionBuyerPaidDelivered(context);
    }
    if(mounted) {
      await context.read<StoreProvider>().getTransactionBuyerPaidDone(context);
    }
  }

  Future<void> handleChanging() async {
    setState(() {
      index = tabC.index;
    });
    if(tabC.indexIsChanging) {
      if(index == 1) {
        if(mounted) {
          await context.read<StoreProvider>().getTransactionBuyerPaidPacking(context);
        }
      }
      if(index == 2) {
        if(mounted) {
          await context.read<StoreProvider>().getTransactionBuyerPaidPickup(context);
        }  
      } 
      if(index == 3) {
        if(mounted) {
          await context.read<StoreProvider>().getTransactionBuyerPaidShipping(context);
        }
      }
      if(index == 4) {
        if(mounted) {
          await context.read<StoreProvider>().getTransactionBuyerPaidDelivered(context);
        }
      }
      if(index == 5) {
        if(mounted) {
          await context.read<StoreProvider>().getTransactionBuyerPaidDone(context);
        }
      }
    }
  }

  Future<bool> onWillPop() {
    NS.pop(context);
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    
    tabC = TabController(length: 7, vsync: this, initialIndex: widget.index);
    tabC.addListener(handleChanging);

    getData();
  }

  @override 
  void dispose() {
    tabC.removeListener(handleChanging);
    tabC.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          backgroundColor: ColorResources.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ColorResources.primaryOrange,
            ),
            onPressed: onWillPop,
          ),
          centerTitle: true,
          elevation: 0.0,
          title: Text("Pesanan Saya",
            style: robotoRegular.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorResources.primaryOrange
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                isScrollable: true,
                indicatorColor: ColorResources.primaryOrange,
                labelColor: ColorResources.black,
                labelStyle: robotoRegular,
                tabs: [
                context.watch<StoreProvider>().transactionUnpaidStatus == TransactionUnpaidStatus.loading 
                ? const Tab(text: "Belum Bayar")
                : context.read<StoreProvider>().tsum.body!.isEmpty
                ? const Tab(text: "Belum Bayar")
                : badges.Badge(
                    position: badges.BadgePosition.custom(
                      top: 0.0,
                      end: -16.0,
                    ),
                    badgeStyle: badges.BadgeStyle(
                      padding: EdgeInsets.zero,
                    ),
                    badgeContent: Container(
                      width: 17.0,
                      height: 17.0,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: ColorResources.error,
                        shape: BoxShape.circle
                      ),
                      child: Text(context.read<StoreProvider>().tsum.body!.length > 10 
                      ? "10+" 
                      : context.read<StoreProvider>().tsum.body!.length.toString(),
                        style: robotoRegular.copyWith(
                          color: ColorResources.white,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),
                    child: Tab(
                      child: Text("Belum Bayar",
                        style: robotoRegular.copyWith(
                          color: ColorResources.black
                        ),
                      ),
                    )
                  ),
                  context.watch<StoreProvider>().transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading 
                  ? const Tab(text: "Menunggu Konfirmasi")
                  : context.read<StoreProvider>().packingCount == 0
                  ? const Tab(text: "Menunggu Konfirmasi")
                  : badges.Badge(
                      position: badges.BadgePosition.custom(
                        top: 0.0,
                        end: -16.0,
                      ),
                      badgeStyle: badges.BadgeStyle(
                        padding: EdgeInsets.zero,
                      ),
                      badgeContent: Container(
                        width: 17.0,
                        height: 17.0,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: ColorResources.error,
                          shape: BoxShape.circle
                        ),
                        child: Text(context.read<StoreProvider>().packingCount > 10 
                        ? "10+" 
                        : context.read<StoreProvider>().packingCount.toString(),
                          style: robotoRegular.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ),
                      child: Tab(
                        child: Text("Menunggu Konfirmasi",
                          style: robotoRegular.copyWith(
                            color: ColorResources.black
                          ),
                        ),
                      )
                    ),
                    context.watch<StoreProvider>().transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading 
                   ? const Tab(text: "Diproses")
                   : context.read<StoreProvider>().pickupCount == 0 
                   ? const Tab(text: "Diproses")
                   : badges.Badge(
                      position: badges.BadgePosition.custom(
                        top: 0.0,
                        end: -16.0,
                      ),
                      badgeStyle: badges.BadgeStyle(
                        padding: EdgeInsets.zero,
                      ),
                      badgeContent: Container(
                        width: 17.0,
                        height: 17.0,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: ColorResources.error,
                          shape: BoxShape.circle
                        ),
                        child: Text(context.read<StoreProvider>().pickupCount > 10 
                        ? "10+" 
                        : context.read<StoreProvider>().pickupCount.toString(),
                          style: robotoRegular.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ),
                      child: const Tab(
                        child: Text("Diproses",
                          style: robotoRegular,
                        ),
                      )
                    ),
                    context.watch<StoreProvider>().transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading 
                    ? const Tab(text: "Dikirim")
                    : context.read<StoreProvider>().shippingCount == 0 
                    ? const Tab(text: "Dikirim")
                    : badges.Badge(
                      position: badges.BadgePosition.custom(
                        top: 0.0,
                        end: -16.0,
                      ),
                      badgeStyle: badges.BadgeStyle(
                        padding: EdgeInsets.zero,
                      ),
                      badgeContent: Container(
                        width: 17.0,
                        height: 17.0,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: ColorResources.error,
                          shape: BoxShape.circle
                        ),
                        child: Text(context.read<StoreProvider>().shippingCount > 10 
                        ? "10+" 
                        : context.read<StoreProvider>().shippingCount.toString(),
                          style: robotoRegular.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ),
                      child: const Tab(
                      child: Text("Dikirim",
                        style: robotoRegular,
                      ),
                    )
                  ),
                  context.watch<StoreProvider>().transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading
                  ? const Tab(text: "Tiba di Tujuan")
                  : context.read<StoreProvider>().deliveredCount == 0 
                  ? const Tab(text: "Tiba di Tujuan")
                  : badges.Badge(
                      position: badges.BadgePosition.custom(
                        top: 0.0,
                        end: -16.0,
                      ),
                      badgeStyle: badges.BadgeStyle(
                        padding: EdgeInsets.zero,
                      ),
                      badgeContent: Container(
                        width: 17.0,
                        height: 17.0,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: ColorResources.error,
                          shape: BoxShape.circle
                        ),
                        child: Text(context.read<StoreProvider>().deliveredCount > 10 
                        ? "10+" 
                        : context.read<StoreProvider>().deliveredCount.toString(),
                          style: robotoRegular.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ),
                      child: const Tab(
                        child: Text("Tiba di Tujuan",
                          style: robotoRegular,
                        ),
                      )
                    ),
                  context.watch<StoreProvider>().transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading 
                  ? const Tab(text: "Selesai")
                  : context.read<StoreProvider>().doneCount == 0 
                  ? const Tab(text: "Selesai") 
                  : badges.Badge(
                      position: badges.BadgePosition.custom(
                        top: 0.0,
                        end: -16.0,
                      ),
                      badgeStyle: badges.BadgeStyle(
                        padding: EdgeInsets.zero,
                      ),
                      badgeContent: Container(
                        width: 17.0,
                        height: 17.0,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: ColorResources.error,
                          shape: BoxShape.circle
                        ),
                        child: Text(context.read<StoreProvider>().doneCount > 10 
                        ? "10+" 
                        : context.read<StoreProvider>().doneCount.toString(),
                          style: robotoRegular.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ),
                      child: const Tab(
                      child: Text("Selesai",
                        style: robotoRegular
                      ),
                    )
                  ),
                  context.watch<StoreProvider>().transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading 
                  ? const Tab(text: "Belum Diulas")
                  : context.read<StoreProvider>().rpl.isEmpty 
                  ? const Tab(text: "Belum Diulas") 
                  : badges.Badge(
                      position: badges.BadgePosition.custom(
                        top: 0.0,
                        end: -16.0,
                      ),
                      badgeStyle: badges.BadgeStyle(
                        padding: EdgeInsets.zero,
                      ),
                      badgeContent: Container(
                        width: 17.0,
                        height: 17.0,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: ColorResources.error,
                          shape: BoxShape.circle
                        ),
                        child: Text(context.read<StoreProvider>().rpl.length > 10 
                        ? "10+" 
                        : context.read<StoreProvider>().rpl.length.toString(),
                          style: robotoRegular.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ),
                      child: const Tab(
                      child: Text("Belum Diulas",
                        style: robotoRegular
                      ),
                    )
                  ),
                ],
                controller: tabC,
              ),
              Expanded(
                flex: 40,
                child: TabBarView(
                  controller: tabC, 
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    getUnpaidData(),
                    getTransactionBuyerByPacking("Menunggu Konfirmasi"),
                    getTransactionBuyerByPickup("Barang di Proses"),
                    getTransactionBuyerByShipping("Barang di Kirim"),
                    getTransactionBuyerByDelivered("Barang di Terima"),
                    getTransactionBuyerByDone("Selesai"),
                    getDataReviewProduct()
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget getUnpaidData() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? snapshot) {
        if (storeProvider.transactionUnpaidStatus == TransactionUnpaidStatus.loading) {
          return loadingList();
        }
        if(storeProvider.tsum.body!.isEmpty) {
          return emptyTransaction();
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.primaryOrange,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              context.read<StoreProvider>().getTransactionUnpaid(context);
            });
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: storeProvider.tsum.body!.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey
                  ),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Transaksi #",
                            style: robotoRegular.copyWith(
                              color: Colors.grey[600],
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                          SelectableText("${storeProvider.tsum.body![i].paymentRef!.refNo}",
                            style: robotoRegular.copyWith(
                              color: Colors.green[900],
                              fontWeight: FontWeight.w600,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ],
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 2.0, bottom: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tanggal",
                            style: robotoRegular.copyWith(
                              color: Colors.grey[600],
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                          Text(DateFormat('dd MMMM yyyy kk:mm').format(DateTime.parse(storeProvider.tsum.body![i].billCreated!).toLocal()),
                            style: robotoRegular.copyWith(
                              color: Colors.grey[600],
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 2.0),
                    Divider(
                      thickness: 8.0,
                      color: Colors.grey[100],
                    ),
                    const SizedBox(height: 6.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(storeProvider.tsum.body![i].paymentChannel!.name!,
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontWeight: FontWeight.w600,
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                          ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: storeProvider.tsum.body![i].paymentChannel!.logo!,
                              height: 20.0,
                              fit: BoxFit.cover,
                              placeholder: (BuildContext context, String url) => const Loader(
                                color: ColorResources.primaryOrange,
                              ),
                              errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                child: Image.asset("assets/images/logo/saka.png",
                                  height: 20.0,
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2.0,
                      color: Colors.grey[100],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nomor ${storeProvider.tsum.body![i].paymentChannel!.category!}",
                            style: robotoRegular.copyWith(
                              color: Colors.grey[600],
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                          const SizedBox(height: 2.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SelectableText(storeProvider.tsum.body![i].paymentRef!.paymentCode!,
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Dimensions.fontSizeDefault,
                                )
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Text("Total Pembayaran",
                            style: robotoRegular.copyWith(
                              color: Colors.grey[600],
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                          const SizedBox(height: 6.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Helper.formatCurrency(storeProvider.tsum.body![i].paymentRef!.amount! + storeProvider.tsum.body![i].paymentChannel!.paymentFee!),
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w600,
                                )
                              ),
                              InkWell(
                                onTap: () {
                                  modalDetail(
                                    storeProvider.tsum.body![i].stores!,
                                    storeProvider.tsum.body![i].totalProductPrice!,
                                    storeProvider.tsum.body![i].totalDeliveryCost!,
                                    storeProvider.tsum.body![i].paymentChannel!.paymentFee!
                                  );
                                },
                                child: Text("Lihat Detail",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.primaryOrange,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Text(storeProvider.tsum.body![i].paymentRef!.paymentGuide!,
                            style: robotoRegular.copyWith(
                              color: Colors.grey[600],
                              fontSize: Dimensions.fontSizeDefault,
                            )
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2.0,
                      color: Colors.grey[100],
                    ),
                    const SizedBox(height: 5.0),
                    InkWell(
                      onTap: () async {
                        try {
                          await launch("${AppConstants.baseUrlPaymentBilling}/${storeProvider.tsum.body![i].paymentRef!.refNo}");
                        } catch(e, stacktrace) {
                          debugPrint(stacktrace.toString());
                        }
                      },
                      child: Center(
                        child: Text("Lihat Cara Pembayaran",
                          style: robotoRegular.copyWith(
                            color: ColorResources.primaryOrange,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          )
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              );
            },
          ),
        );
      }
    );
  }

  Widget getTransactionBuyerByPacking(String statusText) {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if (storeProvider.transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading) {
          return loadingList();
        } 
        if(storeProvider.tspmReceive.body!.isEmpty) {
          return emptyTransaction();
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.primaryOrange,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              context.read<StoreProvider>().getTransactionBuyerPaidPacking(context);
            });
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: storeProvider.tspmReceive.body!.length,
            itemBuilder: (BuildContext context, int i) {
              return Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                margin: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    Helper.prefs!.setString("idTrx", storeProvider.tspmReceive.body![i].id!);
                    NS.push(context, const  DetailBuyerTransactionScreen(
                      typeUser: "buyer", 
                      status: "PACKING"
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Belanja",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )
                                ),
                                const SizedBox(height: 2.0),
                                // kk:mm
                                Text(DateFormat('dd MMM yyyy').format(DateTime.parse(storeProvider.tspmReceive.body![i].created!).toLocal()),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.hintColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.primaryOrange,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(statusText,
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.fontSizeSmall,
                                    )
                                  ),
                                ],
                              ) 
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Divider(
                          thickness: 2.0,
                          color: Colors.grey[100],
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 45.0,
                                height: 45.0,
                                child: Stack(
                                  children: [
                                    storeProvider.tspmReceive.body![i].products!.first.product!.pictures!.isEmpty 
                                    ? const SizedBox() 
                                    : Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${storeProvider.tspmReceive.body![i].products!.first.product!.pictures!.first.path}",
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
                                          errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                            child: Image.asset("assets/images/logo/saka.png",
                                            fit: BoxFit.cover,
                                          )
                                        ),
                                      ),
                                    )),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          storeProvider.tspmReceive.body![i].products!.first.product!.name!,
                                          maxLines: 2,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(storeProvider.tspmReceive.body![i].products!.first.quantity.toString() +" barang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.hintColor,
                                      )
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        storeProvider.tspmReceive.body![i].products!.length > 1
                        ? Text("+" + (storeProvider.tspmReceive.body![i].products!.length - 1).toString() +" barang lainnya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.primaryOrange,
                          ))
                        : Container(),
                        const SizedBox(height: 20.0),
                        Text("Total Belanja",
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontSize: Dimensions.fontSizeSmall,
                          )
                        ),
                        const SizedBox(height: 5.0),
                        Text(Helper.formatCurrency(storeProvider.tspmReceive.body![i].totalProductPrice!),
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeSmall,
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        
      },
    );
  }

  Widget getTransactionBuyerByPickup(String statusText) {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if (storeProvider.transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading) {
          return loadingList();
        } 
        if(storeProvider.tspmPickup.body!.isEmpty) {
          return emptyTransaction();
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.primaryOrange,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              context.read<StoreProvider>().getTransactionBuyerPaidPickup(context);
            });
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: storeProvider.tspmPickup.body!.length,
            itemBuilder: (BuildContext context, int i) {
              return Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                margin: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    Helper.prefs!.setString("idTrx", storeProvider.tspmPickup.body![i].id!);
                    NS.push(context, const DetailBuyerTransactionScreen(
                      typeUser: "buyer", 
                      status: "PICKUP"
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Belanja",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )
                                ),
                                const SizedBox(height: 2.0),
                                // kk:mm
                                Text(DateFormat('dd MMM yyyy').format(DateTime.parse(storeProvider.tspmPickup.body![i].created!).toLocal()),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.hintColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.primaryOrange,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(statusText,
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.fontSizeSmall,
                                    )
                                  ),
                                ],
                              ) 
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Divider(
                          thickness: 2.0,
                          color: Colors.grey[100],
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 45.0,
                                height: 45.0,
                                child: Stack(
                                  children: [
                                    storeProvider.tspmPickup.body![i].products!.first.product!.pictures!.isEmpty 
                                    ? const SizedBox()
                                    : Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: CachedNetworkImage(
                                            imageUrl: "${storeProvider.tspmPickup.body![i].products!.first.product!.pictures!.first.path}",
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
                                            errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                              child: Image.asset("assets/images/logo/saka.png",
                                              fit: BoxFit.cover,
                                            )
                                          ),
                                        ),
                                      )
                                    ),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          storeProvider.tspmPickup.body![i].products!.first.product!.name!,
                                          maxLines: 2,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(storeProvider.tspmPickup.body![i].products!.first.quantity.toString() +" barang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.hintColor,
                                      )
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        storeProvider.tspmPickup.body![i].products!.length > 1
                        ? Text("+" + (storeProvider.tspmPickup.body![i].products!.length - 1).toString() +" barang lainnya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.primaryOrange,
                          ))
                        : Container(),
                        const SizedBox(height: 20.0),
                        Text("Total Belanja",
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontSize: Dimensions.fontSizeSmall,
                          )
                        ),
                        const SizedBox(height: 5.0),
                        Text(Helper.formatCurrency(storeProvider.tspmPickup.body![i].totalProductPrice!),
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeSmall,
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        
      },
    );
  }

   Widget getTransactionBuyerByShipping(String statusText) {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if (storeProvider.transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading) {
          return loadingList();
        } 
        if(storeProvider.tspmPickupShipping.body!.isEmpty) {
          return emptyTransaction();
        } 
        return RefreshIndicator(
          backgroundColor: ColorResources.primaryOrange,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              context.read<StoreProvider>().getTransactionBuyerPaidShipping(context);
            });
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: storeProvider.tspmPickupShipping.body!.length,
            itemBuilder: (BuildContext context, int i) {
              return Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                margin: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    Helper.prefs!.setString("idTrx",  storeProvider.tspmPickupShipping.body![i].id!);
                    NS.push(context, const DetailBuyerTransactionScreen(
                      typeUser: "buyer", 
                      status: "SHIPPING"
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Belanja",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )
                                ),
                                const SizedBox(height: 2.0),
                                // kk:mm
                                Text(DateFormat('dd MMM yyyy').format(DateTime.parse(storeProvider.tspmPickupShipping.body![i].created!).toLocal()),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.hintColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.primaryOrange,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(statusText,
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.fontSizeSmall,
                                    )
                                  ),
                                ],
                              ) 
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Divider(
                          thickness: 2.0,
                          color: Colors.grey[100],
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 45.0,
                                height: 45.0,
                                child: Stack(
                                  children: [
                                    storeProvider.tspmPickupShipping.body![i].products!.first.product!.pictures!.isEmpty 
                                    ? const SizedBox() 
                                    : Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${storeProvider.tspmPickupShipping.body![i].products!.first.product!.pictures!.first.path}",
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
                                          errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                            child: Image.asset("assets/images/logo/saka.png",
                                            fit: BoxFit.cover,
                                          )
                                        ),
                                      ),
                                    )),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          storeProvider.tspmPickupShipping.body![i].products!.first.product!.name!,
                                          maxLines: 2,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(storeProvider.tspmPickupShipping.body![i].products!.first.quantity.toString() +" barang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.hintColor,
                                      )
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        storeProvider.tspmPickupShipping.body![i].products!.length > 1
                        ? Text("+" + (storeProvider.tspmPickupShipping.body![i].products!.length - 1).toString() +" barang lainnya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.primaryOrange
                          ))
                        : Container(),
                        const SizedBox(height: 20.0),
                        Text("Total Belanja",
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontSize: Dimensions.fontSizeSmall,
                          )
                        ),
                        const SizedBox(height: 5.0),
                        Text(Helper.formatCurrency(storeProvider.tspmPickupShipping.body![i].totalProductPrice!),
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeSmall,
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        
      },
    );
  }

  Widget getTransactionBuyerByDelivered(String statusText) {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if (storeProvider.transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading) {
          return loadingList();
        } 
        if(storeProvider.tspmDelivered.body!.isEmpty) {
          return emptyTransaction();
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.primaryOrange,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              context.read<StoreProvider>().getTransactionBuyerPaidDelivered(context);
            });
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: storeProvider.tspmDelivered.body!.length,
            itemBuilder: (BuildContext context, int i) {
              return Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                margin: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    Helper.prefs!.setString("idTrx",  storeProvider.tspmDelivered.body![i].id!);
                    NS.push(context, const DetailBuyerTransactionScreen(
                      typeUser: "buyer", 
                      status: "DELIVERED"
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Belanja",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )
                                ),
                                const SizedBox(height: 2.0),
                                // kk:mm
                                Text(DateFormat('dd MMM yyyy').format(DateTime.parse(storeProvider.tspmDelivered.body![i].created!).toLocal()),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.hintColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.primaryOrange,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(statusText,
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.fontSizeSmall,
                                    )
                                  ),
                                ],
                              ) 
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Divider(
                          thickness: 2.0,
                          color: Colors.grey[100],
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 45.0,
                                height: 45.0,
                                child: Stack(
                                  children: [
                                    storeProvider.tspmDelivered.body![i].products!.first.product!.pictures!.isEmpty 
                                    ? const SizedBox() 
                                    : Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${storeProvider.tspmDelivered.body![i].products!.first.product!.pictures!.first.path}",
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
                                          errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                            child: Image.asset("assets/images/logo/saka.png",
                                            fit: BoxFit.cover,
                                          )
                                        ),
                                      ),
                                    )),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          storeProvider.tspmDelivered.body![i].products!.first.product!.name!,
                                          maxLines: 2,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(storeProvider.tspmDelivered.body![i].products!.first.quantity.toString() +" barang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.hintColor,
                                      )
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        storeProvider.tspmDelivered.body![i].products!.length > 1
                        ? Text("+" + (storeProvider.tspmDelivered.body![i].products!.length - 1).toString() +" barang lainnya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.primaryOrange,
                          ))
                        : Container(),
                        const SizedBox(height: 20.0),
                        Text("Total Belanja",
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontSize: Dimensions.fontSizeSmall,
                          )
                        ),
                        const SizedBox(height: 5.0),
                        Text(Helper.formatCurrency(storeProvider.tspmDelivered.body![i].totalProductPrice!),
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeSmall,
                          )
                        ),
                        const SizedBox(height: 10.0),
                         Row(
                            children:[
                            const Expanded(
                              flex: 5,
                              child: SizedBox.shrink()
                            ),
                            Expanded(
                              flex: 3,
                              child: CustomButton(
                                height: 32.0,
                                onTap: () async {
                                  setState(() {
                                    id = i;
                                  });
                                  await context.read<StoreProvider>().postOrderDone(context, storeProvider.tspmDelivered.body![i].id!);
                                  setState(() {
                                    id = -1;
                                  });
                                },
                                isBoxShadow: false,
                                isBorderRadius: true,
                                isBorder: true,
                                btnBorderColor: ColorResources.success,
                                btnTextColor: ColorResources.success,
                                isLoading: id == i ? true : false,
                                loadingColor: ColorResources.success,
                                sizeBorderRadius: 6.0,
                                btnColor: ColorResources.white,
                                btnTxt: "Barang Diterima",
                              ),
                            ),
                          ]
                        ) 
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        
      },
    );
  }

  Widget getTransactionBuyerByDone(String statusText) {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if (storeProvider.transactionBuyerPaidStatus == TransactionBuyerPaidStatus.loading) {
          return loadingList();
        } 
        if(storeProvider.tspmDone.body!.isEmpty) {
          return emptyTransaction();
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.primaryOrange,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              context.read<StoreProvider>().getTransactionBuyerPaidDone(context);
            });
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: storeProvider.tspmDone.body!.length,
            itemBuilder: (BuildContext context, int i) {
              return Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                margin: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    Helper.prefs!.setString("idTrx", storeProvider.tspmDone.body![i].id!);
                    NS.push(context, const DetailBuyerTransactionScreen(
                      typeUser: "buyer", 
                      status: "DONE"
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Belanja",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )
                                ),
                                const SizedBox(height: 2.0),
                                // kk:mm
                                Text(DateFormat('dd MMM yyyy').format(DateTime.parse(storeProvider.tspmDone.body![i].created!).toLocal()),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.hintColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.primaryOrange,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(statusText,
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.fontSizeSmall,
                                    )
                                  ),
                                ],
                              ) 
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Divider(
                          thickness: 2.0,
                          color: Colors.grey[100],
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 45.0,
                                height: 45.0,
                                child: Stack(
                                  children: [
                                    storeProvider.tspmDone.body![i].products!.first.product!.pictures!.isEmpty 
                                    ? const SizedBox() 
                                    : Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${storeProvider.tspmDone.body![i].products!.first.product!.pictures!.first.path}",
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
                                          errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                            child: Image.asset("assets/images/logo/saka.png",
                                            fit: BoxFit.cover,
                                          )
                                        ),
                                      ),
                                    )),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          storeProvider.tspmDone.body![i].products!.first.product!.name!,
                                          maxLines: 2,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(storeProvider.tspmDone.body![i].products!.first.quantity.toString() +" barang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.hintColor,
                                      )
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        storeProvider.tspmDone.body![i].products!.length > 1
                        ? Text("+" + (storeProvider.tspmDone.body![i].products!.length - 1).toString() +" barang lainnya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.primaryOrange
                          ))
                        : Container(),
                        const SizedBox(height: 20.0),
                        Text("Total Belanja",
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontSize: Dimensions.fontSizeSmall,
                          )
                        ),
                        const SizedBox(height: 5.0),
                        Text(Helper.formatCurrency(storeProvider.tspmDone.body![i].totalProductPrice!),
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeSmall,
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        
      },
    );
  }

  Widget getDataReviewProduct() {
    return context.watch<StoreProvider>().reviewProductListStatus == ReviewProductListStatus.loading
  ? loadingListReview()
  : context.watch<StoreProvider>().reviewProductListStatus == ReviewProductListStatus.empty
  ? emptyTransaction()
  : RefreshIndicator(
      backgroundColor: ColorResources.primaryOrange,
      color: ColorResources.white,
      onRefresh: () {
        return Future.sync(() {
          context.read<StoreProvider>().getReviewProductList(context);
        });
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: context.read<StoreProvider>().rpl.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.only(bottom: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                NS.push(context, ReviewProductPage(
                  productId: context.read<StoreProvider>().rpl[i].id!,
                  nameProduct: context.read<StoreProvider>().rpl[i].name!,
                  imgUrl: context.read<StoreProvider>().rpl[i].pictures!.first.path!
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: Stack(
                        children: [
                          context.read<StoreProvider>().rpl[i].pictures!.isEmpty 
                          ? const SizedBox()
                          : Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ClipRRect(
                              borderRadius:  BorderRadius.circular(12.0),
                              child: CachedNetworkImage(
                                imageUrl: "${context.read<StoreProvider>().rpl[i].pictures!.first.path}",
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
                          Text(Helper.formatDate(DateTime.parse(context.read<StoreProvider>().rpl[i].date!)),
                            style: robotoRegular.copyWith(
                              color: ColorResources.primaryOrange,
                              fontSize: Dimensions.fontSizeSmall,
                            )
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          context.read<StoreProvider>().rpl[i].name!.length > 30
                          ? Text(context.read<StoreProvider>().rpl[i].name!.substring(0, 30) + "...",
                              maxLines: 1,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                                fontWeight: FontWeight.w600
                              ),
                            )
                          : Text(context.read<StoreProvider>().rpl[i].name!,
                            maxLines: 1,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.black,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          RatingBarIndicator(
                            rating: 0.0,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        },
      ),
  );
  }

  Widget emptyTransaction() {
    return RefreshIndicator(
      backgroundColor: ColorResources.primaryOrange,
      color: ColorResources.white,
      onRefresh: () {
        return Future.sync(() {
          context.read<StoreProvider>().getReviewProductList(context);
          context.read<StoreProvider>().getTransactionUnpaid(context);
          context.read<StoreProvider>().getTransactionBuyerPaidPacking(context);
          context.read<StoreProvider>().getTransactionBuyerPaidPickup(context);
          context.read<StoreProvider>().getTransactionBuyerPaidShipping(context);
          context.read<StoreProvider>().getTransactionBuyerPaidDelivered(context);
          context.read<StoreProvider>().getTransactionBuyerPaidDone(context);
        });
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text("Belum ada transaksi saat ini",
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: ColorResources.black,
                  fontWeight: FontWeight.w600
                ),
              )
            ),
          )
        ],
      )
    );
  }

  void modalGuide(String guidePayment) {
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
                      padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0,
                        top: 16, bottom: 8.0
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              NS.pop(context);
                            },
                            child: const Icon(Icons.close)
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 16.0),
                            child: Text("Cara Pembayaran",
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
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [Html(data: guidePayment)],
                      ),
                    )
                  ],
                ),
              ],
            )
          )
        );
      },
    );
  }

  void modalDetail(List<TransactionUnpaidStoreElement> stores, double totalProductPrice, double totalDeliveryCost, double adminfee) {
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
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              NS.pop(context);
                            },
                            child: const Icon(
                              Icons.close
                            )
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Text("Detail Tagihan",
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
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                            ...stores.asMap().map((index, data) => MapEntry(index,
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Pesanan  " + (index + 1).toString(),
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.black,
                                              fontSize: Dimensions.fontSizeDefault,
                                              fontWeight: FontWeight.w600
                                            )
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Container(
                                                height: 30.0,
                                                width: 30.0,
                                                padding: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(40.0),
                                                  color: ColorResources.primaryOrange
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.store,
                                                    color: ColorResources.white
                                                    )
                                                  )
                                                ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(data.store!.name!,
                                                    style: robotoRegular.copyWith(
                                                      color: ColorResources.black,
                                                      fontSize: Dimensions.fontSizeDefault,
                                                      fontWeight: FontWeight.w600
                                                    )
                                                  ),
                                                  Text(data.store!.city!,
                                                    style: robotoRegular.copyWith(
                                                      color: ColorResources.primaryOrange,
                                                      fontSize: Dimensions.fontSizeSmall,
                                                    )
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("No Invoice",
                                                style: robotoRegular.copyWith(
                                                  color: ColorResources.primaryOrange,
                                                  fontSize: Dimensions.fontSizeSmall,
                                                )
                                              ),
                                              const SizedBox(height: 4.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(data.invoiceNo!,
                                                    style: robotoRegular.copyWith(
                                                      color: ColorResources.black,
                                                      fontSize: Dimensions.fontSizeDefault,
                                                    )
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          ...data.items!.map((dataProduct) {
                                            return Container(
                                              margin: const EdgeInsets.only(top: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 60.0,
                                                    height: 60.0,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                          child:
                                                            ClipRRect(
                                                            borderRadius:BorderRadius.circular(12.0),
                                                            child: CachedNetworkImage(
                                                              imageUrl: "${dataProduct.product!.pictures!.first.path}",
                                                              fit: BoxFit.cover,
                                                              placeholder: (context, url) => Center(
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
                                                              errorWidget: (context, url, error) => Center(
                                                                child: Image.asset(
                                                                  "assets/images/logo/saka.png",
                                                                  fit: BoxFit.cover,
                                                                )
                                                              ),
                                                            ),
                                                          )
                                                        ),
                                                        // dataProduct.product!.discount !=  null
                                                        // ? Align(
                                                        //     alignment: Alignment.topLeft,
                                                        //     child: Container(
                                                        //       height: 20.0,
                                                        //       width: 25.0,
                                                        //       padding: const EdgeInsets.all(5.0),
                                                        //       decoration: BoxDecoration(
                                                        //         borderRadius: const BorderRadius.only(
                                                        //           bottomRight: Radius.circular(12.0), 
                                                        //           topLeft: Radius.circular(12.0)
                                                        //         ),
                                                        //         color: Colors.red[900]
                                                        //       ),
                                                        //       child: Center(
                                                        //         child: Text(dataProduct.product!.discount!.discount!.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                                        //           style: robotoRegular.copyWith(
                                                        //             color: ColorResources.white,
                                                        //             fontSize: 10,
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
                                                        dataProduct.product!.name!.length > 75
                                                        ? Text(
                                                            dataProduct.product!.name!.substring(0, 80) + "...",
                                                            maxLines: 2,
                                                            style: robotoRegular.copyWith(
                                                              fontSize: Dimensions.fontSizeDefault,
                                                            ),
                                                          )
                                                        : Text(dataProduct.product!.name!,
                                                            maxLines: 2,
                                                            style: robotoRegular.copyWith(
                                                              fontSize: Dimensions.fontSizeDefault,
                                                            ),
                                                          ),
                                                        const SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Text(dataProduct.quantity.toString() + " barang " + "(" + (dataProduct.product!.weight! * dataProduct.quantity!).toString() +" gr)",
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            color: ColorResources.primaryOrange,
                                                          )
                                                        ),
                                                        const SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Text(
                                                          Helper.formatCurrency(dataProduct.product!.price!),
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
                                            );
                                          }).toList(),
                                          const SizedBox(
                                            height: 25.0,
                                          ),
                                          const SizedBox(
                                            height: 4.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 12.0,
                                      color: Colors.grey[100],
                                    ),
                                  ],
                                )
                              )
                            ).values.toList(),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 88.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: Text("Ringkasan Belanja",
                                      style: robotoRegular.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: ColorResources.black
                                      )
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Harga Barang",
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black
                                          )
                                        ),
                                        SizedBox(
                                          child: Text(Helper.formatCurrency(totalProductPrice),
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.black
                                            )
                                          ),
                                        )
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
                                          color: ColorResources.black
                                        )),
                                        Text(Helper.formatCurrency(totalDeliveryCost),
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black
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
                                        Text("Biaya Admin",
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black
                                          )
                                        ),
                                        Text(Helper.formatCurrency(adminfee),
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black
                                          )
                                        ),
                                      ]
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.grey[100],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Pembayaran",
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black,
                                            fontWeight: FontWeight.w600,
                                          )
                                        ),
                                        Text(Helper.formatCurrency(totalProductPrice + totalDeliveryCost + adminfee),
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black,
                                            fontWeight: FontWeight.w600,
                                          )
                                        ),
                                      ]
                                    ),
                                  ),
                                ]
                              )
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
          )
        );
      },
    );
  }

  Widget loadingListUnPaid() {
    return  ListView.builder(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorResources.white
                            )
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            height: 10.0,
                            width: double.infinity,
                            margin: const EdgeInsets.only(right: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: ColorResources.white
                            )
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            height: 10.0,
                            width: double.infinity,
                            margin: const EdgeInsets.only(right: 32),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorResources.white
                            )
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              Divider(
                thickness: 8.0,
                color: Colors.grey[100],
              ),
              const SizedBox(height: 5.0),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 10.0,
                          width: 120.0,
                          margin: const EdgeInsets.only(right: 16.0, left: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: ColorResources.white
                          )
                        ),
                        Container(
                          height: 10.0,
                          width: 80.0,
                          margin: const EdgeInsets.only(right: 16.0, left: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                              color: ColorResources.white
                          )
                        ),
                      ],
                    ),
                  ],
                )
              ),
              const SizedBox(height: 5),
              Divider(thickness: 2, color: Colors.grey[100]),
              const SizedBox(height: 5),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.0,
                      height: 10.0,
                      margin: const EdgeInsets.only(right: 16.0, left: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: ColorResources.white
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Container(
                        height: 10.0,
                        width: 120.0,
                        margin: const EdgeInsets.only(right: 16.0, left: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: ColorResources.white
                          )
                        ),
                      Container(
                        height: 10.0,
                        width: 40.0,
                        margin: const EdgeInsets.only(right: 16, left: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ColorResources.white
                          )
                        ),
                      ],
                    ),
                      const SizedBox(height: 15.0),
                      Container(
                        width: 80.0,
                        height: 10.0,
                        margin: const EdgeInsets.only(right: 16, left: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorResources.white
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 10.0,
                            width: 100.0,
                            margin: const EdgeInsets.only(right: 16.0, left: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: ColorResources.white
                              )
                            ),
                          Container(
                            height: 10.0,
                            width: 60.0,
                            margin: const EdgeInsets.only(right: 16.0, left: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: ColorResources.white
                            )
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  )
                ),
              const SizedBox(height: 5.0),
              Divider(
                thickness: 2.0, 
                color: Colors.grey[100]
              ),
              const SizedBox(height: 5.0),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Center(
                  child: Container(
                    height: 10.0,
                    width: 120.0,
                    margin: const EdgeInsets.only(right: 16.0, left: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: ColorResources.white
                    )
                  ),
                ),
              ),
              const SizedBox(height: 14.0),
            ],
          ),
        );
      },
    );
  }

  Widget loadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: ColorResources.white
                            )
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 10,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ColorResources.white
                                )
                              ),
                              const SizedBox(height: 2),
                              Container(
                                height: 10.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ColorResources.white
                                )
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        height: 10,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: ColorResources.white
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorResources.white
                        )
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: ColorResources.white
                            )
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 10.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: ColorResources.white
                            )
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    width: 80,
                    height: 10.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorResources.white
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 60,
                    height: 10.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorResources.white
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loadingListReview() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (BuildContext context, int i) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                        color: ColorResources.white
                      )
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 10.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: ColorResources.white
                          )
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          height: 10.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: ColorResources.white
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  }
}
