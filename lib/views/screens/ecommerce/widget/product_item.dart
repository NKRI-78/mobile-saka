import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:saka/data/models/ecommerce/product/all.dart';
import 'package:saka/utils/color_resources.dart';

import 'package:saka/utils/currency.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/bounce/gesture.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  
  const ProductItem({
    required this.product,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureBounce(
      onPress: () {

      },  
      child: Card(
        elevation: 0.80,
        color: const Color(0xffF1F1F1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
                                                    
            SizedBox(
              height: 120.0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  CachedNetworkImage(
                    imageUrl: product.medias.isNotEmpty 
                    ? product.medias.first.path 
                    : 'https://dummyimage.com/300x300/000/fff',
                    imageBuilder: (_, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitHeight
                          )
                        ),
                      );
                    },
                    placeholder: (_, __) {
                      return Center(
                        child: SizedBox(
                          width: 32.0,
                          height: 32.0,
                          child: CircularProgressIndicator.adaptive()
                        )
                      );
                    },
                    errorWidget: (_, __, ___) {
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
            
                ],
              ),
            ),
            
            Padding(
              padding: EdgeInsets.only(
                top: 8.0,
                left: 8.0, 
                right: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(product.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      Text(CurrencyHelper.formatCurrency(double.parse(product.price.toString())),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: ColorResources.black,
                          fontSize: Dimensions.fontSizeExtraSmall,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
    
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0
              ),
              child: Text(product.store.province,
                style: TextStyle(
                  fontSize: Dimensions.fontSizeSmall
                ),
              ),
            ),
    
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.star,
                    //       color: Color(0xffF39C12),
                    //       size: 15.0,
                    //     ),
                    //     const SizedBox(width: 5.0),
                    //     Text("0.0",
                    //       style: TextStyle(
                    //         fontSize: Dimensions.fontSizeExtraSmall
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // const VerticalDivider(
                    //   thickness: 0.5,
                    //   color: Color(0xff9E9E9E),
                    // ),
                    Text("Stok ${product.stock}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: Dimensions.fontSizeExtraSmall
                      ),
                    ),
                  ],
                ),
              ) 
            ),  

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [

                  Icon(
                    Icons.store,
                    size: 12.0,
                  ),

                  const SizedBox(width: 4.0),

                  Text(product.store.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall
                    ),
                  )

                ],
              )
            )
    
          ],
        )
      ),
    ); 
  }
}