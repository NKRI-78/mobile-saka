import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/data/models/store/product_store.dart';

import 'package:saka/views/basewidgets/search/search.dart';
import 'package:saka/views/screens/store/detail_product.dart';
import 'package:saka/views/screens/store/cart_product.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/providers/store/store.dart';

class ProductPage extends StatefulWidget {
  final String? idCategory;
  final String? nameCategory;
  final String? typeProduct;
  final String? path;

  const ProductPage({
    Key? key,
    required this.idCategory,
    required this.nameCategory,
    required this.typeProduct,
    required this.path,
  }) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  
  late ScrollController scrollC;
  
  late String idCategory;

  Future<void> getData() async {
    if(mounted) {
      await context.read<StoreProvider>().getDataCategoryProductByParent(context, widget.typeProduct!);
    }
    if(mounted) {
      await context.read<StoreProvider>().getDataProductByCategoryConsumen(context, "", idCategory);
    }
  }

  @override
  void initState() {
    super.initState();

    idCategory = widget.idCategory!;
    
    scrollC = ScrollController();
    scrollC.addListener(() {
      if (scrollC.position.pixels == scrollC.position.maxScrollExtent) {
        context.read<StoreProvider>().getDataProductByCategoryConsumenLoad(context, "", idCategory);
      }
    });

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
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.backgroundColor,
      body: NestedScrollView(
        controller: scrollC,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
  
            SliverAppBar(
              backgroundColor: ColorResources.white,
              leading: CupertinoNavigationBarBackButton(
                color: ColorResources.primaryOrange,
                onPressed: () {
                  NS.pop(context);
                },
              ),
              title: Text("Barang - ${widget.nameCategory}",
                style: robotoRegular.copyWith(
                  color: ColorResources.primaryOrange,
                  fontWeight: FontWeight.w600
                ),
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
                  const Expanded(
                    child: SearchWidget(
                      hintText: "Cari Barang",
                      type: "commerce",
                    )
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
                        : Text(storeProvider.cartData.numOfItems.toString(),
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

            SliverToBoxAdapter(
              child: getCategoryParent(),
            ),
          
          ];
        },
        body: getDataProductByCategory(),
      ) 
    );
  }

  Widget getCategoryParent() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if(storeProvider.categoryProductByParentStatus == CategoryProductByParentStatus.loading) {
          return Container(
            height: 45.0,
            margin: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    width: 100.0,
                    height: 45.0,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0), 
                      color: ColorResources.white
                    ),
                  );
                },
              ),
            ),
          );
        }
        if(storeProvider.categoryProductByParentStatus == CategoryProductByParentStatus.empty) {
          return Container();
        }
        return Container(
          height: 50.0,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          child: ListView.builder(
            itemCount: storeProvider.categoryProductByParentList.length + 1,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int i) {
              if(i == 0) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      idCategory = widget.idCategory!;
                    });
                    Provider.of<StoreProvider>(context, listen: false).getDataProductByCategoryConsumen(context, "", idCategory);
                  },
                child: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: idCategory == widget.idCategory ? ColorResources.primaryOrange : ColorResources.white,
                    border: Border.all(
                      color: ColorResources.primaryOrange,
                      width: 1.0
                    )
                  ),
                  child: Center(
                    child: Text(widget.nameCategory!,
                  style: robotoRegular.copyWith(
                    color: idCategory == widget.idCategory ? ColorResources.white : ColorResources.primaryOrange,
                    fontSize: Dimensions.fontSizeDefault,
                  )))),
                );
              }
              return InkWell(
                onTap: () {
                  setState(() {
                    idCategory = storeProvider.categoryProductByParentList[i-1].id!;
                  });
                  Provider.of<StoreProvider>(context, listen: false).getDataProductByCategoryConsumen(context, "", idCategory);
                },
                child: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: idCategory == storeProvider.categoryProductByParentList[i-1].id ? ColorResources.primaryOrange : ColorResources.white,
                    border: Border.all(
                      color: ColorResources.primaryOrange,
                      width: 1.0
                    )
                  ),
                  child: Center(
                    child: Text(storeProvider.categoryProductByParentList[i-1].name!,
                  style: robotoRegular.copyWith(
                    color: idCategory == storeProvider.categoryProductByParentList[i-1].id ? ColorResources.white : ColorResources.primaryOrange,
                    fontSize: Dimensions.fontSizeDefault,
                  )
                ))),
              );
            },
          ),
        );
      },
    );
  }

  Widget getDataProductByCategory() {
    return Consumer<StoreProvider>(  
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if(storeProvider.categoryProductByCategoryConsumenStatus == CategoryProductByCategoryConsumenStatus.loading) {
          return loadingList();
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.primaryOrange,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              storeProvider.getDataProductByCategoryConsumen(context, "", idCategory);
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
              itemCount: storeProvider.productStoreConsumenList.length,
              itemBuilder: (BuildContext context, int i) {
                if (i == storeProvider.productStoreConsumenList.length) {
                  return Container();
                } else {
                  return itemsData(context, storeProvider.productStoreConsumenList[i]);
                }
              },
            ),
          ),
        );
      },
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
                                  fit: BoxFit.cover,
                                  image: imageProvider
                                )
                              ),
                            );
                          },
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
                            height: 25.0,
                            width: 30.0,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0)
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
        itemBuilder: (BuildContext context, int i) {
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