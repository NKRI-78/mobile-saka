import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:readmore/readmore.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/views/basewidgets/button/bounce.dart';

class ProductDetail extends StatefulWidget {
  final String productId;
  const ProductDetail({
    required this.productId,
    super.key
  });

  @override
  State<ProductDetail> createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {

  late EcommerceProvider ep;

  int current = 0;

  Future<void> getData() async {
    if(!mounted) return;
      await ep.fetchProduct(productId: widget.productId);

    if(!mounted) return;
      await ep.getCart();
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
          
          Consumer<EcommerceProvider>(
            builder: (__, notifier, _) {
              return RefreshIndicator(
                onRefresh: () {
                  return Future.sync(() {

                  });
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                        
                    SliverAppBar(
                      elevation: 0.0,
                      toolbarHeight: 70.0,
                      leadingWidth: 33.0,
                      pinned: true,
                      floating: false,
                      centerTitle: false,
                      titleSpacing: 0.0,
                      title: const SizedBox(),
                      leading: CupertinoNavigationBarBackButton(
                        color: ColorResources.black,
                        onPressed: () {
                          NS.pop(context);
                        },
                      ),
                      actions: [
                        // Center(
                        //   child: Container(
                        //     margin: const EdgeInsets.only(right: 5.0),
                        //     child: InkWell(
                        //       borderRadius: BorderRadius.circular(50.0),
                        //       onTap: () {
                        
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Image.asset("assets/images/dashboard/notification.png",
                        //           width: 25.0,
                        //           height: 25.0,
                        //         ),
                        //       )
                        //     ),
                        //   ),
                        // ),
                        // Center(
                        //   child: 
                          
                          // Container(
                          //   margin: EdgeInsets.only(
                          //     right: 5.0
                          //   ),
                          //   child: InkWell(
                          //     borderRadius: BorderRadius.circular(50.0),
                          //     onTap: () {
                                
                          //     },  
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Badge(
                          //         label: Text("0",
                          //           style: robotoRegular.copyWith(
                          //             fontSize: Dimensions.fontSizeSmall
                          //           ),
                          //         ),
                          //         child: Icon(Icons.shopping_cart,
                          //           color: ColorResources.black,
                          //         )
                          //       ),
                          //     )
                          //   ),
                          // ),
                        // ),

                      if(notifier.getCartStatus == GetCartStatus.loading)
                        Container(
                          margin: EdgeInsets.only(
                            right: 16.0,
                            left: 16.0
                          ),
                          child: Badge(
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
                        ),

                      if(notifier.getCartStatus == GetCartStatus.error)
                        Container(
                          margin: EdgeInsets.only(
                            right: 16.0,
                            left: 16.0
                          ),
                          child: Badge(
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
                        ),
                    
                      if(notifier.getCartStatus == GetCartStatus.loaded)
                        Container(
                          margin: EdgeInsets.only(
                            right: 16.0,
                            left: 16.0
                          ),
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
                    ),
                
                    if(notifier.detailProductStatus == DetailProductStatus.loading) 
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: CircularProgressIndicator()
                          ),
                        )
                      ),

                    if(notifier.detailProductStatus == DetailProductStatus.error) 
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

                    if(notifier.detailProductStatus == DetailProductStatus.loaded) 
                      SliverList(
                        delegate: SliverChildListDelegate([
                        
                          SizedBox(
                            height: 450.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [

                                notifier.productDetailData.product!.medias.isEmpty 
                                ? CachedNetworkImage(
                                  imageUrl: "https://dummyimage.com/300x300/000/fff",
                                  imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
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
                                      child: SizedBox(
                                        width: 32.0,
                                        height: 32.0,
                                        child: CircularProgressIndicator.adaptive()
                                      )
                                    );
                                  },
                                  errorWidget: (BuildContext context, String url, dynamic error) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage("https://dummyimage.com/300x300/000/fff")
                                        )
                                      ),
                                    );
                                  },
                                )
                              : CarouselSlider(
                                  items: notifier.productDetailData.product!.medias.map((image) {
                                    return CachedNetworkImage(
                                      imageUrl: image.path,
                                      imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
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
                                          child: SizedBox(
                                            width: 32.0,
                                            height: 32.0,
                                            child: CircularProgressIndicator.adaptive()
                                          )
                                        );
                                      },
                                      errorWidget: (BuildContext context, String url, dynamic error) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage("https://dummyimage.com/300x300/000/fff")
                                            )
                                          ),
                                        );
                                      },
                                    );
                                  }
                                ).toList(),
                                  options: CarouselOptions(
                                    height: double.infinity,
                                    enableInfiniteScroll: false,
                                    aspectRatio: 16 / 9,
                                    autoPlay: false,
                                    viewportFraction: 1.0,
                                    onPageChanged: (int i, CarouselPageChangedReason reason) {
                                      setState(() => current = i);
                                    }
                                  ),
                                ),
                        
                                Align(
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
                                          margin: const EdgeInsets.only(
                                            left: 5.0, 
                                            right: 5.0
                                          ),
                                          child: const Icon(
                                            Icons.image
                                          ),
                                        ),
                                        Text("${notifier.productDetailData.product!.medias.isNotEmpty ? current+1 : 0} / ${notifier.productDetailData.product!.medias.length}",
                                          style: const TextStyle(
                                            color: ColorResources.black,
                                            fontSize: Dimensions.fontSizeExtraSmall
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                        
                              ],
                            )
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
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(Helper.formatCurrency(double.parse(notifier.productDetailData.product!.price.toString())),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: Dimensions.fontSizeOverLarge, 
                                      fontWeight: FontWeight.w600
                                    )
                                  ),
                                ),
                                Text(notifier.productDetailData.product!.title,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: Dimensions.fontSizeExtraLarge
                                  )
                                ),
                              ],
                            ),
                          ),
                  
                          Divider(
                            thickness: 1.8,
                            color: ColorResources.hintColor.withOpacity(0.5),
                          ),
                          
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0,
                              bottom: 5.0, top: 5.0
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("Detail Produk",
                                  style: const TextStyle(
                                    fontSize: Dimensions.fontSizeLarge,
                                    fontWeight: FontWeight.w600,
                                    color: ColorResources.black
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                ReadMoreText(
                                  notifier.productDetailData.product!.caption,
                                  trimLength: 150,
                                  style: const TextStyle(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: ColorResources.black
                                  ),
                                  delimiter: " ",
                                  trimExpandedText: "Tutup",
                                  trimCollapsedText: "Selanjutnya",
                                  moreStyle: const TextStyle(
                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff0F903B)
                                  ),
                                  lessStyle: const TextStyle(
                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff0F903B)
                                  ),
                                  delimiterStyle: const TextStyle(
                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.w600,
                                    color: ColorResources.black
                                  ),
                                )
                              ],
                            ),
                          ),
                  
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0,
                              bottom: 10.0, top: 10.0
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                  
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [ 
                                    
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                  
                                        CachedNetworkImage(
                                          imageUrl: notifier.productDetailData.product!.store.logo,
                                          imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                            return CircleAvatar(
                                              maxRadius: 20.0,
                                              backgroundImage: imageProvider,
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
                  
                                        Positioned(
                                          bottom: -5.0,
                                          right: -5.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorResources.purple,
                                              borderRadius: BorderRadius.circular(50.0)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Icon(
                                                Icons.check,
                                                color: ColorResources.white,
                                                size: 10.0,
                                              ),
                                            ),
                                          )
                                        )
                  
                                      ],
                                    ),
                  
                                    const SizedBox(width: 10.0),
                                    
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                  
                                        Text(notifier.productDetailData.product!.store.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.w600,
                                            color: ColorResources.black
                                          ),
                                        ),
                  
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 75.0,
                          )
                        ]
                      )
                    )
                  ],
                ),
              );
            },
          ),

          Consumer<EcommerceProvider>(
            builder: (_, notifier, __) {
              if(notifier.detailProductStatus == DetailProductStatus.loading) 
                return const SizedBox();

              if(notifier.detailProductStatus == DetailProductStatus.error) 
                return const SizedBox();

              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: ColorResources.white,
                    boxShadow: kElevationToShadow[4]
                  ),
                  child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
            
                    Expanded(
                      flex: 5,
                      child:  Material(
                        color: ColorResources.transparent,
                        child: Bouncing(
                          onPress: () {
        
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorResources.purple,
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  
                                  Icon(
                                    Icons.shopping_bag,
                                    color: ColorResources.white,  
                                  ),
                              
                                  const SizedBox(width: 8.0),
                                  
                                  Text("Beli langsung",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.bold,
                                      color: ColorResources.white
                                    ),
                                  )
                                                
                                ],
                              ),
                            ),
                          )
                        ))
                      ),

                      Expanded(
                        flex: 1,
                        child: const SizedBox()
                      ),

                      Expanded(
                        flex: 6,
                        child: Material(
                          color: ColorResources.transparent,
                          child: Bouncing(
                            onPress: () {
          
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.purple,
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    
                                    Icon(
                                      Icons.add_shopping_cart,
                                      color: ColorResources.white,  
                                    ),
                                
                                    const SizedBox(width: 8.0),
                                    
                                    Text("Tambah Keranjang",
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSizeSmall,
                                        fontWeight: FontWeight.bold,
                                        color: ColorResources.white
                                      ),
                                    )
                                                  
                                  ],
                                ),
                              ),
                            )
                          ))
                        ),
        
                    ],
                  ),
                ),
              );

            },
          ),
    
        ],
      )
        
    
    );

  }
}