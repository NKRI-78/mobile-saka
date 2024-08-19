import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:external_path/external_path.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';

class PreviewForumImageScreen extends StatefulWidget {
  final String? username;
  final String? caption;
  final List<dynamic>? medias;
  final int? id;

  const PreviewForumImageScreen({
    this.username,
    this.caption,
    this.medias,
    this.id,
    Key? key, 
  }) : super(key: key);

  @override
  PreviewForumImageScreenState createState() => PreviewForumImageScreenState();
}

class PreviewForumImageScreenState extends State<PreviewForumImageScreen> {

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
      bottomNavigationBar: Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0)
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              margin: const EdgeInsets.only(
                top: 15.0,
                left: 15.0,
              ),
              child: Text(widget.username!,
                style: const TextStyle(
                  fontSize: Dimensions.fontSizeExtraLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(
                top: 15.0,
                left: 15.0,
              ),
              child: Text(widget.caption!,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Colors.white
                ),
              ),
            )

          ],
        )
      ),
      appBar: AppBar(
        backgroundColor:ColorResources.transparent,
        forceMaterialTransparency: true,
        centerTitle: true,
        toolbarHeight: 70.0,
        title: Text("PICTURE ( ${current + 1} / ${widget.medias!.length} )",
          style: poppinsRegular.copyWith(
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
                              String? saveDir = Platform.isIOS 
                              ? documentsIos.path 
                              : await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                              Navigator.pop(context);
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