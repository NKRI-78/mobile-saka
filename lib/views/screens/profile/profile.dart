// ignore_for_file: deprecated_member_use, unused_element, use_build_context_synchronously
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus2/image_gallery_saver_plus.dart';
import 'package:provider/provider.dart';

import 'package:saka/data/models/profile/profile.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/images.dart';

import 'package:saka/providers/profile/profile.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/views/screens/profile/edit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabC;

  // --- KTA capture ---
  final GlobalKey _ktaKey = GlobalKey();
  bool _savingKTA = false;

  // --- (opsional) ganti avatar / update profile ---
  final ImagePicker _picker = ImagePicker();
  File? _pickedFile;
  final ProfileData _profileData = ProfileData();

  int _tabbarIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabC = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabbarIndex != _tabC.index) {
          setState(() => _tabbarIndex = _tabC.index);
        }
      });
  }

  @override
  void dispose() {
    _tabC.dispose();
    super.dispose();
  }

  Future<void> _chooseProfileAvatar() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 500,
      maxWidth: 500,
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() => _pickedFile = File(picked.path));
    }
  }

  Future<void> _updateProfile(BuildContext context) async {
    _profileData.fullname =
        context.read<ProfileProvider>().userProfile.fullname;
    await context
        .read<ProfileProvider>()
        .updateProfile(context, _profileData, _pickedFile);
    ShowSnackbar.snackbar(
      getTranslated("UPDATE_ACCOUNT_SUCCESSFUL", context),
      "",
      Colors.green,
    );
    if (mounted) Navigator.of(context).pop();
  }

  // --- ANDROID-ONLY: minta izin galeri yang benar (storage untuk <=12, photos untuk 13+) ---
  Future<bool> _ensureAndroidGalleryPermission() async {
    if (!Platform.isAndroid) return true;

    // request keduanya; kalau salah satu granted → lanjut
    final statuses = await [Permission.storage, Permission.photos].request();

    final grantedAny = statuses.values.any((s) => s.isGranted);
    if (grantedAny) return true;

    final permanentlyDenied =
        statuses.values.any((s) => s.isPermanentlyDenied);

    if (permanentlyDenied) {
      ShowSnackbar.snackbar(
        getTranslated("PERMISSION_DENIED", context),
        getTranslated("OPEN_SETTINGS_TO_ALLOW_PERMISSION", context),
        Colors.red,
      );
      // buka settings supaya user bisa aktifkan izin
      await openAppSettings();
    } else {
      ShowSnackbar.snackbar(
        getTranslated("PERMISSION_DENIED", context),
        getTranslated("PLEASE_ALLOW_GALLERY_PERMISSION", context),
        Colors.red,
      );
    }
    return false;
  }

  Future<void> _downloadKTA() async {
    if (_savingKTA) return;
    try {
      setState(() => _savingKTA = true);

      // 1) Permission (prioritas Android)
      final ok = await _ensureAndroidGalleryPermission();
      if (!ok) return;

      // 2) Render RepaintBoundary
      final boundary = _ktaKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        ShowSnackbar.snackbar(
          getTranslated("ERROR", context),
          getTranslated("FAILED_RENDER_CARD", context),
          Colors.red,
        );
        return;
      }
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        ShowSnackbar.snackbar(
          getTranslated("ERROR", context),
          getTranslated("FAILED_BUILD_IMAGE", context),
          Colors.red,
        );
        return;
      }
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // 3) Save to gallery
      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 100,
        name: "KTA_${DateTime.now().millisecondsSinceEpoch}",
      );

      final isSuccess = (result['isSuccess'] == true) ||
          (result['filePath'] != null &&
              result['filePath'].toString().isNotEmpty);

      if (isSuccess) {
        ShowSnackbar.snackbar(
          getTranslated("SUCCESS", context),
          getTranslated("KTA_SAVED_TO_GALLERY", context),
          Colors.green,
        );
      } else {
        ShowSnackbar.snackbar(
          getTranslated("ERROR", context),
          getTranslated("FAILED_SAVE_KTA", context),
          Colors.red,
        );
      }
    } catch (e) {
      ShowSnackbar.snackbar(
        getTranslated("ERROR", context),
        e.toString(),
        Colors.red,
      );
    } finally {
      if (mounted) setState(() => _savingKTA = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = robotoRegular.copyWith(
      color: ColorResources.white,
      fontSize: Dimensions.fontSizeDefault,
    );

    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: ColorResources.brown,
        iconTheme: IconThemeData(color: ColorResources.white),
        title: Text(
          getTranslated("MY_PROFILE", context),
          style: titleStyle,
        ),
        actions: [
          if (_tabbarIndex == 1)
            IconButton(
              tooltip: getTranslated("DOWNLOAD_KTA", context),
              onPressed: _savingKTA ? null : _downloadKTA,
              icon: _savingKTA
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download_rounded),
              color: ColorResources.white,
            ),
        ],
        bottom: TabBar(
          controller: _tabC,
          indicatorColor: ColorResources.black,
          labelColor: ColorResources.white,
          unselectedLabelColor: Colors.white70,
          labelStyle:
              robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
          tabs: [
            Tab(text: getTranslated("PROFILE", context)),
            Tab(text: getTranslated("CARD_DIGITAL", context)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabC,
        children: [
          _profileTab(context),
          _digitalCardTab(context),
        ],
      ),
    );
  }

  // =========================
  // Tab 1: PROFILE
  // =========================
  Widget _profileTab(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _header(context),
        const SizedBox(height: 16),
        _profileFields(context),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            height: 36,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: ColorResources.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileEditScreen()),
              ),
              icon: Icon(Icons.edit, size: 16, color: ColorResources.white),
              label: Text(
                getTranslated("EDIT", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: ColorResources.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: _HeaderClipper(),
          child: Container(
            width: size.width,
            height: 110,
            color: ColorResources.brown,
          ),
        ),
        Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child: Consumer<ProfileProvider>(
            builder: (_, profileProvider, __) {
              final imageUrl = profileProvider.userProfile.profilePic ?? "";
              return _AvatarCircleCard(
                radius: 40,
                imageUrl: imageUrl,
                placeholderSvg: "assets/images/svg/user.svg",
              );
            },
          ),
        ),
        Positioned(
          bottom: -60,
          left: 0,
          right: 0,
          child: Center(
            child: Consumer<ProfileProvider>(
              builder: (_, profileProvider, __) {
                final text =
                    profileProvider.profileStatus == ProfileStatus.loading
                        ? "..."
                        : profileProvider.profileStatus == ProfileStatus.error
                            ? "..."
                            : (profileProvider.userProfile.fullname ?? "-");
                return Text(
                  text,
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    color: ColorResources.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _profileFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<ProfileProvider>(
        builder: (_, profileProvider, __) {
          final status = profileProvider.profileStatus;
          String textOr(String? v) {
            if (status == ProfileStatus.loading) return "...";
            if (status == ProfileStatus.error) return "...";
            return v?.isNotEmpty == true ? v! : "-";
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              _profileItem(
                context,
                "Lanud",
                textOr(profileProvider.userProfile.lanud),
              ),
              _profileItem(
                context,
                getTranslated("PROVINCE", context),
                textOr(profileProvider.userProfile.province),
              ),
              _profileItem(
                context,
                getTranslated("CITY", context),
                textOr(profileProvider.userProfile.city),
              ),
              _profileItem(
                context,
                getTranslated("ADDRESS", context),
                textOr(profileProvider.userProfile.address),
              ),
              _profileItem(
                context,
                getTranslated("FULL_NAME", context),
                textOr(profileProvider.userProfile.fullname),
              ),
              _profileItem(
                context,
                getTranslated("PHONE_NUMBER", context),
                textOr(profileProvider.getUserPhoneNumber),
              ),
              _profileItem(
                context,
                getTranslated("EMAIL", context),
                textOr(profileProvider.getUserEmail),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _profileItem(BuildContext context, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault)),
          const SizedBox(height: 6),
          Text(
            value,
            style: robotoRegular.copyWith(
              color: ColorResources.primaryOrange,
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
          const Divider(height: 20),
        ],
      ),
    );
  }

  // =========================
  // Tab 2: KTA (Digital Card)
  // =========================
  Widget _digitalCardTab(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.92;
    final avatarRadius = width * 0.14;
    final nameFont = width * 0.07;
    final noMemberFont = width * 0.045;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: RepaintBoundary(
          key: _ktaKey,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Card background
              Image.asset(
                Images.card,
                width: width,
                fit: BoxFit.cover,
              ),

              // Avatar: circular card yang pas dengan lingkaran
              Positioned(
                top: width * 0.09,
                left: width * 0.09,
                child: Consumer<ProfileProvider>(
                  builder: (_, provider, __) {
                    final url = provider.userProfile.profilePic ?? "";
                    return _AvatarCircleCard(
                      radius: avatarRadius,
                      imageUrl: url,
                      placeholderSvg: "assets/images/svg/user.svg",
                    );
                  },
                ),
              ),

              // Name + Member No
              Positioned(
                top: width * 0.26,
                right: 0,
                child: Consumer<ProfileProvider>(
                  builder: (_, notifier, __) {
                    final name = notifier.userProfile.fullname ?? "-";
                    final noMember = notifier.userProfile.noMember ?? "-";
                    return SizedBox(
                      width: width * 0.55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: robotoRegular.copyWith(
                              color: ColorResources.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: nameFont,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            noMember,
                            style: robotoRegular.copyWith(
                              color: ColorResources.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: noMemberFont,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================
// Circular Photo Card
// =========================
class _AvatarCircleCard extends StatelessWidget {
  final double radius;
  final String? imageUrl;
  final String? placeholderSvg;

  const _AvatarCircleCard({
    required this.radius,
    required this.imageUrl,
    this.placeholderSvg,
  });

  @override
  Widget build(BuildContext context) {
    // ketebalan ring dan stroke menyesuaikan radius agar selalu proporsional
    final ring = radius * 0.14; // outer white ring (card feel)
    final stroke = radius * 0.06; // inner white stroke di atas foto

    final totalSize = (radius * 2) + (ring * 2);
    final imageSize = (radius * 2);

    Widget buildImage(ImageProvider img) {
      return Container(
        width: totalSize,
        height: totalSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: radius * 0.35,
              offset: Offset(0, radius * 0.12),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: stroke,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: ClipOval(
            child: Image(
              image: img,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    Widget buildPlaceholder() {
      return Container(
        width: totalSize,
        height: totalSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: radius * 0.35,
              offset: Offset(0, radius * 0.12),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorResources.primaryOrange,
            border: Border.all(color: Colors.white, width: stroke),
          ),
          child: Center(
            child: placeholderSvg != null
                ? SvgPicture.asset(
                    placeholderSvg!,
                    color: Colors.white,
                    width: radius * 1.2,
                    height: radius * 1.2,
                  )
                : Icon(
                    Icons.person,
                    color: Colors.white,
                    size: radius * 1.2,
                  ),
          ),
        ),
      );
    }

    final url = (imageUrl ?? "").trim();
    if (url.isEmpty) return buildPlaceholder();

    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (_, img) => buildImage(img),
      placeholder: (_, __) => buildPlaceholder(),
      errorWidget: (_, __, ___) => buildPlaceholder(),
    );
  }
}

// =========================
// Header Clipper (hiasan)
// =========================
class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Bentuk V lembut
    final path = Path();
    path.lineTo(size.width * 0.5, size.height * 0.85);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
