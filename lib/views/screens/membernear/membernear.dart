import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/membernear/membernear.dart';
import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

class MemberNearScreen extends StatefulWidget {
  const MemberNearScreen({super.key});

  @override
  State<MemberNearScreen> createState() => MemberNearScreenState();
}

class MemberNearScreenState extends State<MemberNearScreen> {
  late final MembernearProvider _mp;
  final Completer<GoogleMapController> _mapsC = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _mp = context.read<MembernearProvider>();
    _getData();
  }

  Future<void> _getData() async {
    if (!mounted) return;
    await _mp.getMembernear(context);
  }

  LatLng _initialLatLng() {
    final lat = double.tryParse(Helper.prefs?.getString('lat') ?? '') ?? 0.0;
    final lng = double.tryParse(Helper.prefs?.getString('lng') ?? '') ?? 0.0;
    return LatLng(lat, lng);
  }

  int _calcCrossAxisCount(double width) {
    if (width >= 1280) return 8;
    if (width >= 1024) return 6;
    if (width >= 768) return 5;
    if (width >= 560) return 4;
    return 3; // aman untuk ponsel kecil
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: BackButton(
          color: ColorResources.white,
          onPressed: NS.pop,
        ),
        backgroundColor: ColorResources.brown,
        title: Text(
          getTranslated('MEMBER_NEARS', context),
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Map (proporsional, tidak fixed height)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: AspectRatio(
                aspectRatio: 16 / 9, // kurang-lebih 200px pada lebar ponsel, tapi responsif
                child: Selector<MembernearProvider, Set<Marker>>(
                  selector: (_, p) => p.markers.toSet(),
                  builder: (context, markers, _) {
                    return GoogleMap(
                      mapType: MapType.normal,
                      gestureRecognizers: {
                        Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()),
                      },
                      myLocationEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: _initialLatLng(),
                        zoom: 15,
                      ),
                      markers: markers,
                      onMapCreated: (controller) {
                        if (!_mapsC.isCompleted) _mapsC.complete(controller);
                        context.read<MembernearProvider>().googleMapC = controller;
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          // Address (di bawah peta, bukan overlay → bebas overflow)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Selector<MembernearProvider, String>(
                    selector: (_, p) => p.membernearAddress,
                    builder: (context, addr, _) => Text(
                      addr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Status: loading / empty / error
          SliverToBoxAdapter(
            child: Consumer<MembernearProvider>(
              builder: (context, provider, _) {
                final status = provider.membernearStatus;
                if (status == MembernearStatus.loading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(child: Loader(color: ColorResources.primaryOrange)),
                  );
                }
                if (status == MembernearStatus.empty) {
                  return _StatusBlock(
                    text: getTranslated('NO_MEMBER_AVAILABLE', context),
                  );
                }
                if (status == MembernearStatus.error) {
                  return _StatusBlock(
                    text: getTranslated('THERE_WAS_PROBLEM', context),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Grid members (sliver → fleksibel tinggi, tidak overflow)
          Consumer<MembernearProvider>(
            builder: (context, provider, _) {
              if (provider.membernearStatus != MembernearStatus.loaded) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              final items = provider.membernearData;

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _calcCrossAxisCount(w),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.2 / 1.5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final m = items[i];
                      return _MemberTile(
                        fullname: m.fullname,
                        avatarUrl: m.avatarUrl,
                        distanceText: _formatDistance(m.distance),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDistance(String raw) {
    final d = double.tryParse(raw) ?? 0.0;
    if (d <= 0) return '+- 0 Meters';
    if (d >= 1000) return '+- ${(d / 1000).toStringAsFixed(1)} KM';
    return '+- ${d.toStringAsFixed(1)} Meters';
  }
}

class _StatusBlock extends StatelessWidget {
  final String text;
  const _StatusBlock({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 8),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final String fullname;
  final String avatarUrl;
  final String distanceText;

  const _MemberTile({
    required this.fullname,
    required this.avatarUrl,
    required this.distanceText,
  });

  @override
  Widget build(BuildContext context) {
    // Gunakan Column fleksibel + Flexible agar teks tidak overflow
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CachedNetworkImage(
          imageUrl: avatarUrl,
          imageBuilder: (_, provider) => CircleAvatar(
            radius: 30,
            backgroundImage: provider,
          ),
          placeholder: (_, __) => const CircleAvatar(
            backgroundColor: ColorResources.white,
            radius: 30,
            child: Loader(color: ColorResources.primaryOrange),
          ),
          errorWidget: (_, __, ___) => Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: ColorResources.black, width: 0.5),
              borderRadius: BorderRadius.circular(50),
            ),
            child: SvgPicture.asset(
              'assets/images/svg/user.svg',
              width: 48,
              height: 48,
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Nama: biar anti overflow, pakai Flexible + TextAlign.center
        Flexible(
          child: Text(
            fullname,
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2, // kasih 2 baris biar lega
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),

        const SizedBox(height: 4),

        // Jarak: satu baris aman
        Text(
          distanceText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: robotoRegular.copyWith(
            color: Theme.of(context).hintColor,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
      ],
    );
  }
}

/// Disimpan bila dibutuhkan di tempat lain
class CustomClipPath extends CustomClipper<Path> {
  final double radius = 10.0;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 140);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 140);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
