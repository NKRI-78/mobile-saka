import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/constant.dart';

import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';

/// Metadata sederhana untuk menempel di AudioSource.tag
class MediaMeta {
  const MediaMeta({
    required this.id,
    required this.title,
    required this.artist,
    required this.artUri, // asset path
  });

  final String id;
  final String title;
  final String artist;
  final String artUri;
}

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  bool get isLiveLike => duration == Duration.zero;
}

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final AudioPlayer _player = AudioPlayer();
  ConcatenatingAudioSource? _playlist;

  Object? _lastError;
  bool _initializing = false;

  double _volume = 1.0;
  bool _muted = false;

  static const _meta = MediaMeta(
    id: "airmen",
    title: "Airmen FM 107.9 MHz",
    artist: "Airmen FM 107.9 MHz",
    artUri: "assets/images/airmen.png",
  );

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, buffered, duration) =>
            PositionData(position, buffered, duration ?? Duration.zero),
      );

  Future<void> _init() async {
    if (_initializing) return;
    _initializing = true;
    _lastError = null;
    if (mounted) setState(() {});

    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
          Uri.parse(AppConstants.baseUrlAirmen),
          tag: _meta,
        ),
      ]);

      await _player.setAudioSource(_playlist!);
      await _player.setVolume(_volume);
      // Biarkan user menekan play sendiri.
    } catch (e) {
      _lastError = e;
    } finally {
      _initializing = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _retry() async {
    try {
      await _player.stop();
    } catch (_) {}
    _lastError = null;
    if (mounted) setState(() {});
    await _init();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final playing = _player.playing;
    if (playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _toggleMute() {
    setState(() {
      _muted = !_muted;
      _player.setVolume(_muted ? 0 : _volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final gradientTop = ColorResources.primaryOrange;
    final gradientBottom = ColorResources.primaryOrange.withOpacity(0.8);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.primaryOrange,
          leading: BackButton(
            color: ColorResources.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientTop, gradientBottom],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: _buildContentCard(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 30,
                spreadRadius: 4,
                offset: Offset(0, 12),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Artwork + judul
              if (_lastError != null)
                _ErrorBox(error: _lastError!, onRetry: _retry)
              else if (_initializing)
                const _LoadingArt()
              else
                _MetaBlock(meta: _meta),

              const SizedBox(height: 18),

              // Progress bar (auto-hide untuk live)
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (data == null || data.isLiveLike) {
                    return const SizedBox.shrink();
                  }
                  return ProgressBar(
                    barHeight: 8.0,
                    baseBarColor: Colors.white.withOpacity(0.35),
                    bufferedBarColor: Colors.white.withOpacity(0.5),
                    progressBarColor: Colors.white,
                    thumbColor: Colors.white,
                    timeLabelTextStyle: robotoRegular.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    progress: data.position,
                    buffered: data.bufferedPosition,
                    total: data.duration,
                    onSeek: _player.seek,
                  );
                },
              ),

              const SizedBox(height: 10),

              // Kontrol utama (play/pause/buffering)
              Controls(audioPlayer: _player),

              const SizedBox(height: 4),

              // Volume & tombol kecil
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SmallCircleButton(
                    icon: _muted ? Icons.volume_off : Icons.volume_up,
                    onTap: _toggleMute,
                    tooltip: _muted ? 'Unmute' : 'Mute',
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        thumbColor: Colors.white,
                        trackHeight: 3.5,
                      ),
                      child: Slider(
                        value: _muted ? 0 : _volume,
                        min: 0,
                        max: 1,
                        onChanged: (v) {
                          setState(() {
                            _volume = v;
                            _muted = v == 0;
                          });
                          _player.setVolume(v);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _SmallCircleButton(
                    icon: Icons.power_settings_new,
                    onTap: _togglePlay,
                    tooltip: 'Play/Pause',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Blok metadata (artwork + judul + artis) dengan ukuran adaptif
class _MetaBlock extends StatelessWidget {
  const _MetaBlock({required this.meta});
  final MediaMeta meta;

  @override
  Widget build(BuildContext context) {
    final titleStyle = robotoRegular.copyWith(
      color: Colors.white,
      fontSize: Dimensions.fontSizeLarge,
      fontWeight: FontWeight.w700,
    );
    final artistStyle = robotoRegular.copyWith(
      color: Colors.white.withOpacity(0.9),
      fontSize: Dimensions.fontSizeDefault,
      fontWeight: FontWeight.w500,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Max 320 di wide screen, auto mengecil di hp kecil
                final size = constraints.maxWidth.clamp(220.0, 320.0);
                return Image.asset(
                  meta.artUri,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(meta.title, style: titleStyle, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(meta.artist, style: artistStyle, textAlign: TextAlign.center),
      ],
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final processing = state?.processingState ?? ProcessingState.idle;
        final playing = state?.playing ?? false;

        // Loading / Buffering
        if (processing == ProcessingState.loading ||
            processing == ProcessingState.buffering) {
          return const _BigLoader();
        }

        // Tombol utama
        return _PlayPauseButton(
          isPlaying: playing && processing != ProcessingState.completed,
          onPlay: audioPlayer.play,
          onPause: audioPlayer.pause,
          onReplay: () => audioPlayer.seek(Duration.zero),
          isCompleted: processing == ProcessingState.completed,
        );
      },
    );
  }
}

/// Tombol besar dengan gaya melayang
class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    required this.isPlaying,
    required this.onPlay,
    required this.onPause,
    required this.onReplay,
    required this.isCompleted,
  });

  final bool isPlaying;
  final bool isCompleted;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      child: Container(
        key: ValueKey('${isPlaying}_$isCompleted'),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.white.withOpacity(0.18),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.white.withOpacity(0.08),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: isCompleted ? onReplay : (isPlaying ? onPause : onPlay),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                isCompleted
                    ? Icons.replay_rounded
                    : (isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                size: 76,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== Small UI widgets =====================

class _SmallCircleButton extends StatelessWidget {
  const _SmallCircleButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final btn = Material(
      color: Colors.white.withOpacity(0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.circle, size: 0), // placeholder untuk inkwell hit area
        ),
      ),
    );

    return Tooltip(
      message: tooltip ?? '',
      child: Stack(
        alignment: Alignment.center,
        children: [
          btn,
          Icon(icon, size: 22, color: Colors.white),
        ],
      ),
    );
  }
}

class _LoadingArt extends StatelessWidget {
  const _LoadingArt();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Placeholder cover
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const _BigLoader(),
        ),
        const SizedBox(height: 16),
        Text(
          'Memuat…',
          style: robotoRegular.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _BigLoader extends StatelessWidget {
  const _BigLoader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 48,
      height: 48,
      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 28, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            'Gagal memutar radio.',
            style: robotoRegular.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.fontSizeLarge,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '$error',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(
              color: Colors.white70,
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.15),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
