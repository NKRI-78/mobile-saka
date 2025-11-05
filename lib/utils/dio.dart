import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/helper.dart';

class DioManager {
  static final shared = DioManager();

  Dio getClient() {
    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return null;
    };
    dio.options.connectTimeout = 10000;
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        String? token = Helper.prefs!.getString("token");
        if (token != "-") {
          // print(token);
          options.headers["Authorization"] = "Bearer $token";
          String? userId = Helper.prefs!.getString("userId");
          if (userId != "-") {
            options.headers["USERID"] = userId;
          }
        }
        return handler.next(options);
      }, onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response);
      }, onError: (DioError e, ErrorInterceptorHandler handler) async {
        if (e.error is SocketException) {
          return handler.next(e);
        }
        return handler.next(e);
      }),
    );
    return dio;
  }
}
