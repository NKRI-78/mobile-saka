import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:saka/utils/color_resources.dart';

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

class PostVideoState extends State<PostVideo>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  VideoPlayerController? _controller;
  bool _initializing = false;
  Object? _lastError;

  // --- Lifecycle -------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    // Tunda 1 microtask agar context siap, lalu init.
    Future.microtask(_initializePlayer);
  }

  @override
  void didUpdateWidget(covariant PostVideo oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Jika URL video berubah -> re-init
    if (widget.media != oldWidget.media) {
      _reinitializePlayer();
      return; // biar nggak langsung proses blok di bawah sebelum siap
    }

    // Sinkronkan play/pause dengan kontrol eksternal
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller?.play();
      } else {
        _controller?.pause();
      }
    }
  }

  @override
  void dispose() {
    _removeListener();
    _controller?.dispose();
    super.dispose();
  }

  // --- Init helpers ----------------------------------------------------------

  Future<void> _reinitializePlayer() async {
    _removeListener();
    await _controller?.dispose();
    _controller = null;
    if (mounted) setState(() => _lastError = null);
    await _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (_initializing) return;
    _initializing = true;
    _lastError = null;

    try {
      final uri = Uri.parse(widget.media);
      final controller = VideoPlayerController.networkUrl(uri);

      controller.addListener(_onControllerUpdate);
      await controller.initialize();

      // Optional: set preferensi default
      controller.setLooping(true);
      if (widget.isPlaying) {
        // Mulai sesuai state eksternal saat selesai init
        await controller.play();
      } else {
        await controller.pause();
      }

      if (!mounted) {
        controller.removeListener(_onControllerUpdate);
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
      });
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      if (mounted) setState(() => _lastError = e);
    } finally {
      _initializing = false;
      if (mounted) setState(() {}); // segarkan UI
    }
  }

  void _removeListener() {
    _controller?.removeListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    // Minimalkan rebuild; gunakan setState ringan hanya saat mounted
    if (!mounted) return;
    // Hindari setState spam: video_player memanggil listener cukup sering.
    // Tetapi di sini kita tidak heavy rebuild (UI pakai ValueListenableBuilder),
    // setState kecil untuk kasus error/ready sudah cukup.
    setState(() {});
  }

  // --- Visibility ------------------------------------------------------------

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 0.0) {
      _controller?.pause();
    }
  }

  // --- UI Helpers ------------------------------------------------------------

  Widget _buildLoading({double height = 80}) {
    return SizedBox(
      height: height,
      child: Center(
        child: SpinKitChasingDots(
          color: ColorResources.primaryOrange,
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 28, color: Colors.redAccent),
          const SizedBox(height: 8),
          const Text(
            'Gagal memuat video.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            _lastError?.toString() ?? 'Terjadi kesalahan tak dikenal.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _reinitializePlayer,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorResources.primaryOrange,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _handleTapToggle() {
    // Optimistic update: responsif langsung
    final playing = _controller?.value.isPlaying ?? false;
    if (playing) {
      _controller?.pause();
      widget.onPause();
    } else {
      _controller?.play();
      widget.onPlay();
    }
  }

  // --- Build ----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_lastError != null) {
      return _buildError();
    }

    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      // Saat belum init, tampilkan loader
      return _buildLoading();
    }

    return VisibilityDetector(
      key: ValueKey('post-video-${widget.media}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Video area
          Container(
            margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio == 0
                  ? 16 / 9
                  : controller.value.aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: controller,
                  builder: (_, value, __) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        VideoPlayer(controller),

                        // Buffering overlay
                        if (value.isBuffering)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Play/Pause overlay button
          Positioned.fill(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _handleTapToggle,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 160),
                    opacity: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorResources.primaryOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        (controller.value.isPlaying && widget.isPlaying)
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: ColorResources.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
