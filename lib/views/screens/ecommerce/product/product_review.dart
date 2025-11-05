import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

class ProductReviewScreen extends StatefulWidget {
  final String transactionId;
  ProductReviewScreen({
    required this.transactionId,
    super.key
  });

  @override
  State<ProductReviewScreen> createState() => ProductReviewScreenState();
}

class ProductReviewScreenState extends State<ProductReviewScreen> {

  late EcommerceProvider ep;

  Future<void> getData() async {
    if(!mounted) return;
      await ep.fetchAllProductTransaction(transactionId: widget.transactionId);
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
      body: Consumer<EcommerceProvider>(
        builder: (__, notifier, _) {
          return CustomScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()
            ),
            slivers: [
          
              SliverAppBar(
                backgroundColor: ColorResources.white,
                title: Text("Ulasan",
                  style: robotoRegular.copyWith(
                    color: ColorResources.black,
                    fontSize: Dimensions.fontSizeDefault
                  ),
                ),
                centerTitle: true,
                leading: CupertinoNavigationBarBackButton(
                  color: Colors.black,
                  onPressed: () {
                    NS.pop();
                  },
                ),
              ),

              if(notifier.listProductTransactionStatus == ListProductTransactionStatus.loading)
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

              if(notifier.listProductTransactionStatus == ListProductTransactionStatus.error)
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

              if(notifier.listProductTransactionStatus == ListProductTransactionStatus.empty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text("Tidak ada produk yang di ulas",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault
                      ),
                    )
                  )
                ),

              if(notifier.listProductTransactionStatus == ListProductTransactionStatus.loaded)
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 30.0,
                    bottom: 30.0
                  ),
                  sliver: SliverList.separated(
                    separatorBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0
                        ),
                        child: Divider()
                      );
                    },
                    itemCount: notifier.productTransactions.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                CachedNetworkImage(
                                  imageUrl: notifier.productTransactions[i].medias.isEmpty 
                                  ? "https://dummyimage.com/300x300/000/fff" 
                                  : notifier.productTransactions[i].medias.first.path,
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      width: 45.0,
                                      height: 45.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
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
                                      width: 45.0,
                                      height: 45.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        image: DecorationImage(
                                          image: NetworkImage('https://dummyimage.com/300x300/000/fff'),
                                          fit: BoxFit.cover
                                        )
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(width: 10.0),

                                Text(notifier.productTransactions[i].title,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),

                              ],  
                            ),

                            const SizedBox(height: 10.0),
                        
                            TextField(    
                              controller: notifier.productTransactions[i].reviewC,
                              decoration: InputDecoration(
                                border: OutlineInputBorder()
                              ),
                              maxLength: 150,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black
                              ),
                              maxLines: 5,
                            ),
                        
                            const SizedBox(height: 10.0),
                        
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              
                                notifier.productTransactions[i].files.isEmpty 
                                ? Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => notifier.pickImage(
                                          context: context,
                                          i: i
                                        ),
                                        child: Container(
                                          height: 50.0,
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                            color: Colors.grey.withOpacity(0.5)
                                          ),
                                          child: Center(
                                            child: notifier.productTransactions[i].files.isEmpty
                                            ? Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey[600],
                                                size: 20.0,
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: FadeInImage(
                                                  fit: BoxFit.cover,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  image: FileImage(notifier.productTransactions[i].files.first),
                                                  placeholder: const AssetImage("assets/images/default_image.png")
                                                ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Upload Gambar Barang",
                                            style: TextStyle(
                                              fontSize: Dimensions.fontSizeSmall,
                                            )
                                          ),
                                          Text("Maksimum 5 gambar",
                                            style: TextStyle(
                                              fontSize: Dimensions.fontSizeSmall,
                                              color: ColorResources.hintColor
                                            )
                                          ),
                                        ],
                                      )
                                    ],
                                  ) 
                                : SizedBox(
                                    height: 50.0,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.zero,
                                      itemCount: notifier.productTransactions[i].files.length + 1,
                                      itemBuilder: (BuildContext context, int z) {
                                        if (z < notifier.productTransactions[i].files.length) {
                                          return Container(
                                            height: 50.0,
                                            width: 50.0,
                                            margin: const EdgeInsets.only(right: 4.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey[350]
                                            ),
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Center(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    child: FadeInImage(
                                                      fit: BoxFit.cover,
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                      image: FileImage(notifier.productTransactions[i].files[z]),
                                                      placeholder: const AssetImage("assets/images/default_image.png")
                                                    ),
                                                  ),
                                                ),
                                              Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    notifier.removeFile(i: i, z: z);
                                                  },
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: ColorResources.error,
                                                    size: 20.0,  
                                                  ),
                                                ),
                                              )
                                              ],
                                            )
                                          );
                                        } else {
                                          return GestureDetector(
                                            onTap: () async {
                                              if (notifier.productTransactions[i].files.length < 5) {
                                                await notifier.pickImage(
                                                  context: context, 
                                                  i: i
                                                );
                                              }
                                            },
                                            child: notifier.productTransactions[i].files.length >= 5 
                                            ? SizedBox()  
                                            : Container(
                                              height: 50.0,
                                              width: 50.0,
                                              margin: const EdgeInsets.only(right: 4.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0), 
                                                color:  Colors.grey[350]
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey[600],
                                                  size: 20.0,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            ),
                        
                            const SizedBox(height: 30.0),
                        
                            Center(
                              child: RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (double val) {
                                  notifier.onChangeRating(i: i, rating: val);
                                },
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Container(
                                  width: 80.0,
                                  height: 30.0,
                                  margin: EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0
                                  ),
                                  child: CustomButton(
                                    onTap: () async {
                                      ep.onSubmitLoadingReview(i: i);

                                      await ep.productReview(
                                        transactionId: widget.transactionId,
                                        productId: notifier.productTransactions[i].id,
                                        caption: notifier.productTransactions[i].reviewC.text,
                                        rating: notifier.productTransactions[i].rating,
                                        files: notifier.productTransactions[i].files,
                                      );

                                      ep.onSubmitLoadingReview(i: -1); 
                                    },
                                    isBoxShadow: false,
                                    isBorderRadius: true,
                                    isLoading: ep.submitLoadingReview == i
                                    ? true 
                                    : false,
                                    isBorder: false,
                                    btnTxt: "Submit",
                                  ),
                                )

                              ],
                            ),
                        
                          ],
                        ),
                      );
                    },
                  
                  ),
                )
          
            ],
          );
        }
      )
    );
  }
  
}