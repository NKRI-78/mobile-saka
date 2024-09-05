import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';

import 'package:saka/views/basewidgets/button/bounce.dart';
import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/screens/ecommerce/delivery.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {

  late EcommerceProvider ep;

  Future<void> getData() async {
    if(!mounted) return;
      ep.getCart();
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
                  
                });
              },
              child: Consumer<EcommerceProvider>(
                builder: (__, notifier, _) {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      
                      SliverAppBar(
                        backgroundColor: ColorResources.backgroundColor,
                        centerTitle: false,
                        leadingWidth: 33.0,
                        title: Text("Keranjang",
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        ),
                        leading: CupertinoNavigationBarBackButton(
                            color: ColorResources.black,
                            onPressed: () {
                              NS.pop(context);
                            },
                          ) 
                        ),

                        if(notifier.getCartStatus == GetCartStatus.loading)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: CircularProgressIndicator.adaptive()
                              )
                            )
                          ),

                        if(notifier.getCartStatus == GetCartStatus.error)
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
                        
                        if(notifier.getCartStatus == GetCartStatus.loaded)
                          SliverPadding(
                            padding: EdgeInsets.only(
                              top: 20.0,
                              left: 16.0,
                              right: 16.0
                            ),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                          
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                          
                                        Text(notifier.cartData.stores![i].store.name,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault
                                          ),
                                        ),
                                        Text(notifier.cartData.stores![i].store.address,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: ColorResources.hintColor
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 12.0),
                                          
                                        ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color: ColorResources.hintColor,
                                            );
                                          },
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: notifier.cartData.stores![i].items.length,
                                          itemBuilder: (BuildContext context, int z) {
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                      
                                              CachedNetworkImage(
                                                imageUrl: "https://dummyimage.com/300x300/000/fff",
                                                imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                                  return Container(
                                                    width: 45.0,
                                                    height: 45.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover
                                                      )
                                                    ),
                                                  );
                                                },
                                                placeholder: (BuildContext context, String url) {
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 32.0,
                                                      height: 32.0,
                                                      child: CircularProgressIndicator.adaptive()
                                                    )
                                                  );
                                                },
                                                errorWidget: (BuildContext context, String url, dynamic error) {
                                                  return const CircleAvatar(
                                                    maxRadius: 20.0,
                                                    backgroundImage: NetworkImage("https://dummyimage.com/300x300/000/fff"),
                                                  );
                                                },
                                              ),
                                      
                                              const SizedBox(width: 10.0),
                                              
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                      
                                                  SizedBox(
                                                    width: 180.0,
                                                    child: Text( notifier.cartData.stores![i].items[z].name,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: robotoRegular.copyWith(
                                                        fontSize: Dimensions.fontSizeDefault
                                                      ),
                                                    ),
                                                  ),
                                                  
                                                  const SizedBox(height: 5.0),
                                                  
                                                  Text(Helper.formatCurrency(double.parse(notifier.cartData.stores![i].items[z].price.toString())),
                                                    style: robotoRegular.copyWith(
                                                      fontSize: Dimensions.fontSizeDefault,
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  
                                                  const SizedBox(height: 8.0),
                                      
                                                  SizedBox(
                                                    width: 220.0,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                      
                                                        Expanded(
                                                          flex: 25,
                                                          child: Bouncing(
                                                          onPress: () {
                                                            showModalBottomSheet(
                                                              shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(30.0),
                                                                  topRight: Radius.circular(30.0)
                                                                )
                                                              ),
                                                              context: context,
                                                              isScrollControlled: true,
                                                              builder: (BuildContext context) {
                                                                return Padding(
                                                                  padding: EdgeInsets.only(
                                                                    bottom: MediaQuery.of(context).viewInsets.bottom
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets.only(top: 35.0),
                                                                        child: Column(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(
                                                                                top: 5.0,
                                                                                left: 10.0,
                                                                                right: 10.0,
                                                                                bottom: 5.0
                                                                              ),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text("Catatan",
                                                                                    style: robotoRegular.copyWith(
                                                                                      fontSize: Dimensions.fontSizeLarge,
                                                                                      fontWeight: FontWeight.w600
                                                                                    ),
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      NS.pop(context);
                                                                                    },
                                                                                    child: const Padding(
                                                                                      padding: EdgeInsets.all(5.0),
                                                                                      child: Icon(
                                                                                        Icons.close,
                                                                                        size: 30.0,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ) 
                                                                            ),
                                                                            const Divider(
                                                                              height: 10.0,
                                                                              thickness: 1.5,
                                                                              color: ColorResources.greyBottomNavbar,
                                                                            ),
                                                                            Container(
                                                                              margin: const EdgeInsets.all(10.0),
                                                                              child: TextField(
                                                                                controller: notifier.cartData.stores![i].items[z].cart.noteC,
                                                                                maxLines: 8,
                                                                                decoration: const InputDecoration(
                                                                                  border: OutlineInputBorder(),
                                                                                  focusedBorder: OutlineInputBorder(),
                                                                                  enabledBorder: OutlineInputBorder()
                                                                                ),
                                                                                cursorColor: ColorResources.black,
                                                                              )
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ).whenComplete(() async {
                                                              
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text("Tulis Catatan",
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeSmall,
                                                                  color: const Color(0xFF0F903B)
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                      
                                                        Expanded(
                                                          flex: 37,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Container(
                                                                height: 40.0,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                  border: Border.all(
                                                                    color: ColorResources.hintColor
                                                                  )
                                                                ),
                                                                child: TextField(
                                                                  readOnly: true,
                                                                  textAlign: TextAlign.center,
                                                                  controller: ep.cartData.stores![i].items[z].cart.totalCartC,
                                                                  style: robotoRegular.copyWith(
                                                                    fontSize: Dimensions.fontSizeDefault,
                                                                  ),
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter.digitsOnly
                                                                  ],
                                                                  onChanged: (String val) {},
                                                                  cursorColor: ColorResources.black,
                                                                  decoration: InputDecoration(
                                                                    contentPadding: const EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right: 0.0
                                                                    ),
                                                                    border: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                        color: ColorResources.black
                                                                      )
                                                                    ),
                                                                    focusedBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                        color: Color(0xFF0F903B)
                                                                      )
                                                                    ),
                                                                    enabledBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                        color: ColorResources.black
                                                                      )
                                                                    ),
                                                                    suffixIcon: Bouncing(
                                                                      onPress: () {
                                                                        int currval = int.parse(ep.cartData.stores![i].items[z].cart.totalCartC.text);
                                                                        
                                                                        setState(() {
                                                                          currval = currval + 1;
                                                                          ep.cartData.stores![i].items[z].cart.totalCartC.text = (currval).toString();
                                                                        });

                                                                        ep.incrementQty(i: i, z: z, qty: currval);
                                                                      }, 
                                                                      child: Icon(
                                                                        Icons.add,
                                                                        size: 15.0,
                                                                        color: ColorResources.black
                                                                      )
                                                                    ),
                                                                    prefixIcon: Bouncing(
                                                                      onPress: () {
                                                                        var currval = int.parse(ep.cartData.stores![i].items[z].cart.totalCartC.text);
                                                                        if(currval > 1) {
                                                                          setState(() {
                                                                            currval = currval - 1;
                                                                            ep.cartData.stores![i].items[z].cart.totalCartC.text = (currval).toString();
                                                                          });

                                                                          ep.decrementQty(i: i, z: z, qty: currval);
                                                                        }
                                                                      }, 
                                                                      child: const Icon(
                                                                        Icons.remove,
                                                                        size: 15.0,
                                                                        color: ColorResources.black
                                                                      )
                                                                    )
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ), 
                                                        ),
                                      
                                                        Bouncing(
                                                          onPress: () {
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
                                                                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                                                                      height: 280.0,
                                                                      decoration: BoxDecoration(
                                                                        color: const Color(0xff0F903B), 
                                                                        borderRadius: BorderRadius.circular(20.0)
                                                                      ),
                                                                      child: Stack(
                                                                        clipBehavior: Clip.none,
                                                                        children: [
                                                                                                          
                                                                          Align(
                                                                            alignment: Alignment.topLeft,
                                                                            child: Container(
                                                                              margin: const EdgeInsets.only(top: 0.0, left: 0.0),
                                                                              child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                                child: Image.asset("assets/images/background/shading-top-left.png")
                                                                              )
                                                                            )
                                                                          ),
                                                                                                          
                                                                          Align(
                                                                            alignment: Alignment.topRight,
                                                                            child: Container(
                                                                              margin: const EdgeInsets.only(top: 0.0, right: 0.0),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(20.0),
                                                                                child: Image.asset("assets/images/background/shading-right.png")
                                                                              )
                                                                            )
                                                                          ),
                                                                                                          
                                                                          Align(
                                                                            alignment: Alignment.bottomRight,
                                                                            child: Container(
                                                                              margin: const EdgeInsets.only(top: 200.0, right: 0.0),
                                                                              child: Image.asset("assets/images/background/shading-right-bottom.png")
                                                                            )
                                                                          ),
                                                                          
                                                                          Align(
                                                                            alignment: Alignment.center,
                                                                            child: Text("Apakah kamu yakin ingin hapus dari keranjang",
                                                                              style: robotoRegular.copyWith(
                                                                                fontSize: Dimensions.fontSizeDefault,
                                                                                fontWeight: FontWeight.w600,
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
                                                                                  margin: const EdgeInsets.only(bottom: 30.0),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Expanded(child: Container()),
                                                                                      Expanded(
                                                                                        flex: 5,
                                                                                        child: CustomButton(
                                                                                          isBorderRadius: true,
                                                                                          btnColor: ColorResources.white,
                                                                                          btnTextColor: ColorResources.black,
                                                                                          onTap: () {
                                                                                            NS.pop(context);
                                                                                          }, 
                                                                                          btnTxt: "Batal"
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(child: Container()),
                                                                                      Expanded(
                                                                                        flex: 5,
                                                                                        child: CustomButton(
                                                                                          isBorderRadius: true,
                                                                                          isLoading: false,
                                                                                          btnColor: ColorResources.error ,
                                                                                          btnTextColor: ColorResources.white,
                                                                                          onTap: () async {
                                                                                            
                                                                                          }, 
                                                                                          btnTxt: "OK"
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(child: Container()),
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
                                                          child: const Padding(
                                                            padding: EdgeInsets.all(5.0),
                                                            child: Icon(
                                                              Icons.delete,
                                                              color: ColorResources.error,
                                                            ),
                                                          ),
                                                        )
                                      
                                                      ],
                                                    ),
                                                  )
                                      
                                                ],
                                              )
                                            ],
                                          );
                                        }),
                                      ],
                                    );
                                  },
                                )
                                          
                              ]
                            )
                          ),
                        )
                    ],
                  );
                },
              ) 
            ),

            Consumer<EcommerceProvider>(
              builder: (_, notifier, __) {
                if(notifier.getCartStatus == GetCartStatus.loading) {
                  return const SizedBox();
                }
                if(notifier.getCartStatus == GetCartStatus.error) {
                  return const SizedBox();
                }
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: ColorResources.white,
                      boxShadow: kElevationToShadow[4]
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Container(
                          margin: const EdgeInsets.only(
                            left: 10.0
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Total Pembayaran",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: ColorResources.hintColor
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(Helper.formatCurrency(double.parse(notifier.cartData.totalPrice.toString())),
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w600,
                                  color: ColorResources.black
                                ),
                              )
                            ],
                          ),
                        ),
                        
                        Container(
                          margin: const EdgeInsets.only(
                            right: 10.0
                          ),
                          width: 90.0,
                          height: 40.0,
                          child: CustomButton(
                            onTap: () {
                               NS.push(context, DeliveryScreen());
                            },
                            isBorder: false,
                            isBorderRadius: true,
                            sizeBorderRadius: 5.0,
                            isBoxShadow: false,
                            fontSize: Dimensions.fontSizeSmall,
                            isLoading: false,
                            btnColor: ColorResources.purple,
                            btnTxt: "Selanjutnya",
                          ),
                        )
                      ],
                    ),
                  ),
                );

              },
            )

        ]
      )
    );
  }
}