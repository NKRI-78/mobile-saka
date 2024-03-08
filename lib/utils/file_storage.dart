import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/permission_helper.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

class FileStorage {
  
  static Future<String> getExternalDocumentPath() async { 
    Directory directory = Directory(""); 
    if (Platform.isAndroid) { 
      directory = Directory("/storage/emulated/0/Download"); 
    } else { 
      directory = await getApplicationDocumentsDirectory(); 
    } 
  
    final exPath = directory.path; 
    await Directory("$exPath/SAKA").create(recursive: true); 
    return exPath; 
  } 
  
  static Future<String> get localPath async { 

    final String directory = await getExternalDocumentPath(); 
    return directory; 
  } 

  static Future<String> getFileFromAsset(String filename , BuildContext context, bool isExistFile) async {
    final path = await localPath; 
    debugPrint('Filename : $path/SAKA/$filename');
    final snackBar = SnackBar(
      backgroundColor: isExistFile ? ColorResources.error : ColorResources.success,
      duration: const Duration(seconds: 5),
      content: Text("${isExistFile ? 'File already exists in ' : 'File downloaded successfully, File saved to '} $path/SAKA/$filename"),
      action: SnackBarAction(
        label: 'View',
        onPressed: () async {
          PermissionHelper.check(context, permissionType: Permission.storage, permissionName: 'Storage');
          final result = await OpenFile.open('$path/SAKA/$filename');
          debugPrint("type=${result.type}  message=${result.message}");
          Future.delayed(Duration.zero, () {
            ShowSnackbar.snackbar(context, result.message == "done" ?   "Successfully opened the file" : result.message, '', result.message == "done" ?  ColorResources.success : ColorResources.error);
          });
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return "$path/SAKA/$filename"; 
  }

  static Future<bool> checkFileExist(String filename) async {
    final path = await localPath; 
    debugPrint('Filename : $filename');
    File file = File('$path/SAKA/$filename');

    bool checkIsExist = await file.exists();
    if(checkIsExist) {
      return true;
    } 
    
    
    return false;
  }
  
  static Future<File> saveFile(Uint8List bytes, String filename) async { 
    final path = await localPath; 
    debugPrint('Filename : $filename');
    File file = File('$path/SAKA/$filename');
    return file.writeAsBytes(bytes); 
  } 
}