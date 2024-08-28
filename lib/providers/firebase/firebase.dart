import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:soundpool/soundpool.dart';

import 'package:saka/services/navigation.dart';
import 'package:saka/services/services.dart';

import 'package:saka/views/screens/news/detail.dart';

import 'package:saka/views/screens/feed/index.dart';
import 'package:saka/views/screens/feed/post_detail.dart';
import 'package:saka/views/screens/inbox/inbox.dart';

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

  Future<void> setupInteractedMessage(BuildContext context) async {

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null) {
        handleMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });
  }

  Future<void> handleMessage(message) async {

    // NEWS
    if(message.data["click_action"] == "news") {
      NS.push(navigatorKey.currentContext!, DetailNewsScreen(
        contentId: message.data["news_id"],
      ));
    }

    // BROADCAST
    if(message.data["click_action"] == "broadcast") {
      NS.push(navigatorKey.currentContext!, 
        InboxScreen()
      );
    }

    // SOS
    if(message.data["click_action"] == "sos") {
      NS.push(navigatorKey.currentContext!,
        InboxScreen()
      );    
    }

    // FORUM
    if(message.data["click_action"] == "create") {
      NS.push(navigatorKey.currentContext!,
        const FeedIndex()
      );
    }

    // LIKE
    if(message.data["click_action"] == "like") {
      NS.push(navigatorKey.currentContext!,
        const FeedIndex()
      );
    }

    // COMMENT LIKE
    if(message.data["click_action"] == "comment-like") {
      NS.push(navigatorKey.currentContext!,
        const FeedIndex()
      );
    }

    // CREATE COMMENT
    if(message.data["click_action"] == "create-comment") {       
      NS.pushUntil(navigatorKey.currentContext!, 
        PostDetailScreen(
          from: "direct",
          data: {
            "forum_id": message.data["forum_id"],
            "comment_id": message.data["comment_id"],
            "reply_id": "-",
            "from": "notification-comment",
          },
        )
      );
    } 

    // CREATE REPLY
    if(message.data["click_action"] == "create-reply") {
      NS.pushUntil(navigatorKey.currentContext!, 
        PostDetailScreen(
          from: "direct",
          data: {
            "forum_id": message.data["forum_id"],
            "comment_id": message.data["comment_id"],
            "reply_id": message.data["reply_id"],
            "from": "notification-reply",
          },
        )
      );
    }

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

  void listenNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      
      Map<String, dynamic> data = message.data;
      
      int soundId = await rootBundle.load("assets/sounds/notification.mpeg").then((ByteData soundData) {
        return soundpool.load(soundData);
      });

      await soundpool.play(soundId);

      NotificationService.showNotification(
        id: Helper.createUniqueId(),
        title: notification.title,
        body: notification.body,
        payload: data
      );
    });
  }

  String get getCurrentLat => sp.getString("lat") ?? "0.0";  
  String get getCurrentLng => sp.getString("lng") ?? "0.0";  
}