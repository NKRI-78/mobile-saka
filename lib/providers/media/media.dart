import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:saka/data/repository/media/media.dart';


class MediaProvider extends ChangeNotifier {
  final MediaRepo mr;
  MediaProvider({
    required this.mr });

  Future<Response?> postMedia(BuildContext context, File file) async {
    try {
      Response res = await mr.postMedia(context, file);
      return res;
    } catch(e) {
      print(e);
    }
    return null;
  }

}
