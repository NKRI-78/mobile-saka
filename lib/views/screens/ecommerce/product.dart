import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:provider/provider.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/views/basewidgets/button/bounce.dart';
import 'package:saka/views/screens/ecommerce/cart.dart';

import 'package:saka/views/screens/ecommerce/widget/product_item.dart';

class EcommerceScreen extends StatefulWidget {
  const EcommerceScreen({super.key});

  @override
  State<EcommerceScreen> createState() => EcommerceScreenState();
}

class EcommerceScreenState extends State<EcommerceScreen> {

  Timer? debounce;

  late TextEditingController searchC;
  late FocusNode searchFn;

  late EcommerceProvider ep;

  Future<void> getData() async {
    
    if(!mounted) return; 
      await ep.fetchAllProducts(search: "");

    if(!mounted) return;
      await ep.getCart();

  }

  @override 
  void initState() {
    super.initState();
    
    searchC = TextEditingController();
    searchFn = FocusNode();

    ep = context.read<EcommerceProvider>();

    searchC.addListener(() {

      if(searchC.text.isNotEmpty) {
        if (debounce?.isActive ?? false) debounce?.cancel();
          debounce = Timer(const Duration(milliseconds: 500), () {
            ep.fetchAllProducts(search: searchC.text);
          });
      }

    });

    Future.microtask(() => getData());
  }

  @override 
  void dispose() {
    debounce?.cancel();

    searchC.dispose();
    searchFn.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () {
          return Future.sync(() {
            ep.fetchAllProducts(search: "");
          });
        },
        child: Consumer<EcommerceProvider>(
          builder: (_, notifier, __) {
            return CustomScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [
            
                SliverAppBar(
                  title: Text("Toko Saka",
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.black
                    ),
                  ),
                  leading: CupertinoNavigationBarBackButton(
                    color: ColorResources.brown,
                    onPressed: () {
                      NS.pop(context);
                    },
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      left: 16.0,
                      right: 16.0
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [

                          Expanded(
                            child: TextField(
                              controller: searchC,
                              focusNode: searchFn,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault
                              ),
                              decoration: InputDecoration(
                                labelText: "Cari Produk",
                                labelStyle: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                contentPadding: EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 16.0,
                                  right: 16.0
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                                )
                              ),
                            ),
                          ),

                          const SizedBox(width: 15.0),

                          if(notifier.getCartStatus == GetCartStatus.loading)
                            Badge(
                              label: Text("0",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall
                                ),
                              ),
                              child: Icon(
                                Icons.shopping_cart,
                                size: 20.0
                              ),
                            ),

                          if(notifier.getCartStatus == GetCartStatus.error)
                            Badge(
                              label: Text("0",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall
                                ),
                              ),
                              child: Icon(
                                Icons.shopping_cart,
                                size: 20.0
                              ),
                            ),
                        
                         if(notifier.getCartStatus == GetCartStatus.loaded)
                            Bouncing(
                              onPress: () {
                                NS.push(context, CartScreen());
                              },
                              child: Badge(
                                label: Text(notifier.cartData.totalItem.toString(),
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 20.0
                                ),
                              ),
                            ),

                        ],
                      )
                    )
                  )
                ),

                if(notifier.listProductStatus == ListProductStatus.loading)
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

                if(notifier.listProductStatus == ListProductStatus.error)
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

                if(notifier.listProductStatus == ListProductStatus.loaded)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 25.0,
                      horizontal: 16.0
                    ),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.0 / 4.5,
                        mainAxisSpacing: 10.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int i) {
                          final product = notifier.products[i];
                          return ProductItem(product: product);
                        },
                        childCount: notifier.products.length,
                      ),
                    ),
                  ),

              ],
            );
          },
        )
        
      ),
    );
  }
}