import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/constant.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/screens/store/seller_detail_order_transaction.dart';

import 'package:saka/providers/store/store.dart';

class SellerTransactionOrderScreen extends StatefulWidget {
  final int? index;

  const SellerTransactionOrderScreen({
    Key? key,
    required this.index,
  }) : super(key: key);
  @override
  _SellerTransactionOrderScreenState createState() => _SellerTransactionOrderScreenState();
}

class _SellerTransactionOrderScreenState extends State<SellerTransactionOrderScreen> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late TabController tabC;

  int index = 0;

  int id = -1;

  List progress = ['ORDER_PAID','ORDER_PACKED','ORDER_PICKUP', 'ORDER_SHIPPED', 'ORDER_DELIVERED', 'ORDER_COMPLETED'];

  Future<void> getData() async { 
    if(mounted) {
      await context.read<StoreProvider>().getTransactionSellerPaidReceive(context);
    }
    if(mounted) {
      await context.read<StoreProvider>().getTransactionSellerPaidPacking(context);
    }
    if(mounted) {
      await context.read<StoreProvider>().getTransactionSellerPaidPickupShipping(context);
    }
    if(mounted) { 
      await context.read<StoreProvider>().getTransactionSellerPaidDelivered(context);
    }
    if(mounted) {
      await context.read<StoreProvider>().getTransactionSellerPaidDone(context);
    }
  }

  Future<void> handleChanging() async {
    setState(() {
      index = tabC.index;
    });
    if(tabC.indexIsChanging) {
      if(index == 0) {
        if(mounted) {
          await context.read<StoreProvider>().getTransactionSellerPaidReceive(context);
        }
      }
      if(index == 1) {
        if(mounted) {
          await context.read<StoreProvider>().getTransactionSellerPaidPacking(context);
        }  
      } 
      if(index == 2) {
        if(mounted) {
          await context.read<StoreProvider>().getTransactionSellerPaidPickupShipping(context);
        }
      }
      if(index == 3) {
        if(mounted) {
          await context.read<StoreProvider>().getTransactionSellerPaidDelivered(context);
        }
      }
      if(index == 4) {
        if(mounted) {
          await context.read<StoreProvider>().getTransactionSellerPaidDone(context);
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
    
    tabC = TabController(length: 5, vsync: this, initialIndex: widget.index!);
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
        backgroundColor: ColorResources.backgroundColor,
        appBar: AppBar(
          backgroundColor: ColorResources.primaryOrange,
          leading: CupertinoNavigationBarBackButton(
            color: ColorResources.white,
            onPressed: onWillPop,
          ),
          centerTitle: true,
          elevation: 0.0,
          title: Text("Penjualan Saya",
            style: robotoRegular.copyWith(
              color: ColorResources.white,
              fontWeight: FontWeight.w600
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
                  
                  context.watch<StoreProvider>().transactionSellerPaidStatus == TransactionSellerPaidStatus.loading 
                  ? const Tab(text: "Pesanan Baru")
                  : context.read<StoreProvider>().packingCount == 0 
                  ? const Tab(text: "Pesanan Baru")
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
                      child: Text("Pesanan Baru",
                        style: robotoRegular.copyWith(
                          color: ColorResources.black
                        ),
                      ),
                    ),

                  context.watch<StoreProvider>().transactionSellerPaidStatus == TransactionSellerPaidStatus.loading 
                  ? const Tab(text: "Siap Dikirim")
                  : context.read<StoreProvider>().pickupCount == 0 
                  ? const Tab(text: "Siap Dikirim")
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
                        child: Text("Siap Dikirim",
                          style: robotoRegular
                        )
                      )
                    ),

                  context.watch<StoreProvider>().transactionSellerPaidStatus == TransactionSellerPaidStatus.loading 
                  ? const Tab(text: "Sedang Dikirim")
                  : context.read<StoreProvider>().shippingCount == 0 
                  ? const Tab(text: "Sedang Dikirim")
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
                        child: Text("Sedang Dikirim",
                          style: robotoRegular
                        ),
                      )
                    ),

                  context.watch<StoreProvider>().transactionSellerPaidStatus == TransactionSellerPaidStatus.loading 
                  ? const Tab(text: "Sampai Tujuan")
                  : context.read<StoreProvider>().deliveredCount == 0 
                  ? const Tab(text: "Sampai Tujuan")
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
                        child: Text("Sampai Tujuan",
                          style: robotoRegular
                        ),
                      )
                    ),

                  context.watch<StoreProvider>().transactionSellerPaidStatus == TransactionSellerPaidStatus.loading 
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
                  ],
                controller: tabC
              ),
              Expanded(
                flex: 40,
                child: TabBarView(
                  controller: tabC, 
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    getTransactionSellerByStatusReceive(),
                    getTransactionSellerByStatusPacking(),
                    getTransactionSellerByStatusPickupShipping(),
                    getTransactionSellerByStatusDelivered(),
                    getTransactionSellerByStatusDone(),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTransactionSellerByStatusReceive() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if (storeProvider.transactionSellerPaidStatus == TransactionSellerPaidStatus.loading) {
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
              context.read<StoreProvider>().getTransactionSellerPaidReceive(context);
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
                    NS.push(context, const DetailSellerTransactionScreen(
                      typeUser: "seller",
                      status: "RECEIVED"
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
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
                                Text("Pesanan Baru",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                                const SizedBox(height: 2.0),
                                Text('${storeProvider.tspmReceive.body![i].id}',
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.yellowSecondaryV5,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.alarm,
                                    size: 20.0,
                                    color: ColorResources.white,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(DateFormat('dd MMM yyyy kk:mm').format(DateTime.parse(storeProvider.tspmReceive.body![i].created!).toLocal()),
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
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${AppConstants.baseUrlFeedImg}${storeProvider.tspmReceive.body![i].products!.first.product!.pictures!.first.path}",
                                          fit: BoxFit.cover,
                                          placeholder: (BuildContext context, String url) =>
                                            Center(
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
                                          errorWidget:(BuildContext context, String url, dynamic error) => Center(
                                            child: Image.asset(
                                            "assets/images/logo/saka.png",
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
                                        Text(storeProvider.tspmReceive.body![i].products!.first.product!.name!,
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
                                    Text(storeProvider.tspmReceive.body![i].products!.first.quantity.toString() + " barang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.primaryOrange,
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
                        ? Text("+" + (storeProvider.tspmReceive.body![i].products!.length - 1).toString() + " barang lainnya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.primaryOrange,
                          )
                        )
                        : Container(),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Belanja",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                                const SizedBox(height: 5.0),
                                Text(Helper.formatCurrency(storeProvider.tspmReceive.body![i].sellerProductPrice!),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
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
                                  await context.read<StoreProvider>().postOrderPacking(context, storeProvider.tspmReceive.body![i].id!);
                                  setState(() {
                                    id = -1;
                                  });
                                },
                                isBoxShadow: false,
                                isBorderRadius: true,
                                isBorder: true,
                                sizeBorderRadius: 6.0,
                                btnBorderColor: ColorResources.success,
                                btnTextColor: ColorResources.success,
                                loadingColor: ColorResources.success,
                                isLoading: id == i ? true : false,
                                btnColor: ColorResources.white,
                                btnTxt: "Konfirmasi Pesanan",
                              ),
                            )
                          ],
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

  Widget getTransactionSellerByStatusPacking() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if (storeProvider.transactionSellerPaidStatus == TransactionSellerPaidStatus.loading) {
          return loadingList();
        }
        if(storeProvider.tspmPacking.body!.isEmpty) {
          return emptyTransaction();
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.primaryOrange,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              context.read<StoreProvider>().getTransactionSellerPaidPacking(context);
            });
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: storeProvider.tspmPacking.body!.length,
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
                    Helper.prefs!.setString("idTrx", storeProvider.tspmPacking.body![i].id!);
                    NS.push(context, const DetailSellerTransactionScreen(
                      typeUser: "seller",
                      status: "PACKING"
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
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
                                Text("Siap Dikirim",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                                const SizedBox(height: 2.0),
                                Text('${storeProvider.tspmPacking.body![i].id}',
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.yellowSecondaryV5,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.alarm,
                                    size: 20.0,
                                    color: ColorResources.white,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(DateFormat('dd MMM yyyy kk:mm').format(DateTime.parse(storeProvider.tspmPacking.body![i].created!).toLocal()),
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
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${AppConstants.baseUrlFeedImg}${storeProvider.tspmPacking.body![i].products!.first.product!.pictures!.first.path}",
                                          fit: BoxFit.cover,
                                          placeholder: (BuildContext context, String url) =>
                                            Center(
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
                                          errorWidget:(BuildContext context, String url, dynamic error) => Center(
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
                                        Text(storeProvider.tspmPacking.body![i].products!.first.product!.name!,
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
                                    Text(storeProvider.tspmPacking.body![i].products!.first.quantity.toString() + " barang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.primaryOrange,
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
                        storeProvider.tspmPacking.body![i].products!.length > 1
                        ? Text("+" + (storeProvider.tspmPacking.body![i].products!.length - 1).toString() + " barang lainnya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.primaryOrange,
                          )
                        )
                        : Container(),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Belanja",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                                const SizedBox(height: 5.0),
                                Text(Helper.formatCurrency(storeProvider.tspmPacking.body![i].sellerProductPrice!),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
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
                                  await context.read<StoreProvider>().bookingCourier(context, storeProvider.tspmPacking.body![i].id!, storeProvider.tspmPacking.body![i].deliveryCost!.courierId!);
                                  setState(() {
                                    id = -1;
                                  });
                                },
                                isBoxShadow: false,
                                isBorderRadius: true,
                                isBorder: true,
                                sizeBorderRadius: 6.0,
                                btnBorderColor: ColorResources.success,
                                btnTextColor: ColorResources.success,
                                loadingColor: ColorResources.success,
                                isLoading: id == i ? true : false,
                                btnColor: ColorResources.white,
                                btnTxt: "Pesan Kurir",
                              ),
                            )
                          ],
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

  Widget getTransactionSellerByStatusPickupShipping() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if (storeProvider.transactionSellerPaidStatus == TransactionSellerPaidStatus.loading) {
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
              context.read<StoreProvider>().getTransactionSellerPaidPickupShipping(context);
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
                    Helper.prefs!.setString("idTrx", storeProvider.tspmPickupShipping.body![i].id!);
                    NS.push(context, const DetailSellerTransactionScreen(
                      typeUser: "seller",
                      status: "PICKUP,SHIPPING"
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
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
                                Text("Sedang Dikirim",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                                const SizedBox(height: 2.0),
                                Text('${storeProvider.tspmPickupShipping.body![i].id}',
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.yellowSecondaryV5,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.alarm,
                                    size: 20.0,
                                    color: ColorResources.white,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(DateFormat('dd MMM yyyy kk:mm').format(DateTime.parse(storeProvider.tspmPickupShipping.body![i].created!).toLocal()),
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
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${AppConstants.baseUrlFeedImg}${storeProvider.tspmPickupShipping.body![i].products!.first.product!.pictures!.first.path}",
                                          fit: BoxFit.cover,
                                          placeholder: (BuildContext context, String url) =>
                                            Center(
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
                                          errorWidget:(BuildContext context, String url, dynamic error) => Center(
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
                                        Text(storeProvider.tspmPickupShipping.body![i].products!.first.product!.name!,
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
                                    Text(storeProvider.tspmPickupShipping.body![i].products!.first.quantity.toString() + " barang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.primaryOrange,
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
                        ? Text("+" + (storeProvider.tspmPickupShipping.body![i].products!.length - 1).toString() + " barang lainnya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.primaryOrange,
                          )
                        )
                        : Container(),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Belanja",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                                const SizedBox(height: 5.0),
                                Text(Helper.formatCurrency(storeProvider.tspmPickupShipping.body![i].sellerProductPrice!),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeSmall,
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
          ),
        );
      },
    );
  }

  Widget getTransactionSellerByStatusDelivered() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if (storeProvider.transactionSellerPaidStatus == TransactionSellerPaidStatus.loading) {
          return loadingList();
        }
        if( storeProvider.tspmDelivered.body!.isEmpty) {
          return emptyTransaction();
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.primaryOrange,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              context.read<StoreProvider>().getTransactionSellerPaidDelivered(context);
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
                    Helper.prefs!.setString("idTrx", storeProvider.tspmDelivered.body![i].id!);
                    NS.push(context, const DetailSellerTransactionScreen(
                      typeUser: "seller",
                      status: "DELIVERED"
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
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
                                Text("Sampai Tujuan",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                                const SizedBox(height: 2.0),
                                Text('${storeProvider.tspmDelivered.body![i].id}',
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.yellowSecondaryV5,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.alarm,
                                    size: 20.0,
                                    color: ColorResources.white,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(DateFormat('dd MMM yyyy kk:mm').format(DateTime.parse(storeProvider.tspmDelivered.body![i].created!).toLocal()),
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
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${AppConstants.baseUrlFeedImg}${storeProvider.tspmDelivered.body![i].products!.first.product!.pictures!.first.path}",
                                          fit: BoxFit.cover,
                                          placeholder: (BuildContext context, String url) =>
                                            Center(
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
                                          errorWidget:(BuildContext context, String url, dynamic error) => Center(
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
                                        Text(storeProvider.tspmDelivered.body![i].products!.first.product!.name!,
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
                                    Text(storeProvider.tspmDelivered.body![i].products!.first.quantity.toString() + " barang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.primaryOrange,
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
                        ? Text("+" + (storeProvider.tspmDelivered.body![i].products!.length - 1).toString() + " barang lainnya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.primaryOrange,
                          )
                        )
                        : Container(),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Belanja",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                                const SizedBox(height: 5.0),
                                Text(Helper.formatCurrency(storeProvider.tspmDelivered.body![i].sellerProductPrice!),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeSmall,
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
          ),
        );
      },
    );
  }

  Widget getTransactionSellerByStatusDone() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if (storeProvider.transactionSellerPaidStatus == TransactionSellerPaidStatus.loading) {
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
              context.read<StoreProvider>().getTransactionSellerPaidDone(context);
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
                    NS.push(context, const DetailSellerTransactionScreen(
                      typeUser: "seller",
                      status: "DONE"
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
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
                                Text("Selesai",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                                const SizedBox(height: 2.0),
                                Text('${storeProvider.tspmDone.body![i].id}',
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.yellowSecondaryV5,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.alarm,
                                    size: 20.0,
                                    color: ColorResources.white,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(DateFormat('dd MMM yyyy kk:mm').format(DateTime.parse(storeProvider.tspmDone.body![i].created!).toLocal()),
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
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${AppConstants.baseUrlFeedImg}${storeProvider.tspmDone.body![i].products!.first.product!.pictures!.first.path}",
                                          fit: BoxFit.cover,
                                          placeholder: (BuildContext context, String url) =>
                                            Center(
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
                                          errorWidget:(BuildContext context, String url, dynamic error) => Center(
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
                                        Text(storeProvider.tspmDone.body![i].products!.first.product!.name!,
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
                                    Text(storeProvider.tspmDone.body![i].products!.first.quantity.toString() + " barang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.primaryOrange,
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
                        ? Text("+" + (storeProvider.tspmDone.body![i].products!.length - 1).toString() + " barang lainnya",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.primaryOrange,
                          )
                        )
                        : Container(),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Belanja",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                                const SizedBox(height: 5.0),
                                Text(Helper.formatCurrency(storeProvider.tspmDone.body![i].sellerProductPrice!),
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeSmall,
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
          ),
        );
      },
    );
  }

  Widget loadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (BuildContext context, int i) {
        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.only(bottom: 8.0),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 25.0,
                            width: 25.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: ColorResources.white
                            )
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 10.0,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: ColorResources.white
                                )
                              ),
                              const SizedBox(height: 2.0),
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
                  const SizedBox(height: 5.0),
                  const Divider(
                    thickness: 2.0,
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 45.0,
                        width: 45.0,
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
                  const SizedBox(height: 30.0),
                  Container(
                    width: 80.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorResources.white
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 60.0,
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

  Widget emptyTransaction() {
    return RefreshIndicator(
      backgroundColor: ColorResources.primaryOrange,
      color: ColorResources.white,
      onRefresh: () {
        return Future.sync(() {
          context.read<StoreProvider>().getTransactionSellerPaidReceive(context);
          context.read<StoreProvider>().getTransactionSellerPaidPacking(context);
          context.read<StoreProvider>().getTransactionSellerPaidPickupShipping(context);
          context.read<StoreProvider>().getTransactionSellerPaidDelivered(context);
          context.read<StoreProvider>().getTransactionSellerPaidDone(context);
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
}