import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:saka/views/screens/store/detail_product.dart';
import 'package:saka/views/screens/store/cart_product.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/box_shadow.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';

class SearchProductScreen extends StatefulWidget {
  final String typeProduct;

  const SearchProductScreen({
    Key? key,
    required this.typeProduct,
  }) : super(key: key);
  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  
  Future<void> getDataSearch(String text) async {
    await context.read<StoreProvider>().getDataSearchProduct(context, text, 0);
  }

  Future<void> getData() async {
    if(mounted) {
      await context.read<StoreProvider>().getCartInfo(context);
    }
  }
  
  Future<bool> onWillPop() {
    NS.pop(context);
    return Future.value(true);
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
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: ColorResources.backgroundColor,
        key: globalKey,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [

            const SliverAppBar(
              floating: true,
              elevation: 0,
              centerTitle: false,
              toolbarHeight: 10.0,
              automaticallyImplyLeading: false,
              backgroundColor: ColorResources.primaryOrange,
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
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 20.0,
                      color: ColorResources.primaryOrange,
                    ),
                    onPressed: onWillPop
                  ),
                  Expanded(
                    child: Container(
                      height: 55.0,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        boxShadow: boxShadow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.text,
                              cursorColor: ColorResources.primaryOrange,
                              style: robotoRegular.copyWith(
                                color: ColorResources.black
                              ),
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[200]!
                                  )
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[200]!
                                  )
                                )
                              ),
                              autofocus: true,
                              onSubmitted: (String val) {
                                getDataSearch(val);
                              },
                            ),
                          ),
                          const Icon(
                            Icons.search,
                            color: ColorResources.primaryOrange
                          ),
                        ], 
                      ),
                    ),
                  ),

                  Consumer<StoreProvider>(
                    builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                      return storeProvider.cartStatus == CartStatus.empty 
                      ? GestureDetector(
                          onTap: () {
                            NS.push(context, const CartProdukPage());
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20.0, right: 14.0),
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
                            color: ColorResources.primaryOrange 
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
                              fontSize: Dimensions.fontSizeDefault
                            ),
                          )
                        : Text(
                          storeProvider.cartData.numOfItems.toString(),
                          style: robotoRegular.copyWith(
                            color: ColorResources.white, 
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: ColorResources.primaryOrange 
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

            SliverFillRemaining(
              child: widgetDataSearch()
            )

          ],
        ) 
      ),
    );
  }

  Widget widgetDataSearch() {
    return context.watch<StoreProvider>().allProductSearch.isEmpty
    ? emptyTransaction() 
    : getDataProductByCategory();
  }

  Widget getDataProductByCategory() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        return GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, 
            bottom: 16.0, top: 8.0
          ),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 3 / 5,
          ),
          itemCount: storeProvider.allProductSearch.length,
          itemBuilder: (BuildContext context, int i) {
            return GestureDetector(
            onTap: () {
              NS.push(context, DetailProductPage(
                productId: storeProvider.allProductSearch[i].id!,
                typeProduct: widget.typeProduct,
                path: "",
              ));
            },
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 5 / 4.8,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0)
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                            child: CachedNetworkImage(
                              imageUrl: storeProvider.allProductSearch[i].pictures!.isEmpty
                              ? ""
                              : storeProvider.allProductSearch[i].pictures!.first.path!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
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
                              errorWidget: (context, url, error) => Center(
                                child: Image.asset("assets/images/logo/saka.png",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )),
                            ),
                          )),
                          storeProvider.allProductSearch[i].discount != null
                          ? Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 25,
                              width: 30,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(12),
                                  topLeft: Radius.circular(12)
                                ),
                                color: Colors.red[900]
                              ),
                              child: Center(
                                child: Text(storeProvider.allProductSearch[i].discount!.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.white,
                                    fontSize: Dimensions.fontSizeSmall,
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
                          child: Text(storeProvider.allProductSearch[i].name!,
                            overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ),
                        Text(Helper.formatCurrency(storeProvider.allProductSearch[i].price!),
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
                                child: Icon(Icons.store,
                                  color: ColorResources.white, 
                                  size: 15.0
                                )
                              )
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(storeProvider.allProductSearch[i].store!.name!,
                                    maxLines: 1,
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black,
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w600
                                    )
                                  ),
                                  Text(storeProvider.allProductSearch[i].store!.city!,
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
                              rating: storeProvider.allProductSearch[i].stats!.ratingAvg!,
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
                              child: Text(storeProvider.allProductSearch[i].stats!.ratingAvg.toString().substring(0, 3),
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
          );
          },
        );
      },
    ); 
  }

  Widget emptyTransaction() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text("Saat ini barang belum tersedia",
          textAlign: TextAlign.center,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: ColorResources.black
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