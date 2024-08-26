import 'dart:io' as io;
import 'dart:typed_data';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/file_storage.dart';
import 'package:video_player/video_player.dart';

class PostVideo extends StatefulWidget {
  final String media;
  const PostVideo({
    super.key, 
    required this.media,
  });

  @override
  State<PostVideo> createState() => PostVideoState();
}

class PostVideoState extends State<PostVideo> {

  VideoPlayerController? videoC;
  ChewieController? chewieC;

  int total = 0;
  int received = 0;

  bool finishDownload = false;

  late http.StreamedResponse response;

  final List<int> bytes = [];
  
  Future<void> initializePlayer() async {
    String originName = p.basename(widget.media.split('/').last).split('.').first;
    String ext = p.basename(widget.media).toString().split('.').last;

    String filename = "${DateFormat('yyyydd').format(DateTime.now())}-$originName.$ext";

    bool isExistFile = await FileStorage.checkFileExist(filename);

    if(!isExistFile) {
      response = await http.Client().send(http.Request('GET', Uri.parse(widget.media)));
    
      total = response.contentLength ?? 0;

      response.stream.listen((value) {
        if(!mounted) return;
          setState(() {
            bytes.addAll(value);
            received += value.length;
          });
      }).onDone(() async {
        Uint8List uint8List = Uint8List.fromList(bytes);

        await FileStorage.saveFile(uint8List, filename);

        String fileToPlay = await FileStorage.getFileFromAsset(filename);
          
        videoC = VideoPlayerController.file(io.File(fileToPlay))
          ..initialize().then((_) {
          if(!mounted) return;
            setState(() {
              finishDownload = true;

              chewieC = ChewieController(
                videoPlayerController: videoC!,
                aspectRatio: videoC?.value.aspectRatio,
                autoPlay: false,
                looping: false,
              );
            });
        });
      });

      // Create a ByteBuilder to accumulate bytes
      // BytesBuilder byteBuilder = BytesBuilder();

      // Listen to the stream and accumulate bytes
      // await for (List<int> chunk in response.stream) {
      //   byteBuilder.add(chunk);
      // }

      // Get the final bytes
      // Uint8List resultBytes = byteBuilder.toBytes();

    } else {
      playMediaFromAsset(filename);
    }
  }

  Future<void> playMediaFromAsset(String filename) async {
    String fileToPlay = await FileStorage.getFileFromAsset(filename);

    videoC = VideoPlayerController.file(io.File(fileToPlay))
      ..initialize().then((_) {
      setState(() {
        finishDownload = true;

        chewieC = ChewieController(
          videoPlayerController: videoC!,
          aspectRatio: videoC?.value.aspectRatio,
          autoPlay: false,
          looping: false,
        );
      });
    });    
  }

  @override 
  void initState() {
    super.initState();

    Future.microtask(() => initializePlayer());
  }

  @override 
  void dispose() {
    videoC?.dispose();
    chewieC?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return finishDownload && chewieC != null && chewieC!.videoPlayerController.value.isInitialized
    ? Container(
        margin: EdgeInsets.only(
          top: 10.0,
          left: 12.0,
          right: 12.0
        ),
        child: AspectRatio(
          aspectRatio: videoC!.value.aspectRatio,
          child: ClipRRect(
            borderRadius:  BorderRadius.circular(10.0),
            child: Chewie(
              controller: chewieC!
            ),
          ),
        ),
    )
    : SizedBox(
        height: 80.0,
        child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            
            Text("${(received / total * 100).isNaN || (received / total * 100).isInfinite ? '0' : (received / total * 100).toStringAsFixed(2)}%",
              style: TextStyle(
                color: ColorResources.primaryOrange,
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(width: 12.0),

            SpinKitChasingDots(
              color: ColorResources.primaryOrange,
            )

          ],
        )
      ),
    );
  }
}