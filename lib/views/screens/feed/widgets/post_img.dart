

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/preview/preview.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class PostImage extends StatefulWidget {
  final String username;
  final String caption;
  final bool isDetail;
  final List medias;

  const PostImage(
    this.username,
    this.caption,
    this.isDetail,
    this.medias,
    {Key? key}
  ) : super(key: key);

  @override
  PostImageState createState() => PostImageState();
}

class PostImageState extends State<PostImage> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    
    if(widget.medias.length > 3 && !widget.isDetail) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          const SizedBox(height: 8.0),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    CachedNetworkImage(
                      imageUrl: "${widget.medias.first.path}",
                      imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (BuildContext context, String url, dynamic _) {
                        return Container(
                          margin: const EdgeInsets.all(0.0),
                          padding: const EdgeInsets.all(0.0),
                          width: double.infinity,
                          height: 150.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage("assets/images/logo/logo.png")
                            )
                          ),
                        );
                      },
                      placeholder: (BuildContext context, String url) {
                        return Shimmer.fromColors(
                          highlightColor: ColorResources.white,
                          baseColor: Colors.grey[200]!,
                          child: Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(0.0),
                            width: double.infinity,
                            height: 150.0,
                            color: ColorResources.white
                          )  
                        );
                      } 
                    ),

                    CachedNetworkImage(
                      imageUrl: "${widget.medias[1].path}",
                      imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (BuildContext context, String url, dynamic _) {
                        return Container(
                          margin: const EdgeInsets.all(0.0),
                          padding: const EdgeInsets.all(0.0),
                          width: double.infinity,
                          height: 150.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage("assets/images/logo/logo.png")
                            )
                          ),
                        );
                      },
                      placeholder: (BuildContext context, String url) {
                        return Shimmer.fromColors(
                          highlightColor: ColorResources.white,
                          baseColor: Colors.grey[200]!,
                          child: Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(0.0),
                            width: double.infinity,
                            height: 150.0,
                            color: ColorResources.white
                          )  
                        );
                      } 
                    ),

                  ],
                ),
              ),
              Expanded(
                child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [

                        CachedNetworkImage(
                          imageUrl: "${widget.medias[2].path}",
                          imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                            height: 150.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          errorWidget: (BuildContext context, String url, dynamic _) {
                            return Container(
                              margin: const EdgeInsets.all(0.0),
                              padding: const EdgeInsets.all(0.0),
                              width: double.infinity,
                              height: 150.0,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage("assets/images/logo/logo.png")
                                )
                              ),
                            );
                          },
                          placeholder: (BuildContext context, String url) {
                            return Shimmer.fromColors(
                              highlightColor: ColorResources.white,
                              baseColor: Colors.grey[200]!,
                              child: Container(
                                margin: const EdgeInsets.all(0.0),
                                padding: const EdgeInsets.all(0.0),
                                width: double.infinity,
                                height: 150.0,
                                color: ColorResources.white
                              )  
                            );
                          } 
                        ),

                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          bottom: 0.0,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            height: 200.0,
                            decoration:  BoxDecoration(
                              color: ColorResources.black.withOpacity(0.6)
                            ),
                            child: Text("Photos (+${widget.medias.length - 3})",
                              style: robotoRegular.copyWith(
                                color: ColorResources.white,
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          )
                        ),

                      ],
                    ),
                    CachedNetworkImage(
                      imageUrl: "${widget.medias[4].path}",
                      imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (BuildContext context, String url, dynamic _) {
                        return Container(
                          margin: const EdgeInsets.all(0.0),
                          padding: const EdgeInsets.all(0.0),
                          width: double.infinity,
                          height: 150.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage("assets/images/logo/logo.png")
                            )
                          ),
                        );
                      },
                      placeholder: (BuildContext context, String url) {
                        return Shimmer.fromColors(
                          highlightColor: ColorResources.white,
                          baseColor: Colors.grey[200]!,
                          child: Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(0.0),
                            width: double.infinity,
                            height: 150.0,
                            color: ColorResources.white
                          )  
                        );
                      } 
                    ),
                  ],
                ) 
              )
            ],
          )
        ]
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        
        const SizedBox(height: 8.0),

        CarouselSlider(
          options: CarouselOptions(
            height: 400.0,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            onPageChanged: (int i, CarouselPageChangedReason reason) {
              setState(() => current = i);
            }
          ),
          items: widget.medias.map((i) {
            return InkWell(
              onTap: () {
                NS.push(context, PreviewForumImageScreen(
                  id: current,  
                  username: widget.username,
                  caption: widget.caption,
                  medias: widget.medias,
                ));
              },
              onLongPress: () async {
                showAnimatedDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (ctx) {
                    return Dialog(
                      child: Container(
                      height: 50.0,
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                      child: StatefulBuilder(
                        builder: (BuildContext c, Function s) {
                        return ElevatedButton(
                          onPressed: () async { 
                            await GallerySaver.saveImage("${widget.medias.first.path}");
                            NS.pop(context);
                            ShowSnackbar.snackbar("Gambar telah disimpan pada galeri", "", ColorResources.success);
                          },
                          child: Text("Unduh Gambar", 
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.black
                            ),
                          ),                           
                        );
                      })
                      )
                    );
                  },
                );
              },
              child: CachedNetworkImage(
                imageUrl: "${i.path}",
                imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                  height: 400.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                errorWidget: (BuildContext context, String url, dynamic _) {
                  return Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    width: double.infinity,
                    height: 400.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/images/logo/logo.png")
                      )
                    ),
                  );
                },
                placeholder: (BuildContext context, String url) {
                  return Shimmer.fromColors(
                    highlightColor: ColorResources.white,
                    baseColor: Colors.grey[200]!,
                    child: Container(
                      margin: const EdgeInsets.all(0.0),
                      padding: const EdgeInsets.all(0.0),
                      width: double.infinity,
                      height: 400.0,
                      color: ColorResources.white
                    )  
                  );
                } 
              ),
            );
          }).toList(),
        ),
        
        widget.medias.length == 1 
        ? const SizedBox() 
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.medias.map((i) {
            int index = widget.medias.indexOf(i);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current == index
                  ? ColorResources.primaryOrange
                  : ColorResources.dimGrey,
              ),
            );
          }).toList(),
        ),

      ],
    );
  }
}