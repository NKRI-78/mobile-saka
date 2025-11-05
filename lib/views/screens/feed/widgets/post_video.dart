
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:visibility_detector/visibility_detector.dart';

import 'package:flutter/material.dart';

import 'package:saka/utils/color_resources.dart';

import 'package:video_player/video_player.dart';

class PostVideo extends StatefulWidget {
  final String media;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onPause;

  const PostVideo({
    super.key, 
    required this.media,
    required this.isPlaying,
    required this.onPlay,
    required this.onPause,
  });

  @override
  State<PostVideo> createState() => PostVideoState();
}

class PostVideoState extends State<PostVideo> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isPlay = false;

  VideoPlayerController? videoC;

  @override
  void didUpdateWidget(PostVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.media != oldWidget.media) {
      reinitializePlayer();
    }

    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        videoC?.play();
      } else {
        videoC?.pause();
      }
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

  void onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 0.0) {
      videoC?.pause();
    }
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
                  child: widget.isPlaying
                  ? Icon(Icons.pause,
                      color: ColorResources.white,
                    )
                  : Icon(Icons.play_arrow,
                      color: ColorResources.white,
                    )
                ),
                onTap: widget.isPlaying ? widget.onPause : widget.onPlay,
              ),
            )
          )
        ),
    
      ],
    );
  }
}