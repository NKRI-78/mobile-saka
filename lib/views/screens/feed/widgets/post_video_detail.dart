import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

import 'package:saka/utils/color_resources.dart';

class PostVideoDetail extends StatefulWidget {
  final String media;

  const PostVideoDetail({
    super.key,
    required this.media,
  });

  @override
  State<PostVideoDetail> createState() => PostVideoDetailState();
}

class PostVideoDetailState extends State<PostVideoDetail>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  VideoPlayerController? _controller;
  bool _initializing = false;
  Object? _lastError;

  // ---------------- Lifecycle ----------------

  @override
  void initState() {
    super.initState();
    Future.microtask(_initializePlayer);
  }

  @override
  void didUpdateWidget(covariant PostVideoDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.media != oldWidget.media) {
      _reinitializePlayer();
    }
  }

  @override
  void dispose() {
    _removeListener();
    _controller?.dispose();
    super.dispose();
  }

  // ---------------- Init helpers ----------------

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
      final c = VideoPlayerController.networkUrl(uri);

      c.addListener(_onControllerUpdate);
      await c.initialize();
      c.setLooping(true);

      if (!mounted) {
        c.removeListener(_onControllerUpdate);
        await c.dispose();
        return;
      }

      setState(() {
        _controller = c;
      });
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      if (mounted) setState(() => _lastError = e);
    } finally {
      _initializing = false;
      if (mounted) setState(() {});
    }
  }

  void _removeListener() {
    _controller?.removeListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    // UI utama memakai ValueListenableBuilder; setState minimal untuk error/ready.
    setState(() {});
  }

  // ---------------- Controls ----------------

  void _togglePlay() {
    final c = _controller;
    if (c == null) return;
    if (c.value.isPlaying) {
      c.pause();
    } else {
      c.play();
    }
    // Tidak perlu setState manual; ValueListenableBuilder akan rebuild.
  }

  // ---------------- UI helpers ----------------

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

  // ---------------- Build ----------------

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_lastError != null) {
      return _buildError();
    }

    final c = _controller;
    if (c == null || !c.value.isInitialized) {
      return _buildLoading();
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10.0, left: 12.0, right: 12.0),
          child: AspectRatio(
            aspectRatio: c.value.aspectRatio == 0 ? 16 / 9 : c.value.aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: c,
                builder: (_, value, __) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Video
                      GestureDetector(
                        onTap: _togglePlay,
                        child: VideoPlayer(c),
                      ),

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

                      // Play/Pause button
                      Center(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            onTap: _togglePlay,
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.primaryOrange,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: ColorResources.white,
                              ),
                            ),
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
      ],
    );
  }
}
