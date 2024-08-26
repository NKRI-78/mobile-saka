import 'dart:io';
import 'dart:typed_data';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saka/services/navigation.dart';
import 'package:provider/provider.dart';
import 'package:saka/utils/input_formatters.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';

import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:video_compress/video_compress.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/views/screens/feed/widgets/create_post_image_camera.dart';
import 'package:saka/views/screens/feed/widgets/create_post_link.dart';
import 'package:saka/views/screens/feed/widgets/create_post_video.dart';
import 'package:saka/views/screens/feed/widgets/create_post_image.dart';
import 'package:saka/views/screens/feed/widgets/create_post_doc.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/providers/profile/profile.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

class CreatePostText extends StatefulWidget {
  const CreatePostText({
    Key? key, 
  }) : super(key: key);

  @override
  CreatePostTextState createState() => CreatePostTextState();
}

class CreatePostTextState extends State<CreatePostText> {

  late ScrollController scrollController;
  late FeedProviderV2 fd;
  
    ImageSource? imageSource;
  File? fileVideo;
  Uint8List? thumbnail;

  List<Asset> images = [];
  List<File> files = [];
  List<Asset> resultList = [];

  Future<void> uploadPic() async {

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
      
      files = [];

      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if(pickedFile != null) {
        NS.push(context, CreatePostImageCameraScreen(
          pickedFile
        ));
      }
    }

    if(imageSource == ImageSource.gallery) {
      
      files = [];

      resultList = await MultiImagePicker.pickImages(
        iosOptions: const IOSOptions(
          settings: CupertinoSettings(
            selection: SelectionSetting(max: 8)
          )
        ),
        androidOptions: const AndroidOptions(
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
        NS.push(context, CreatePostImageScreen(
          files: files,
        ));
      });
    }

  }

  void postLink() {
    NS.push(context, const CreatePostLink());
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
      
      // String fs = filesize(sizeInBytes, 0).replaceAll(RegExp(r'[^0-9]'),'');

      // if(int.parse(fs) >= 100) {
      //   ShowSnackbar.snackbar(context, getTranslated("SIZE_MAXIMUM", context), "", ColorResources.error);
      //   return;
      // }

      setState(() =>  fileVideo = file);

      thumbnail =  await VideoCompress.getByteThumbnail(fileVideo!.path);

      Future.delayed(const Duration(seconds: 1), () async {
        NS.push(context, CreatePostVideoScreen(
          file: file,
          thumbnail: thumbnail,
          videoSize: filesize(sizeInBytes, 0)
        ));
      }); 
    }
  }

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
      NS.push(context, CreatePostDocScreen(files: result));
    }
  }

  
  @override 
  void initState() {
    super.initState();
    fd = context.read<FeedProviderV2>();

    scrollController = ScrollController();
    fd.postC = TextEditingController();
    fd.resetFeedType();
  }

  @override 
  void dispose() {
    scrollController.dispose();
    fd.postC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorResources.white,
        title: Text(getTranslated("CREATE_POST", context), 
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.bold,
            color: ColorResources.black
          )
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorResources.black,
          ),
          onPressed: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading 
          ? () {} 
          : () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading 
                  ? () {} 
                  : () async {
                    await fd.post(context, "text", []);   
                  },
                  child: Container(
                    width: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading ? null : 80.0,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: ColorResources.primaryOrange,
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading 
                    ? const Loader(
                        color: ColorResources.white,
                      ) 
                    : Text('Post',
                      textAlign: TextAlign.center,
                      style: robotoRegular.copyWith(
                        color: ColorResources.white
                      ),
                    ),
                  ),
                )
              ]
            ),
          )
        ],
        centerTitle: false,
      ),
      bottomNavigationBar: SizedBox(
        height: 80.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: uploadPic,
              icon: const Icon(
                size: 30.0,
                Icons.image,
                color: ColorResources.primaryOrange
              ),
            ),
            IconButton(
              onPressed: uploadVid,
              icon: const Icon(
                size: 30.0,
                Icons.video_call,
                color: ColorResources.primaryOrange,
              ),
            ),
            IconButton(
              onPressed: postLink, 
              icon: const Icon(
                size: 30.0,
                Icons.attach_file,
                color: ColorResources.primaryOrange,
              ),
              
            ),
            IconButton(
              onPressed: uploadDoc,
              icon: const Icon(
                size: 30.0,
                Icons.picture_as_pdf,
                color: ColorResources.primaryOrange,
              ),
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 20.0, 
          left: 16.0, 
          right: 16.0
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            const SizedBox(width: 20.0),

            Flexible(
              child: TextField(
                maxLines: null,
                minLines: 3,
                cursorColor: ColorResources.black,
                controller: fd.postC,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
                inputFormatters: [
                  CapitalizeWordsInputFormatter()
                ],
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: getTranslated("WRITE_POST", context),
                  labelStyle: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.black
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(
                      color: ColorResources.black, 
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(
                      color: ColorResources.black, 
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    
    );
  }


}