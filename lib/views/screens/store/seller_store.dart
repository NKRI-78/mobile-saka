import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/extension.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/views/screens/store/edit_store.dart';
import 'package:saka/views/screens/store/seller_add_product.dart';
import 'package:saka/views/screens/store/seller_transaction_order.dart';
import 'package:saka/views/screens/store/stuff_sell.dart';

class SellerStoreScreen extends StatefulWidget {
  const SellerStoreScreen({Key? key}) : super(key: key);

  @override
  _SellerStoreScreenState createState() => _SellerStoreScreenState();
}

class _SellerStoreScreenState extends State<SellerStoreScreen> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Future<bool> onWillPop() { 
    NS.pop(context);
    return Future.value(true);
  }

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
          elevation: 0,
          title: Text("Toko Saya",
            style: robotoRegular.copyWith(
              color: ColorResources.white,
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.fontSizeDefault
            ),
          ),
        ),
        body: Consumer<StoreProvider>(
          builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
            if(storeProvider.sellerStoreStatus == SellerStoreStatus.loading) {
              return const Loader(
                color: ColorResources.primaryOrange
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 65.0,
                        height: 65.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: CachedNetworkImage(
                            imageUrl: "${AppConstants.baseUrlFeedImg}${storeProvider.sellerStoreModel.body?.picture?.path}",
                            fit: BoxFit.cover,
                            placeholder: (BuildContext context, String url) => const Loader(
                              color: ColorResources.primaryOrange,
                            ),
                            errorWidget: (BuildContext context, String url, dynamic error) => ClipOval(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: ColorResources.primaryOrange
                                ),
                                child: const Icon(
                                  Icons.store,
                                  size: 30.0,
                                  color: ColorResources.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(storeProvider.sellerStoreModel.body!.name!.toTitleCase(),
                              style: robotoRegular.copyWith(
                                color: ColorResources.black,
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w600
                              )
                            ),
                            const SizedBox(height: 4.0),
                            Text(storeProvider.sellerStoreModel.body!.address! +", " + storeProvider.sellerStoreModel.body!.city!,
                              style: robotoRegular.copyWith(
                                color: ColorResources.black, 
                                fontSize: Dimensions.fontSizeDefault
                              )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      GestureDetector(
                        onTap: () {
                          NS.push(context, EditStorePage(
                            idStore: storeProvider.sellerStoreModel.body!.id!,
                            nameStore: storeProvider.sellerStoreModel.body!.name!,
                            description: storeProvider.sellerStoreModel.body!.description!,
                            province: storeProvider.sellerStoreModel.body!.province!,
                            city: storeProvider.sellerStoreModel.body!.city!,
                            subDistrict: storeProvider.sellerStoreModel.body!.subDistrict!,
                            village: storeProvider.sellerStoreModel.body!.village!,
                            postalCode: storeProvider.sellerStoreModel.body!.postalCode!,
                            address: storeProvider.sellerStoreModel.body!.address!,
                            email: storeProvider.sellerStoreModel.body!.email!,
                            phone: storeProvider.sellerStoreModel.body!.phone!,
                            location: storeProvider.sellerStoreModel.body!.location!,
                            supportedCouriers: storeProvider.sellerStoreModel.body!.supportedCouriers!,
                            picture: storeProvider.sellerStoreModel.body!.picture!,
                            status: storeProvider.sellerStoreModel.body!.open!,
                          ));
                        },
                        child: const Icon(
                          Icons.edit_outlined,
                          color: ColorResources.black
                        )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0, 
                    right: 16.0, 
                    top: 20.0, 
                    bottom: 10.0
                  ),
                  child: Text("Barang Jualan Saya",
                    style: robotoRegular.copyWith(
                      color: ColorResources.black,
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w600
                    )
                    )
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    NS.push(context, TambahJualanPage(
                      idStore: storeProvider.sellerStoreModel.body!.id!,
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: const Icon(
                            Icons.add_circle_outline,
                            color: ColorResources.black
                          )
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tambah Barang",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                              ),
                              Text( "Upload foto barang jualanmu lalu lengkapi detailnya",
                                style: robotoRegular.copyWith(
                                  fontSize: 12.0, 
                                  color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Icon(Icons.arrow_forward_ios),
                          ],
                        )
                      ],
                    )
                  ),
                ),
                const Divider(),
                GestureDetector(
                  onTap: () {
                    NS.push(context, StuffSellerScreen(
                      idStore: storeProvider.sellerStoreModel.body!.id!,
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: const Icon(
                            Icons.list_alt,
                            color: ColorResources.black
                          )
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Daftar Produk",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                              ),
                              Text("Lihat semua barang yang dijual di Toko mu",
                                style: robotoRegular.copyWith(
                                  fontSize: 12.0, 
                                  color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Icon(Icons.arrow_forward_ios),
                          ],
                        )
                      ],
                    )
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    NS.push(context, const SellerTransactionOrderScreen(
                      index: 0,
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: const Icon(
                            Icons.list,
                            color: ColorResources.black
                          )
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pesanan",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                              ),
                              Text("Barang pesanan yang masuk",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall, 
                                  color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Icon(Icons.arrow_forward_ios),
                          ],
                        )
                      ],
                    )
                  ),
                ),
                const Divider(),
              ],
            );         
          },
        )
      ),
    );
  }
}
