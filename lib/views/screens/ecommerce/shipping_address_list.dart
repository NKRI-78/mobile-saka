import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

class ShippingAddressListScreen extends StatefulWidget {
  const ShippingAddressListScreen({super.key});

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
    return Stack(
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
                    title: const Text("Pilih Alamat Lain",
                      style: TextStyle(
                        color: ColorResources.black, 
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: ColorResources.white,
                    iconTheme: const IconThemeData(color: ColorResources.black),
                    leading: CupertinoNavigationBarBackButton(
                      color: ColorResources.black,
                      onPressed: () {
                        NS.pop(context);
                      },
                    ),
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
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () async {
                                  // await context.read<RegionProvider>().selectPrimaryAddress(
                                  //   uid: regionProvider.shippingAddressData[i].shippingAddressId!
                                  // );
                                },
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
                                                Text(notifier.shippingAddress[i].name,
                                                  style: const TextStyle(
                                                    color: ColorResources.black,
                                                    fontSize: Dimensions.fontSizeDefault,
                                                    fontWeight: FontWeight.w600
                                                  )
                                                ),
                                                const SizedBox(height: 5),
                                                Text(notifier.shippingAddress[i].province,
                                                  style: const TextStyle(
                                                    color: ColorResources.black,
                                                    fontSize: Dimensions.fontSizeDefault,
                                                  )
                                                ),
                                                const SizedBox(height: 3),
                                                Text(notifier.shippingAddress[i].city,
                                                  style: const TextStyle(
                                                    color: ColorResources.black,
                                                    fontSize: 14,
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
                                      const SizedBox(height: 14.0),
                                      GestureDetector(
                                        onTap: () {
                                          // NS.push(EditAddressScreen(
                                          //   id: regionProvider.shippingAddressData[i].shippingAddressId!
                                          // ));
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
                                          child: const Center(
                                            child: Text("Ubah Alamat",
                                              style: TextStyle(
                                                color: const Color(0xFF0F903B),
                                                fontSize: Dimensions.fontSizeDefault,
                                              )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                
              },
              btnTxt: "Tambah Alamat Baru",
              isBorder: false,
              isBorderRadius: true,
              btnColor: const Color(0xFF0F903B),
            )
          )     
        )

      ]
    ); 
  } 
}