import 'package:flutter/material.dart';
import 'package:path/path.dart' as b;
import 'package:url_launcher/url_launcher.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class PostDoc extends StatefulWidget {
  final List medias;

  const PostDoc({
    Key? key, 
    required this.medias,
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
                        
                        await launchUrl(Uri.parse(widget.medias[0].path));
                        // showAnimatedDialog(
                        //   context: context,
                        //   barrierDismissible: true,
                        //   builder: (BuildContext context) {
                        //     return Dialog(
                        //       child: Container(
                        //         padding: const EdgeInsets.all(8.0),
                        //         height: 140.0,
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             const SizedBox(height: 10.0),
                        //             const Icon(Icons.download_rounded),
                        //             const SizedBox(height: 10.0),
                        //             Text(getTranslated("SAVE_DOCUMENT", context),
                        //               style: robotoRegular.copyWith(
                        //                 fontSize: Dimensions.fontSizeSmall,
                        //                 fontWeight: FontWeight.w600
                        //               ),
                        //             ),
                        //             const SizedBox(height: 10.0),
                        //             Row(
                        //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //               children: [
                        //                 ElevatedButton(
                        //                   style: ButtonStyle(
                        //                     backgroundColor:  MaterialStateProperty.all<Color>(ColorResources.error)
                        //                   ),
                        //                   onPressed: () => Navigator.of(context).pop(), 
                        //                   child: Text(getTranslated("NO", context),
                        //                     style: robotoRegular.copyWith(
                        //                       fontSize: Dimensions.fontSizeSmall
                        //                     ),
                        //                   )
                        //                 ),
                        //                 ElevatedButton(
                        //                   onPressed: () async {
                        //                     await DownloadHelper.downloadDoc(context: context, url: "${}");
                        //                     Navigator.of(context, rootNavigator: true).pop();
                        //                   },
                        //                   child: Text(getTranslated("YES", context),
                        //                     style: robotoRegular.copyWith(
                        //                       fontSize: Dimensions.fontSizeSmall
                        //                     ),
                        //                   ),
                        //                 )
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   animationType: DialogTransitionType.scale,
                        //   curve: Curves.fastOutSlowIn,
                        //   duration: const Duration(seconds: 1),
                        // );       
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