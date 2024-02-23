import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/constant.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/screens/store/seller_edit_product.dart';
import 'package:saka/views/screens/store/detail_product.dart';
import 'package:saka/views/screens/store/seller_add_product.dart';

class StuffSellerScreen extends StatefulWidget {
  final String idStore;

  const StuffSellerScreen({ 
    Key? key, 
    required this.idStore,
   }) : super(key: key);
  @override
  _StuffSellerScreenState createState() => _StuffSellerScreenState();
}

class _StuffSellerScreenState extends State<StuffSellerScreen> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Future<void> getData() async {
    if(mounted) {
      await context.read<StoreProvider>().getDataCategoryProduct(context, "seller");
    }
    if(mounted) {
      await context.read<StoreProvider>().getDataProductByCategorySeller(context);
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
        key: globalKey,
        backgroundColor: ColorResources.white,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(
            bottom: 40.0, 
            right: 15.0
          ),
          child: FloatingActionButton(
            backgroundColor: ColorResources.primaryOrange,
            child: const Center( 
              child: Icon(
                Icons.add,
                color: ColorResources.white,
                size: 40.0,
              )
            ),
            onPressed: () {
              NS.push(context, TambahJualanPage(
                idStore: widget.idStore
              ));
            },
          ),
        ),
        body: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification) {
              if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                context.read<StoreProvider>().getDataProductByCategorySellerLoad(context); 
              }
            } 
            return false;
          },
          child: RefreshIndicator(
            backgroundColor: ColorResources.primaryOrange,
            color: ColorResources.white,
            onRefresh: () {
              return Future.sync(() {
                context.read<StoreProvider>().resetPageListProduct();
                context.read<StoreProvider>().getDataProductByCategorySeller(context);
              }); 
            },
            child: Consumer<StoreProvider>(
              builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                      
                    SliverAppBar(
                      backgroundColor: ColorResources.primaryOrange,
                      leading: CupertinoNavigationBarBackButton(
                        color: ColorResources.white,
                        onPressed: onWillPop,
                      ),
                      centerTitle: true,
                      title: Text("Daftar Produk",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.white
                        ),
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          margin: const EdgeInsets.only(
                            left: 16.0, right: 16.0, 
                            top: 10.0, bottom: 4.0
                          ),
                          child: Text("Kategori Produk",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault,
                              fontWeight: FontWeight.w600
                            )
                          )
                        ),
                        getDataCategoryProductParent(),
                        getCategoryChild(),
                      ])
                    ),

                    if(storeProvider.categoryProductByCategorySellerStatus ==  CategoryProductByCategorySellerStatus.loading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: SpinKitThreeBounce(
                            size: 20.0,
                            color: ColorResources.primaryOrange,
                          ),
                        )
                      ),
                    
                    if(storeProvider.categoryProductByCategorySellerStatus == CategoryProductByCategorySellerStatus.empty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: emptyAddProduct()
                      ),

                    if(storeProvider.categoryProductByCategorySellerStatus == CategoryProductByCategorySellerStatus.loaded)
                      SliverFillRemaining(
                        child: getDataProductByCategory() 
                      )
                  ],
                );
              },
            ) 
          ),
        )
      ),
    );
  }

  Widget getDataCategoryProductParent() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if(storeProvider.categoryProductStatus == CategoryProductStatus.loading) {
          return Container(
            height: 40.0,
            margin: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    width: 100.0,
                    height: 40.0,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0), 
                      color: ColorResources.white
                    ),
                  );
                },
              ),
            ),
          ); 
        }
        
        return Container(
          padding: const EdgeInsets.only(
            top: 8.0, 
            bottom: 8.0, 
            left: 16.0
          ),
          height: 56.0,
          child: ListView.builder(
            itemCount: storeProvider.categoryHasManyProduct.length + 1,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) {
              if(i == 0) {
                return Container(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: storeProvider.idCategory == "all" 
                      ? ColorResources.primaryOrange 
                      : ColorResources.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(
                          width: 1.0, 
                          color: ColorResources.primaryOrange
                        )
                      ),
                    ),
                    onPressed: () {
                      storeProvider.changeIdCategory(val: "all");
                      storeProvider.resetPageListProduct();

                      storeProvider.getDataProductByCategorySeller(context);                      
                      storeProvider.getDataCategoryProductByParent(context, "seller");                    
                    },
                    child: Text("All",
                      style: robotoRegular.copyWith(
                        color: context.watch<StoreProvider>().idCategory == "all" 
                        ? ColorResources.white 
                        : ColorResources.primaryOrange,
                      )
                    ),
                  ),
                ); 
              }
              return Container(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: storeProvider.idCategory == storeProvider.categoryHasManyProduct[i-1]["id"] ? ColorResources.primaryOrange : ColorResources.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(
                        width: 1.0, 
                        color: ColorResources.primaryOrange
                      )
                    ),
                  ),
                  onPressed: () {
                    storeProvider.changeIdCategory(val: storeProvider.categoryHasManyProduct[i-1]["id"]);
                    storeProvider.resetPageListProduct();

                    storeProvider.getDataCategoryProductByParent(context, "seller");                  
                    storeProvider.getDataProductByCategorySeller(context);                      
                  },
                  child: Text(storeProvider.categoryHasManyProduct[i-1]["category"],
                    style: robotoRegular.copyWith(
                      color: storeProvider.idCategory == storeProvider.categoryHasManyProduct[i-1]["id"] ? ColorResources.white : ColorResources.primaryOrange,
                    )
                  ),
                ),
              );      
            }
          ),
        ); 
      },
    );
  }

  Widget getCategoryChild() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if(storeProvider.categoryProductByParentStatus == CategoryProductByParentStatus.loading) {
          return Container();
        }
        if(storeProvider.categoryProductByParentList.isEmpty) {
          return Container();
        }
        return Container(
          height: 55.0,
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
          child: ListView.builder(
            itemCount: storeProvider.categoryProductByParentList.length,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) { 
              return Container(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: storeProvider.idCategory == storeProvider.categoryProductByParentList[i].id ? ColorResources.primaryOrange : ColorResources.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    side: const BorderSide(
                      width: 1.0, 
                      color: ColorResources.primaryOrange
                    )
                  ),
                  onPressed: () {
                    context.read<StoreProvider>().changeIdCategory(val: storeProvider.categoryProductByParentList[i].id!);

                    context.read<StoreProvider>().getDataProductByCategorySeller(context);       
                  },
                  child: Text(storeProvider.categoryProductByParentList[i].name!,
                    style: robotoRegular.copyWith(
                      color: storeProvider.idCategory == storeProvider.categoryProductByParentList[i].id
                      ? ColorResources.white 
                      : ColorResources.primaryOrange
                    )
                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }

  Widget getDataProductByCategory() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 16.0, 
            right: 16.0, 
            bottom: 16.0
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: storeProvider.productStoreList.length,
          itemBuilder: (BuildContext context, int i) {
            return GestureDetector(
              onTap: () {
                NS.push(context, DetailProductPage(
                  productId: storeProvider.productStoreList[i].id!,
                  typeProduct: 'seller',
                  path: '/fetch',
                ));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorResources.grey,
                    width: 1.0
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      imageUrl: "${AppConstants.baseUrlFeedImg}${storeProvider.productStoreList[i].pictures!.first.path}",
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
                                        )
                                      ),
                                      errorWidget: (BuildContext context, String url, dynamic error) => const Center(
                                        child: Icon(Icons.store)
                                      ),
                                    ),
                                  )
                                ),
                                storeProvider.productStoreList[i].discount != null
                                ? Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      height: 20.0,
                                      width: 25.0,
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(12.0),
                                          topLeft: Radius.circular(12.0)
                                        ),
                                        color: Colors.red[900]
                                      ),
                                      child: Center(
                                        child: Text(storeProvider.productStoreList[i].discount!.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
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
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                storeProvider.productStoreList[i].name!.length > 75
                                ? Text(
                                    storeProvider.productStoreList[i].name!.substring(0, 75) + "...",
                                    maxLines: 2,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                    ),
                                  )
                                : Text(
                                    storeProvider.productStoreList[i].name!,
                                    maxLines: 2,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                    ),
                                  ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(Helper.formatCurrency(storeProvider.productStoreList[i].price!),
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
                                        color: Colors.orange[700]
                                      )
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(storeProvider.productStoreList[i].stock.toString(),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Colors.orange[700]
                                      )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                NS.push(context, EditProductStorePage(
                                    idProduct: storeProvider.productStoreList[i].id!,
                                    typeProduct: "seller",
                                    path: "/fetch"
                                  )
                                );
                              },
                              child: Container(
                                height: 30.0,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorResources.black,
                                    width: 0.5
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: ColorResources.white
                                ),
                                child: const Center(
                                  child: Text("Ubah",
                                    style: robotoRegular,
                                  )
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                NS.push(context, DetailProductPage(
                                  productId: storeProvider.productStoreList[i].id!,
                                  typeProduct: 'seller',
                                  path: '/fetch',
                                ));
                              },
                              child: Container(
                                height: 30.0,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorResources.black,
                                    width: 0.5
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: ColorResources.white
                                ),
                                child: const Center(
                                  child: Text("Lihat Barang",
                                    style: robotoRegular,
                                  )
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          InkWell(
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
                                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                                        height: 280,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF06B9E2), 
                                          borderRadius: BorderRadius.circular(20.0),
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
                                              alignment: Alignment.topCenter,
                                              child: Container(
                                                margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                                child: Image.asset("assets/images/feed/remove.png",
                                                  width: 90.0,
                                                  height: 90.0,
                                                ),
                                              )
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text("Apakah Anda yakin ingin Hapus?",
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
                                                    child: StatefulBuilder(
                                                      builder: (BuildContext context, Function setState) {
                                                        return Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Expanded(child: Container()),
                                                            Expanded(
                                                              flex: 5,
                                                              child: CustomButton(
                                                                isBorderRadius: true,
                                                                btnColor: ColorResources.white,
                                                                btnTextColor: ColorResources.primaryOrange,
                                                                onTap: () {
                                                                  NS.pop(context);
                                                                }, 
                                                                btnTxt: getTranslated("CANCEL", context)
                                                              ),
                                                            ),
                                                            Expanded(child: Container()),
                                                            Expanded(
                                                              flex: 5,
                                                              child: CustomButton(
                                                                isBorderRadius: true,
                                                                btnColor: ColorResources.primaryOrange,
                                                                btnTextColor: ColorResources.white,
                                                                isLoading: context.watch<StoreProvider>().deleteProductStatus == DeleteProductStatus.loading ? true : false,
                                                                onTap: () async {
                                                                  context.read<StoreProvider>().resetPageListProduct();
                                                                  await context.read<StoreProvider>().postDeleteProductStore(context, storeProvider.productStoreList[i].id!, -1, widget.idStore);
                                                                }, 
                                                                btnTxt: "OK"
                                                              ),
                                                            ),
                                                            Expanded(child: Container()),
                                                          ],
                                                        );
                                                      },
                                                    )
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
                              // showAnimatedDialog(
                              //   context: context, 
                              //   barrierDismissible: true,
                              //   builder: (BuildContext ctx) {
                              //     return Dialog(
                              //       child: SizedBox(
                              //         height: 120.0,
                              //         child: Column(
                              //           mainAxisAlignment: MainAxisAlignment.center,
                              //           children: [
                              //             const Text("Apakah Anda yakin ingin Hapus ?",
                              //               style: robotoRegular,
                              //             ),
                              //             const SizedBox(height: 10.0),
                              //             Row(
                              //               mainAxisAlignment: MainAxisAlignment.center,
                              //               children: [
                              //                 TextButton(
                              //                   onPressed: () => Navigator.of(context).pop(), 
                              //                   child: Text("Batal",
                              //                     style: robotoRegular.copyWith(
                              //                       color: ColorResources.black
                              //                     ),
                              //                   ),
                              //                 ),
                              //                 TextButton(
                              //                   onPressed: () async {
                              //                     ProgressDialog pr = ProgressDialog(context: context);
                              //                     pr.show(
                              //                       max: 2,
                              //                       msg: "Mohon Tunggu...",
                              //                       borderRadius: 10.0,
                              //                       backgroundColor: ColorResources.white,
                              //                       progressBgColor: ColorResources.primaryOrange
                              //                     );
                              //                     try {
                              //                       await Provider.of<StoreProvider>(context, listen: false).postDeleteProductStore(context, productStoreList.id!, -1);
                              //                       pr.close();
                              //                       Fluttertoast.showToast(
                              //                         msg: "Hapus Produk Berhasil",
                              //                         toastLength: Toast.LENGTH_SHORT,
                              //                         gravity: ToastGravity.BOTTOM,
                              //                         timeInSecForIosWeb: 1,
                              //                         backgroundColor: Colors.orange[700],
                              //                         textColor: ColorResources.white
                              //                       );
                              //                       Navigator.push(context, MaterialPageRoute(builder: (context) {
                              //                         return StuffSellerScreen(
                              //                           idStore: widget.idStore,
                              //                         );
                              //                       }));
                              //                       Navigator.of(context, rootNavigator: true).pop();
                              //                     } catch(e, stacktrace) {
                              //                       pr.close();
                              //                       debugPrint(stacktrace.toString());
                              //                     }
                              //                   }, 
                              //                   child: Text("Hapus",
                              //                     style: robotoRegular.copyWith(
                              //                       color: ColorResources.error
                              //                     ),
                              //                   ),
                              //                 )
                              //               ],
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //     );                          
                              //   },
                              // );
                            },
                            child: Container(
                              height: 30.0,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[200]
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.delete,
                                  size: 20.0, 
                                  color: ColorResources.error
                                )
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    );    
  }


  Widget emptyAddProduct() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Anda belum menambahkan Barang",
          textAlign: TextAlign.center,
          style: robotoRegular.copyWith(
            fontSize: 18.0,
            color: ColorResources.black,
            fontWeight: FontWeight.w600
          ),
        ),
        const SizedBox(height: 5.0),
         Text("Tambah barang anda yang akan dijual",
          textAlign: TextAlign.center,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault, 
            color: ColorResources.primaryOrange
          )
        )
      ]
      ),
    );
  }
}