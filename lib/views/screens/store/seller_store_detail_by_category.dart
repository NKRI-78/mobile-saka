import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:saka/data/models/store/product_store.dart';

import 'package:shimmer/shimmer.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/screens/store/detail_product.dart';
import 'package:saka/views/screens/store/seller_store_detail_search.dart';
import 'package:saka/views/screens/store/cart_product.dart';

class SellerStoreDetailByCategory extends StatefulWidget {
  final String storeId;
  final String storeName;
  final String categoryId;
  final String productType;

  const SellerStoreDetailByCategory({ 
    required this.storeId,
    required this.storeName,
    required this.categoryId,
    required this.productType,
    Key? key 
  }) : super(key: key);

  @override
  State<SellerStoreDetailByCategory> createState() => _SellerStoreDetailByCategoryState();
}

class _SellerStoreDetailByCategoryState extends State<SellerStoreDetailByCategory> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Future<void> getData() async {
    if(mounted) {
      await context.read<StoreProvider>().getCartInfo(context);
    }
    if(mounted) {
      await context.read<StoreProvider>().getAllProductByCategorySellerDetail(context, widget.categoryId, widget.storeId);
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
      backgroundColor: ColorResources.backgroundColor,
      body: NestedScrollView(
         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            
            SliverAppBar(
              title: Text("${widget.storeName} - ${widget.productType}",
                style: robotoRegular.copyWith(
                  color: ColorResources.white,
                  fontWeight: FontWeight.w600
                ),
              ),
              centerTitle: true,
              titleSpacing: 0.0,
              leading: CupertinoNavigationBarBackButton(
                color: ColorResources.white,
                onPressed: () {
                  NS.pop(context);
                },
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: SliverDelegate(
                child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall, 
                  vertical: 2.0
                ),
                color: ColorResources.white,
                alignment: Alignment.center,
                child: Row(
                  children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        NS.push(context, SellerDetailSearchProductScreen(
                          typeProduct: "commerce",
                          storeId: widget.storeId
                        ));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 16.0, 
                          right: 16.0
                        ),
                        width: double.infinity,
                        height: 48.0,
                        decoration:  BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16)
                          )
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(
                                9.0, 14.0, 
                                9.0, 14.0
                              ),
                              child: const Icon(
                                Icons.search,
                                color: ColorResources.grey,
                              ),
                            ),
                            Text("Cari Barang di Toko ${widget.storeName}",
                              style: robotoRegular.copyWith(
                                color: ColorResources.grey,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Consumer<StoreProvider>(
                    builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                      return storeProvider.cartStatus == CartStatus.empty 
                      ? GestureDetector(
                          onTap: () {
                            NS.push(context,  const CartProdukPage());
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 20.0, 
                              right: 14.0
                            ),
                            child: const Icon(
                              Icons.shopping_cart,
                              color: ColorResources.primaryOrange,
                            )
                          ),
                        ) 
                      : storeProvider.cartStatus == CartStatus.error 
                      ? IconButton(
                          icon: const Icon(
                            Icons.shopping_cart, 
                            color: ColorResources.primaryOrange,
                          ),
                          onPressed: () {
                            NS.push(context, const CartProdukPage());
                          },
                        )
                      : badges.Badge(
                          position: badges.BadgePosition.topEnd(top: 3.0, end: 6.0),
                          badgeAnimation: badges.BadgeAnimation.slide(
                            animationDuration: Duration(milliseconds: 300)
                          ),
                          badgeContent: storeProvider.cartStatus == CartStatus.loading 
                          ? Text("...",
                            style: robotoRegular.copyWith(
                              color: ColorResources.white, 
                              fontSize: Dimensions.fontSizeSmall
                            ),
                          )
                        : Text(
                          storeProvider.cartData.numOfItems.toString(),
                          style: robotoRegular.copyWith(
                            color: ColorResources.white, 
                            fontSize: Dimensions.fontSizeSmall
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.shopping_cart, 
                            color: ColorResources.primaryOrange,
                          ),
                          onPressed: () {
                            NS.push(context, const CartProdukPage());
                          },
                        )
                      );
                    },
                  ),
                ]
              )
            ))),
          ];
        },
        body: getDataProductByCategory()
      )
    );
  }


  Widget getDataProductByCategory() {
    return Consumer<StoreProvider>(  
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if(storeProvider.allProductSellerByCategoryStatus == AllProductSellerByCategoryStatus.loading) {
          return loadingList();
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.primaryOrange,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              storeProvider.getAllProductByCategorySellerDetail(context, widget.categoryId, widget.storeId);
            }); 
          },
          child: Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, 
              ),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1 / 1.6
              ),
              itemCount: storeProvider.allProductSellerDetail.length,
              itemBuilder: (BuildContext context, int i) {
                return itemsData(context, storeProvider.allProductSellerDetail[i]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget loadingList() {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: GridView.builder(
        padding: const EdgeInsets.only(
          left: 16.0, right: 16.0
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 3 / 5.4,
        ),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200.0,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      ),
                      color: ColorResources.white
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: 150.0,
                    height: 15.0,
                    margin: const EdgeInsets.only(
                      left: 8.0, right: 8.0, 
                      bottom: 8.0
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorResources.white
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 15.0,
                    margin: const EdgeInsets.only(
                      left: 8.0, right: 8.0
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorResources.white
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget itemsData(BuildContext context, ProductStoreList productStoreList) {
    return SizedBox(
      width: 130.0,
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            NS.push(context, DetailProductPage(
              productId: productStoreList.id!,
              typeProduct: "commerce",
              path: "",
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(
                color: Colors.grey,
                width: 0.5
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 5 / 5,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                    ClipRRect(
                     borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)
                      ),
                      child: CachedNetworkImage(
                        imageUrl: "${AppConstants.baseUrlFeedImg}${productStoreList.pictures!.first.path}",
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: imageProvider
                              )
                            ),
                          );
                        },
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
                        errorWidget: (BuildContext context, String url, dynamic error) => Center(
                        child: Image.asset("assets/images/logo/saka.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )),
                      ),
                      ),
                      productStoreList.discount!= null
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 25,
                            width: 30,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                topLeft: Radius.circular(12)
                              ),
                              color: Colors.red[900]
                            ),
                            child: Center(
                              child: Text(productStoreList.discount!.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                style: robotoRegular.copyWith(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100.0,
                        child: Text(
                          productStoreList.name!,
                          overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                      ),
                      Text(Helper.formatCurrency(productStoreList.price!),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 20.0,
                            width: 20.0,
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: ColorResources.primaryOrange
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.store,
                                color: ColorResources.white, 
                                size: 15.0
                              )
                            )
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productStoreList.store!.name!,
                                  maxLines: 1,
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                    fontWeight: FontWeight.w600
                                  )
                                ),
                                Text(productStoreList.store!.city!,
                                  maxLines: 1,
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.primaryOrange,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: productStoreList.stats!.ratingAvg!,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 15.0,
                            direction: Axis.horizontal,
                          ),
                          Container(),
                          Container(
                            margin: const EdgeInsets.only(left: 4.0),
                            child: Text(productStoreList.stats!.ratingAvg.toString().substring(0, 3),
                            style: robotoRegular.copyWith(
                              color: ColorResources.primaryOrange,
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.w600,
                            )),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ), 
      ),
    );         
  }

}


class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 75;

  @override
  double get minExtent => 55;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}