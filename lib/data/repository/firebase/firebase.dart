import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

class FirebaseRepo {
  final AuthRepo ar;
  final SharedPreferences sp;

  FirebaseRepo({required this.ar, required this.sp});

  Future<void> initFcm({required double lat, required double lng}) async {
    try {
      final Dio dio = DioManager.shared.getClient();
      final String? fcmToken = await _getFcmToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('Initialize FCM skipped: token is empty');
        return;
      }

      final Response res = await dio.post(
        '${AppConstants.baseUrl}/data/user',
        data: {
          'userId': ar.getUserId(),
          'fcmSecret': fcmToken,
          'latitude': lat.toString(),
          'longitude': lng.toString(),
        },
      );

      debugPrint('Initialize FCM : ${res.statusCode}');
    } on DioException catch (e) {
      debugPrint('Initialize FCM DioError: ${e.response?.data ?? e.message}');
    } catch (e, stacktrace) {
      debugPrint('Initialize FCM Error: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<String?> _getFcmToken() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (Platform.isIOS) {
      final NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint(
        'iOS Notification permission: ${settings.authorizationStatus}',
      );

      String? apnsToken = await messaging.getAPNSToken();

      int retry = 0;
      while (apnsToken == null && retry < 10) {
        await Future.delayed(const Duration(seconds: 1));
        apnsToken = await messaging.getAPNSToken();
        retry++;
      }

      debugPrint('APNs Token: $apnsToken');

      if (apnsToken == null) {
        debugPrint('APNs token is still null. Skip FCM token for now.');
        return null;
      }
    }

    final String? fcmToken = await messaging.getToken();
    debugPrint('FCM Token: $fcmToken');

    return fcmToken;
  }
}
