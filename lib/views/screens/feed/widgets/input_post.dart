
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:video_compress/video_compress.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/views/screens/feed/widgets/create_post_image_camera.dart';
import 'package:saka/views/screens/feed/widgets/create_post_link.dart';
import 'package:saka/views/screens/feed/widgets/create_post_video.dart';
import 'package:saka/views/screens/feed/widgets/create_post_image.dart';
import 'package:saka/views/screens/feed/widgets/create_post_doc.dart';
import 'package:saka/views/screens/feed/widgets/create_post_text.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/providers/profile/profile.dart';

class InputPostComponent extends StatefulWidget {
  const InputPostComponent({
    Key? key, 
  }) : super(key: key);
  @override
  _InputPostComponentState createState() => _InputPostComponentState();
}

class _InputPostComponentState extends State<InputPostComponent> {

  ImageSource? imageSource;
  File? fileVideo;
  Uint8List? thumbnail;

  List<Asset> images = [];
  List<File> files = [];
  List<Asset> resultList = [];

  void uploadPic() async {
    imageSource = await showDialog<ImageSource>(context: context, builder: (context) => 
      AlertDialog(
        title: Text(getTranslated("SOURCE_IMAGE", context),
        style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: ColorResources.primaryOrange,
          fontWeight: FontWeight.w600, 
        ),
      ),
      actions: [
        MaterialButton(
          child: Text(getTranslated("CAMERA", context),
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: ColorResources.black
            )
          ),
          onPressed: () => Navigator.pop(context, ImageSource.camera),
        ),
        MaterialButton(
          child: Text(getTranslated("GALLERY", context),
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: ColorResources.black
            ),
          ),
          onPressed: () => Navigator.pop(context, ImageSource.gallery)
          )
        ],
      )
    );
    if(imageSource == ImageSource.camera) {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if(pickedFile != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
          CreatePostImageCameraScreen(
            pickedFile
          )),
        ); 
      }
    }
    if(imageSource == ImageSource.gallery) {
      files = [];
      resultList = await MultiImagePicker.pickImages(
        cupertinoOptions: const CupertinoOptions(
          settings: CupertinoSettings(
            selection: SelectionSetting(max: 8)
          )
        ),
        materialOptions: MaterialOptions(
          maxImages: 8
        ),
        selectedAssets: images,
      );
      for (var imageAsset in resultList) {
        String? filePath = await LecleFlutterAbsolutePath.getAbsolutePath(uri: imageAsset.identifier);
        setState(() => files.add(File(filePath!))); 
      }
    }
    if(files.isNotEmpty) {
      Future.delayed(const Duration(seconds: 1),() {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreatePostImageScreen(
          files: files,
        )));
      });
    }
  }

  void postLink() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePostLink()));
  }

  Future<void> uploadVid() async {
    ProgressDialog pr = ProgressDialog(context: context);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
      allowCompression: true,
      withData: false,
      withReadStream: true,
      onFileLoading: (FilePickerStatus filePickerStatus) {
        if(filePickerStatus == FilePickerStatus.picking) {
          pr.show(
            max: 2,
            msg: "${getTranslated("PLEASE_WAIT", context)}...",
            borderRadius: 10.0,
            backgroundColor: ColorResources.white,
            progressBgColor: ColorResources.primaryOrange,
            progressValueColor: ColorResources.white
          ); 
        }
        if(filePickerStatus == FilePickerStatus.done) {
          pr.close();
        }
      }
    );
    if(result != null) {
      File file = File(result.files.single.path!);
      int sizeInBytes = file.lengthSync();
      String fs = filesize(sizeInBytes, 0).replaceAll(RegExp(r'[^0-9]'),'');
      if(int.parse(fs) >= 100) {
        ShowSnackbar.snackbar(context, getTranslated("SIZE_MAXIMUM", context), "", ColorResources.error);
        return;
      }
      setState(() {
        fileVideo = file;
      });

      thumbnail =  await VideoCompress.getByteThumbnail(fileVideo!.path);

      Future.delayed(Duration(milliseconds: 1000), () async {
        Navigator.push(context, MaterialPageRoute(builder:  (context)  =>
          CreatePostVideoScreen(
            file: file,
            thumbnail: thumbnail,
            videoSize: filesize(sizeInBytes, 0)
          )
        ));
      }); 
    }
  }

  // Future<void> generateThumbnail(File file) async {
  //   final thumbnailBytes = await VideoCompress.getByteThumbnail(file.path);
  //   setState(() {
  //     thumbnail = thumbnailBytes;
  //   });
  // }

  // Future<void> getVideoSize(File file) async {
  //   final size = await file.length(); 
  //   setState(() {
  //     videoSize = size;
  //   });
  // }

   void uploadDoc() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf","doc","docx","xls","xlsx","ppt","ppt","pptx","txt"],
      allowCompression: true,
    );
    if(result != null) {
      for (int i = 0; i < result.files.length; i++) {
        if(result.files[i].size > 50000000) {
          ShowSnackbar.snackbar(context, getTranslated("SIZE_MAXIMUM", context), "", ColorResources.error);
          return;
        } 
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
        CreatePostDocScreen(
          files: result
        ),
      ));     
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildUI(); 
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [ 
                    Consumer<ProfileProvider>(
                      builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
                        return CachedNetworkImage(
                        imageUrl: "${profileProvider.userProfile.profilePic}",
                          imageBuilder: (BuildContext context, dynamic imageProvider) => CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: imageProvider,
                            radius: 20.0,
                          ),
                          placeholder: (BuildContext context, String url) => const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                            radius: 20.0,
                          ),
                          errorWidget: (BuildContext context, String url, dynamic error) => const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                            radius: 20.0,
                          )
                        );
                      }
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault
                        ),
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                          hintText: getTranslated("WRITE_POST", context),
                          hintStyle: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall
                          )
                        ),
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute( builder: (context) =>
                              CreatePostText(key: UniqueKey())
                            ),
                          );
                        },
                      ),
                    )
                  ]
                ),
                SizedBox(
                  height: 56.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: uploadPic,
                        icon: const Icon(
                          Icons.image,
                          color: ColorResources.primaryOrange
                        ),
                      ),
                      IconButton(
                        onPressed: uploadVid,
                        icon: const Icon(
                          Icons.video_call,
                          color: ColorResources.primaryOrange,
                        ),
                      ),
                      IconButton(
                        onPressed: postLink, 
                        icon: const Icon(
                          Icons.attach_file,
                          color: ColorResources.primaryOrange,
                        ),
                        
                      ),
                      IconButton(
                        onPressed: uploadDoc,
                        icon: const Icon(
                          Icons.picture_as_pdf,
                          color: ColorResources.primaryOrange,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  
}