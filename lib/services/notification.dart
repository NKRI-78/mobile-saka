import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  debugPrint(
    '>>> BG LOCAL NOTIFICATION TAP: id=${response.id}, '
    'action=${response.actionId}, payload=${response.payload}',
  );
}

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static final BehaviorSubject<String?> onNotifications =
      BehaviorSubject<String?>();

  static const String generalChannelId = 'general_channel';
  static const String generalChannelName = 'General Notifications';
  static const String generalChannelDescription =
      'General notification channel';

  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/ic_notification');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      defaultPresentBanner: true,
      defaultPresentList: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('>>> LOCAL NOTIFICATION TAP: ${response.payload}');
        onNotifications.add(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _requestPermissions();
    await _createAndroidChannels();

    debugPrint('>>> NotificationService.init() selesai');
  }

  static Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImpl = notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImpl?.requestNotificationsPermission();

    final IOSFlutterLocalNotificationsPlugin? iosImpl = notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> _createAndroidChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImpl = notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl == null) return;

    const AndroidNotificationChannel generalChannel =
        AndroidNotificationChannel(
          generalChannelId,
          generalChannelName,
          description: generalChannelDescription,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );

    await androidImpl.createNotificationChannel(generalChannel);
  }

  static Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          generalChannelId,
          generalChannelName,
          channelDescription: generalChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          channelShowBadge: true,
          enableVibration: true,
          enableLights: true,
          icon: '@drawable/ic_notification',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    );

    return const NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
  }) async {
    final Map<String, dynamic> safePayload = {};

    payload?.forEach((key, value) {
      safePayload[key.toString()] = value?.toString() ?? '-';
    });

    final String safeTitle = title?.trim().isNotEmpty == true
        ? title!.trim()
        : 'SAKA';
    final String safeBody = body?.trim().isNotEmpty == true ? body!.trim() : '';
    final String? payloadStr = safePayload.isEmpty
        ? null
        : jsonEncode(safePayload);

    debugPrint('>>> SHOW LOCAL NOTIFICATION');
    debugPrint('>>> title: $safeTitle');
    debugPrint('>>> body: $safeBody');
    debugPrint('>>> payload: $payloadStr');

    await notifications.show(
      id,
      safeTitle,
      safeBody,
      await _notificationDetails(),
      payload: payloadStr,
    );
  }
}
