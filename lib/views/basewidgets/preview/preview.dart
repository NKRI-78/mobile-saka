import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:saka/utils/color_resources.dart';

class PreviewImageScreen extends StatefulWidget {
  const PreviewImageScreen({
    Key? key, 
    this.img
  }) : super(key: key);
  final String? img;

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: ColorResources.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: 'Image',
          child: CachedNetworkImage(
            imageUrl: widget.img!,
            imageBuilder: (context, imageProvider) => PhotoView(
              initialScale: PhotoViewComputedScale.contained * 1.1,
              imageProvider: imageProvider,
            ),
            placeholder: (context, url) => Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey[200]!,
              child: Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                width: double.infinity,
                height: 200.0,
                color: Colors.grey
              )  
            ),
          ),
        )
      ),
    );
  }
}