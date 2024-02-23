import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';

class MediaItem {
  const MediaItem({
    this.id,
    this.title,
    this.artist,
    this.artUri
  });

  final String? id;
  final String? title;
  final String? artist;
  final String? artUri;
}

class MediaMetaData extends StatelessWidget {
  const MediaMetaData({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist
  });

  final String imageUrl;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 4),
                blurRadius: 4
              ),
            ],
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(imageUrl,
              width: 300.0,
              height: 300.0,
              fit: BoxFit.cover,
            ),
          )
        ),
        const SizedBox(height: 20.0),
        Text(title, 
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 8.0),   
        Text(artist, 
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeSmall,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration
  );

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class RadioScreen extends StatefulWidget {
  const RadioScreen({ Key? key }) : super(key: key);

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  late AudioPlayer audioPlayer;

  final playlist = ConcatenatingAudioSource(
    children: [
      AudioSource.uri(
        Uri.parse(AppConstants.baseUrlAirmen),
        tag: MediaItem(
          id: "0",
          title: "Airmen FM 107.9 MHz",
          artist: "Airmen FM 107.9 MHz",
          artUri: "assets/images/airmen.png",
        )
      ),
    ],
  );

  Stream<PositionData> get positionDataStream => 
    Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      audioPlayer.positionStream,
      audioPlayer.bufferedPositionStream,
      audioPlayer.durationStream,
      (position, bufferedPosition, duration) => PositionData(
        position,
        bufferedPosition,
        duration ?? Duration.zero
      )
    );

  Future<void> init() async {
    await audioPlayer.setAudioSource(playlist);
  }

  @override 
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    init();
  }

  @override 
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ColorResources.primaryOrange,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
    
            CustomAppBar(title: "Radio"),
    
            Center(
              child: Container(
                margin: EdgeInsets.only(
                  left: 16.0, 
                  right: 16.0
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder<SequenceState?>(
                      stream: audioPlayer.sequenceStateStream,
                      builder: (BuildContext context, AsyncSnapshot<SequenceState?> snapshot) {
                        final state = snapshot.data;
                        if(state?.sequence.isEmpty ?? true) {
                          return const SizedBox();
                        }
                        final metaData = state!.currentSource!.tag as MediaItem;
                        return MediaMetaData(
                          title: metaData.title!,
                          artist: metaData.artist!,
                          imageUrl: metaData.artUri!,
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    StreamBuilder<PositionData>(
                      stream: positionDataStream,
                      builder: (BuildContext context, AsyncSnapshot<PositionData> snapshot) {
                        final positionData = snapshot.data;
                        return ProgressBar(
                          barHeight: 8.0,
                          baseBarColor: Colors.grey[600],
                          bufferedBarColor: Colors.grey,
                          progressBarColor: Colors.red,
                          thumbColor: Colors.red,
                          timeLabelTextStyle: poppinsRegular.copyWith(
                            color: ColorResources.white,
                            fontWeight: FontWeight.w600
                          ),
                          progress: positionData?.position ?? Duration.zero,
                          buffered: positionData?.bufferedPosition ?? Duration.zero,
                          total: positionData?.duration ?? Duration.zero,
                          onSeek: audioPlayer.seek,
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Controls(audioPlayer: audioPlayer)
                  ],
                ),
              ),
            ) 
          ],
        )
      ),
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioPlayer 
  });

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        final playerState = snapshot.data;
        final proccesingState = playerState?.processingState;
        final playing = playerState?.playing;
        if(!(playing ?? false)) {
          return IconButton(
            onPressed: audioPlayer.play, 
            iconSize: 80.0,
            color: ColorResources.white,
            icon: const Icon(Icons.play_arrow_rounded),
          );
        } else if(proccesingState != ProcessingState.completed) {
          return IconButton( 
            onPressed: audioPlayer.pause, 
            iconSize: 80.0,
            color: ColorResources.white,
            icon: const Icon(Icons.pause_rounded),
          );
        }
        return const Icon( 
          Icons.play_arrow_rounded,
          size: 80.0,
          color: ColorResources.white,
        ); 
      },
    );
  }
}