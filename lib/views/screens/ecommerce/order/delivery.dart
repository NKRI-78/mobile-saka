import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/currency.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/button/bounce.dart';
import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/screens/ecommerce/shipping_address/shipping_address_list.dart';

class DeliveryScreen extends StatefulWidget {
  final String from;

  DeliveryScreen({
    required this.from,
    super.key
  });

  @override
  State<DeliveryScreen> createState() => DeliveryScreenState();
}

class DeliveryScreenState extends State<DeliveryScreen> {

  late EcommerceProvider ep;

  int loading = -1;
  int loadingListCourier = -1;

  Future<void> getData() async {    
    if(!mounted) return; 
      await ep.clearCourier();

    if(!mounted) return; 
      await ep.getBalance();

    if(!mounted) return;
      ep.clearPayment();

    if(!mounted) return;
      Future.delayed(Duration(milliseconds: 500), () async {
        await ep.getCheckoutList(from: widget.from);
      });

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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if(widget.from == "live") {
          await ep.deleteCartLiveAll();                        
        }
        NS.pop();
      },
      child: Scaffold(
        body: RefreshIndicator.adaptive(
          onRefresh: () {
            return Future.sync(() {
              getData();
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
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold,
                        color: ColorResources.black
                      ),
                    ),
                    leading: CupertinoNavigationBarBackButton(
                      color: ColorResources.black,
                      onPressed: () async {
                        if(widget.from == "live") {
                          await ep.deleteCartLiveAll();                        
                        }
                        NS.pop();
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
      
                  if(notifier.getShippingAddressDefaultStatus == GetShippingAddressDefaultStatus.loading) 
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                ),
                                      
                                InkWell(
                                  onTap: () {
                                    NS.push(context, ShippingAddressListScreen(
                                      from: widget.from,
                                    ));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text("Pilih alamat lain",
                                      style: robotoRegular.copyWith(
                                        color: ColorResources.purple,
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.bold
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
                                child: notifier.getShippingAddressDefaultStatus == GetShippingAddressDefaultStatus.error
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Anda belum memilih alamat",
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.bold,
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
                                                fontWeight: FontWeight.bold
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
                                                fontWeight: FontWeight.bold,
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
                                            fontWeight: FontWeight.bold
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
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
      
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        child: CachedNetworkImage(
                                                          imageUrl: notifier.checkoutListData.stores![i].products[z].picture.toString() == "-" 
                                                          ? "https://dummyimage.com/300x300/000/fff" 
                                                          : notifier.checkoutListData.stores![i].products[z].picture.toString(),
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
                                              
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            
                                                            SizedBox(
                                                              width: 200.0,
                                                              child: Text(notifier.checkoutListData.stores![i].products[z].name.toString(),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeDefault
                                                                ),
                                                              ),
                                                            ),
                                                        
                                                            Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Text(Helper.formatCurrency(notifier.checkoutListData.stores![i].products[z].price),
                                                                  style: robotoRegular.copyWith(
                                                                    fontSize: Dimensions.fontSizeDefault,
                                                                    fontWeight: FontWeight.bold
                                                                  )
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(
                                                                    left: 5.0,
                                                                    right: 5.0
                                                                  ),
                                                                  child: Text("x",
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall
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
                                                        
                                                            notifier.checkoutListData.stores![i].products[z].note.isEmpty 
                                                            ? const SizedBox()
                                                            : SizedBox(
                                                                width: 250.0,
                                                                child: Text("( ${notifier.checkoutListData.stores![i].products[z].note} )",
                                                                style: robotoRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeExtraSmall,
                                                                  color: ColorResources.black
                                                                ),
                                                              ),
                                                            ),
                                                          
                                                          ],
                                                        ),
                                                      ),                                          
                                                    ],
                                                  ),
                                            
                                              ],
                                            ),
                                          );
                                        },
                                      ),
      
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
                                              setState(() => loadingListCourier = i);
                                          
                                              await ep.getCourierList(
                                                context: context,
                                                storeId: notifier.checkoutListData.stores![i].id,
                                                from: widget.from
                                              );
                                              
                                              setState(() => loadingListCourier = -1 );
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
                                                            fontWeight: FontWeight.bold,
                                                          )
                                                        ),
                                                        
                                                        Text(notifier.checkoutListData.stores![i].courier.service!,
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeDefault,
                                                            fontWeight: FontWeight.bold,
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
                                                                  Text(Helper.formatCurrency(notifier.checkoutListData.stores![i].courier.cost!.value),
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: 15.0,
                                                                      fontWeight: FontWeight.bold,
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
                                                storeId: notifier.checkoutListData.stores![i].id,
                                                from: widget.from
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
                                                      fontSize: Dimensions.fontSizeDefault,
                                                      fontWeight: FontWeight.bold,
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
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                            
                                Text(Helper.formatCurrency(notifier.checkoutListData.totalPriceWithCost! + ep.paymentFee),
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.bold
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
      
                                        Text("Produk Yang Dibeli",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.bold
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
                                                                NS.pop();
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets.all(10.0),
                                                                child: Text("X",
                                                                  style: robotoRegular.copyWith(
                                                                    fontSize: Dimensions.fontSizeDefault,
                                                                    fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ),
                                      
                                                          Text("Produk Yang Dibeli",
                                                            style: robotoRegular.copyWith(
                                                              color: ColorResources.black,
                                                              fontSize: Dimensions.fontSizeDefault,
                                                              fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ],
                                                      ),
      
                                                      ListView.builder(
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        itemCount: notifier.checkoutListData.productDetails!.length,
                                                        itemBuilder: (BuildContext context, int k) {
                                                          return Padding(
                                                            padding: const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0  
                                                            ),
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
                                                                      Flexible(
                                                                        child: SizedBox(
                                                                          width: 100.0,
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text("Nama",
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 2,
                                                                                style: robotoRegular.copyWith(
                                                                                  fontSize: Dimensions.fontSizeDefault,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: ColorResources.black
                                                                                ),
                                                                              ),
                                                                              const SizedBox(height: 5.0),
                                                                              Text(notifier.checkoutListData.productDetails![k].name,
                                                                                maxLines: 1,
                                                                                style: robotoRegular.copyWith(
                                                                                  fontSize: Dimensions.fontSizeSmall,
                                                                                  color: ColorResources.black
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ) 
                                                                      ),
                                                                      Flexible(
                                                                        child: SizedBox(
                                                                          width: 100.0,
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text("Harga",
                                                                                style: robotoRegular.copyWith(
                                                                                  fontSize: Dimensions.fontSizeDefault,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: ColorResources.black
                                                                                ),
                                                                              ),
                                                                              const SizedBox(height: 5.0),
                                                                              Text(Helper.formatCurrency(notifier.checkoutListData.productDetails![k].price),
                                                                                style: robotoRegular.copyWith(
                                                                                  fontSize: Dimensions.fontSizeSmall,
                                                                                  color: ColorResources.black
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ) 
                                                                      ),
                                                                      Flexible(
                                                                        child: SizedBox(
                                                                          width: 100.0,
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text("Qty",
                                                                                style: robotoRegular.copyWith(
                                                                                  fontSize: Dimensions.fontSizeDefault,
                                                                                  fontWeight: FontWeight.bold,
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
                                                                          ),
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
                                                        padding: const EdgeInsets.only(
                                                          top: 10.0,
                                                          left: 16.0,
                                                          right: 16.0  
                                                        ),
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
      
                                                                  Flexible(
                                                                    child: SizedBox(
                                                                      width: 100.0,
                                                                    )
                                                                  ),
      
                                                                  Flexible(
                                                                    child: SizedBox(
                                                                      width: 100.0,
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text("Admin",
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeDefault,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 5.0),
                                                                          Text(Helper.formatCurrency(ep.paymentFee),
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeSmall,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ) 
                                                                  ),
      
                                                                  Expanded(
                                                                    child: const SizedBox()
                                                                  ),
      
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
      
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                          top: 10.0,
                                                          bottom: 10.0,
                                                          left: 16.0,
                                                          right: 16.0  
                                                        ),
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
      
                                                                  Flexible(
                                                                    child: SizedBox(
                                                                      width: 100.0,
                                                                    )
                                                                  ),
      
                                                                  Flexible(
                                                                    child: SizedBox(
                                                                      width: 100.0,
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text("Biaya Pengiriman",
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeDefault,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 5.0),
                                                                          Text(Helper.formatCurrency(ep.checkoutListData.totalCost!),
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeSmall,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ) 
                                                                  ),
      
                                                                  Flexible(
                                                                    child: SizedBox(
                                                                      width: 100.0,
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text("Total Bayar",
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeDefault,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: ColorResources.black
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 5.0),
                                                                          Text(Helper.formatCurrency(ep.checkoutListData.totalPriceWithCost! + ep.paymentFee),
                                                                            style: robotoRegular.copyWith(
                                                                              fontSize: Dimensions.fontSizeLarge,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: ColorResources.purple
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
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
                                              }
                                            );
                                          },
                                          child: const Icon(
                                            Icons.info, 
                                            color: ColorResources.purple,
                                            size: 18.0
                                          ),
                                        )
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 10.0),
      
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text("Total harga",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(Helper.formatCurrency(ep.checkoutListData.totalPriceWithCost! + ep.paymentFee),
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.purple,
                                            fontSize: Dimensions.fontSizeLarge,
                                            fontWeight: FontWeight.bold
                                          ),
                                        )                                      
                                      ],
                                    ),
                                    
                                  ],
                                ),
                              ],
                            ),
                          ),
      
                          Consumer<EcommerceProvider>(
                            builder: (_, notifier, __) {
                              return notifier.channelId != -1 
                              ? Container(
                                  margin: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 16.0, 
                                    right: 16.0,
                                  ),
                                  child: Bouncing(
                                  onPress: () async {
                                    await notifier.getPaymentChannel(
                                      context: context,
                                    );
                                  },
                                  child: Container(
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
                                        children: [

                                          notifier.paymentName == "Saldo" 
                                          ? Expanded(
                                              flex: 4,
                                              child: Icon(
                                                Icons.payment,
                                                color: ColorResources.purple,
                                                size: 30.0,
                                              ),
                                            ) 
                                          : Expanded(
                                              flex: 4,
                                              child: CachedNetworkImage(
                                              imageUrl: notifier.paymentLogo,
                                              imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                                return Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(image: imageProvider)
                                                  ),
                                                );
                                              },
                                              errorWidget: (BuildContext context, String url, dynamic error) {
                                                return Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(image: AssetImage('assets/images/default_image.png'))
                                                  ),
                                                ); 
                                              },
                                            )
                                          ),
      
                                          Expanded(
                                            flex: 1,
                                            child: const SizedBox(),
                                          ),
                                      
                                          Expanded(
                                            flex: 12,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(notifier.getPaymentChannelStatus == GetPaymentChannelStatus.loading 
                                                ? "Mohon tunggu..."
                                                : "${notifier.paymentName}",
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeDefault,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorResources.black
                                                  ),
                                                ),

                                                notifier.paymentName == "Saldo" 
                                                ? const SizedBox(width: 8.0)
                                                : const SizedBox(),

                                                notifier.paymentName == "Saldo" 
                                                ? notifier.getPaymentChannelStatus == GetPaymentChannelStatus.loading  
                                                ? const SizedBox() 
                                                :  Text(CurrencyHelper.formatCurrency(notifier.balance),
                                                    style: robotoRegular.copyWith(
                                                      fontSize: Dimensions.fontSizeSmall,
                                                      color: ColorResources.black
                                                    ),
                                                  )
                                                : const SizedBox()
                                              ],
                                            )
                                          ),
      
                                          Expanded(
                                            flex: 2,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Color(0xffC5C3C3)
                                            )
                                          )
                                      
                                        ]),
                                      ),
                                    ),
                                  )
                                )
                              : Container(
                                  margin: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 16.0, 
                                    right: 16.0,
                                  ),
                                  child: Bouncing(
                                  onPress: () async {
                                    await ep.getPaymentChannel(
                                      context: context,
                                    );
                                  },
                                  child: Container(
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
                                        children: [
                                      
                                          Expanded(
                                            flex: 4,
                                            child: Icon(
                                              Icons.payment,
                                              color: ColorResources.purple,
                                            )
                                          ),
                                      
                                          Expanded(
                                            flex: 12,
                                            child: Text(notifier.getPaymentChannelStatus == GetPaymentChannelStatus.loading 
                                            ? "Mohon tunggu..."
                                            : "Pilih Pembayaran",
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeDefault,
                                                fontWeight: FontWeight.bold,
                                                color: ColorResources.purple
                                              ),
                                            ),
                                          ),
      
                                          Expanded(
                                            flex: 2,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: ColorResources.purple
                                            )
                                          )
                                      
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              );
                            },
                          ),
      
                          Container(
                            margin: const EdgeInsets.only(
                              top: 16.0,
                              bottom: 16.0,
                              left: 16.0,
                              right: 16.0
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: SizedBox()
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Consumer<EcommerceProvider>(
                                    builder: (_, notifier, __) {
                                      return CustomButton(
                                        onTap: notifier.payStatus == PayStatus.loading 
                                        ? () {} 
                                        : () async {
                                          if(notifier.getShippingAddressDefaultStatus == GetShippingAddressDefaultStatus.error) {
                                            ShowSnackbar.snackbar("Anda belum memilih Alamat Utama", "", ColorResources.error);
                                            return;
                                          }

                                          if(notifier.courierNameSelect == "") {
                                            ShowSnackbar.snackbar("Anda belum pilih Pengiriman", "", ColorResources.error);
                                            return;
                                          }
                                          
                                          if(notifier.channelId == -1) {
                                            ShowSnackbar.snackbar("Anda belum memilih Metode Pembayaran", "", ColorResources.error);
                                            return;
                                          }
      
                                          await ep.pay(
                                            amount: ep.checkoutListData.totalPerStuff!,
                                            cost: ep.checkoutListData.totalCost!,
                                            from: widget.from
                                          );
                                        },
                                        isBorder: false,
                                        isBoxShadow: false,
                                        isBorderRadius: true,
                                        sizeBorderRadius: 30.0,
                                        isLoading: notifier.payStatus == PayStatus.loading 
                                        ? true 
                                        : false,
                                        btnColor: ColorResources.purple,
                                        btnTxt: "Bayar",
                                      );
                                    },
                                  )
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
      ),
    );
  }
}