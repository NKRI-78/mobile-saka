import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/services/services.dart';
import 'package:saka/views/screens/feed/index.dart';
import 'package:saka/views/screens/feed/post_detail.dart';
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
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {

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

  Future<void> getData() async {
    if (!mounted) return;
      await NotificationService.init();

    if (!mounted) return;
      await context.read<FirebaseProvider>().setupInteractedMessage(context);
  }

  @override 
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    checkPermissions();  

    Future.microtask(() => getData()); 

    context.read<FirebaseProvider>().listenNotification(context);

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

    // FORUM
    if(data["click_action"] == "create") {
      NS.push(navigatorKey.currentContext!,
        const FeedIndex()
      );
    }

    if(data["click_action"] == "like") {
      NS.push(navigatorKey.currentContext!,
        const FeedIndex()
      );
    }

    if(data["click_action"] == "comment-like") {
      NS.push(navigatorKey.currentContext!,
        const FeedIndex()
      );
    }

    if(data["click_action"] == "create-comment") {
      NS.pushUntil(
        navigatorKey.currentContext!, 
        PostDetailScreen(
          data: {
            "forum_id": data["forum_id"],
            "comment_id": data["comment_id"],
            "reply_id": "-",
            "from": "notification-comment",
          },
        )
      );
    }

    if(data["click_action"] == "create-reply") {
      NS.pushUntil(
        navigatorKey.currentContext!, 
        PostDetailScreen(
          data: {
            "forum_id": data["forum_id"],
            "comment_id": data["comment_id"],
            "reply_id": data["reply_id"],
            "from": "notification-reply",
          },
        )
      );
    }

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
