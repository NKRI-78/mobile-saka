import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:saka/firebase_options.dart';
import 'localization/app_localization.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:saka/container.dart' as core;

import 'package:saka/services/navigation.dart';
import 'package:saka/services/services.dart';
import 'package:saka/services/notification.dart';

import 'package:saka/providers.dart';
import 'package:saka/providers/firebase/firebase.dart';
import 'package:saka/providers/localization/localization.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';

import 'package:saka/views/screens/splash/splash.dart';
import 'package:saka/views/screens/inbox/inbox.dart';
import 'package:saka/views/screens/feed/index.dart';
import 'package:saka/views/screens/feed/post_detail.dart';
import 'package:saka/views/screens/news/detail.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('>>> BACKGROUND MESSAGE TRIGGERED');
  debugPrint('>>> background data: ${message.data}');
  debugPrint(
    '>>> background notification: '
    '${message.notification?.title} / ${message.notification?.body}',
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Penting: tunggu init Firebase selesai
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Locale untuk timeago
  timeago.setLocaleMessages('id', CustomLocalDate());

  await Helper.initSharedPreferences();
  await core.init();
  await NotificationService.init();

  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  StreamSubscription<String?>? _notifSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Jalankan setelah frame pertama agar provider & context siap
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initNotifications();
    });
  }

  Future<void> _initNotifications() async {
    if (!mounted) return;

    final firebaseProvider = context.read<FirebaseProvider>();

    // 1) request permission, ambil token FCM, dan kirim ke BE
    await firebaseProvider.initFcm();

    if (!mounted) return;

    // 2) listen pesan foreground
    firebaseProvider.listenNotification(context);

    // 3) pesan ketika app dibuka dari notif (terminated/background)
    await firebaseProvider.setupInteractedMessage(context);

    // 4) klik notif lokal
    _notifSub = NotificationService.onNotifications.stream.listen(
      _onClickedNotification,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notifSub?.cancel();
    super.dispose();
  }

  // ===== Lifecycle logs (opsional untuk debugging) =====
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('=== APP RESUMED ===');
        break;
      case AppLifecycleState.inactive:
        debugPrint('=== APP INACTIVE ===');
        break;
      case AppLifecycleState.paused:
        debugPrint('=== APP PAUSED ===');
        break;
      case AppLifecycleState.detached:
        debugPrint('=== APP DETACHED ===');
        break;
      case AppLifecycleState.hidden: // jika pakai Flutter terbaru
        debugPrint('=== APP HIDDEN ===');
        break;
    }
  }

  // ===== Handle klik notifikasi =====
  void _onClickedNotification(String? payload) {
    if (payload == null || payload.isEmpty) return;

    Map<String, dynamic> data;
    try {
      final decoded = json.decode(payload);
      if (decoded is! Map) {
        return;
      }
      data = Map<String, dynamic>.from(decoded);
    } catch (_) {
      // payload bukan JSON valid -> abaikan
      return;
    }

    final action =
        (data['click_action'] ?? data['type'] ?? data['broadcast_type'] ?? '')
            .toString();
    final ctx = navigatorKey.currentState?.context ?? context;

    switch (action) {
      // NEWS
      case 'news':
        final contentId = data['news_id'];
        if (contentId != null) {
          NS.push(ctx, DetailNewsScreen(contentId: contentId));
        }
        break;

      // BROADCAST / SOS -> Inbox
      case 'broadcast':
      case 'sos':
        NS.push(ctx, InboxScreen());
        break;

      // Forum: create/like/comment-like -> ke index feed
      case 'create':
      case 'like':
      case 'comment-like':
        NS.pushUntil(ctx, const FeedIndex());
        break;

      // Forum: create-comment -> detail dengan data comment
      case 'create-comment':
        NS.pushUntil(
          ctx,
          PostDetailScreen(
            from: 'direct',
            data: {
              'forum_id': data['forum_id'],
              'comment_id': data['comment_id'],
              'reply_id': '-',
              'from': 'notification-comment',
            },
          ),
        );
        break;

      // Forum: create-reply -> detail dengan reply_id
      case 'create-reply':
        NS.pushUntil(
          ctx,
          PostDetailScreen(
            from: 'direct',
            data: {
              'forum_id': data['forum_id'],
              'comment_id': data['comment_id'],
              'reply_id': data['reply_id'],
              'from': 'notification-reply',
            },
          ),
        );
        break;

      default:
        // aksi tidak dikenal -> bisa diarahkan ke halaman default
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locales = AppConstants.languages
        .map((l) => Locale(l.languageCode!, l.countryCode))
        .toList(growable: false);

    return MaterialApp(
      title: 'Saka',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: ColorResources.white,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
            TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      locale: context.watch<LocalizationProvider>().locale,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: locales,
      home: const SplashScreen(),
    );
  }
}
