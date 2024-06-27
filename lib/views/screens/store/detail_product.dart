

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:saka/utils/extension.dart';
import 'package:shimmer/shimmer.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/data/models/store/product_single.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';
 
import 'package:saka/views/screens/comingsoon/comingsoon.dart';
import 'package:saka/views/screens/store/seller_store.dart';
import 'package:saka/views/screens/store/seller_store_detail.dart';
import 'package:saka/views/screens/store/product.dart';
import 'package:saka/views/screens/store/cart_product.dart';
import 'package:saka/views/screens/store/search_product.dart';
import 'package:saka/views/screens/store/seller_edit_product.dart';

//ignore: must_be_immutable
class DetailProductPage extends StatefulWidget {
  final String productId;
  final String typeProduct;
  final String path;
  int count = 1;

  DetailProductPage({
    Key? key,
    required this.productId,
    required this.typeProduct,
    required this.path,
    this.count = 1,
  }) : super(key: key);
  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late ExpandableController ec;
  late ExpandableController ecSupportCouriers;

  int current = 0;

  Future<void> getData() async {
    if(mounted) {
      context.read<StoreProvider>().getDataStore(context);
    }
    if(mounted) {
      context.read<StoreProvider>().getDataSingleProduct(context, widget.productId, widget.path, widget.typeProduct);
    }
    if(mounted) {  
      context.read<StoreProvider>().getReviewProductDetail(context, productId: widget.productId);
    }
    if(mounted) {  
      context.read<StoreProvider>().getCartInfo(context);
    }
  }

  Future<bool> onWillPop() {
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == widget.count;
    });
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();

    ec = ExpandableController(initialExpanded: false);
    ecSupportCouriers = ExpandableController(initialExpanded: false);

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
        key: scaffoldKey,
        backgroundColor: ColorResources.backgroundColor,
        body: context.watch<StoreProvider>().sellerStoreStatus == SellerStoreStatus.loading
        ? loadingDetailPage() 
        : context.watch<StoreProvider>().singleProductStatus == SingleProductStatus.loading 
        ? loadingDetailPage()
        : detailProduct(),
      ),
    );
  }

  Widget detailProduct() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {

        return Stack(
          clipBehavior: Clip.none,
          children: [
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [

                SliverAppBar(
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
                  floating: false,
                  titleSpacing: 0.0,
                  title: searchCard(),
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
                              end: 20.0
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
                ),

                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 450.0,
                      child: getImages(storeProvider.productSingleStoreModel)
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0,
                        bottom: 10.0, top: 16.0
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              bottom: .05
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Helper.formatCurrency(storeProvider.productSingleStoreModel.body!.price!),
                                  textAlign: TextAlign.start,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeOverLarge + 3.0, 
                                    fontWeight: FontWeight.w600
                                  )
                                ),
                                const Icon(
                                  Icons.favorite_outline,
                                  size: 40.0,
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                              bottom: .05
                            ),
                            child: Text(storeProvider.productSingleStoreModel.body!.name!,
                              textAlign: TextAlign.start,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraLarge + 3.0
                              )
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0
                            ),
                            child: GestureDetector(
                              onTap: storeProvider.rpdm.data!.isEmpty 
                              ? () {}
                              : () {
                                showModalBottomSheet(
                                  context: context, 
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.96,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 20.0,
                                              left: 16.0, 
                                              right: 16.0
                                            ),
                                            child: Text("Ulasan Pembeli",
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeLarge,
                                                fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.separated(
                                              separatorBuilder: (BuildContext context, int i) {
                                                return const Divider();
                                              },
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.only(
                                                top: 30.0,
                                                left: 16.0, right: 16.0
                                              ),
                                              itemCount: storeProvider.rpdm.data!.length,
                                              itemBuilder: (BuildContext context, int i) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(storeProvider.rpdm.data![i].user!.fullname!,
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeDefault,
                                                            fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                        RatingBarIndicator(
                                                          rating: storeProvider.rpdm.data![i].star,
                                                          itemBuilder: (BuildContext context, int i) => const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          itemCount: 5,
                                                          itemPadding: EdgeInsets.zero,
                                                          itemSize: 15.0,
                                                          direction: Axis.horizontal,
                                                        ),
                                                        const SizedBox(height: 5.0),
                                                        Text(storeProvider.rpdm.data![i].review!.isEmpty 
                                                          ? "-" 
                                                          : storeProvider.rpdm.data![i].review!,
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeDefault,
                                                            fontWeight: FontWeight.w300
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8.0),
                                                        SizedBox(
                                                          height: 80.0,
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            padding: EdgeInsets.zero,
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: storeProvider.rpdm.data![i].photos!.length,
                                                            itemBuilder: (BuildContext context, int z) {
                                                              return Container(
                                                                margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                  child: CachedNetworkImage(
                                                                    imageUrl: "${storeProvider.rpdm.data![i].photos![z].path}",
                                                                    imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                                                                      return Container(
                                                                        width: 80.0,
                                                                        height: 80.0,
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                            color: Colors.grey,
                                                                            width: 1.0
                                                                          ),
                                                                          image: DecorationImage(
                                                                            image: imageProvider,
                                                                            fit: BoxFit.fitHeight
                                                                          ),
                                                                        ),
                                                                      ); 
                                                                    },
                                                                    placeholder: (BuildContext context, String placeholder) {
                                                                      return Container(
                                                                        width: 80.0,
                                                                        height: 80.0,
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                            color: Colors.grey,
                                                                            width: 1.0
                                                                          )
                                                                        ),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                          child: Image.asset("assets/images/logo/saka.png",
                                                                            fit: BoxFit.fitHeight,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    errorWidget: (BuildContext context, String val, dynamic _) {
                                                                      return Container(
                                                                        width: 80.0,
                                                                        height: 80.0,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                          border: Border.all(
                                                                            color: Colors.grey,
                                                                            width: 1.0
                                                                          )
                                                                        ),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                          child: Image.asset("assets/images/logo/saka.png",
                                                                            fit: BoxFit.fitHeight,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      ],  
                                                    ),
                                                  ],
                                                );
                                              }
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  RatingBarIndicator(
                                    rating: storeProvider.productSingleStoreModel.body!.stats!.ratingAvg!,
                                    itemBuilder: (BuildContext context, int i) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.only(left: 2.0, right: 2.0),
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 8.0, right: 15.0),
                                    child: Text(storeProvider.productSingleStoreModel.body!.stats!.ratingAvg!.toString().substring(0, 3),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        fontWeight: FontWeight.w600,
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 4.0,
                      color: Colors.grey[350],
                    ),
                    ExpandablePanel(
                      controller: ec,
                      theme: const ExpandableThemeData(
                        alignment: Alignment.center,
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        useInkWell: false,
                        hasIcon: false,
                      ),
                      header: GestureDetector(
                        onTap: () {
                          setState(() {
                            ec.toggle();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 5.0, bottom: 5.0, 
                            right: 25.0, left: 25.0, 
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Detail Barang",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraLarge,
                                  color: ColorResources.black,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Icon(
                                ec.expanded ? 
                                Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                                color: ColorResources.black,
                              )
                            ],
                          )
                        ),
                      ),
                      collapsed: Container(),
                      expanded: Container(
                        margin: const EdgeInsets.only(
                          left: 25.0, 
                          right: 25.0
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Kategori",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black.withOpacity(0.48), 
                                      fontSize: Dimensions.fontSizeDefault
                                    )
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      NS.push(context, ProductPage(
                                        idCategory: storeProvider.productSingleStoreModel.body!.category!.id,
                                        nameCategory: storeProvider.productSingleStoreModel.body!.category!.name,
                                        typeProduct: widget.typeProduct,
                                        path: widget.path
                                      ));
                                    },
                                    child: Text(
                                      storeProvider.productSingleStoreModel.body!.category!.name!,
                                      style: robotoRegular.copyWith(  
                                        color: ColorResources.black,                           
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w600,
                                      )
                                    ),
                                  ),
                                )
                              ]
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.grey[350],
                            ),
                            const SizedBox(height: 2.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(storeProvider.productSingleStoreModel.body!.stock! < 1 ? "Stok Habis" : "Stok",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black.withOpacity(0.48), 
                                      fontSize: Dimensions.fontSizeDefault
                                    )
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(storeProvider.productSingleStoreModel.body!.stock!.toString(),
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.fontSizeDefault
                                    )
                                  ),
                                )
                              ]
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.grey[350],
                            ),
                            const SizedBox(height: 2.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Berat",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black.withOpacity(0.48),
                                      fontSize: Dimensions.fontSizeDefault
                                    )
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(storeProvider.productSingleStoreModel.body!.weight.toString() + " gr",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.fontSizeDefault
                                    )
                                  ),
                                )
                              ]
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.grey[350],
                            ),
                            const SizedBox(height: 2.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Kondisi",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black.withOpacity(0.48), 
                                      fontSize: Dimensions.fontSizeDefault
                                    )
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    storeProvider.productSingleStoreModel.body!.condition == "NEW"
                                    ? "Baru"
                                    : "Bekas",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.fontSizeDefault
                                    )
                                  ),
                                )
                              ]
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.grey[350],
                            ),
                            const SizedBox(height: 2.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Minimal Pemesanan",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black.withOpacity(0.48), 
                                      fontSize: Dimensions.fontSizeDefault
                                    )
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(storeProvider.productSingleStoreModel.body!.minOrder.toString() + " Buah",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.fontSizeDefault
                                    )
                                  ),
                                )
                              ]
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.grey[350],
                            ),
                            const SizedBox(height: 2.0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        bottom: 5.0
                      ),
                      child: Text("Deskripsi Barang",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: ColorResources.black,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        bottom: 5.0
                      ),
                      child: storeProvider.productSingleStoreModel.body!.description!.length > 90
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(storeProvider.productSingleStoreModel.body!.description!.substring(0, 90) + "...",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            GestureDetector(
                              onTap: () {
                                modalDeskripsi(storeProvider.productSingleStoreModel);
                              },
                              child: Text("Baca Selengkapnya",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault, 
                                  color: ColorResources.primaryOrange
                                ),
                              ),
                            )
                          ],
                        )
                      : Text(storeProvider.productSingleStoreModel.body!.description!,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 4.0,
                      color: Colors.grey[350],
                    ),
                    const SizedBox(height: 5.0),
                    GestureDetector(
                      onTap: () {
                        if(storeProvider.productSingleStoreModel.body!.store!.id! == storeProvider.sellerStoreModel.body?.id) {
                          NS.push(context, const SellerStoreScreen());
                        } else {
                          NS.push(context, SellerStoreDetail(
                            productStoreSingle: storeProvider.productSingleStoreModel.body!,
                          ));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 16.0, bottom: 16.0,
                          left: 25.0, right: 25.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(55.0)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(55.0),
                                child: CachedNetworkImage(
                                  imageUrl: "${storeProvider.productSingleStoreModel.body?.store?.picture?.path}",
                                  fit: BoxFit.cover,
                                  placeholder: (BuildContext context, String url) => Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/logo/saka.png'),
                                        fit: BoxFit.cover
                                      )
                                    ),
                                  ),
                                  errorWidget: (BuildContext context, String url, dynamic error) => Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/logo/saka.png'),
                                        fit: BoxFit.cover
                                      )
                                    ),
                                  ),
                                ),
                              )
                            ),
                            const SizedBox(width: 15.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(storeProvider.productSingleStoreModel.body!.store!.name!.toTitleCase(),
                                      style: robotoRegular.copyWith(
                                        color: ColorResources.black,
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w600
                                      )
                                    ),
                                    storeProvider.productSingleStoreModel.body!.store!.open! 
                                    ? const SizedBox.shrink()
                                    : Container(
                                      decoration: BoxDecoration(
                                        color: ColorResources.error,
                                        borderRadius: BorderRadius.circular(10.0)
                                      ),
                                      padding: const EdgeInsets.all(5.0),
                                      margin: const EdgeInsets.only(left: 10.0),
                                      child: Text("Toko Tutup",
                                        style: robotoRegular.copyWith(
                                          color: ColorResources.white,
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w600
                                        )
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Text(storeProvider.productSingleStoreModel.body!.store!.city!,
                                  style: robotoRegular.copyWith(
                                    color: Colors.grey[600], 
                                    fontSize: Dimensions.fontSizeDefault
                                  )
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Divider(
                      thickness: 4.0,
                      color: Colors.grey[350],
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 12.0, bottom: 12.0,
                        left: 25.0, right: 25.0
                      ),
                      child:  ExpandablePanel(
                      controller: ecSupportCouriers,
                      theme: const ExpandableThemeData(
                        alignment: Alignment.center,
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        useInkWell: false,
                        hasIcon: false,
                      ),
                      header: GestureDetector(
                        onTap: () {
                          setState(() {
                            ecSupportCouriers.toggle();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 5.0, bottom: 5.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Dukungan Kurir",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: ColorResources.black,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Icon(
                                ecSupportCouriers.expanded ? 
                                Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                                color: ColorResources.black,
                              )
                            ],
                          )
                        ),
                      ),
                      collapsed: Container(),
                        expanded: Container(
                          decoration: const BoxDecoration(
                            color: ColorResources.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)
                            )
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: storeProvider.productSingleStoreModel.body!.store!.supportedCouriers!.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                    //   CachedNetworkImage(
                                    //     imageUrl: "${AppConstants.baseUrlFeedImg}${storeProvider.productSingleStoreModel.body!.store!.supportedCouriers![i].image!}",
                                    //     fit: BoxFit.contain,
                                    //     width: double.infinity,
                                    //     placeholder: (BuildContext context, String url) => Center(
                                    //       child: Shimmer.fromColors(
                                    //         baseColor: Colors.grey[200]!,
                                    //         highlightColor: Colors.grey[100]!,
                                    //         child: Container(
                                    //           color: ColorResources.white,
                                    //           width: double.infinity,
                                    //         ),
                                    //       )
                                    //     ),
                                    //     errorWidget: (BuildContext context, String url,  dynamic error) {
                                    //       return Center(
                                    //         child: Image.asset("assets/images/logo/saka.png",
                                    //         fit: BoxFit.cover,
                                    //       )
                                    //     );
                                    //   }
                                    // ),
                                    storeProvider.productSingleStoreModel.body!.store!.supportedCouriers![i].name! == "AnterAja" 
                                    ? Center(
                                        child: Image.asset("assets/images/icons/couriers/anter-aja.png",
                                          width: 60.0,
                                          fit: BoxFit.fill,
                                        )
                                      )
                                    : storeProvider.productSingleStoreModel.body!.store!.supportedCouriers![i].name! == "JNE" 
                                    ? Center(
                                        child: Image.asset("assets/images/icons/couriers/jne.png",
                                          width: 60.0,
                                          fit: BoxFit.fill,
                                        )
                                      )
                                    : storeProvider.productSingleStoreModel.body!.store!.supportedCouriers![i].name! == "Ninja Xpress (NINJA)"  
                                    ? Center(
                                        child: Image.asset("assets/images/icons/couriers/ninja-express.png",
                                          width: 60.0,      
                                          fit: BoxFit.fill,
                                        )
                                      )
                                    : Center(
                                        child: Image.asset("assets/images/logo/saka.png",
                                        fit: BoxFit.cover,
                                      )
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10.0),
                                      child: Text(storeProvider.productSingleStoreModel.body!.store!.supportedCouriers![i].name!,
                                        style: robotoRegular.copyWith(
                                          color: ColorResources.black,
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w600
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ),
                                  ],
                                )
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider(
                                thickness: 1.0,
                              );
                            },
                          )
                          )
                      )
                      ),
                    ),
                    Divider(
                      thickness: 15.0,
                      color: Colors.grey[100],
                    ),
                  ]
                )
              ),
              getAdapter(storeProvider),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 80.0,
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorResources.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5.0,
                    blurRadius: 7.0,
                    offset: const Offset(0, 4.0),
                  ),
                ],
              ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NS.push(context, const ComingSoonScreen(title: "Chats"));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 50.0,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 5.0,
                          children: [
                            const Icon(
                              Icons.chat,
                              size: 25.0,
                            ),
                            Text("Chat",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 1.0,
                      color: ColorResources.grey,
                    ),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 15.0,
                        children: [
                          // if(storeProvider.productSingleStoreModel.body!.store!.id! != storeProvider.sellerStoreModel.body?.id)
                          //   SizedBox(
                          //     width: 170.0,
                          //     child: CustomButton(
                          //       key: const Key('Beli Sekarang'),
                          //       isBoxShadow: false,
                          //       isBorder: false,
                          //       isBorderRadius: true,
                          //       sizeBorderRadius: 20.0,
                          //       btnColor: storeProvider.productSingleStoreModel.body!.store!.open! 
                          //       ? storeProvider.productSingleStoreModel.body!.stock! < 1  
                          //       ? ColorResources.hintColor
                          //       : ColorResources.success 
                          //       : Colors.grey[350]!,
                          //       onTap: storeProvider.productSingleStoreModel.body!.store!.open! 
                          //       ? storeProvider.productSingleStoreModel.body!.stock! < 1 
                          //       ? () {} 
                          //       : () async {
                          //         await storeProvider.postAddCart(
                          //           context, 
                          //           storeProvider.productSingleStoreModel.body!.id!, 
                          //           storeProvider.productSingleStoreModel.body!.minOrder!,
                          //           fromCart: false,
                          //           productStoreSingle: storeProvider.productSingleStoreModel.body
                          //         );
                          //       } : () {},
                          //       isLoading: context.watch<StoreProvider>().postAddLiveBuyStatus == PostAddLiveBuyStatus.loading 
                          //       ? true 
                          //       : false,
                          //       btnTxt: "Beli Sekarang"
                          //     ),
                          //   ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: CustomButton(
                              key: const Key('Tambah Keranjang - Ubah Barang'),
                              isBoxShadow: false,
                              isBorder: false,
                              isBorderRadius: true,
                              sizeBorderRadius: 20.0,
                              btnColor: context.watch<StoreProvider>().productSingleStoreModel.body!.store!.open! 
                              ? storeProvider.productSingleStoreModel.body!.stock! < 1 
                              ? ColorResources.hintColor
                              : ColorResources.primaryOrange 
                              : Colors.grey[350]!,
                              onTap: context.watch<StoreProvider>().productSingleStoreModel.body!.store!.open! 
                              ? storeProvider.productSingleStoreModel.body!.stock! < 1 
                              ? () {}
                              : () async {
                                  if (storeProvider.productSingleStoreModel.body!.store!.id != storeProvider.sellerStoreModel.body?.id) {
                                    await storeProvider.postAddCart(
                                      context, storeProvider.productSingleStoreModel.body!.id!, 
                                      storeProvider.productSingleStoreModel.body!.minOrder!
                                    );   
                                  } else {
                                    if (storeProvider.productSingleStoreModel.body!.stock! < 1) {
                                      ShowSnackbar.snackbar(context, "Stok Barang Habis", "", ColorResources.error);
                                    } else {
                                      NS.push(context, EditProductStorePage(
                                        idProduct: storeProvider.productSingleStoreModel.body!.id!,
                                        typeProduct: widget.typeProduct,
                                        path: widget.path
                                      ));
                                    }
                                  }
                                } 
                              : () {},
                              isLoading: context.watch<StoreProvider>().postAddCartStatus == PostAddCartStatus.loading 
                              ? true 
                              : false,
                              customText: true,
                              text: getStatusText(storeProvider),
                            ),
                          )
                        ],
                      ),
                    )
                    
                  ],
                )
              )
            )
          ],
        );
      },
    );
  }

  Widget getAdapter(StoreProvider storeProvider) {
    if (storeProvider.productSingleStoreModel.body!.store!.id! != storeProvider.sellerStoreModel.body?.id) {
      return getDataProductByCategory(storeProvider);
    } else {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.only(
            left: 25.0, right: 25.0, 
            bottom: 15.0
          ),
          child: Text("Pembeli akan melihat barangmu tampil seperti ini",
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.black,
            ),
          ),
        )
      );
    }
  }

  Color getStatusColor(StoreProvider storeProvider) {
    if (storeProvider.productSingleStoreModel.body!.store!.id != storeProvider.sellerStoreModel.body?.id) {
      if (storeProvider.productSingleStoreModel.body!.stock! < 1) {
        return Colors.grey[200]!;
      } else {
        return ColorResources.primaryOrange;
      }
    } else {
      if (storeProvider.productSingleStoreModel.body!.stock! < 1) {
        return Colors.grey[200]!;
      } else {
        return Colors.grey[200]!;
      }
    }
  }

  Text getStatusText(StoreProvider storeProvider) {
    if (storeProvider.productSingleStoreModel.body!.store!.id! != storeProvider.sellerStoreModel.body?.id) {
      if (storeProvider.productSingleStoreModel.body!.stock! < 1) {
        return Text("Stok Habis",
          style: robotoRegular.copyWith(
            color: ColorResources.white, 
            fontWeight: FontWeight.w600,
            fontSize: Dimensions.fontSizeDefault
          )
        );
      } else {
        return Text("Tambah Keranjang",
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontWeight: FontWeight.w600,
            fontSize: Dimensions.fontSizeDefault
          )
        );
      }
    } else {
      if (storeProvider.productSingleStoreModel.body!.stock! < 1) {
        return Text("Stok Habis",
          style: robotoRegular.copyWith(
            color: ColorResources.white, 
            fontWeight: FontWeight.w600,
            fontSize:  Dimensions.fontSizeDefault
          )
        );
      } else {
        return Text("Ubah Barang",
          style: robotoRegular.copyWith(
            color: ColorResources.white, 
            fontWeight: FontWeight.w600,
            fontSize: Dimensions.fontSizeDefault
          )
        );
      }
    }
  }

  Widget searchCard() {
    return GestureDetector(
      onTap: () {
        NS.push(context, SearchProductScreen(
          typeProduct: widget.typeProduct,
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
            const Padding(
              padding: EdgeInsets.fromLTRB(
                9.0, 14.0, 
                9.0, 14.0
              ),
              child: Icon(
                Icons.search,
                color: ColorResources.grey,
              ),
            ),
            Text("Cari Barang",
              style: robotoRegular.copyWith(
                color: ColorResources.grey,
                fontSize: Dimensions.fontSizeDefault,
              ),
            )
          ],
        ),
      ),
    );
  } 

  Widget getImages(ProductSingleStoreModel imageUrl) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CarouselSlider(
          items: imageUrl.body!.pictures!.map((fileImage) {
            return GestureDetector(
              onTap: () {
                modalBottomimages(context, current, imageUrl);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  child: CachedNetworkImage(
                  imageUrl:"${fileImage.path}",
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) => Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: ColorResources.white,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  ),
                  errorWidget: (BuildContext context, String url, dynamic error) => Center(
                  child: Image.asset("assets/images/logo/saka.png",
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )),
                )
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: double.infinity,
          enableInfiniteScroll: false,
          aspectRatio: 16 / 9,
          autoPlay: false,
          viewportFraction: 1.0,
          onPageChanged: (index, reason) {
            setState(() => current = index);
          }),
        ),
        imageUrl.body!.pictures!.length != 1
        ? Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 75.0,
              margin: const EdgeInsets.only(
                right: 16.0, 
                bottom: 12.0
              ),
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(6.0)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: const Icon(
                      Icons.image
                    ),
                  ),
                  Text("${current+1} / ${imageUrl.body!.pictures!.length}",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall
                    ),
                  )
                ],
              ),
            ),
          )
        // Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: imageUrl.body!.pictures!.map((url) {
        //         int index = imageUrl.body!.pictures!.indexOf(url);
        //         return Container(
        //           width: 8.0,
        //           height: 8.0,
        //           margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: current == index ? ColorResources.primaryOrange : Colors.grey
        //           ),
        //         );
        //       }).toList(),
        //     ),
        //   )
        : Container()
      ],
    );
  }

  void modalBottomimages(BuildContext context, int number, ProductSingleStoreModel imageUrl) {
    PageController pageController = PageController(initialPage: number);

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        context: context,
        builder: (BuildContext cn) {
          return Container(
            decoration: const BoxDecoration(
              color: ColorResources.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0
              )
            )
          ),
          child: Scaffold(
            backgroundColor: ColorResources.black,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: PhotoViewGallery.builder(
                    pageController: pageController,
                    itemCount: imageUrl.body!.pictures!.length,
                    loadingBuilder: (context, event) => const Loader(
                      color: ColorResources.primaryOrange
                    ),
                    builder: (BuildContext context, int i) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage("${imageUrl.body!.pictures![i].path!}"),
                        initialScale: PhotoViewComputedScale.contained * 1,
                        heroAttributes: PhotoViewHeroAttributes(
                          tag: imageUrl.body!.pictures![i].path!
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      NS.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
                      child: const Icon(
                        Icons.close,
                        color: ColorResources.white,
                      ),
                    )
                  ),
                ),
              ],
            )
          ),
        );
      }
    );
  }

  Widget getDataProductByCategory(StoreProvider storeProvider) {
    // List<ProductStoreList> delivered = storeProvider.productStoreConsumenList.where((el) => el.id != widget.productId).toList();
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(
          left: 25.0, right: 25.0, 
          top: 15.0, bottom: 15.0
        ),
        // height: delivered.isEmpty ? 0.0 : 315.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          //   delivered.isEmpty
          //   ? Container()
          //   : Text("Lainnya",
          //     style: robotoRegular.copyWith(
          //       fontSize: Dimensions.fontSizeLarge,
          //       color: ColorResources.black,
          //       fontWeight: FontWeight.w600
          //     ),
          //   ),
            // delivered.isEmpty
            // ? Container()
            // : Expanded(
            //   child: ListView(
            //     shrinkWrap: true,
            //     padding: EdgeInsets.zero,
            //     physics: const BouncingScrollPhysics(),
            //     scrollDirection: Axis.horizontal,
            //     children: storeProvider.productStoreConsumenList.where((el) => el.id != widget.productId).map((productStoreList) {
            //     return GestureDetector(
            //       onTap: () { 
            //         NS.push(context, DetailProductPage(
            //           productId: productStoreList.id!, 
            //           typeProduct: "commerce", 
            //           path: "",
            //           count: 2,
            //         ));
            //       },
            //       child: SizedBox(
            //         width: 130.0,
            //         child: Card(
            //           elevation: 2.0,
            //             shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(15.0)
            //           ),
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               AspectRatio(
            //                 aspectRatio: 5 / 5,
            //                 child: SizedBox(
            //                   width: double.infinity,
            //                   height: double.infinity,
            //                   child: ClipRRect(
            //                     borderRadius: const BorderRadius.only(
            //                       topLeft: Radius.circular(12.0),
            //                       topRight: Radius.circular(12.0)
            //                     ),
            //                     child: CachedNetworkImage(
            //                       imageUrl: "${AppConstants.baseUrlFeedImg}${productStoreList.pictures!.first.path}",
            //                         fit: BoxFit.cover,
            //                         placeholder: (BuildContext context, String url) => Center(
            //                           child: Shimmer.fromColors(
            //                           baseColor: Colors.grey[200]!,
            //                           highlightColor: Colors.grey[100]!,
            //                           child: Container(
            //                             color: ColorResources.white,
            //                             width: double.infinity,
            //                             height: double.infinity,
            //                           ),
            //                         )
            //                       ),
            //                       errorWidget: (BuildContext context, String url, dynamic error) => Center(
            //                         child: Image.asset("assets/images/logo/saka.png",
            //                           fit: BoxFit.cover,
            //                           width: double.infinity,
            //                           height: double.infinity,
            //                         )
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     productStoreList.name!.length > 35
            //                     ? Text(productStoreList.name!.toTitleCase().substring(0, 35) + "...",
            //                         maxLines: 2,
            //                         style: robotoRegular.copyWith(
            //                           fontSize: Dimensions.fontSizeDefault,
            //                         ),
            //                       )
            //                     : Text(productStoreList.name!.toTitleCase(),
            //                       maxLines: 2,
            //                       style: robotoRegular.copyWith(
            //                         fontSize: Dimensions.fontSizeDefault,
            //                       ),
            //                     ),
            //                     const SizedBox(
            //                       height: 5.0,
            //                     ),
            //                     Text(Helper.formatCurrency(productStoreList.price!),
            //                       style: robotoRegular.copyWith(
            //                         fontSize: Dimensions.fontSizeDefault,
            //                         fontWeight: FontWeight.w600,
            //                       )
            //                     ),
            //                     const SizedBox(
            //                       height: 8.0,
            //                     ),
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Row(
            //                           children: [
            //                             const Expanded(
            //                               flex: 1,
            //                               child: Icon(
            //                                 Icons.store,
            //                                 size: 15.0,
            //                               ),
            //                             ),
            //                             Expanded(
            //                               flex: 5,
            //                               child: Text(productStoreList.store!.name!,
            //                                 style: robotoRegular.copyWith(
            //                                   color: ColorResources.black,
            //                                   fontSize: Dimensions.fontSizeSmall,
            //                                   fontWeight: FontWeight.w600
            //                                 )
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                         Text(productStoreList.store!.city!,
            //                           style: robotoRegular.copyWith(
            //                             color: ColorResources.primaryOrange,
            //                             fontSize: Dimensions.fontSizeSmall,
            //                           )
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(
            //                       height: 8.0,
            //                     ),
            //                     Row(
            //                       children: [
            //                         RatingBarIndicator(
            //                           rating: productStoreList.stats!.ratingAvg!,
            //                           itemBuilder: (context, index) => const Icon(
            //                             Icons.star,
            //                             color: Colors.amber,
            //                           ),
            //                           itemCount: 5,
            //                           itemSize: 15.0,
            //                           direction: Axis.horizontal,
            //                         ),
            //                         Text(
            //                           "(" + productStoreList.stats!.ratingAvg.toString().substring(0, 3) + ")",
            //                           style: robotoRegular.copyWith(
            //                             fontSize: Dimensions.fontSizeSmall,
            //                             color: ColorResources.primaryOrange,
            //                             fontWeight: FontWeight.w600,
            //                           )
            //                         ),
            //                       ],
            //                     )
            //                   ],
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     );
            //     }).toList(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget loadingStoreId() {
    return SliverToBoxAdapter(
      child: Container(
        height: 320.0,
        margin: const EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 180.0,
                    height: 15.0,
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorResources.white
                    ),
                  ),
                  Container(
                    height: 280.0,
                    padding: const EdgeInsets.only(left: 16.0, right: 7.0, bottom: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 150.0,
                          margin: const EdgeInsets.only(right: 7.0),
                          decoration: BoxDecoration(
                            color: ColorResources.white,
                            borderRadius: BorderRadius.circular(15.0)
                          ),
                        );
                      },
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showKurirAvailable(List<SupportedCourierProductStoreSingle> kurir) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
            decoration: const BoxDecoration(
              color: ColorResources.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, 
                    top: 16.0, bottom: 8.0
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          NS.pop(context);
                        },
                        child: const Icon(Icons.close)),
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: Text("Kurir yang tersedia",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault, 
                            color: ColorResources.black
                          )
                        )
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 3,
                ),
                Expanded(
                  flex: 40,
                  child: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: kurir.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            left: 16.0,
                            right: 16.0,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60.0,
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl: "${kurir[index].image!}",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (BuildContext context, String url) => Center(
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[200]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: ColorResources.white,
                                          width: double.infinity,
                                        ),
                                      )
                                    ),
                                    errorWidget: (BuildContext context, String url,  dynamic error) {
                                    return Center(
                                      child: Image.asset("assets/images/logo/saka.png",
                                        fit: BoxFit.cover,
                                      )
                                    );
                                  }
                                ),
                              )
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: Text(kurir[index].name!,
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.center,
                              )
                            ),
                          ],
                        )
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        thickness: 1.0,
                      );
                    },
                  )
                ),
              )
            ],
          )
        );
      },
    );
  }

  void modalDeskripsi(ProductSingleStoreModel productSingleStoreModel) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.96,
          color: Colors.transparent,
          child: Container(
              decoration: const BoxDecoration(
                color: ColorResources.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)
                )
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, 
                          top: 5.0, bottom: 5.0
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                NS.pop(context);
                              },
                              child: const Icon(Icons.close)
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 16.0),
                              child: Text("Deskripsi Barang",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.black
                                )
                              )
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 3.0,
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16.0),
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 70.0,
                                height: 70.0,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${productSingleStoreModel.body!.pictures!.first.path}",
                                          fit: BoxFit.cover,
                                          placeholder: (BuildContext context, String url) =>
                                            Center(
                                              child: Shimmer.fromColors(
                                              baseColor: Colors.grey[200]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                color: ColorResources.white,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            )
                                          ),
                                          errorWidget: (BuildContext context, String url, dynamic error) =>
                                            Center(
                                              child: Image.asset("assets/images/logo/saka.png",
                                              fit: BoxFit.cover,
                                            )
                                          ),
                                        ),
                                      )
                                    ),
                                    productSingleStoreModel.body!.discount != null
                                      ? Align(
                                          alignment: Alignment.topLeft,
                                            child: Container(
                                              height: 20.0,
                                              padding: const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  bottomRight: Radius.circular(12.0),
                                                  topLeft: Radius.circular(12.0)
                                                ),
                                                color: Colors.red[900]
                                              ),
                                              child: Text(productSingleStoreModel.body!.discount!.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                              style: robotoRegular.copyWith(
                                              color: ColorResources.white,
                                              fontSize: Dimensions.fontSizeSmall,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    productSingleStoreModel.body!.name!.length > 90
                                      ? Text(
                                          productSingleStoreModel.body!.name!.substring(0, 90) + "...",
                                          maxLines: 2,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                          ),
                                        )
                                      : Text(productSingleStoreModel.body!.name!,
                                        maxLines: 2,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                        ),
                                      ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(Helper.formatCurrency(productSingleStoreModel.body!.price!),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w600,
                                      )
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("STOK: ",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.primaryOrange
                                          )
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(productSingleStoreModel.body!.stock.toString(),
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.primaryOrange
                                          )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Divider(
                            thickness: 2.0,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            productSingleStoreModel.body!.description!,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                         ],
                      ),
                    )
                  ],
                ),
              ],
            )
          )
        );
      },
    );
  }

  Widget loadingDetailPage() {
    return ListView(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, 
                height: 280.0, 
                color: ColorResources.white
              ),
              Container(
                width: double.infinity,
                height: 20.0,
                margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: ColorResources.white
                ),
              ),
              Container(
                width: double.infinity,
                height: 20.0,
                margin: const EdgeInsets.only(left: 16.0, right: 100.0, top: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: ColorResources.white
                ),
              ),
              Container(
                width: 120.0,
                height: 20.0,
                margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: ColorResources.white
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 15.0,
          color: Colors.grey[100],
        ),
        const SizedBox(height: 16.0),
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                margin: const EdgeInsets.only(left: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: ColorResources.white
                )
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorResources.white
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 80.0,
                    height: 15.0,
                    margin: const EdgeInsets.only(top: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorResources.white
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Divider(
          thickness: 15.0,
          color: Colors.grey[100],
        ),
        const SizedBox(height: 16.0),
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150.0,
                height: 15.0,
                margin: const EdgeInsets.only(
                  left: 16.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: ColorResources.white
                ),
              ),
              Container(
                width: 20.0,
                height: 20.0,
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: ColorResources.white
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Divider(
          thickness: 15.0,
          color: Colors.grey[100],
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 320.0,
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 180.0,
                      height: 15.0,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: ColorResources.white
                      ),
                    ),
                    Container(
                      height: 280.0,
                      padding: const EdgeInsets.only(left: 16.0, right: 7.0, bottom: 16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 150.0,
                            margin: const EdgeInsets.only(right: 7.0),
                            decoration: BoxDecoration(
                              color: ColorResources.white,
                              borderRadius: BorderRadius.circular(15.0)
                            ),
                          );
                        },
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
