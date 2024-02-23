import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/views/basewidgets/preview/preview.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/data/models/feed/feedmedia.dart';

class PostImage extends StatefulWidget {
  final bool isDetail;
  final List<FeedMedia> medias;
  final String caption;

  const PostImage(
    this.isDetail,
    this.medias,
    this.caption, 
    {Key? key}
  ) : super(key: key);

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    
    if(widget.medias.length > 3 && !widget.isDetail) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
            child: ReadMoreText(widget.caption,
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault,
              ),
              trimLines: 2,
              colorClickableText: ColorResources.black,
              trimMode: TrimMode.Line,
              trimCollapsedText: getTranslated("READ_MORE", context),
              trimExpandedText: getTranslated("LESS_MORE", context),
              moreStyle: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault, 
                fontWeight: FontWeight.w600
              ),
              lessStyle: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault, 
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          
          const SizedBox(height: 8.0),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: "${AppConstants.baseUrlImg}${widget.medias.first.path}",
                  imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                    height: 200.0,
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
                      height: 200.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
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
                        height: 200.0,
                        color: ColorResources.white
                      )  
                    );
                  } 
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
                          imageUrl: "${AppConstants.baseUrlImg}${widget.medias[1].path}",
                          imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                            height: 200.0,
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
                              height: 200.0,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
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
                                height: 200.0,
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
                      imageUrl: "${AppConstants.baseUrlImg}${widget.medias[2].path}",
                      imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                        height: 200.0,
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
                          height: 200.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
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
                            height: 200.0,
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

    if(widget.medias.length > 3 && widget.isDetail) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
            child: ReadMoreText(widget.caption,
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault,
              ),
              trimLines: 2,
              colorClickableText: ColorResources.black,
              trimMode: TrimMode.Line,
              trimCollapsedText: getTranslated("READ_MORE", context),
              trimExpandedText: getTranslated("LESS_MORE", context),
              moreStyle: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault, 
                fontWeight: FontWeight.w600
              ),
              lessStyle: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault, 
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          
          const SizedBox(height: 8.0),

          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (int i, CarouselPageChangedReason reason) {
               setState(() => current = i);
              }
            ),
            items: widget.medias.map((i) {
              return InkWell(
                onTap: () {
                  NS.push(context, PreviewImageScreen(
                    img: '${AppConstants.baseUrlImg}${i.path}',
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
                              Directory documentsIos = await getApplicationDocumentsDirectory();
                              String? saveDir = Platform.isIOS ? documentsIos.path : await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                            
                              NS.pop(context);
                              ShowSnackbar.snackbar(context, "Gambar telah disimpan pada $saveDir", "", ColorResources.success);
                            },
                            child: Text("Unduh Gambar", 
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault
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
                  imageUrl: "${AppConstants.baseUrlImg}${i.path}",
                  imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                    height: 200.0,
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
                      height: 200.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
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
                        height: 200.0,
                        color: ColorResources.white
                      )  
                    );
                  } 
                ),
              );
            }).toList(),
          ),
          
          Row(
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
    
    if(widget.medias.length == 3 && widget.isDetail) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
            child: ReadMoreText(widget.caption,
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault,
              ),
              trimLines: 2,
              colorClickableText: ColorResources.black,
              trimMode: TrimMode.Line,
              trimCollapsedText: getTranslated("READ_MORE", context),
              trimExpandedText: getTranslated("LESS_MORE", context),
              moreStyle: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault, 
                fontWeight: FontWeight.w600
              ),
              lessStyle: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault, 
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          
          const SizedBox(height: 8.0),

          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (int i, CarouselPageChangedReason reason) {
               setState(() => current = i);
              }
            ),
            items: widget.medias.map((i) {
              return InkWell(
                onTap: () {
                  NS.push(context, PreviewImageScreen(
                    img: '${AppConstants.baseUrlImg}${i.path}',
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
                              Directory documentsIos = await getApplicationDocumentsDirectory();
                              String? saveDir = Platform.isIOS ? documentsIos.path : await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                            
                              NS.pop(context);
                              ShowSnackbar.snackbar(context, "Gambar telah disimpan pada $saveDir", "", ColorResources.success);
                            },
                            child: Text("Unduh Gambar", 
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault
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
                  imageUrl: "${AppConstants.baseUrlImg}${i.path}",
                  imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                    height: 200.0,
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
                      height: 200.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
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
                        height: 200.0,
                        color: ColorResources.white
                      )  
                    );
                  } 
                ),
              );
            }).toList(),
          ),
          
          Row(
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

    if(widget.medias.length > 3 && !widget.isDetail || widget.medias.length > 1 && !widget.isDetail) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
            child: ReadMoreText(widget.caption,
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault,
              ),
              trimLines: 2,
              colorClickableText: ColorResources.black,
              trimMode: TrimMode.Line,
              trimCollapsedText: getTranslated("READ_MORE", context),
              trimExpandedText: getTranslated("LESS_MORE", context),
              moreStyle: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault, 
                fontWeight: FontWeight.w600
              ),
              lessStyle: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault, 
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          
          const SizedBox(height: 8.0),

          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (int i, CarouselPageChangedReason reason) {
               setState(() => current = i);
              }
            ),
            items: widget.medias.map((i) {
              return InkWell(
                onTap: () {
                  NS.push(context, PreviewImageScreen(
                    img: '${AppConstants.baseUrlImg}${i.path}',
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
                              Directory documentsIos = await getApplicationDocumentsDirectory();
                              String? saveDir = Platform.isIOS ? documentsIos.path : await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                            
                              NS.pop(context);
                              ShowSnackbar.snackbar(context, "Gambar telah disimpan pada $saveDir", "", ColorResources.success);
                            },
                            child: Text("Unduh Gambar", 
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault
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
                  imageUrl: "${AppConstants.baseUrlImg}${i.path}",
                  imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                    height: 200.0,
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
                      height: 200.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
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
                        height: 200.0,
                        color: ColorResources.white
                      )  
                    );
                  } 
                ),
              );
            }).toList(),
          ),
          
          Row(
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
          width: 250.0,
          child: ReadMoreText(widget.caption,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.black
            ),
            trimLines: 2,
            colorClickableText: ColorResources.black,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Tampilkan Lebih',
            trimExpandedText: 'Tutup',
            moreStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.black,
              fontWeight: FontWeight.w600
            ),
            lessStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.black,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        InkWell(
          onTap: () {
            NS.push(context, PreviewImageScreen(
              img: '${AppConstants.baseUrlImg}${widget.medias[0].path}',
            ));
          },
          onLongPress: () {
            showAnimatedDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext ctx) {
                return Dialog(
                  child: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                  child: StatefulBuilder(
                    builder: (BuildContext c, Function s) {
                      return ElevatedButton(
                        onPressed: () async { 
                          ProgressDialog pr = ProgressDialog(context: context);
                          try {
                            PermissionStatus status = await Permission.storage.request();
                            if(!status.isGranted) {
                              await Permission.storage.request();
                            } 
                            pr.show(
                              max: 2,
                              msg: "Downloading..."
                            );
                            Response response = await Dio().get('${AppConstants.baseUrlImg}/${widget.medias[0].path}');
                            await ImageGallerySaver.saveImage(
                              Uint8List.fromList(response.data),
                              quality: 60,
                            );
                            pr.close();
                            NS.pop(context);
                            ShowSnackbar.snackbar(context, "Gambar telah disimpan di galeri", "", ColorResources.success);
                          } catch(_) {
                            pr.close();
                            ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
                          }
                        },
                        child: Text("Unduh Gambar", 
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        ),                           
                      );
                    }
                  ))
                );
              },
            );
          },
          child: CachedNetworkImage(
            imageUrl: "${AppConstants.baseUrlImg}${widget.medias[0].path}",
            imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
              return Container(
                width: double.infinity,
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            errorWidget: (BuildContext context, String url, dynamic _) {
              return Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                width: double.infinity,
                height: 200.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
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
                  color: ColorResources.grey,
                  height: 200.0,
                )  
              );
            }
          ),
        ),
      ]
    );
  }
}