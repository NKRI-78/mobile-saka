import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:hex/hex.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/feed/feed.dart';
import 'package:saka/container.dart';
import 'package:saka/data/repository/feed/feed.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/views/screens/dashboard/dashboard.dart';

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
  _CreatePostVideoScreenState createState() => _CreatePostVideoScreenState();
}

class _CreatePostVideoScreenState extends State<CreatePostVideoScreen> {
  late VideoPlayerController videoPlayerController;
  late TextEditingController captionC;

  File? fileX;
  double? progress;

  @override
  void initState() {
    super.initState();
    captionC = TextEditingController();
    setState(() {
      fileX = File(widget.file!.path);
    });
    videoPlayerController = VideoPlayerController.file(fileX!);
  }

  @override
  void dispose() {
    captionC.dispose();
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
              onPressed: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? () {} : () {
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
                      onTap: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? () {} : () async {
                        String caption = captionC.text;
                        if(caption.trim().isNotEmpty) {
                          if(caption.trim().length < 10) {
                            ShowSnackbar.snackbar(context, getTranslated("CAPTION_MINIMUM", context), "", ColorResources.error);
                            return;
                          }
                        }  
                        if(caption.trim().length > 1000) {
                          ShowSnackbar.snackbar(context, getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
                          return;
                        }
                        context.read<FeedProvider>().setStateWritePost(WritePostStatus.loading);
                        String? body = await getIt<FeedRepo>().getMediaKey(context); 
                        File f = File(fileX!.path);
                        Uint8List bytesFiles = f.readAsBytesSync();
                        String digestFile = sha256.convert(bytesFiles).toString();
                        String imageHash = base64Url.encode(HEX.decode(digestFile)); 
                        await getIt<FeedRepo>().uploadMedia(context, body!, imageHash, f);
                        await context.read<FeedProvider>().sendPostVideo(context, caption, f);
                        context.read<FeedProvider>().setStateWritePost(WritePostStatus.loaded);
                        NS.push(context, DashboardScreen(key: UniqueKey()));
                      },
                      child: Container(
                        width: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? null : 80.0,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: ColorResources.primaryOrange,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
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
                    controller: captionC,
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