import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/data/models/store/product_store.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/views/basewidgets/search/search.dart';

import 'package:saka/views/screens/store/detail_product.dart';
import 'package:saka/views/screens/store/product.dart';
import 'package:saka/views/screens/store/buyer_transaction_order.dart';
import 'package:saka/views/screens/store/cart_product.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin { 
  GlobalKey<ScaffoldState> globalKey = GlobalKey();

  late ScrollController scrollC;

  bool sliverPersistentHeader = false;
  
  void shrinkNavListener() {
    if (isShrink != sliverPersistentHeader) {    
      setState(() => sliverPersistentHeader = isShrink);
    }
  }

  bool get isShrink {
    return scrollC.hasClients && scrollC.offset > kToolbarHeight;
  }
  
  Future<void> getData() async {
    if(mounted) {
      context.read<StoreProvider>().getDataStore(context);
    }
    if(mounted) {
      context.read<StoreProvider>().getDataCategoryProduct(context, "commerce");
    }
    if(mounted) {
      context.read<StoreProvider>().getCartInfo(context);
    }
  }

  Future<bool> onWillPop() {
    NS.pop(context);
    return Future.value(true);
  }

  @override 
  void initState() {
    super.initState();
    
    scrollC = ScrollController();

    getData();  
  }

  @override 
  void dispose() {
    scrollC.dispose();

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
        body: Stack(
          clipBehavior: Clip.none,
          children: [

            RefreshIndicator(
              backgroundColor: ColorResources.white,
              color: ColorResources.primaryOrange,
              onRefresh: () {
                return Future.sync(() {
                  context.read<StoreProvider>().getDataCategoryProduct(context, "commerce");
                  context.read<StoreProvider>().setStateCategoryProductStatus(CategoryProductStatus.refetch);
                  context.read<StoreProvider>().getDataStore(context);
                  context.read<StoreProvider>().getCartInfo(context);
                });        
              },
              child: Consumer<StoreProvider>(
                builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                  return CustomScrollView(
                    controller: scrollC,
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [

                      SliverAppBar(
                        backgroundColor: ColorResources.primaryOrange,
                        centerTitle: true,
                        title: Text(getTranslated("SAKA_MART", context),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600, 
                            color: ColorResources.white
                          ),
                        ),
                        leading: CupertinoNavigationBarBackButton(
                          color: ColorResources.white,
                          onPressed: () {
                            NS.pop(context);
                          },
                        )
                      ),

                      SliverPersistentHeader(
                        pinned: true,               
                        delegate: SliverDelegate(
                          child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall, 
                            vertical: isShrink ? 2.0 : 0.0 
                          ),
                          color: ColorResources.white,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Expanded(
                                child: SearchWidget(
                                  hintText: "Cari Barang",
                                  type: "commerce",
                                )
                              ),
                              InkWell(
                                onTap: () {
                                  NS.push(context, const TransactionOrderScreen(
                                    index: 0,
                                  ));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20.0),
                                  child: const Icon(
                                    Icons.list,
                                    color: ColorResources.primaryOrange,
                                  )
                                ),
                              ),
                              storeProvider.cartStatus == CartStatus.empty 
                              ? GestureDetector(
                                  onTap: () {
                                    NS.push(context, const CartProdukPage());
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0, 
                                      right: 15.0
                                    ),
                                    child: const Icon(
                                      Icons.shopping_cart,
                                      color: ColorResources.primaryOrange,
                                    )
                                  ),
                                ) 
                              : storeProvider.cartStatus == CartStatus.error ? 
                                IconButton(
                                  icon: const Icon(
                                    Icons.shopping_cart,
                                    color: ColorResources.primaryOrange
                                  ),
                                  onPressed: () {
                                    NS.push(context,  const CartProdukPage());
                                  }
                                ) 
                              : badges.Badge(
                                  position: badges.BadgePosition.topEnd(top: -2.0, end: 16.0),
                                  badgeAnimation: badges.BadgeAnimation.slide(
                                    animationDuration: Duration(milliseconds: 300)
                                  ),
                                  badgeContent: Text(
                                    storeProvider.cartStatus == CartStatus.loading 
                                    ? "..." 
                                    : storeProvider.cartData.numOfItems.toString(),
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.white,
                                      fontSize: Dimensions.fontSizeSmall
                                    ),
                                  ),
                                  child: IconButton(
                                  icon: const Icon(
                                    Icons.shopping_cart,
                                    color: ColorResources.primaryOrange
                                  ),
                                  onPressed: () {
                                    NS.push(context,  const CartProdukPage());
                                  }
                                )
                              ),
                            ]
                          )
                        )
                      )
                    ),

                    if(storeProvider.categoryProductStatus == CategoryProductStatus.loading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: SpinKitThreeBounce(
                            size: 20.0,
                            color: ColorResources.primaryOrange,
                          ),
                        )
                      ),
                    
                    if(storeProvider.categoryProductStatus == CategoryProductStatus.error)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.black
                            ),
                          )
                        )
                      ),

                    if(storeProvider.categoryProductStatus == CategoryProductStatus.empty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(getTranslated("THERE_IS_NO_PRODUCT", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.black
                            ),
                          )
                        )
                      ),

                    if(storeProvider.categoryProductStatus == CategoryProductStatus.loaded)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: getDataCategory(context),
                        ),
                      ), 
                      
                  ],
                );
              },
            )
          ),
        ]
      ),
    )    
  );
  }

  Widget getDataCategory(BuildContext context) {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        
        return ListView.builder(
          shrinkWrap: true,
          itemCount: storeProvider.categoryHasManyProduct.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int i) {
            List<ProductStoreList> categoryHasManyProduct = storeProvider.categoryHasManyProduct[i]["items"];
            return Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(storeProvider.categoryHasManyProduct[i]["category"],
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  if(categoryHasManyProduct.isEmpty)
                    Container(
                      width: double.infinity,
                      height: 250.0,
                      alignment: Alignment.center,
                      child: Text(getTranslated("THERE_IS_NO_PRODUCT", context),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black
                        )
                      ),
                    ),
                  if(categoryHasManyProduct.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 260.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categoryHasManyProduct.take(6).length,
                        itemBuilder: (BuildContext context, int z) {
                          if(z == 5) {
                            return SizedBox(
                              width: 130.0,
                              child: Card(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)
                                  ),
                                  onTap: () {
                                    NS.push(context, ProductPage(
                                      idCategory: storeProvider.categoryHasManyProduct[i]['id'],
                                      nameCategory: storeProvider.categoryHasManyProduct[i]['category'],
                                      typeProduct: "commerce",
                                      path: ""
                                    )) ;              
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.5
                                      )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Lihat semua",
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.primaryOrange
                                          ),
                                        ),
                                        Text("...",
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.primaryOrange
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ), 
                              ),
                            );      
                          }
                          return SizedBox(
                            width: 130.0,
                            child: Card(
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                              child: InkWell(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                onTap: () {
                                  NS.push(context, DetailProductPage(
                                    productId: categoryHasManyProduct[z].id!,
                                    typeProduct: "commerce",
                                    path: "",
                                    count: 1,
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.5
                                    )
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 5 / 5,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0)
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: "${categoryHasManyProduct[z].pictures!.first.path}",
                                                imageBuilder: (context, imageProvider) {
                                                  return Container(
                                                    height: 100.0,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
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
                                            categoryHasManyProduct[z].discount != null
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
                                                    child: Text(categoryHasManyProduct[z].discount!.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
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
                                                categoryHasManyProduct[z].name!,
                                                overflow: TextOverflow.ellipsis,
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeDefault,
                                                ),
                                              ),
                                            ),
                                            Text(Helper.formatCurrency(categoryHasManyProduct[z].price!),
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeDefault,
                                                fontWeight: FontWeight.w600,
                                              )
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  padding: const EdgeInsets.all(2.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(40.0),
                                                    color: ColorResources.primaryOrange
                                                  ),
                                                  child: const Center(
                                                    child: Icon(Icons.store,
                                                      color: ColorResources.white, size: 15
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
                                                      Text(categoryHasManyProduct[z].store!.name!,
                                                      maxLines: 1,
                                                      style: robotoRegular.copyWith(
                                                          color: ColorResources.black,
                                                          fontSize: Dimensions.fontSizeDefault,
                                                          fontWeight: FontWeight.w600
                                                        )
                                                      ),
                                                      Text(categoryHasManyProduct[z].store!.city!,
                                                        maxLines: 1,
                                                        style: robotoRegular.copyWith(
                                                          color: ColorResources.primaryOrange,
                                                          fontSize: Dimensions.fontSizeDefault,
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
                                                  rating: categoryHasManyProduct[z].stats!.ratingAvg!,
                                                  itemBuilder: (BuildContext context, int index) => const Icon(
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
                                                  child: Text(categoryHasManyProduct[z].stats!.ratingAvg.toString().substring(0, 3),
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeDefault,
                                                    color: ColorResources.primaryOrange,
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
                      ),
                    )
                ],
              ),
            );
          }
        );
          
                       
      }
    );

  }  
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({
    required this.child
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 75.0;

  @override
  double get minExtent => 55.0;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50.0 || oldDelegate.minExtent != 50.0 || child != oldDelegate.child;
  }
}