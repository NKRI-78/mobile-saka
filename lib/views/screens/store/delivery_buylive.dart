import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/screens/store/select_payment.dart';
import 'package:saka/views/screens/store/select_address.dart';
import 'package:saka/views/screens/store/select_delivery.dart';

import 'package:saka/data/models/store/address.dart';
import 'package:saka/data/models/store/cart_add.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/providers/region/region.dart';

import 'package:saka/providers/store/store.dart';

class DeliveryBuyLiveScreen extends StatefulWidget {
  const DeliveryBuyLiveScreen({Key? key}) : super(key: key);

  @override
  _DeliveryBuyLiveScreenState createState() => _DeliveryBuyLiveScreenState();
}

class _DeliveryBuyLiveScreenState extends State<DeliveryBuyLiveScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Future<void> getData() async {
    if(mounted) {
      await context.read<RegionProvider>().getDataAddress(context);
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
      appBar: AppBar(
        backgroundColor: ColorResources.backgroundColor,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.primaryOrange,
          onPressed: () {
            NS.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
        title: Text("Pengiriman",
          style: robotoRegular.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorResources.primaryOrange
          ),
        ),
      ),
      body: Consumer<StoreProvider>(
        builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
          if(storeProvider.cartStatus == CartStatus.loading) {
            return const Loader(
              color: ColorResources.primaryOrange,
            );
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Alamat Pengiriman",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: ColorResources.black,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            NS.push(context, const SelectAddressPage(
                              title:"Pilih Alamat Pengiriman",
                            ));
                          },
                          child: Text("Pilih Alamat Lain",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.primaryOrange,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Divider(
                      thickness: 2.0,
                      color: Colors.grey[100],
                    ),
                    const SizedBox(height: 4.0),
                    Consumer<RegionProvider>(
                      builder: (BuildContext context, RegionProvider regionProvider, Widget? child) {
                        if(regionProvider.getAddressStatus == GetAddressStatus.loading) {
                          return const Loader(
                            color: ColorResources.primaryOrange,
                          );
                        }
                        List<AddressList> addresses = regionProvider.addressList.where((el) => el.defaultLocation == true).toList();
                        return regionProvider.addressList.isEmpty
                          ? Text("Silahkan pilih alamat pengiriman Anda.",
                              style: robotoRegular.copyWith(
                                color: ColorResources.primaryOrange,
                                fontSize: Dimensions.fontSizeSmall,
                              )
                            )
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: addresses.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(addresses[i].name!,
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black,
                                      fontSize: Dimensions.fontSizeDefault,
                                      fontWeight: FontWeight.w600
                                    )
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(addresses[i].phoneNumber!,
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black,
                                      fontSize: Dimensions.fontSizeDefault,
                                    )
                                  ),
                                  const SizedBox(height: 3.0),
                                  Text(addresses[i].address!,
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black,
                                      fontSize: Dimensions.fontSizeDefault,
                                    )
                                  ),
                                ],
                              );
                            },
                          );
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 12.0,
                color: Colors.grey[100],
              ),
              ...storeProvider.cartStores.where((el) => el.isActive == true).toList().asMap().map((int i, StoreElement data) => MapEntry(i,
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pesanan  " + (i + 1).toString(),
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
                                padding: const EdgeInsets.all(2.0),
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
                          const SizedBox(
                            height: 8.0,
                          ),
                          ...data.items!.where((el) => el.isActive == true).toList().map((dataProduct) {
                            return Container(
                              margin: const EdgeInsets.only(top: 8.0),
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
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12.0),
                                            child: CachedNetworkImage(
                                              imageUrl: "${dataProduct.product!.pictures!.first.path!}",
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
                                              errorWidget: (BuildContext context, String url, dynamic error) =>
                                                Center(
                                                  child: Image.asset("assets/images/logo/saka.png",
                                                  fit: BoxFit.cover,
                                                )
                                              ),
                                            ),
                                          )
                                        ),
                                        dataProduct.product!.discount != null
                                        ? Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              height: 20.0,
                                              width: 25.0,
                                              padding: const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                bottomRight: Radius.circular(12.0),
                                                topLeft: Radius.circular(12.0)
                                              ),
                                                color: Colors.red[900]
                                              ),
                                              child: Center(
                                                child: Text(dataProduct.product!.discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container()
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        dataProduct.product!.name!.length > 75
                                        ? Text(dataProduct.product!.name!.substring(0, 80) + "...",
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
                                        Text(dataProduct.quantity.toString() + " barang " + "(" + (dataProduct.product!.weight! * dataProduct.quantity!) .toString() + " gr)",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: ColorResources.primaryOrange,
                                          )
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(Helper.formatCurrency(dataProduct.product!.price!),
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.black,
                                            fontWeight:FontWeight.w600,
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
                          GestureDetector(
                            onTap: () {
                              if(context.read<RegionProvider>().addressList.where((el) => el.defaultLocation == true).isEmpty) {
                                ShowSnackbar.snackbar(context, "Anda belum memilih alamat pengiriman", "", ColorResources.error);
                                return;
                              } else {
                                NS.push(context, PilihPengirimanPage(idStore: data.storeId!));
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.grey),
                                color: ColorResources.white,
                              ),
                              child: data.shippingRate!.serviceType == ""
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      const Icon(
                                        Icons.local_shipping,
                                        color: ColorResources.primaryOrange
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      Text("Pilih Pengiriman",
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w600,
                                        )
                                      )
                                    ],
                                  )),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey
                                  )
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(data.shippingRate!.serviceType!,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w600,
                                        )
                                      )
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Divider(
                                  thickness: 1.0,
                                  color: Colors.grey[100],
                                ),
                                Column(
                                  children: [
                                    Text(data.shippingRate!.courierName!,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w600,
                                      )
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data.shippingRate!.serviceName!,
                                            style: robotoRegular.copyWith(
                                              fontSize:  15.0,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            Helper.formatCurrency(data.shippingRate!.price!),
                                            style: robotoRegular.copyWith(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                              color: ColorResources.primaryOrange
                                            )
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text( "Estimasi tiba " + data.shippingRate!.estimateDays!.replaceAll(RegExp(r"HARI"), "") + " Hari",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.primaryOrange
                                            )
                                          ),
                                        ]
                                      )
                                    ),
                                  ],
                                ),
                              ],
                            )),
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
                padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, 
                  top: 8.0, bottom: 80.0
                ),
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
                          Text("Total Harga", style: robotoRegular.copyWith(color: ColorResources.black)),
                          Text(Helper.formatCurrency(storeProvider.cartData.totalProductPrice! + storeProvider.cartData.serviceCharge!),
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
                          Text("Ongkos Kirim",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black
                            )
                          ),
                          Text(Helper.formatCurrency(storeProvider.cartData.totalDeliveryCost!),
                            style: robotoRegular.copyWith(
                              color: ColorResources.black
                            )
                          ),
                        ]
                      ),
                    ),
                  ]
                )
              ),
              ]
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70.0,
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, 
                  top: 8.0, bottom: 8.0
                ),
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5.0,
                      blurRadius: 7.0,
                      offset: const Offset(0.0, 4.0)
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Total Tagihan",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.primaryOrange
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(Helper.formatCurrency(storeProvider.cartData.totalProductPrice! + storeProvider.cartData.totalDeliveryCost! + storeProvider.cartData.serviceCharge!),
                              style: robotoRegular.copyWith(
                                color: ColorResources.black,
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w600
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        bool active = false;
                        var s =  storeProvider.cartStores.where((el) => el.isLiveBuy == true).toList();
                        for (int i = 0; i < s.length; i++) {
                          if (s[i].shippingRate != null) {
                            active = true;
                          } else {
                            active = false;
                            break;
                          }
                        }
                        active  
                        ? NS.push(context, const SelectPaymentScreen())
                        : ShowSnackbar.snackbar(context, "Anda belum memilih metode pengiriman", "", ColorResources.error);
                      },
                      child: Container(
                        width: 170.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: ColorResources.primaryOrange
                        ),
                        child: Center(
                          child: Text("Pilih Pembayaran",
                          style: robotoRegular.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            )
          )
        ]);      
      })
    );
  }

  Widget loadingList(int index) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: index,
        itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 12.0,
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorResources.white
              ),
            ),
            Container(
              width: 120,
              height: 12.0,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorResources.white
              ),
            ),
            Container(
              width: 180,
              height: 12.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorResources.white
              ),
            ),
          ],
        );
      },
    ),
  );
  }
}
