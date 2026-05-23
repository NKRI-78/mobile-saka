import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'package:saka/providers/splash/splash.dart';
import 'package:saka/providers/auth/auth.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/images.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/screens/auth/sign_in.dart';
import 'package:saka/views/screens/dashboard/dashboard.dart';
import 'package:saka/views/screens/onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  // ======= BOOTSTRAP =======
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Tunda sampai frame pertama supaya aman akses context/provider.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissionsSafely();
      await _loadPackageInfo();

      // optional: tampilkan TnC hanya saat belum accept (contoh logic tersimpan)
      // final isAccepted = Helper.prefs?.getBool('isAccept') ?? false;
      // if (!isAccepted && mounted) termsAndCondition();

      final ok = await context.read<SplashProvider>().initConfig();
      if (!mounted) return;

      if (ok) {
        // Delay splash 2 detik seperti semula
        Timer(const Duration(seconds: 2), () {
          if (!mounted) return;
          final isLoggedIn = context.read<AuthProvider>().isLoggedIn();
          if (isLoggedIn) {
            NS.pushReplacement(context, DashboardScreen());
          } else {
            if (context.read<SplashProvider>().isSkipOnboarding()) {
              NS.pushReplacement(context, SignInScreen());
            } else {
              NS.push(context, OnBoardingScreen(
                indicatorColor: ColorResources.grey,
                selectedIndicatorColor: ColorResources.primaryOrange,
              ));
            }
          }
        });
      }
    });
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() => _packageInfo = info);
    } catch (_) {/* biarkan Unknown */}
  }

  Future<void> _requestPermissionsSafely() async {
    // Lokasi via Geolocator agar punya handling lengkap (service + forever)
    await _ensureLocationPermission();

    // Izin lain via permission_handler
    final permissions = <Permission>[
      Permission.camera,
      Permission.microphone,
      Permission.notification,
      // Catatan: Permission.storage deprecated di Android 13+,
      // pertimbangkan gunakan Permission.photos atau manage external storage sesuai kebutuhan.
      Permission.storage,
    ];

    try {
      await permissions.request();
    } on PlatformException catch (e) {
      // Sering terjadi saat app baru start: "Unable to detect current Android Activity"
      // Retry sekali setelah frame berikutnya.
      if ((e.message ?? '').contains('Unable to detect current Android Activity')) {
        await Future.delayed(const Duration(milliseconds: 350));
        if (!mounted) return;
        try {
          await permissions.request();
        } catch (_) {
          // swallow, app tetap lanjut bootstrap
        }
      }
    } catch (_) {
      // swallow, app tetap lanjut bootstrap
    }
  }

  Future<void> _ensureLocationPermission() async {
    try {
      // Pastikan service lokasi aktif
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Tidak memaksa, hanya early return (bisa tampilkan dialog sendiri bila perlu)
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        // arahkan user ke settings jika ingin menggunakan fitur lokasi
        await openAppSettings();
      }
      // granted / whileInUse / always -> lanjut
    } on PlatformException {
      // Activity belum siap, abaikan agar splash tidak crash.
    } catch (_) {
      // swallow
    }
  }

  // ======= T&C DIALOG =======
  void termsAndCondition() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext ctx, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Center(
          child: Material(
            color: ColorResources.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              height: 580.0,
              decoration: BoxDecoration(
                color: ColorResources.brown,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0.0, left: 0.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset("assets/images/background/shading-top-left.png"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0.0, right: 0.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset("assets/images/background/shading-right.png"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 200.0, right: 0.0),
                      child: Image.asset("assets/images/background/shading-right-bottom.png"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "It's important that you understand what",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "information Saka Dirgantara collects.",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Some examples of data Saka Dirgantara\ncollects and uses are:",
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "● Your Forum Information & Content",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "This may include any information you share with us,\nfor example: you create a post, other users can like\nor comment; you can also delete your post.",
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "● Photos, Videos & Documents",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "This may include media you post:\nphotos, videos, or documents.",
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "● Embedded Links",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "This may include links you post (news, etc).",
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                      child: CustomButton(
                        isBorderRadius: true,
                        btnColor: ColorResources.brown,
                        btnTextColor: ColorResources.white,
                        onTap: () {
                          Helper.prefs?.setBool("isAccept", true);
                          NS.pop();
                        },
                        btnTxt: "Agree",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        final tween = Tween<Offset>(
          begin: anim.status == AnimationStatus.reverse ? const Offset(-1, 0) : const Offset(1, 0),
          end: Offset.zero,
        );
        return SlideTransition(
          position: tween.animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }

  // ======= UI =======
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: ColorResources.splash,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Logo atas
            const Positioned(
              top: 50.0,
              left: 0,
              right: 0,
              child: Center(
                child: Image(
                  image: AssetImage(Images.logo),
                  width: 120.0,
                  height: 120.0,
                ),
              ),
            ),

            // Ilustrasi tengah
            Positioned(
              top: size.height / 3,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  Images.splash,
                  height: size.height * .4,
                ),
              ),
            ),

            // Powered by
            Positioned(
              bottom: 120.0,
              left: 0,
              right: 0,
              child: Text(
                "Powered by:",
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  color: ColorResources.white,
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ),
            ),

            // Logo partner
            const Positioned(
              bottom: 50.0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 75.0,
                child: Image(image: AssetImage(Images.logo_inovasi78)),
              ),
            ),

            // Versi & badge DEV
            Positioned(
              bottom: 15.0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _packageInfo.version,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      fontWeight: FontWeight.normal,
                      color: ColorResources.white,
                    ),
                  ),
                  SizedBox(height: AppConstants.switchTo == "prod" ? 20.0 : 3.0),
                  if (AppConstants.switchTo != "prod")
                    Text(
                      "DEV",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.normal,
                        color: ColorResources.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
