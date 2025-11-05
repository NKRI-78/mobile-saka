
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_animated_dialog_updated/flutter_animated_dialog.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';

class PreviewReviewImageScreen extends StatefulWidget {
  final List<dynamic>? medias;
  final int? id;

  const PreviewReviewImageScreen({
    this.medias,
    this.id,
    Key? key, 
  }) : super(key: key);

  @override
  PreviewReviewImageScreenState createState() => PreviewReviewImageScreenState();
}

class PreviewReviewImageScreenState extends State<PreviewReviewImageScreen> {

  bool loadingBtn = false;

  int current = 0;
  
  @override
  void initState() {
    super.initState();

    current = widget.id!;
  }
  
  @override
  void dispose() {  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:ColorResources.black,
      appBar: AppBar(
        backgroundColor:ColorResources.transparent,
        forceMaterialTransparency: true,
        centerTitle: true,
        toolbarHeight: 70.0,
        title: Text("PICTURE ( ${current + 1} / ${widget.medias!.length} )",
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: ColorResources.white
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(
            top: 12.0,
            bottom: 12.0,
            left: 15.0
          ),
          child: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.5),
            child: InkWell(
              borderRadius: BorderRadius.circular(50.0),
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.close, 
                  color: Colors.white, 
                ),
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              top: 12.0,
              bottom: 12.0,
              right: 15.0
            ),
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.5),
              child: InkWell(
                onTap: () {
                  showAnimatedDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) {
                      return Dialog(
                        child: Container(
                        height: 50.0,
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                        child: StatefulBuilder(
                          builder: (BuildContext context, Function setStateBuilder) {
                          return ElevatedButton(
                            onPressed: () async { 
                              // setStateBuilder(() => loadingBtn = true);
                              // await GallerySaver.saveImage("${widget.medias![current].path}");
                              // setStateBuilder(() => loadingBtn = false);
                              // Navigator.pop(context);
                              // ShowSnackbar.snackbar("Gambar telah disimpan pada galeri", "", ColorResources.success);
                            },
                            child: loadingBtn 
                            ? Text("Mohon tunggu...", 
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black
                              ))
                            : Text("Unduh Gambar", 
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black
                              ),
                            )
                          );
                        })
                        )
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.save, 
                  color: Colors.white, 
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            height: 400.0,
            enableInfiniteScroll: false,
            initialPage: current,
            viewportFraction: 1.0,
            onPageChanged: (int i, CarouselPageChangedReason reason) {
              setState(() => current = i);
            }
          ),
          items: widget.medias!.map((z) {
            return CachedNetworkImage(
              imageUrl: "${z.path}",
              imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
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
                    color: ColorResources.white
                  )  
                );
              } 
            );
          }).toList()
        )
      )
    );
  }
}