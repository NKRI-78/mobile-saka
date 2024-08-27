import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'notification',
      'notification_channel',
      channelDescription: 'notification_channel',
      importance: Importance.max, 
      priority: Priority.high,
      playSound: false,
      channelShowBadge: true,
      enableVibration: true,
      enableLights: true,
    );
    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: const IOSNotificationDetails(
        presentBadge: true,
        presentSound: true,
        presentAlert: true,
      )
    );
  } 

  static Future init() async {
    InitializationSettings settings =  const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      )
    );
    await notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload!);
      }
    );
  }

  static Future showNotification({
    int? id,
    String? title, 
    String? body,
    Map<String, dynamic>? payload,
  }) async {
    notifications.show(
      id!, 
      title, 
      body, 
      await notificationDetails(),
      payload: json.encode(payload)
    );
  }

}