import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:saka/services/navigation.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/images.dart';
import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
import 'package:saka/views/screens/radio/radio.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  // Konfigurasi item media
  static const double _iconSize = 32;

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      final ok = await canLaunchUrl(uri);
      if (!ok) {
        _showError(context, 'Tidak bisa membuka tautan.');
        return;
      }
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showError(context, 'Gagal membuka tautan.');
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Terjadi kesalahan: $e');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(title: 'Media', isBackButtonExist: false),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: ListView.separated(
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _MediaCard(
                            leadingAsset: Images.instagram,
                            leadingSize: _iconSize,
                            title: 'Pusterau',
                            onTap: () => _openUrl(
                              context,
                              'https://www.instagram.com/pusterau/',
                            ),
                          );
                        case 1:
                          return _MediaCard(
                            leadingAsset: Images.youtube,
                            leadingSize: _iconSize + 4,
                            title: 'CIGAR TV',
                            onTap: () => _openUrl(
                              context,
                              'https://www.youtube.com/channel/UCmGTuRzUU7JkEQ5tKGMZwKw/featured',
                            ),
                          );
                        default:
                          return _MediaCard(
                            leadingAsset: Images.radio,
                            leadingSize: _iconSize + 3,
                            title: 'AIRMEN FM 107.9 MHz',
                            onTap: () => NS.push(context, const RadioScreen()),
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu media generik agar UI konsisten & mudah di-reuse.
class _MediaCard extends StatelessWidget {
  final String leadingAsset;
  final double leadingSize;
  final String title;
  final VoidCallback onTap;

  const _MediaCard({
    required this.leadingAsset,
    required this.leadingSize,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: Image.asset(
              leadingAsset,
              width: leadingSize,
              height: leadingSize,
              fit: BoxFit.contain,
            ),
            title: Text(
              title,
              style: robotoRegular,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
