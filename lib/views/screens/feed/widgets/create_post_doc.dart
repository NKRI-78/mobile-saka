import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/feed/feed.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/container.dart';
import 'package:saka/data/repository/feed/feed.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class CreatePostDocScreen extends StatefulWidget {
  final FilePickerResult? files;
  const CreatePostDocScreen({
    Key? key, 
    this.files,
  }) : super(key: key);
  @override
  _CreatePostDocScreenState createState() => _CreatePostDocScreenState();
}

class _CreatePostDocScreenState extends State<CreatePostDocScreen> {

  late TextEditingController captionC;

  Color? color;

  Widget displaySingleDoc() {
    File? file = File(widget.files!.files.single.path!);
    switch (basename(file.path).split('.').last) {
      case 'pdf':
        setState(() => color = Colors.red[300]);
      break;
      case 'ppt':
        setState(() => color = Colors.red[300]);
      break;
      case 'pptx':
        setState(() => color = Colors.red[300]);
      break;
      case 'txt':
        setState(() => color = Colors.blueGrey[300]);
      break;
      case 'xls':
        setState(() => color = Colors.green[300]);
      break;
      case 'xlsx':
        setState(() => color = Colors.green[300]);
      break;
        case 'doc':
        setState(() => color = Colors.green[300]);
      break;
      case 'docx':
        setState(() => color = Colors.green[300]);
      break;
      default:
    }
    return Container(
      width: 200.0,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filename : ${basename(file.path)}', 
            style: robotoRegular.copyWith(
              color: ColorResources.white,
              fontSize: Dimensions.fontSizeSmall
            ) 
          ),
          const SizedBox(height: 6.0),
          Text('Size : ${filesize(file.lengthSync())}', 
            style: robotoRegular.copyWith(
              color: ColorResources.white,
              fontSize: Dimensions.fontSizeSmall
            ) 
          ),
        ],
      ) 
    );
  }

  @override 
  void initState() {
    super.initState();

    captionC = TextEditingController();
  }
  
  @override 
  void dispose() {
    captionC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI(context);
  }

  Widget buildUI(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            backgroundColor: ColorResources.white,
            title: Text(getTranslated("CREATE_POST", context), 
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.black 
              )
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: ColorResources.black,
              ),
              onPressed: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
              ? () {} 
              : () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              Container(
                margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? () {} : () async {
                        String caption = captionC.text;  
                        if(caption.trim().isNotEmpty) {
                          if(caption.trim().length < 10) {
                            ShowSnackbar.snackbar(context, getTranslated("CAPTION_MINIMUM", context), "", ColorResources.error);
                            return;
                          }
                        } 
                        if(caption.trim().length > 1000) {
                          ShowSnackbar.snackbar(context, getTranslated("CAPTION_MAXIMUM", context), "", ColorResources.error);
                          return;
                        }
                        context.read<FeedProvider>().setStateWritePost(WritePostStatus.loading);
                        String? body = await getIt<FeedRepo>().getMediaKey(context); 
                        File? files = File(widget.files!.files[0].path!);
                        Uint8List bytesFiles = files.readAsBytesSync();
                        String digestFile = sha256.convert(bytesFiles).toString();
                        String imageHash = base64Url.encode(HEX.decode(digestFile)); 
                        await getIt<FeedRepo>().uploadMedia(context, body!, imageHash, files);
                        await context.read<FeedProvider>().sendPostDoc(context, caption, widget.files!);
                        context.read<FeedProvider>().setStateWritePost(WritePostStatus.loaded);
                        Navigator.of(context).pop();            
                      },
                      child: Container(
                        width: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
                        ? null 
                        : 80.0,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: ColorResources.primaryOrange,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
                        ? const Loader(
                            color: ColorResources.white,
                          ) 
                        : Text('Post',
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            color: ColorResources.white,
                          ),
                        ),
                      ),
                    )
                  ]
                ),
              )
            ],
            centerTitle: false,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              height: MediaQuery.of(context).size.height - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(widget.files != null)
                    displaySingleDoc(),
                  const SizedBox(height: 10.0),
                  TextField(
                    maxLines: null,
                    controller: captionC,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                    decoration: InputDecoration(
                      labelText: "Caption",
                      labelStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Colors.grey
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey, 
                          width: 0.5
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey, 
                          width: 0.5
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          )
        ]
      ),
    );
  }
  
}