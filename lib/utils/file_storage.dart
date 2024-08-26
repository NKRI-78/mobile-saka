import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileStorage {
  
  static Future<String> getExternalDocumentPath() async { 
    late Directory directory;

    if (Platform.isAndroid) { 
      directory = Directory("/storage/emulated/0/Download"); 
    } else { 
      directory = await getApplicationDocumentsDirectory(); 
    } 
  
    final exPath = directory.path; 
    
    // await Directory("$exPath/SuperApps").create(recursive: true); 
    // await Directory("$exPath/Temporary").create(recursive: true); 

    return exPath;
  } 
  
  static Future<String> get localPath async { 
    final String directory = await getExternalDocumentPath(); 

    return directory; 
  } 

  static Future<String> getFileFromAsset(String filename) async {
    final path = await localPath; 

    return "$path/Saka/$filename"; 
  }

  static Future<bool> checkFileExist(String filename) async {
    final path = await localPath; 

    File file = File('$path/Saka/$filename');

    bool checkIsExist = await file.exists();
    if(checkIsExist) {
      return true;
    } 

    return false;
  }
  
  static Future<File> saveFile(Uint8List bytes, String filename) async {
    try {
      final path = await localPath;

      final directory = Directory('$path/Saka');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      File file = File('${directory.path}/$filename');
      return await file.writeAsBytes(bytes);
    } catch (e) {
      print('Error saving file: $e');
      rethrow; 
    }
  }

}