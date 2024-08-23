import 'dart:io';
import 'dart:typed_data';

import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import 'package:saka/providers/feedv2/feed.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

class CreatePostVideoScreen extends StatefulWidget {
  final Uint8List? thumbnail;
  final File? file;
  final String? groupId;
  final String? videoSize; 
  const CreatePostVideoScreen({
    Key? key, 
    this.thumbnail,
    this.file,
    this.groupId,
    this.videoSize
  }) : super(key: key);
  @override
  CreatePostVideoScreenState createState() => CreatePostVideoScreenState();
}

class CreatePostVideoScreenState extends State<CreatePostVideoScreen> {
  late VideoPlayerController videoPlayerController;
  late FeedProviderV2 fdv2;

  File? fileX;
  double? progress;

  @override
  void initState() {
    super.initState();
    fdv2 = context.read<FeedProviderV2>();
    fdv2.postC = TextEditingController();
    setState(() {
      fileX = File(widget.file!.path);
    });
    videoPlayerController = VideoPlayerController.file(fileX!);
  }

  @override
  void dispose() {
    fdv2.postC.dispose();
    videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [

          SliverAppBar(
            centerTitle: false,
            floating: true, 
            backgroundColor: ColorResources.white,
            title: Text(getTranslated("CREATE_POST", context), 
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.black 
              )
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: ColorResources.black,
              ),
              onPressed: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading ? () {} : () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              Container(
                margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading ? () {} : () async {
                       
                        File f = File(fileX!.path);
                        fdv2.feedType = "video";
                        await fdv2.postVideo(context, "video", f);
                      },
                      child: Container(
                        width: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading ? null : 80.0,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: ColorResources.primaryOrange,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading 
                        ? const Loader(
                            color: ColorResources.white,
                          ) 
                        : Text('Post',
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeSmall
                          ),
                        ),
                      ),
                    )
                  ]
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(
                top: 10.0, 
                left: 16.0, 
                right: 16.0
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: Dimensions.marginSizeDefault, 
                      bottom: Dimensions.marginSizeDefault
                    ),
                    height: 185.0,
                    child: displaySingleVideo()
                  ),
                  TextField(
                    maxLines: null,
                    controller: fdv2.postC,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                    decoration: InputDecoration(
                      labelText: "Caption",
                      labelStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Colors.grey
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey, 
                          width: 0.5
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey, 
                          width: 0.5
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            )
          )
        ]
      ),
    );
  }

  Widget displaySingleVideo() {
    int progressBar = progress == null ? 0 : (progress!).toInt(); 
    return widget.thumbnail == null && widget.videoSize == null ? const CircularProgressIndicator()
    : Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.memory(
          widget.thumbnail!, 
          height: 100.0
        ),
        const SizedBox(height: 10.0),
        Text("${getTranslated("FILE_SIZE", context)}: ${widget.videoSize.toString()}",
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall
          ),
        ),
        const SizedBox(height: 10.0),
        Text(progressBar.toString() == "0" 
        ? ""
        : "${progressBar.toString()} %",
          style: robotoRegular.copyWith(
            color: ColorResources.success,
            fontSize: Dimensions.fontSizeSmall,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );  
  }

}