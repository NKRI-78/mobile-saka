import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/data/models/store/bank_payment_store.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/providers/store/store.dart';

class SelectPaymentScreen extends StatefulWidget {
  const SelectPaymentScreen({
    Key? key
  }) : super(key: key);

  @override
  _SelectPaymentScreenState createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
 
  String id = "";
  String nameBank = "";
  
  late TextEditingController bankC;

  Future<bool> willPopScope() {
    NS.pop(context);
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();

    bankC = TextEditingController();
  }

  @override 
  void dispose() {
    bankC.dispose();

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
          backgroundColor: ColorResources.white,
           leading: CupertinoNavigationBarBackButton(
            color: ColorResources.primaryOrange,
            onPressed: () {
              NS.pop(context);
            },
          ),
          centerTitle: true,
          elevation: 0,
          title: Text("Pilih Pembayaran",
            style: robotoRegular.copyWith(
              color: ColorResources.primaryOrange,
              fontWeight: FontWeight.w600
            )
          ),
        ),
        body: Stack(
          clipBehavior: Clip.none,
          children: [

            ListView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              children: [
                Card(
                  margin: const EdgeInsets.only(
                    top: 12.0, left: 12.0, 
                    right: 12.0, bottom: 70.0, 
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    backgroundColor: ColorResources.white,
                    iconColor: ColorResources.black,
                    title: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: ColorResources.black,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text("Pilih Cara Pembayaran",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black
                            ),
                          )
                        )
                      ],
                    ),
                    children: [
                      ExpansionTile(
                        initiallyExpanded: true,
                        backgroundColor: ColorResources.white,
                        iconColor: ColorResources.black,
                        collapsedIconColor: ColorResources.black,
                        title: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 5.0),
                              child: Text("TRANSFER",
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black
                                ),
                              )
                            )
                          ],
                        ),
                        children: [getDataBank()],
                      ),
                    ],
                  ),
                )
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 10.0, right: 10.0, 
                  bottom: 10.0
                ),
                child: CustomButton(
                  isBorder: false,
                  isBoxShadow: false,
                  isBorderRadius: true,
                  onTap: bankC.text == ""
                  ? () {
                      ShowSnackbar.snackbar(context, "Anda belum memilih metode pembayaran", "", ColorResources.error);
                      return;
                    }
                  : () async {
                    await context.read<StoreProvider>().postCartCheckout(context, nameBank, id);
                  },
                  btnColor: bankC.text == "" ? Colors.grey[200]! : ColorResources.primaryOrange,
                  isLoading: context.watch<StoreProvider>().postCartCheckoutStatus == PostCartCheckoutStatus.loading 
                  ? true 
                  : false,
                  btnTxt: "Bayar",
                ),
              )
            ),

          ],
        )
      ),
    );
  }

  Widget getDataBank() {
    return FutureBuilder<BankPaymentStore?>(
      future: Provider.of<StoreProvider>(context, listen: false).getDataBank(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final BankPaymentStore bps = snapshot.data;
          return ListView.builder(
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: bps.body!.length,
            itemBuilder: (BuildContext context, int i) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 70.0,
                      margin: const EdgeInsets.only(
                        left: 16.0, right: 16.0, 
                        bottom: 5.0, top: 5.0
                      ),
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: id == bps.body![i].channel 
                        ? ColorResources.primaryOrange 
                        : ColorResources.white,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              id = bps.body![i].channel!;
                              bankC = TextEditingController(text: bps.body![i].name);
                              nameBank = bps.body![i].name!;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl: bps.body![i].logo!,
                                        height: 30.0,
                                        fit: BoxFit.cover,
                                        placeholder: (BuildContext context, String url) => const Loader(
                                          color: ColorResources.primaryOrange,
                                        ),
                                        errorWidget: (BuildContext context, String url, dynamic error) {
                                          return Center(
                                            child: Image.asset("assets/images/logo/saka.png",
                                              height: 20.0,
                                              fit: BoxFit.cover,
                                            )
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        bps.body![i].name!,
                                        style: robotoRegular.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: id == bps.body![i].channel 
                                          ? ColorResources.white 
                                          : ColorResources.black
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              );
            }
          );
        }
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: const Loader(
            color: ColorResources.primaryOrange
          ),
        );
      },
    );
  }
}