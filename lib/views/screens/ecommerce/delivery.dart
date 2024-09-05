import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';
import 'package:saka/views/screens/ecommerce/shipping_address/shipping_address_list.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => DeliveryScreenState();
}

class DeliveryScreenState extends State<DeliveryScreen> {

  late EcommerceProvider ep;

  int loading = -1;
  int loadingListCourier = -1;

  Future<void> getData() async {
    if(!mounted) return;
      await ep.getCheckoutList();
    
    if(!mounted) return; 
      await ep.getShippingAddressDefault();
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
      body: RefreshIndicator.adaptive(
        onRefresh: () {
          return Future.sync(() {
            
          });
        },
        child: Consumer<EcommerceProvider>(
          builder: (_, notifier, __) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [
                      
                SliverAppBar(
                  title: Text("Pengiriman",
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.black
                    ),
                  ),
                  leading: CupertinoNavigationBarBackButton(
                    color: ColorResources.black,
                    onPressed: () {
                      NS.pop(context);
                    },
                  ),
                ),

                if(notifier.getCheckoutStatus == GetCheckoutStatus.loading)
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

                // if(notifier.getShippingAddressDefaultStatus == GetShippingAddressDefaultStatus.loading) 
                //   SliverFillRemaining(
                //     hasScrollBody: false,
                //     child: Center(
                //       child: SizedBox(
                //         width: 32.0,
                //         height: 32.0,
                //         child: CircularProgressIndicator.adaptive()
                //       )
                //     )
                //   ),

                if(notifier.getCheckoutStatus == GetCheckoutStatus.error)
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
                
                // if(notifier.getShippingAddressDefaultStatus == GetShippingAddressDefaultStatus.empty) 
                //   SliverFillRemaining(
                //     hasScrollBody: false,
                //     child: Center(
                //       child: Text("Hmm... Mohon tunggu yaa",
                //         style: robotoRegular.copyWith(
                //           fontSize: Dimensions.fontSizeDefault
                //         ),
                //       )
                //     )
                //   ),
                if(notifier.getCheckoutStatus == GetCheckoutStatus.loaded)
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      bottom: 30.0
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                                    
                        Container(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              Text("Barang yang dibeli",
                                style: robotoRegular.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                              ),
                                    
                              InkWell(
                                onTap: () {
                                  NS.push(context, ShippingAddressListScreen());
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text("Pilih alamat lain",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.purple,
                                      fontSize: Dimensions.fontSizeDefault,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                        
                        const Divider(
                          height: 15.0,
                          thickness: 3.0,
                          color: Color(0xffF0F0F0),
                        ),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            
                            Container(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                left: 16.0,
                                right: 16.0
                              ),
                              child: context.watch<EcommerceProvider>().getShippingAddressDefaultStatus == GetShippingAddressDefaultStatus.empty 
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Anda belum memilih alamat",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w600,
                                        color: ColorResources.black
                                      ),
                                    )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        SizedBox(
                                          width: 250.0,
                                          child: Text(notifier.shippingAddressDataDefault.address.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                        
                                        const SizedBox(width: 10.0),

                                        Container(
                                          padding: const EdgeInsets.only(
                                            top: 3.0,
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 3.0  
                                          ),
                                          decoration: const BoxDecoration(
                                            color: ColorResources.purple,
                                            borderRadius: BorderRadius.all(Radius.circular(3.0))
                                          ),
                                          child: Text("Utama",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeSmall,
                                              fontWeight: FontWeight.w600,
                                              color: ColorResources.white
                                            ),
                                          ),
                                        )
                                        
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 5.0),

                                    Text(notifier.shippingAddressDataDefault.address.toString(),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.hintColor
                                      ),
                                    )
                                  ],
                                ),
                              )

                            ],
                          ),
                          
                          const Divider(
                            height: 30.0,
                            thickness: 5.0,
                            color: Color(0xffF0F0F0),
                          ),
                            
                          Container(
                            margin: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: notifier.checkoutListData.stores!.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    top: 12.0,
                                    bottom: 12.0
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                  
                                      Text(notifier.checkoutListData.stores![i].name.toString(),
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),

                                      Text(notifier.checkoutListData.stores![i].address.toString(),
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.hintColor
                                        ),
                                      ),
                                  
                                      ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: notifier.checkoutListData.stores![i].products.length,
                                        itemBuilder: (BuildContext context, int z) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: notifier.checkoutListData.stores![i].products[z].picture.toString(),
                                                        imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                                          return Container(
                                                            width: 62.0,
                                                            height: 62.0,
                                                            decoration: BoxDecoration(
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
                                                          return Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius.only(
                                                                topLeft: Radius.circular(8.0),
                                                                topRight: Radius.circular(8.0)
                                                              ),
                                                              image: DecorationImage(
                                                                image: NetworkImage('https://dummyimage.com/300x300/000/fff'),
                                                                fit: BoxFit.fitHeight
                                                              )
                                                            ),
                                                          ); 
                                                        },
                                                      ),
                                                    ),
                                            
                                                    const SizedBox(width: 18.0),
                                            
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(notifier.checkoutListData.stores![i].products[z].name.toString(),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeDefault
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Text(Helper.formatCurrency(double.parse(notifier.checkoutListData.stores![i].products[z].price.toString())),
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeDefault,
                                                                fontWeight: FontWeight.w600
                                                              )
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets.only(
                                                                left: 5.0,
                                                                right: 5.0
                                                              ),
                                                              child: Text("X",
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeDefault
                                                                ),
                                                              ),
                                                            ),
                                                            Text(notifier.checkoutListData.stores![i].products[z].qty.toString(),
                                                              overflow: TextOverflow.ellipsis,
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeDefault
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),                                          
                                                  ],
                                                ),
                                          
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                      
                                    // cpw.getCheckoutCourierStatus == GetCheckoutCourierStatus.loading 
                                    // ? const SizedBox() 
                                    // : cpw.getCheckoutCourierStatus == GetCheckoutCourierStatus.error 
                                    // ? const SizedBox() 
                                    // : cp.checkoutCourierData.stores![i].courier.name != "-"
                                    // ? loadingListCourier == i 
                                    //   ? Container(
                                    //       height: 120.0,
                                    //       margin: const EdgeInsets.only(top: 16.0),
                                    //       decoration: BoxDecoration(
                                    //         borderRadius: BorderRadius.circular(5.0),
                                    //         border: Border.all(
                                    //           width: 3.0,
                                    //           style: BorderStyle.solid,
                                    //           color: const Color(0xFFD9D9D9)
                                    //         )
                                    //       ),
                                    //       child: const Column(
                                    //         crossAxisAlignment: CrossAxisAlignment.center,
                                    //         mainAxisAlignment: MainAxisAlignment.center,
                                    //         children: [
                                    //           Center(
                                    //             child: SpinKitChasingDots(
                                    //               color: Color(0xff0F903B),
                                    //               size: 20.0,
                                    //             ),
                                    //           )
                                    //         ],
                                    //       )
                                    //     )
                                    //   : InkWell(
                                    //       borderRadius: BorderRadius.circular(5.0),
                                    //       onTap: () async {
                                    //         setState(() {
                                    //           loadingListCourier = i;
                                    //         });
                                        
                                    //         await cp.getCheckoutCourierCost(context, 
                                    //           storeId: cp.checkoutCourierData.stores![i].id,
                                    //           i: i,
                                    //         );
                                            
                                    //         setState(() {
                                    //           loadingListCourier = -1;
                                    //         });
                                    //       },
                                    //       child: Container(
                                    //         margin: const EdgeInsets.only(top: 16.0),
                                    //         decoration: BoxDecoration(
                                    //           borderRadius: BorderRadius.circular(5.0),
                                    //           border: Border.all(
                                    //             width: 3.0,
                                    //             style: BorderStyle.solid,
                                    //             color: const Color(0xFFD9D9D9)
                                    //           )
                                    //         ),
                                    //         child: Padding(
                                    //           padding: const EdgeInsets.all(8.0),
                                    //           child: Row(
                                    //             children: [
                                    //               Expanded(
                                    //                 child: Column(
                                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                                    //                   children: [
                                    //                     Text(cp.checkoutCourierData.stores![i].courier.name!,
                                    //                       style: const robotoRegular.copyWith(
                                    //                         fontSize: Dimensions.fontSizeDefault,
                                    //                         fontWeight: FontWeight.w600,
                                    //                       )
                                    //                     ),
                                    //                     Text(cp.checkoutCourierData.stores![i].courier.service!,
                                    //                       style: const robotoRegular.copyWith(
                                    //                         fontSize: Dimensions.fontSizeDefault,
                                    //                         fontWeight: FontWeight.w600,
                                    //                       )
                                    //                     ),
                                    //                     Row(
                                    //                       mainAxisAlignment: MainAxisAlignment.start,
                                    //                       crossAxisAlignment: CrossAxisAlignment.center,
                                    //                       children: [
                                    //                         Expanded(
                                    //                           child: Column(
                                    //                           crossAxisAlignment: CrossAxisAlignment.start,
                                    //                             children: [
                                    //                               Text(Helper.formatCurrency(double.parse(cp.checkoutCourierData.stores![i].courier.cost!.value.toString())),
                                    //                                 style: const robotoRegular.copyWith(
                                    //                                   fontSize: 15.0,
                                    //                                   fontWeight: FontWeight.w600,
                                    //                                   color: ColorResources.bluePrimary
                                    //                                 )
                                    //                               ),
                                    //                               const SizedBox(
                                    //                                 height: 5.0,
                                    //                               ),
                                    //                               Text("Estimasi tiba ${cp.checkoutCourierData.stores![i].courier.cost!.etd} Hari",
                                    //                               style: const robotoRegular.copyWith(
                                    //                                 fontSize: Dimensions.fontSizeDefault,
                                    //                                 color: ColorResources.bluePrimary
                                    //                                 )
                                    //                               ),
                                    //                             ]
                                    //                           )
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //               const Icon(
                                    //                 Icons.keyboard_arrow_right,
                                    //                 color: Color(0xffC5C3C3),
                                    //               )
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     )
                                    // : 

                                    notifier.checkoutListData.stores![i].courier.name != '-'
                                    ? loadingListCourier == i 
                                      ? Container(
                                          width: double.infinity,
                                          height: 120.0,
                                          margin: const EdgeInsets.only(top: 16.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            border: Border.all(
                                              width: 3.0,
                                              style: BorderStyle.solid,
                                              color: const Color(0xFFD9D9D9)
                                            )
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator()
                                            ],
                                          )
                                        )
                                      : InkWell(
                                          borderRadius: BorderRadius.circular(5.0),
                                          onTap: () async {
                                            setState(() {
                                              loadingListCourier = i;
                                            });
                                        
                                            await ep.getCourierList(
                                              context: context,
                                              storeId: notifier.checkoutListData.stores![i].id
                                            );
                                            
                                            setState(() {
                                              loadingListCourier = -1;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 16.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              border: Border.all(
                                                width: 3.0,
                                                style: BorderStyle.solid,
                                                color: const Color(0xFFD9D9D9)
                                              )
                                            ),
                                            child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(notifier.checkoutListData.stores![i].courier.name!,
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault,
                                                          fontWeight: FontWeight.w600,
                                                        )
                                                      ),
                                                      Text(notifier.checkoutListData.stores![i].courier.service!,
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault,
                                                          fontWeight: FontWeight.w600,
                                                        )
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(Helper.formatCurrency(double.parse(notifier.checkoutListData.stores![i].courier.cost!.value.toString())),
                                                                  style: robotoRegular.copyWith(
                                                                    fontSize: 15.0,
                                                                    fontWeight: FontWeight.w600,
                                                                  )
                                                                ),
                                                                const SizedBox(
                                                                  height: 5.0,
                                                                ),
                                                                Text("Estimasi tiba ${notifier.checkoutListData.stores![i].courier.cost!.etd} Hari",
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeDefault,
                                                                  )
                                                                ),
                                                              ]
                                                            )
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Color(0xffC5C3C3),
                                                )
                                                
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.only(top: 16.0),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(5.0),
                                          onTap: () async {
                                            setState(() => loading = i);

                                            await ep.getCourierList(
                                              context: context,
                                              storeId: notifier.checkoutListData.stores![i].id
                                            );

                                            setState(() => loading = -1);
                                          },
                                          child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                              border: Border.all(
                                              width: 3.0,
                                              style: BorderStyle.solid,
                                              color: const Color(0xFFD9D9D9)
                                            )
                                          ),
                                          child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              
                                              Expanded(
                                                flex: 4,
                                                child: Container(
                                                  child: Icon(
                                                    Icons.delivery_dining,
                                                    color: ColorResources.purple,
                                                  )
                                                )
                                              ),
                                          
                                              Expanded(
                                                flex: 12,
                                                child: Text(loading == i
                                                  ? "Mohon tunggu..." 
                                                  : "Pilih Pengiriman",
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeLarge,
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorResources.purple
                                                  ),
                                                )
                                              ),
                                          
                                              const Expanded(
                                                flex: 2,
                                                child: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: ColorResources.purple
                                                )
                                              )
                                          
                                            ],
                                          ),
                                        )
                                      ),
                                      )),



                                                                                        
                                  ],
                                ),
                              );
                            },
                          )
                        ),
                        
                        const Divider(
                          height: 40.0,
                          thickness: 3.0,
                          color: Color(0xffF0F0F0),
                        ),   
                          
                        Container(
                          margin: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                          
                              Text("Subtotal",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                          
                              Text(Helper.formatCurrency(double.parse(notifier.checkoutListData.totalPrice.toString())),
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w600
                                ),
                              )
                          
                            ],
                          ),
                        ),
                          
                        const Divider(
                          height: 30.0,
                          thickness: 5.0,
                          color: Color(0xffF0F0F0),
                        ),
                          
                        Container(
                          margin: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 10.0
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      Text("Ringkasan belanja",
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),

                                      const SizedBox(width: 5.0),

                                      InkWell(
                                        onTap: () {

                                          Future.delayed(Duration.zero, () {  
                                            showModalBottomSheet(
                                              context: context, 
                                              isDismissible: true,
                                              isScrollControlled: true,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10.0),
                                                  topRight: Radius.circular(10.0)
                                                )
                                              ),
                                              builder: (BuildContext context) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                    
                                                    Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0,
                                                            left: 15.0,
                                                            right: 15.0,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              width: 2.0,
                                                              color: ColorResources.black
                                                            ),
                                                            shape: BoxShape.circle
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              NS.pop(context);
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.all(10.0),
                                                              child: Text("X",
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeLarge,
                                                                  fontWeight: FontWeight.w600
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ),
                                    
                                                        Text("Ringkasan belanja",
                                                          style: robotoRegular.copyWith(
                                                            color: ColorResources.black,
                                                            fontSize: Dimensions.fontSizeLarge,
                                                            fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    ListView.separated(
                                                      separatorBuilder: (BuildContext context, int i) {
                                                        return const Divider(
                                                          thickness: 1.0,
                                                          color: ColorResources.black,
                                                        );
                                                      },
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      padding: EdgeInsets.zero,
                                                      shrinkWrap: true,
                                                      itemCount: notifier.checkoutListData.productDetails!.length,
                                                      itemBuilder: (BuildContext context, int k) {
                                                        return Padding(
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Container(
                                                            margin: const EdgeInsets.only(
                                                              left: 10.0, 
                                                              right: 10.0
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [

                                                                Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text("Nama",
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeDefault,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 5.0),
                                                                          Text(notifier.checkoutListData.productDetails![k].name,
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeSmall,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ) 
                                                                    ),
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text("Harga",
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeDefault,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 5.0),
                                                                          Text(Helper.formatCurrency(double.parse(notifier.checkoutListData.productDetails![k].price.toString())),
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeSmall,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ) 
                                                                    ),
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text("Qty",
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeDefault,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 5.0),
                                                                          Text(notifier.checkoutListData.productDetails![k].qty.toString(),
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeSmall,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ) 
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.all(16.0),
                                                      child: Container(
                                                        margin: const EdgeInsets.only(
                                                          left: 10.0, 
                                                          right: 10.0
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [

                                                            Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  child: Container()
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Text("Biaya Pengiriman",
                                                                        style: robotoRegular.copyWith(
                                                                          fontSize: Dimensions.fontSizeDefault,
                                                                          color: ColorResources.black
                                                                        ),
                                                                      ),
                                                                      const SizedBox(height: 5.0),
                                                                      Text(Helper.formatCurrency(double.parse("10000".toString())),
                                                                        style: robotoRegular.copyWith(
                                                                          fontSize: Dimensions.fontSizeSmall,
                                                                          color: ColorResources.black
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ) 
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Text("Total",
                                                                        style: robotoRegular.copyWith(
                                                                          fontSize: Dimensions.fontSizeDefault,
                                                                          color: ColorResources.black
                                                                        ),
                                                                      ),
                                                                      const SizedBox(height: 5.0),
                                                                      Text(Helper.formatCurrency(double.parse("100000".toString())),
                                                                        style: robotoRegular.copyWith(
                                                                          fontSize: Dimensions.fontSizeSmall,
                                                                          color: ColorResources.black
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ) 
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )

                                                  ]);
                                                },
                                              );
                                            });

                                        },
                                        child: const Icon(
                                          Icons.info, 
                                          color: ColorResources.purple,
                                          size: 18.0
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text("Total harga",
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          fontWeight: FontWeight.w300
                                        ),
                                      ),
                                      Text(Helper.formatCurrency(double.parse("100000".toString())),
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          fontWeight: FontWeight.w300
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                          
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                            left: 16.0,
                            right: 16.0
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container()
                              ),
                              Expanded(
                                flex: 4,
                                child: CustomButton(
                                  onTap: () {},
                                  isBorder: false,
                                  isBoxShadow: false,
                                  isBorderRadius: true,
                                  sizeBorderRadius: 30.0,
                                  isLoading: false,
                                  btnColor: ColorResources.purple,
                                  btnTxt: "Pilih Pembayaran",
                                ),
                              )
                            ],
                          ),
                        )
                                    
                      ])
                    ),
                  ),

              ],
            );
          },
        )
      )      
    );
  }
}