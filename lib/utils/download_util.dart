
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/file_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DownloadHelper {
  static Future<void> downloadDoc(
      {required BuildContext context, required String url}) async {
    int total = 0;
    int received = 0;

    late http.StreamedResponse response;

    final List<int> bytes = [];
    
    String originName = p.basename(url.split('/').last).split('.').first;
    String ext = p.basename(url).toString().split('.').last;

    String filename = "${DateFormat('yyyydd').format(DateTime.now())}-$originName.$ext";

    bool isExistFile = await FileStorage.checkFileExist(filename);

    if(!isExistFile) {
      ProgressDialog pr = ProgressDialog(context: context);
      pr.show(
          backgroundColor: ColorResources.greyDarkPrimary,
          msgTextAlign: TextAlign.start,
          max: 100,
          msgColor: ColorResources.grey,
          msg: "Please wait...",
          progressBgColor: ColorResources.blue,
          progressValueColor: ColorResources.greyDarkPrimary,
          onStatusChanged: (status) async {
            if (status == DialogStatus.opened){
              response = await http.Client().send(http.Request('GET', Uri.parse(url)));
            
              total = response.contentLength ?? 0;

              response.stream.listen((value) {
                bytes.addAll(value);
                received =  value.length;
                ProgressDialog pr = ProgressDialog(context: context);
                int progress = (((received / total) * 100).toInt());
                pr.update(value: progress, msg: 'File Downloading...');
              }).onDone(() async {
                pr.close();
                Uint8List uint8List = Uint8List.fromList(bytes);

                await FileStorage.saveFile(uint8List, filename);
                await FileStorage.getFileFromAsset(filename, context, isExistFile);
              });
            }
          }
      );
    } else {
      await FileStorage.getFileFromAsset(filename, context, isExistFile); 
    }
  }
}
