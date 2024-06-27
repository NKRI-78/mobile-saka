import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/color_resources.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/data/models/store/shipping_couriers.dart';

import 'package:saka/providers/store/store.dart';

class PilihPengirimanPage extends StatefulWidget {
  final String idStore;

  const PilihPengirimanPage({
    Key? key,
    required this.idStore,
  }) : super(key: key);
  @override
  _PilihPengirimanPageState createState() => _PilihPengirimanPageState();
}

class _PilihPengirimanPageState extends State<PilihPengirimanPage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Future<bool> willPopScope() {
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
      onWillPop: willPopScope,
      child: Scaffold(
        key: globalKey,
        backgroundColor: ColorResources.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Pilih Jasa Pengiriman",
            style: robotoRegular.copyWith(
              color: ColorResources.black, 
              fontWeight: FontWeight.w600
            ),
          ),
          backgroundColor: ColorResources.white,
          iconTheme: const IconThemeData(color: ColorResources.black),
          titleSpacing: 0,
          leading: CupertinoNavigationBarBackButton(
            color: ColorResources.black,
            onPressed: () {
              NS.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: getDataCourier()
      ),
    );
  }

  Widget getDataCourier() {
    return FutureBuilder<ShippingCouriersModel?>(
      future: context.read<StoreProvider>().getCourierShipping(context, widget.idStore),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final ShippingCouriersModel shippingCM = snapshot.data!;
          if(shippingCM.body == null) {
            return emptyCourier();
          }
          return ListView.builder(
            itemCount: shippingCM.body!.categories!.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int i) {
              return shippingCM.body!.categories!.isNotEmpty
              ? ExpansionTile(
                  initiallyExpanded: true,
                  backgroundColor: ColorResources.white,
                  iconColor: ColorResources.black,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shippingCM.body!.categories![i].type!.replaceAll('_', ''),
                        style: robotoRegular.copyWith(
                          color: ColorResources.black,
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w600
                        )
                      ),
                      Text(shippingCM.body!.categories![i].label!.replaceAll('_', ''),
                        style: robotoRegular.copyWith(
                          color: ColorResources.black,
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600
                        )
                      ),
                    ],
                  ),
                  children: shippingCM.body!.categories![i].rates!.asMap().map((int key, Rate rate) => MapEntry(key,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () {
                                    context.read<StoreProvider>().postSetCouriers(context, widget.idStore, rate.rateId!); 
                                  },
                                  leading: CachedNetworkImage(
                                    imageUrl: "${rate.courierLogo}",
                                    width: 75.0,
                                    height: 75.0,
                                  ),
                                  title: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8.0),
                                        Text(rate.serviceName!,
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(rate.courierName!,
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text("("+ Helper.formatCurrency(rate.price!) + ")",
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black,
                                            fontSize: 15.0,
                                          )
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text("Estimasi Tiba " + rate.estimateDays!.replaceAll(RegExp(r"HARI"), "") + " Hari",
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black,
                                            fontSize: 15.0,
                                          )
                                        ),
                                        const SizedBox(height: 8.0),
                                      ],
                                    ),
                                  ),
                                ),
                                shippingCM.body!.categories!.length == key + 1
                                ? Container()
                                : Container()
                              ],
                            )
                          ],
                        ),
                      )
                    )
                  ).values.toList(),
                )
              : Container();
            },
          );
        }
        return const Loader(
          color: ColorResources.primaryOrange
        );
      },
    );
  }

  Widget emptyCourier() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Belum ada kurir\nSilahkan coba ganti/tambah alamat anda",
          textAlign: TextAlign.center,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: ColorResources.black,
          ),
        ),
      ),
    );
  }

}