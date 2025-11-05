import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/screens/ecommerce/shipping_address/create_shipping_address.dart';
import 'package:saka/views/screens/ecommerce/shipping_address/edit_shipping_address.dart';

class ShippingAddressListScreen extends StatefulWidget {
  final String from;
  const ShippingAddressListScreen({
    required this.from,
    super.key
  });

  @override
  State<ShippingAddressListScreen> createState() => ShippingAddressListScreenState();
}

class ShippingAddressListScreenState extends State<ShippingAddressListScreen> {

  late EcommerceProvider ep;

  Future<void> getData() async {
    if(!mounted) return; 
      ep.getShippingAddressList();
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
      body: Stack(
        clipBehavior: Clip.none,
        children: [
      
          RefreshIndicator.adaptive(
            onRefresh: () {
              return Future.sync(() {
                ep.getShippingAddressList();
              });
            },
            child: Consumer<EcommerceProvider>(
              builder: (_, notifier, __) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                        
                    SliverAppBar(
                      title: Text("Pilih Alamat Lain",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: ColorResources.white,
                      iconTheme: const IconThemeData(color: ColorResources.black),
                      leading: CupertinoNavigationBarBackButton(
                        color: ColorResources.black,
                        onPressed: () {
                          NS.pop();
                        },
                      ),
                    ),

                    if(notifier.getShippingAddressListStatus == GetShippingAddressListStatus.loading)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: CircularProgressIndicator()
                          ),
                        )
                      ),

                    if(notifier.getShippingAddressListStatus == GetShippingAddressListStatus.empty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text("Belum ada alamat",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault
                            ),
                          )
                        )
                      ),

                    if(notifier.getShippingAddressListStatus == GetShippingAddressListStatus.error) 
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text("Hmm... Mohon tunggu yaa",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault
                            ),
                          )
                        )
                      ),
              
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int i) {
                          return Container(
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                              left: 10.0, 
                              right: 10.0
                            ),
                            child: Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.only(bottom: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                              
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(notifier.shippingAddress[i].name!,
                                                style: robotoRegular.copyWith(
                                                  color: ColorResources.black,
                                                  fontSize: Dimensions.fontSizeDefault,
                                                  fontWeight: FontWeight.bold
                                                )
                                              ),
                                              const SizedBox(height: 5),
                                              Text(notifier.shippingAddress[i].province!,
                                                style: robotoRegular.copyWith(
                                                  color: ColorResources.black,
                                                  fontSize: Dimensions.fontSizeDefault,
                                                )
                                              ),
                                              const SizedBox(height: 3),
                                              Text(notifier.shippingAddress[i].city!,
                                                style: robotoRegular.copyWith(
                                                  color: ColorResources.black,
                                                  fontSize: Dimensions.fontSizeDefault,
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        notifier.shippingAddress[i].defaultLocation == true
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Color(0xFF0F903B)
                                          )
                                        : Container()
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 12.0),
                              
                                    GestureDetector(
                                      onTap: () async {
                                        await ep.selectPrimaryShippingAddress(
                                          id: notifier.shippingAddress[i].id!,
                                          from: widget.from
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: ColorResources.success,
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Center(
                                          child: Text("Pilih Alamat",
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: Dimensions.fontSizeDefault,
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                              
                                    const SizedBox(height: 12.0),
                              
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                              
                                        Expanded(
                                          flex: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              NS.push(context, EditShippingAddressScreen(
                                                id: notifier.shippingAddress[i].id!
                                              ));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  width: 2.0,
                                                  color: Colors.grey[350]!,
                                                )
                                              ),
                                              child: Center(
                                                child: Text("Ubah Alamat",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                              
                                        Expanded(
                                          child: SizedBox()
                                        ),
                              
                                        Expanded(
                                          flex: 5,
                                          child: notifier.shippingAddress[i].defaultLocation!
                                          ? const SizedBox() 
                                          : GestureDetector(
                                            onTap: () {
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
                                                          color: ColorResources.purple, 
                                                          borderRadius: BorderRadius.circular(20.0)
                                                        ),
                                                        child: Stack(
                                                          clipBehavior: Clip.none,
                                                          children: [
                                                                                            
                                                            Align(
                                                              alignment: Alignment.center,
                                                              child: Text("Apakah kamu yakin ingin hapus dari keranjang",
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeDefault,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: ColorResources.white
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
                                                                                isLoading: notifier.deleteShippingAddressStatus == DeleteShippingAddressStatus.loading 
                                                                                ? true 
                                                                                : false,
                                                                                btnColor: ColorResources.error ,
                                                                                btnTextColor: ColorResources.white,
                                                                                onTap: () async {
                                                                                  await ep.deleteShippingAddress(id: notifier.shippingAddress[i].id!);
                                                                                  NS.pop();
                                                                                }, 
                                                                                btnTxt: "OK"
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
                                            child: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: ColorResources.error,
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  width: 2.0,
                                                  color: ColorResources.error
                                                )
                                              ),
                                              child: Center(
                                                child: Text("Hapus Alamat",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                              
                              
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      childCount: notifier.shippingAddress.length
                    )
                  )
      
                ]);
              }
            )
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60.0,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: ColorResources.white,
              ),
              child: CustomButton(
                onTap: () {
                  NS.push(context, CreateShippingAddressScreen());
                },
                btnTxt: "Tambah Alamat Baru",
                isBorder: false,
                isBorderRadius: true,
                btnColor: ColorResources.purple,
              )
            )     
          )
      
        ]
      ),
    ); 
  } 
}