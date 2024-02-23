import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future notificationDetails({required Map<String, dynamic> payload}) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'notification',
      'notification_channel',
      channelDescription: 'notification_channel',
      importance: Importance.max, 
      priority: Priority.high,
      channelShowBadge: true,
      enableVibration: true,
      enableLights: true,
    );
    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(
        presentBadge: true,
        presentSound: true,
        presentAlert: true,
      )
    );
  } 

  static Future init({bool initScheduled = true}) async {
    InitializationSettings settings =  const InitializationSettings(
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
      await notificationDetails(payload: payload!),
      payload: "",
    );
  }

}