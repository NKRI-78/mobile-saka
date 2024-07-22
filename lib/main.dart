import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/services/services.dart';
import 'package:saka/views/screens/news/detail.dart';
import 'localization/app_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:saka/container.dart' as core;

import 'package:saka/services/notification.dart';

import 'package:saka/providers.dart';
import 'package:saka/providers/firebase/firebase.dart';
import 'package:saka/providers/localization/localization.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';

import 'package:saka/views/screens/splash/splash.dart';

Future<void> main() async {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  timeago.setLocaleMessages('id', CustomLocalDate());
  await Helper.initSharedPreferences();
  await core.init();
  runApp(MultiProvider(
    providers: providers,
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  late FirebaseProvider fp;

  Future<void> checkPermissions() async {
    if(Platform.isAndroid) {
      await Permission.contacts.request();
      LocationPermission lp = await Geolocator.requestPermission();
      if(lp == LocationPermission.denied) {
        await Geolocator.openAppSettings();
      }
    }
  }

  @override 
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state); 
    /* Lifecycle */
    // - Resumed (App in Foreground)
    // - Inactive (App Partially Visible - App not focused)
    // - Paused (App in Background)
    // - Detached (View Destroyed - App Closed)
    if(state == AppLifecycleState.resumed) {
      debugPrint("=== APP RESUME ===");
      if(Platform.isAndroid) {
        bool isLocationDeny = await Permission.location.isDenied;
        if(isLocationDeny) {
          await Geolocator.openAppSettings();
        } else {
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
          Helper.prefs?.setString("lat", position.latitude.toString());
          Helper.prefs?.setString("lng", position.longitude.toString());
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude
          );
          Placemark place = placemarks[0];
          Helper.prefs?.setString("membernearAddress", "${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
        }
      }
    }
    if(state == AppLifecycleState.inactive) {
      debugPrint("=== APP INACTIVE ===");
    }
    if(state == AppLifecycleState.paused) {
      debugPrint("=== APP PAUSED ===");
    }
    if(state == AppLifecycleState.detached) {
      debugPrint("=== APP CLOSED ===");
    }
  }

  @override 
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    fp = context.read<FirebaseProvider>();

    checkPermissions();  

    Future.delayed(Duration.zero, () {
      if(mounted) {
        fp.init();
      }
      if(mounted) {
        fp.setupInteractedMessage(context);
      }
      if(mounted) {
        NotificationService.init();
      }
    });

    fp.listenNotification(context);
    listenOnClickNotifications();
  }

  @override 
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void listenOnClickNotifications() => NotificationService.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    var data = json.decode(payload!);

    if(data["news_id"] != "-") {
      NS.push(navigatorKey.currentContext!, DetailNewsScreen(
        contentId: data["news_id"],
      ));
    }

    // if(payload != "approval") {
    //   GlobalVariable.navState.currentState!.push(
    //     PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    //       return NotificationScreen(
    //         key: UniqueKey(),
    //       );
    //     },
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       const begin = Offset(1.0, 0.0);
    //       const end = Offset.zero;
    //       const curve = Curves.ease;
    //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //       return SlideTransition(
    //         position: animation.drive(tween),
    //         child: child,
    //       );
    //     }),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    AppConstants.languages.forEach((language) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    });
    return MaterialApp(
      title: 'Saka',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: ColorResources.white,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          },
        )
      ),
      locale: context.watch<LocalizationProvider>().locale,
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: locals,
      home: SplashScreen(),
    );    
  }
}
