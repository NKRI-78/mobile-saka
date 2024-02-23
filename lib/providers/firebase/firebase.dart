import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:soundpool/soundpool.dart';

import 'package:saka/providers/auth/auth.dart';

import 'package:saka/utils/helper.dart';

import 'package:saka/services/notification.dart';
import 'package:saka/data/repository/firebase/firebase.dart';

class FirebaseProvider with ChangeNotifier {
  final AuthProvider ap;
  final FirebaseRepo fp;
  final SharedPreferences sp;

  FirebaseProvider({
    required this.ap,
    required this.fp,
    required this.sp
  });

  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();
  final soundpool = Soundpool.fromOptions(
    options: SoundpoolOptions.kDefault,
  );

  static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    final soundpool = Soundpool.fromOptions(
      options: SoundpoolOptions.kDefault,
    );
    int soundId = await rootBundle.load("assets/sounds/notification.mpeg").then((ByteData soundData) {
      return soundpool.load(soundData);
    });
    await soundpool.play(soundId);
  }

  Future<void> setupInteractedMessage(BuildContext context) async {
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // When Tap Notification
    });
  }

  Future<void> initFcm(BuildContext context) async {
    try {
      await fp.initFcm(
        context, 
        lat: getCurrentLat, 
        lng: getCurrentLng
      );
    } catch(e) {
      debugPrint(e.toString());
    } 
  }

  Future<void> init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentBanner: true,
        defaultPresentSound: true,
        defaultPresentList: true
      )
    );
    await notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        onNotifications.add(details.payload!); 
      },
    );
  }

  void listenNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      int soundId = await rootBundle.load("assets/sounds/notification.mpeg").then((ByteData soundData) {
        return soundpool.load(soundData);
      });
      await soundpool.play(soundId);
      NotificationService.showNotification(
        id: Helper.createUniqueId(),
        title: notification.title,
        body: notification.body,
        payload: {},
      );
    });
  }

  String get getCurrentLat => sp.getString("lat") ?? "0.0";  
  String get getCurrentLng => sp.getString("lng") ?? "0.0";  
}