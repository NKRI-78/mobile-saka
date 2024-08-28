
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/material.dart';

import 'package:saka/utils/color_resources.dart';

import 'package:video_player/video_player.dart';

class PostVideoDetail extends StatefulWidget {
  final String media;

  const PostVideoDetail({
    super.key, 
    required this.media,
  });

  @override
  State<PostVideoDetail> createState() => PostVideoDetailState();
}

class PostVideoDetailState extends State<PostVideoDetail> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isPlay = false;

  VideoPlayerController? videoC;

  @override
  void didUpdateWidget(PostVideoDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.media != oldWidget.media) {
      reinitializePlayer();
    }
  }

  Future<void> reinitializePlayer() async {
    await videoC?.dispose();
    await initializePlayer();
  }

  Future<void> initializePlayer() async {
    try {
      videoC = VideoPlayerController.networkUrl(Uri.parse(widget.media))
      ..addListener(updateState);
      await videoC!.initialize();
    } catch (e) {
      print('Error initializing video player: $e');
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

    void updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void play() {
    videoC?.play();

    setState(() {
      isPlay = true;
    });
  }

  void pause() {
    videoC?.pause();

    setState(() {
      isPlay = false;
    });
  }

  @override
  void initState() {
    super.initState();
    
    Future.microtask(() => initializePlayer());
  }

  @override
  void dispose() {
    videoC?.removeListener(updateState);
    videoC?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (videoC == null || !videoC!.value.isInitialized) {
      return SizedBox(
        height: 80.0,
        child: Center(
          child: SpinKitChasingDots(
            color: ColorResources.primaryOrange,
          ),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [

        Container(
          margin: const EdgeInsets.only(
            top: 10.0,
            left: 12.0,
            right: 12.0,
          ),
          child: AspectRatio(
            aspectRatio: videoC!.value.aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: VideoPlayer(videoC!),
            ),
          ),
        ),

        Positioned.fill(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: ColorResources.primaryOrange,
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: isPlay
                  ? Icon(Icons.pause,
                      color: ColorResources.white,
                    )
                  : Icon(Icons.play_arrow,
                      color: ColorResources.white,
                    )
                ),
                onTap: isPlay ? pause : play,
              ),
            )
          )
        ),

      ],
    );
  }
}