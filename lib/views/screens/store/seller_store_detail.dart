import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/data/models/store/product_single.dart';
import 'package:saka/providers/store/store.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/screens/store/seller_store_detail_by_category.dart';
import 'package:saka/views/screens/store/cart_product.dart';
import 'package:saka/views/screens/store/seller_store_detail_search.dart';
import 'package:saka/views/screens/store/detail_product.dart';

class SellerStoreDetail extends StatefulWidget {
  final ProductStoreSingle productStoreSingle;
  const SellerStoreDetail({ 
    required this.productStoreSingle,
    Key? key,
  }) : super(key: key);

  @override
  State<SellerStoreDetail> createState() => _SellerStoreDetailState();
}

class _SellerStoreDetailState extends State<SellerStoreDetail> with TickerProviderStateMixin {  
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late TabController tabC;

  int index = 0;

  Future<void> handleChanging() async {
    setState(() {
      index = tabC.index;
    });
    if(tabC.indexIsChanging) {
      if(index == 0) { 
        if(mounted) {
          await context.read<StoreProvider>().getAllCategorySellerDetail(context);
        }     
      }
      if(index == 1) {
        if(mounted) {
          await context.read<StoreProvider>().getAllProductSellerDetail(context, widget.productStoreSingle.store!.id!);
        }
      } 
    }
  }
  
  Future<void> getData() async {
    if(mounted) {
      await context.read<StoreProvider>().getAllCategorySellerDetail(context);
    }
    if(mounted) {
      await context.read<StoreProvider>().getAllProductSellerDetail(context, widget.productStoreSingle.store!.id!);
    }
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

    tabC = TabController(length: 2, vsync: this);
    tabC.addListener(handleChanging);

    getData();
  }

  @override 
  void dispose() {
    tabC.removeListener(handleChanging);
    tabC.dispose();

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
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return RefreshIndicator(
              backgroundColor: ColorResources.primaryOrange,
              color: ColorResources.white,
              onRefresh: () {
                return Future.sync(() {
                  context.read<StoreProvider>().getAllCategorySellerDetail(context);
                  context.read<StoreProvider>().getAllProductSellerDetail(context, widget.productStoreSingle.store!.id!);
                  context.read<StoreProvider>().getCartInfo(context);
                });
              },
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                
                    SliverAppBar(
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarBrightness: Brightness.light,
                        statusBarColor: ColorResources.primaryOrange
                      ),
                      elevation: 0.0,
                      toolbarHeight: 70.0,
                      backgroundColor: ColorResources.primaryOrange,
                      iconTheme: const IconThemeData(
                        color: ColorResources.white,
                      ),
                      leading: Container(
                        margin: const EdgeInsets.only(left: 16.0),
                        child: CupertinoNavigationBarBackButton(
                          color: ColorResources.white,
                          onPressed: onWillPop,
                        ),
                      ),
                      pinned: true,
                      floating: true,
                      titleSpacing: 0.0,
                      expandedHeight: 320.0,
                      title: GestureDetector(
                        onTap: () {
                          NS.push(context, SellerDetailSearchProductScreen(
                            typeProduct: "commerce",
                            storeId: widget.productStoreSingle.store!.id!,
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
                              Text("Cari Barang di Toko ${widget.productStoreSingle.store?.name}",
                                style: robotoRegular.copyWith(
                                  color: ColorResources.grey,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        Container(
                          margin: const EdgeInsets.only(
                            right: 16.0
                          ),
                          child: Consumer<StoreProvider>(
                            builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                              return storeProvider.cartStatus == CartStatus.empty 
                              ? GestureDetector(
                                  onTap: () {
                                    NS.push(context, const CartProdukPage());
                                  },
                                  child: const Center(
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: ColorResources.white 
                                    )
                                  ),
                                )
                              : storeProvider.cartStatus == CartStatus.error 
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.shopping_cart,
                                    color: ColorResources.white
                                  ),
                                  onPressed: () {
                                    NS.push(context,  const CartProdukPage());
                                  },
                                )
                              : badges.Badge(
                                position: badges.BadgePosition.topEnd(
                                  top: 12.0, 
                                  end: 16.0
                                ),
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
                                    color: ColorResources.white
                                  ),
                                  onPressed: () {
                                    NS.push(context,  const CartProdukPage());
                                  },
                                )
                              );
                            },
                          ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        centerTitle: true,
                        background: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: "${widget.productStoreSingle.store?.picture?.path}",
                              imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                return CircleAvatar(
                                  backgroundColor: ColorResources.white,
                                  maxRadius: 40.0,
                                  child: Container(
                                    width: 52.0,
                                    height: 52.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider
                                      )
                                    ),
                                  )
                                );
                              },
                              placeholder: (BuildContext context, String placeholder) {
                                return CircleAvatar(
                                  backgroundColor: ColorResources.white,
                                  maxRadius: 40.0,
                                  child: Container(
                                    width: 52.0,
                                    height: 52.0,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/logo/saka.png')
                                      )
                                    ),
                                  )
                                );  
                              },
                              errorWidget: (BuildContext context, String error, dynamic val) {
                                return CircleAvatar(
                                  backgroundColor: ColorResources.white,
                                  maxRadius: 40.0,
                                  child: Container(
                                    width: 52.0,
                                    height: 52.0,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/logo/saka.png')
                                      )
                                    ),
                                  )
                                ); 
                              },
                            ),
                            const SizedBox(height: 8.0),
                            Text("${widget.productStoreSingle.store!.name}",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w600,
                                color: ColorResources.white
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text("${widget.productStoreSingle.store!.city}",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey[300]
                              ),
                            )
                          ],
                        ),
                      ),
                      bottom: TabBar(
                        controller: tabC,
                        labelStyle: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault
                        ),
                        unselectedLabelStyle: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault
                        ),
                        labelColor: ColorResources.white,
                        indicatorColor: ColorResources.yellow,
                        tabs: [ 
                          Tab(
                            icon: const Icon(Icons.category), 
                            child: Text("Daftar Barang",
                              style: robotoRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                          Tab(
                            icon: const Icon(Icons.list), 
                            child: Text("Semua Barang",
                              style: robotoRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ];
                }, 
                body: Consumer<StoreProvider>(
                  builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                    return TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabC,  
                      children: [
                        listStuffSeller(storeProvider),
                        allStuffSeller(storeProvider),
                      ],
                    );
                  },
                )
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listStuffSeller(StoreProvider storeProvider) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          if(storeProvider.allCategorySellerDetailStatus == AllCategorySellerDetailStatus.loading)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 6,
                padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0
                ),
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    margin: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[300]!,
                      child: Container(
                        height: 70.0,
                        decoration: const BoxDecoration(
                          color: ColorResources.white
                        ),
                      ), 
                    ),
                  );
                }
              )
            ),

          if(storeProvider.allCategorySellerDetailStatus == AllCategorySellerDetailStatus.empty)
            Expanded(
              child: Center(
                child: Text("Belum ada Kategori",
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault
                  ),
                ),
              )
            ),

          if(storeProvider.allCategorySellerDetailStatus == AllCategorySellerDetailStatus.error)
            Expanded(
              child: Center(
                child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault
                  ),
                ),
              )
            ),

          if(storeProvider.allCategorySellerDetailStatus == AllCategorySellerDetailStatus.loaded)
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: storeProvider.allCategorySellerDetail.length,
                padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0
                ),
                separatorBuilder: (BuildContext context, int i) {
                  return Divider(
                    height: 2.0,
                    color: Colors.grey[300],
                  );
                }, 
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Material(
                      color: ColorResources.transparent,
                      child: InkWell(
                        onTap: () {
                          NS.push(context, SellerStoreDetailByCategory(
                            categoryId: storeProvider.allCategorySellerDetail[i].id!,
                            productType: storeProvider.allCategorySellerDetail[i].name!,
                            storeId: widget.productStoreSingle.store!.id!,
                            storeName: widget.productStoreSingle.store!.name!,
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(storeProvider.allCategorySellerDetail[i].name!,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    )
                  );
                }
              ),
            )

        ],
      ),
    );
  }

  Widget allStuffSeller(StoreProvider storeProvider) {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.only(top: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          if(storeProvider.allProductSellerDetailStatus == AllProductSellerDetailStatus.loading)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, 
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 3 / 5.4,
                ),
                physics: const NeverScrollableScrollPhysics(),
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
            ),

            if(storeProvider.allProductSellerDetailStatus == AllProductSellerDetailStatus.empty)
              Expanded(
                child: Center(
                  child: Text("Belum ada barang",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  ),
                )
              ),

            if(storeProvider.allProductSellerDetailStatus == AllProductSellerDetailStatus.error)
              Expanded(
                child: Center(
                  child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  ),
                )
              ),

            if(storeProvider.allProductSellerDetailStatus == AllProductSellerDetailStatus.loaded)
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: ColorResources.primaryOrange,
                  color: ColorResources.white,
                  onRefresh: () {
                    return Future.sync(() {
                      storeProvider.getAllProductSellerDetail(context, widget.productStoreSingle.store!.id!);
                    });
                  },
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
                      return SizedBox(
                        width: 130.0,
                        child: Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)
                          ),
                          child: InkWell(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0)
                            ),
                            onTap: () {
                              NS.push(context, DetailProductPage(
                                productId: storeProvider.allProductSellerDetail[i].id!,
                                typeProduct: "commerce",
                                path: "",
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15.0)
                                ),
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
                                            imageUrl: "${storeProvider.allProductSellerDetail[i].pictures!.first.path}",
                                            imageBuilder: (BuildContext context, ImageProvider<Object>  imageProvider) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: imageProvider
                                                  )
                                                ),
                                              );
                                            },
                                            placeholder: (BuildContext context, String url) {
                                              return Center(
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor: Colors.grey[100]!,
                                                  child: Container(
                                                    color: ColorResources.white,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                )
                                              );
                                            },
                                            errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                            child: Image.asset("assets/images/logo/saka.png",
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            )),
                                          ),
                                        ),
                                        storeProvider.allProductSellerDetail[i].discount!= null
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
                                                child: Text(storeProvider.allProductSellerDetail[i].discount!.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
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
                                            storeProvider.allProductSellerDetail[i].name!,
                                            overflow: TextOverflow.ellipsis,
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                            ),
                                          ),
                                        ),
                                        Text(Helper.formatCurrency(storeProvider.allProductSellerDetail[i].price!),
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
                                                  Text(storeProvider.allProductSellerDetail[i].store!.name!,
                                                    maxLines: 1,
                                                    style: robotoRegular.copyWith(
                                                      color: ColorResources.black,
                                                      fontSize: Dimensions.fontSizeSmall,
                                                      fontWeight: FontWeight.w600
                                                    )
                                                  ),
                                                  Text(storeProvider.allProductSellerDetail[i].store!.city!,
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
                                              rating: storeProvider.allProductSellerDetail[i].stats!.ratingAvg!,
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
                                              child: Text(storeProvider.allProductSellerDetail[i].stats!.ratingAvg.toString().substring(0, 3),
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
                    },
                  ),
                ),
              )
          ],
        ),
    );
    }
}