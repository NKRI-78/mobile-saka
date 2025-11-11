import 'package:flutter/material.dart';
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
  Future<void>? _initFuture;
  Object? _lastError;

  // ---------------- Lifecycle ----------------

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant PostVideoDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.media != oldWidget.media) {
      _reinitController();
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  // ---------------- Controller helpers ----------------

  void _disposeController() {
    final c = _controller;
    _controller = null;
    _initFuture = null;
    c?.removeListener(_noopListener);
    c?.dispose();
  }

  Future<void> _reinitController() async {
    _disposeController();
    setState(() => _lastError = null);
    _initController();
  }

  void _initController() {
    try {
      final uri = Uri.parse(widget.media);
      final c = VideoPlayerController.networkUrl(uri);
      c.addListener(_noopListener);

      _controller = c;
      _initFuture = c.initialize().then((_) async {
        c.setLooping(true);
        if (!mounted) return;
        setState(() {}); // render pertama setelah init
      }).catchError((e) {
        _lastError = e;
        if (mounted) setState(() {});
      });
    } catch (e) {
      _lastError = e;
      setState(() {});
    }
  }

  // Listener dummy agar ValueListenableBuilder update tanpa setState spam
  void _noopListener() {}

  // ---------------- Controls ----------------

  void _togglePlay() {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    if (c.value.isPlaying) {
      c.pause();
    } else {
      c.play();
    }
    // UI auto-rebuild via ValueListenableBuilder
  }

  // ---------------- UI helpers ----------------

  Widget _buildLoading({double height = 180}) {
    return SizedBox(
      height: height,
      child: const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2),
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
          const Text('Gagal memuat video.', style: TextStyle(fontWeight: FontWeight.w600)),
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
            onPressed: _reinitController,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorResources.primaryOrange,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

    if (_lastError != null) return _buildError();

    final c = _controller;
    if (c == null || _initFuture == null) return _buildLoading();

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) return _buildLoading();
        if (_lastError != null) return _buildError();
        if (!c.value.isInitialized) return _buildLoading();

        return Container(
          margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
          child: AspectRatio(
            aspectRatio: (c.value.aspectRatio == 0) ? (16 / 9) : c.value.aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Video + buffering overlay
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: c,
                    builder: (_, value, __) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: value.size.width,
                              height: value.size.height,
                              child: GestureDetector(
                                onTap: _togglePlay,
                                child: VideoPlayer(c),
                              ),
                            ),
                          ),
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

                  // Play/Pause overlay (hanya saat paused)
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: _togglePlay,
                        child: ValueListenableBuilder<VideoPlayerValue>(
                          valueListenable: c,
                          builder: (_, v, __) {
                            final showOverlay = !v.isPlaying;
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 160),
                              opacity: showOverlay ? 1.0 : 0.0,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorResources.primaryOrange,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    showOverlay ? Icons.play_arrow : Icons.pause,
                                    color: ColorResources.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
