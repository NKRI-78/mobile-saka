import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/data/repository/firebase/firebase.dart';
import 'package:saka/providers/auth/auth.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/services/notification.dart';
import 'package:saka/services/services.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/views/screens/feed/index.dart';
import 'package:saka/views/screens/feed/post_detail.dart';
import 'package:saka/views/screens/inbox/inbox.dart';
import 'package:saka/views/screens/news/detail.dart';

class FirebaseProvider with ChangeNotifier {
  final AuthProvider ap;
  final FirebaseRepo fp;
  final SharedPreferences sp;

  FirebaseProvider({required this.ap, required this.fp, required this.sp});

  bool _fcmListenerAttached = false;
  bool _interactionListenerAttached = false;
  bool _tokenRefreshListenerAttached = false;

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  String _messageTypeFromData(Map<String, dynamic> data) {
    return (data['type'] ??
            data['broadcast_type'] ??
            data['click_action'] ??
            '')
        .toString();
  }

  String _getClickAction(Map<String, dynamic> data) {
    return (data['click_action'] ??
            data['type'] ??
            data['broadcast_type'] ??
            '')
        .toString();
  }

  Future<void> setupInteractedMessage(BuildContext context) async {
    if (_interactionListenerAttached) {
      debugPrint('>>> setupInteractedMessage() sudah pernah di-attach, skip');
      return;
    }

    _interactionListenerAttached = true;

    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      debugPrint(
        '>>> App dibuka dari terminated via remote notif: ${initialMessage.data}',
      );
      await handleMessage(initialMessage);
    }

    _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen(
          (RemoteMessage message) async {
            debugPrint('>>> onMessageOpenedApp TRIGGERED: ${message.data}');
            await handleMessage(message);
          },
          onError: (e, s) {
            debugPrint('>>> onMessageOpenedApp ERROR: $e\n$s');
          },
        );
  }

  Future<void> handleMessage(RemoteMessage message) async {
    debugPrint('>>> handleMessage() data: ${message.data}');
    await handleDataMessage(message.data);
  }

  Future<void> handleLocalPayload(String? payload) async {
    if (payload == null || payload.isEmpty) return;

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) return;

      await handleDataMessage(Map<String, dynamic>.from(decoded));
    } catch (e, s) {
      debugPrint('>>> LOCAL notification payload decode ERROR: $e\n$s');
    }
  }

  Future<void> handleDataMessage(Map<String, dynamic> data) async {
    final BuildContext? context = navigatorKey.currentContext;

    if (context == null) {
      debugPrint(
        '>>> navigatorKey.currentContext masih null, navigation dibatalkan',
      );
      return;
    }

    final String messageType = _messageTypeFromData(data);
    final String clickAction = _getClickAction(data);

    final bool openNews =
        messageType.contains('news') || clickAction.contains('news');
    final bool openInbox =
        messageType.contains('broadcast') ||
        messageType.contains('sos') ||
        clickAction.contains('broadcast') ||
        clickAction.contains('sos') ||
        clickAction == 'inbox';

    if (openNews) {
      final String? contentId = data['news_id']?.toString();
      if (contentId != null && contentId.isNotEmpty && contentId != '-') {
        NS.push(context, DetailNewsScreen(contentId: contentId));
      }
      return;
    }

    if (openInbox) {
      NS.push(context, InboxScreen());
      return;
    }

    if (clickAction == 'create' ||
        clickAction == 'like' ||
        clickAction == 'comment-like') {
      NS.pushUntil(context, const FeedIndex());
      return;
    }

    if (clickAction == 'create-comment') {
      NS.pushUntil(
        context,
        PostDetailScreen(
          from: 'direct',
          data: {
            'forum_id': data['forum_id']?.toString() ?? '-',
            'comment_id': data['comment_id']?.toString() ?? '-',
            'reply_id': '-',
            'from': 'notification-comment',
          },
        ),
      );
      return;
    }

    if (clickAction == 'create-reply') {
      NS.pushUntil(
        context,
        PostDetailScreen(
          from: 'direct',
          data: {
            'forum_id': data['forum_id']?.toString() ?? '-',
            'comment_id': data['comment_id']?.toString() ?? '-',
            'reply_id': data['reply_id']?.toString() ?? '-',
            'from': 'notification-reply',
          },
        ),
      );
      return;
    }

    debugPrint('>>> clickAction tidak dikenali: $clickAction');
  }

  Future<void> initFcm([BuildContext? context]) async {
    try {
      debugPrint('>>> initFcm() mulai');

      final NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      debugPrint('>>> Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('>>> Permission denied, notifikasi tidak bisa tampil');
        return;
      }

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );

      await fp.initFcm(lat: getCurrentLat, lng: getCurrentLng);

      if (!_tokenRefreshListenerAttached) {
        _tokenRefreshListenerAttached = true;
        _onTokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
            .listen((String newToken) async {
              debugPrint('>>> FCM token refreshed: $newToken');

              try {
                await fp.initFcm(lat: getCurrentLat, lng: getCurrentLng);
                debugPrint('>>> token refresh dikirim ulang ke backend');
              } catch (e, s) {
                debugPrint(
                  '>>> token refresh gagal dikirim ke backend: $e\n$s',
                );
              }
            });
      }

      debugPrint('>>> fr.initFcm() kirim token ke backend selesai');
    } catch (e, s) {
      debugPrint('>>> initFcm() ERROR: $e\n$s');
    }
  }

  void listenNotification(BuildContext context) {
    if (_fcmListenerAttached) {
      debugPrint('>>> listenNotification() sudah pernah di-attach, skip');
      return;
    }

    _fcmListenerAttached = true;

    _onMessageSubscription = FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        debugPrint('>>> onMessage TRIGGERED');
        debugPrint('>>> message.data: ${message.data}');

        final RemoteNotification? notification = message.notification;
        final Map<String, dynamic> data = message.data;

        final String title =
            notification?.title ??
            data['title']?.toString() ??
            data['notification_title']?.toString() ??
            'SAKA';

        final String body =
            notification?.body ??
            data['body']?.toString() ??
            data['notification_body']?.toString() ??
            data['message']?.toString() ??
            '';

        if (title.trim().isEmpty && body.trim().isEmpty) {
          debugPrint('>>> title & body kosong, notifikasi dibatalkan');
          return;
        }

        await NotificationService.showNotification(
          id: Helper.createUniqueId(),
          title: title,
          body: body,
          payload: {
            ...data,
            'click_action': _getClickAction(data),
            'notification_title': title,
            'notification_body': body,
          },
        );
      },
      onError: (e, s) {
        debugPrint('>>> onMessage STREAM ERROR: $e\n$s');
      },
    );
  }

  double _readCoordinate(String key) {
    final Object? value = sp.get(key);
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  double get getCurrentLat => _readCoordinate('lat');

  double get getCurrentLng => _readCoordinate('lng');

  @override
  void dispose() {
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    _onTokenRefreshSubscription?.cancel();
    super.dispose();
  }
}
