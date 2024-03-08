import 'dart:io' as io;


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import 'package:saka/utils/color_resources.dart';


class PostVideo extends StatefulWidget {
  final String media;

  const PostVideo({
    Key? key, 
    required this.media,
  }) : super(key: key);

  @override
  _PostVideoState createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {

  VideoPlayerController? videoPlayerC;
  ChewieController? chewieC;
  
  Future<void> getData() async {
    if(mounted) {
      if(io.Platform.isAndroid) {
        videoPlayerC = VideoPlayerController.networkUrl(Uri.parse(widget.media))
        ..setLooping(false)
        ..initialize().then((_) {
          setState(() {});
        });
        chewieC = ChewieController(
          videoPlayerController: videoPlayerC!,
          aspectRatio: videoPlayerC!.value.aspectRatio,
          autoPlay: false,
          looping: false,
        );
      } else {
        videoPlayerC = VideoPlayerController.networkUrl(Uri.parse(widget.media))
        ..setLooping(false)
        ..initialize().then((_) {
          setState(() { });
        });
        chewieC = ChewieController(
          videoPlayerController: videoPlayerC!,
          aspectRatio: videoPlayerC!.value.aspectRatio,
          autoPlay: false,
          looping: false,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
     
    getData();
  }

  @override
  void dispose() {
    videoPlayerC!.dispose();
    chewieC!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            videoPlayerC != null
            ? Container(
                margin: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 30.0
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AspectRatio(
                      aspectRatio: videoPlayerC!.value.aspectRatio,
                      child: Chewie(
                        controller: chewieC!,
                      )
                    ),
                    // Positioned.fill(
                    //   child: GestureDetector(
                    //     behavior: HitTestBehavior.opaque,
                    //     onTap: () => videoPlayerC!.value.isPlaying 
                    //     ? videoPlayerC!.pause() 
                    //     : videoPlayerC!.play(),
                    //     child: Stack(
                    //       clipBehavior: Clip.none,
                    //       children: [
                    //         videoPlayerC!.value.isPlaying 
                    //         ? Container() 
                    //         : Container(
                    //             alignment: Alignment.center,
                    //             child: const Icon(
                    //               Icons.play_arrow,
                    //               color: ColorResources.white,
                    //               size: 80.0
                    //             ),
                    //           ),
                    //         Positioned(
                    //           bottom: 0.0,
                    //           left: 0.0,
                    //           right: 0.0,
                    //           child: VideoProgressIndicator(
                    //             videoPlayerC!,
                    //             allowScrubbing: true,
                    //           )
                    //         ),
                    //       ],
                    //     ),
                    //   )
                    // )
                  ],
                ),
            ) 
            : const SizedBox(
              height: 200,
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primaryOrange,
              ),
            ),
          ],
        ); 
      },
    );
  }
}

// import 'package:flutter/material.dart';

// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';

// import 'package:saka/utils/constant.dart';

// class VideoPlay extends StatefulWidget {
//   final String dataSource;
//   const VideoPlay({
//     required this.dataSource,
//     super.key
//   });

//   @override
//   State<VideoPlay> createState() => _VideoPlayState();
// }

// class _VideoPlayState extends State<VideoPlay> {

//   ChewieController? chewieC;
//   late VideoPlayerController videoC;
  
//   @override 
//   void initState() {
//     super.initState();
//     initializePlayer();
//   }

//   @override 
//   void dispose() {
//     videoC.dispose();
//     chewieC?.dispose();

//     super.dispose();
//   }

//   Future<void> initializePlayer() async {
//     videoC = VideoPlayerController.networkUrl(Uri.parse("${AppConstants.baseUrlFeedImg}${widget.dataSource}"));
    
//     await Future.wait([
//       videoC.initialize(),
//     ]);

//     chewieC = ChewieController(
//       videoPlayerController: videoC,
//       autoInitialize: true,
//       aspectRatio: videoC.value.aspectRatio,
//       autoPlay: false,
//       looping: false,
//     );

//     setState(() { });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return chewieC != null && chewieC!.videoPlayerController.value.isInitialized
//     ? AspectRatio(
//         aspectRatio: videoC.value.aspectRatio,
//         child: Chewie(
//           controller: chewieC!
//         ),
//       )
//     : Container();
//   }
// }