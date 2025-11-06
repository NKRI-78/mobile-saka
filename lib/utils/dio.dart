import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart'; 
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/helper.dart';

class DioManager {
  DioManager._internal();
  static final DioManager shared = DioManager._internal();

  Dio? _dio; // single instance

  /// Dapatkan Dio singleton (buat sekali, pakai berkali-kali).
  Dio getClient() {
    if (_dio != null) return _dio!;

    final options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      // biar tidak throw untuk status 4xx/5xx — biar kamu handle sendiri di layer atas
      validateStatus: (status) =>
          status != null && status >= 200 && status < 600,
      // default content-type
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    final dio = Dio(options);

    // -------- SSL bypass (DEV ONLY) --------
    final ioAdapter = IOHttpClientAdapter();
    ioAdapter.createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.httpClientAdapter = ioAdapter;
    // --------------------------------------

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ambil token & userId dari SharedPreferences via Helper.prefs
          final token = Helper.prefs?.getString('token');
          if (token != null && token.isNotEmpty && token != '-') {
            options.headers['Authorization'] = 'Bearer $token';
            final userId = Helper.prefs?.getString('userId');
            if (userId != null && userId.isNotEmpty && userId != '-') {
              options.headers['USERID'] = userId;
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Kamu bisa tambahkan normalisasi / logging singkat di sini bila perlu
          return handler.next(response);
        },
        onError: (e, handler) {
          // v5: DioException, bukan DioError
          // Pass-through; kamu sudah handle di repo/provider masing-masing
          if (e.error is SocketException) {
            return handler.next(e);
          }
          return handler.next(e);
        },
      ),
    );

    // Optional: aktifkan log saat debug
    // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    _dio = dio;
    return _dio!;
  }

  /// Jika kamu perlu reset instance (mis. user logout / ganti baseUrl)
  void reset({String? newBaseUrl}) {
    _dio?.close(force: true);
    _dio = null;
    if (newBaseUrl != null) {
      AppConstants.baseUrl = newBaseUrl; // kalau baseUrl kamu mutable
    }
  }
}
