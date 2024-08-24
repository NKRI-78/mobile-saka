import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PostVideo extends StatefulWidget {
  final String media;

  const PostVideo({
    Key? key, 
    required this.media,
  }) : super(key: key);

  @override
  PostVideoState createState() => PostVideoState();
}

class PostVideoState extends State<PostVideo> {

  VideoPlayerController? videoPlayerC;
  ChewieController? chewieC;
  
  Future<void> getData() async {
    if(!mounted) return;

    videoPlayerC = VideoPlayerController.networkUrl(Uri.parse(widget.media))
    ..setLooping(false)
    ..initialize().then((_) {
      if (mounted) {
        setState(() {
          chewieC = ChewieController(
            videoPlayerController: videoPlayerC!,
            aspectRatio: videoPlayerC!.value.aspectRatio,
            autoPlay: false,
            looping: false,
          );
        });
      }
    });
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

     if (chewieC == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 30.0,
            bottom: 30.0
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AspectRatio(
                aspectRatio: chewieC!.aspectRatio!,
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
        
      ],
    );
  }
}