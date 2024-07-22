import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';

import 'package:saka/views/screens/auth/sign_in.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

class DioManager {
  static final shared = DioManager();

  Future<Dio> getClient(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return null;
    };
    dio.options.connectTimeout = 10000;
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        options.headers["Authorization"] = "Bearer ${sp.getString("token")}";
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response);
      },
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        if(e.type == DioErrorType.connectTimeout) {
          ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
        }
        if(sp.getString("token") != null) {
          bool isTokenExpired = JwtDecoder.isExpired(sp.getString('token')!);
          if(isTokenExpired) {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInScreen()), (Route<dynamic> route) => false);
          }
        }
        return handler.next(e);
      }
    ));
    return dio;  
  }

}
