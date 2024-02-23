import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as b;
import 'package:dio/dio.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/data/models/feed/feedmedia.dart';

class PostDoc extends StatefulWidget {
  final List<FeedMedia> medias;
  final String caption;

  const PostDoc({
    Key? key, 
    required this.medias,
    required this.caption,
  }) : super(key: key);

  @override
  _PostDocState createState() => _PostDocState();
}

class _PostDocState extends State<PostDoc> {

  String? type = "";
  Color? color;

  @override
  Widget build(BuildContext context) {

    switch (b.basename(widget.medias[0].path!).split('.').last) {
      case "pdf":
        setState(() => type = "PDF");
        setState(() => color = Colors.red[300]);
      break;
      case "ppt":
        setState(() => type = "PPT");
        setState(() => color = Colors.red[300]);
      break;
      case "pptx":
        setState(() => type = "PPTX");
        setState(() => color = Colors.red[300]);
      break;
      case "txt":
        setState(() => type = "TXT");
        setState(() => color = Colors.blueGrey[300]);
      break;
      case "xls": 
        setState(() => type = "XLS");
        setState(() => color = Colors.green[300]);
      break;
      case "xlsx": 
        setState(() => type = "XLSX");
        setState(() => color = Colors.green[300]);
      break;
      case "doc":
        setState(() => type = "DOC");
        setState(() => color = Colors.blue[300]);
      break;
      case "docx":
        setState(() => type = "DOCX");
        setState(() => color = Colors.blue[300]);
      break;
      default:
    }
    return buildUI();   
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(widget.caption,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Container(
              height: 56.0,
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8.0)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [ 
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 12.0),
                      child: Text(type!,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.white
                        ),
                      ),
                    )
                  ),
                  Expanded(
                    child: Text(widget.medias[0].path!.split('/').last,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: ColorResources.white
                      )
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () async {
                        showAnimatedDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                height: 140.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 10.0),
                                    const Icon(Icons.download_rounded),
                                    const SizedBox(height: 10.0),
                                    Text(getTranslated("SAVE_DOCUMENT", context),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:  MaterialStateProperty.all<Color>(ColorResources.error)
                                          ),
                                          onPressed: () => Navigator.of(context).pop(), 
                                          child: Text(getTranslated("NO", context),
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          )
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            ProgressDialog pr = ProgressDialog(context: context);
                                            try {
                                              Dio dio = Dio();
                                              PermissionStatus status = await Permission.storage.request();
                                              if(!status.isGranted) {
                                                await Permission.storage.request();
                                              } 
                                              Directory documentsIos = await getApplicationDocumentsDirectory();
                                              String? saveDir = Platform.isIOS ? documentsIos.path : await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                                              String url = '${AppConstants.baseUrlImg}${widget.medias[0].path}'; 
                                              pr.show(
                                                max: 2,
                                                msg: getTranslated("PLEASE_WAIT", context),
                                                progressBgColor: Colors.blue
                                              );
                                              await dio.download(url, "$saveDir/${b.basename(widget.medias[0].path!)}");  
                                              pr.close();
                                              ShowSnackbar.snackbar(context,"${getTranslated("DOCUMENT_SAVED", context)} $saveDir", "", ColorResources.success);
                                              Navigator.of(context, rootNavigator: true).pop();
                                            } catch(e) {
                                              pr.close();
                                              ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
                                            }
                                          },
                                          child: Text(getTranslated("YES", context),
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          animationType: DialogTransitionType.scale,
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(seconds: 1),
                        );       
                      },
                      color: ColorResources.white,
                      icon: const Icon(Icons.arrow_circle_down),
                    ),
                  )
                ],
              )
            )
          ],
        );
      },
    );
  }
}