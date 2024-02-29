import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:saka/data/models/feedv2/feed.dart';
import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/feedv2/feed.dart';
import 'package:saka/localization/language_constraints.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/exceptions.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:uuid/uuid.dart';

enum FeedStatus { idle, loading, loaded, empty, error }
enum WritePostStatus { idle, loading, loaded, empty, error }

class FeedProviderV2 with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepoV2 fr;
  FeedProviderV2({
    required this.ar,
    required this.fr
  });

  bool hasMore = true;
  int pageKey = 1;

  late TextEditingController postC;

  String feedType = "text";

  bool? isImage;

  File? videoFile;
  Uint8List? videoFileThumbnail;
  String? videoSize;

  String? docName;
  File? docFile;
  String? docSize;

  List<File> pickedFile = [];
  List<Asset> images = [];
  List<Asset> resultList = [];
  List<File> files = [];


  FeedStatus _feedStatus = FeedStatus.loading;
  FeedStatus get feedStatus => _feedStatus;

  WritePostStatus _writePostStatus = WritePostStatus.idle;
  WritePostStatus get writePostStatus => _writePostStatus;

  void setStateFeedStatus(FeedStatus feedStatus) {
    _feedStatus = feedStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  void setStateWritePost(WritePostStatus writePostStatus) {
    _writePostStatus = writePostStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  FeedData _fd = FeedData();
  FeedData get fd => _fd;

  List<Forum> _forum1 = [];
  List<Forum> get forum1 => [..._forum1];
  List<Forum> _forum2 = [];
  List<Forum> get forum2 => [..._forum2];
  List<Forum> _forum3 = [];
  List<Forum> get forum3 => [..._forum3];

  Future<void> fetchFeedMostRecent(BuildContext context) async {
    setStateFeedStatus(FeedStatus.loading);
    pageKey = 1;
    try {
      FeedModel? g = await fr.fetchFeedMostRecent(context, pageKey, ar.getUserId().toString());
      _fd = g!.data!;

      _forum1.clear();
      _forum1.addAll(g.data!.forums!);
      setStateFeedStatus(FeedStatus.loaded);

      if (_forum1.isEmpty) {
        setStateFeedStatus(FeedStatus.empty);
      }
    } on CustomException catch (e) {
      setStateFeedStatus(FeedStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedStatus(FeedStatus.error);
    }
  }
  Future<void> fetchFeedPopuler(BuildContext context) async {
    setStateFeedStatus(FeedStatus.loading);
    pageKey = 1;
    try {
      FeedModel? g = await fr.fetchFeedPopuler(context, pageKey, ar.getUserId().toString());
      _fd = g!.data!;

      _forum2.clear();
      _forum2.addAll(g.data!.forums!);
      setStateFeedStatus(FeedStatus.loaded);

      if (_forum2.isEmpty) {
        setStateFeedStatus(FeedStatus.empty);
      }
    } on CustomException catch (e) {
      setStateFeedStatus(FeedStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedStatus(FeedStatus.error);
    }
  }
  Future<void> fetchFeedSelf(BuildContext context) async {
    setStateFeedStatus(FeedStatus.loading);
    pageKey = 1;
    try {
      FeedModel? g = await fr.fetchFeedSelf(context, pageKey, ar.getUserId().toString());
      _fd = g!.data!;

      _forum3.clear();
      _forum3.addAll(g.data!.forums!);
      setStateFeedStatus(FeedStatus.loaded);
      debugPrint("Jumlah forum : ${_forum3.length}");

      if (_forum3.isEmpty) {
        debugPrint("Kosong");
        setStateFeedStatus(FeedStatus.empty);
      }
    } on CustomException catch (e) {
      setStateFeedStatus(FeedStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedStatus(FeedStatus.error);
    }
  }

  Future<void> post(BuildContext context,String type, List<File> files) async {
    String feedId = const Uuid().v4();
    
    if (postC.text.trim().isEmpty) {
      return ShowSnackbar.snackbar(context, getTranslated("CAPTION_IS_REQUIRED", context), "", ColorResources.error);
    }
    if(postC.text.trim().length > 1000) {
      ShowSnackbar.snackbar(context, getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
      return;
    }

    setStateWritePost(WritePostStatus.loading);
    if (feedType == "text") {
      await fr.post(
        context: context, 
        feedId: feedId,
        appName: 'saka', 
        userId: ar.getUserId().toString(), 
        feedType: type, 
        media: 'hello.jpg', 
        caption: postC.text, 
      );
    }

    if (feedType == "image") {
      await fr.post(
        context: context, 
        feedId: feedId,
        appName: 'saka', 
        userId: ar.getUserId().toString(), 
        feedType: type, 
        media: 'hello.jpg', 
        caption: postC.text, 
      );
      for (File p in files) {
        Map<String, dynamic> d = await fr.uploadMedia(context: context, folder: "images", media: File(p.path));
        print("Image : ${d["data"]["path"]}");
        await fr.postMedia(context: context, feedId: feedId, path: d["data"]["path"], size: d["data"]["size"]);
      }
    }

    Future.delayed(Duration.zero, () {
      NS.pop(context);
    });
    setStateWritePost(WritePostStatus.loaded);
    Future.delayed(Duration.zero, () {
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });
  }

  Future<void> postVideo(BuildContext context,String type, File files) async {
    setStateWritePost(WritePostStatus.loading);
    String feedId = const Uuid().v4();
    
    if (postC.text.trim().isEmpty) {
      return ShowSnackbar.snackbar(context, getTranslated("CAPTION_IS_REQUIRED", context), "", ColorResources.error);
    }
    if(postC.text.trim().length > 1000) {
      ShowSnackbar.snackbar(context, getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
      return;
    }

    if (feedType == "video") {
      await fr.post(
        context: context, 
        feedId: feedId,
        appName: 'saka', 
        userId: ar.getUserId().toString(), 
        feedType: type, 
        media: 'hello.jpg', 
        caption: postC.text, 
      );
      Map<String, dynamic> d = await fr.uploadMedia(context: context, folder: "images", media: files);
      print("Image : ${d["data"]["path"]}");
      await fr.postMedia(context: context, feedId: feedId, path: d["data"]["path"], size: d["data"]["size"]);
    }

    Future.delayed(Duration.zero, () {
      NS.pop(context);
    });
    setStateWritePost(WritePostStatus.loaded);
    Future.delayed(Duration.zero, () {
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });
  }
  Future<void> postVDoc(BuildContext context, String caption ,String type, File files) async {
    setStateWritePost(WritePostStatus.loading);
    String feedId = const Uuid().v4();
    
    if (caption.trim().isEmpty) {
      return ShowSnackbar.snackbar(context, getTranslated("CAPTION_IS_REQUIRED", context), "", ColorResources.error);
    }
    if(caption.trim().length > 1000) {
      ShowSnackbar.snackbar(context, getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
      return;
    }

    await fr.post(
      context: context, 
      feedId: feedId,
      appName: 'saka', 
      userId: ar.getUserId().toString(), 
      feedType: type, 
      media: 'hello.jpg', 
      caption: caption, 
    );
    Map<String, dynamic> d = await fr.uploadMedia(context: context, folder: "images", media: files);
    print("Image : ${d["data"]["path"]}");
    await fr.postMedia(context: context, feedId: feedId, path: d["data"]["path"], size: d["data"]["size"]);

    Future.delayed(Duration.zero, () {
      NS.pop(context);
    });
    setStateWritePost(WritePostStatus.loaded);
    Future.delayed(Duration.zero, () {
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });
  }

  Future<void> deletePost(BuildContext context, String postId) async {
    await fr.deletePost(context, postId);
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pop();
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });
  }

  // Future<void> uploadPic(BuildContext context) async {
  //   pickedFile = [];
  //   videoFile = null;
  //   docFile = null;
  //   if (imageSource == ImageSource.camera) {
  //     XFile? xf = await ImagePicker()
  //         .pickImage(source: ImageSource.camera, imageQuality: 80);
  //     if (xf != null) {
  //       pickedFile.add(File(xf.path));
  //       isImage = true;
  //       feedType = "image";
  //     }
  //   }
  //   if (imageSource == ImageSource.gallery) {
  //     resultList = await MultiImagePicker.pickImages(
  //       cupertinoOptions: const CupertinoOptions(
  //           settings: CupertinoSettings(selection: SelectionSetting(max: 8))),
  //       materialOptions: const MaterialOptions(maxImages: 8),
  //       selectedAssets: images,
  //     );
  //     for (var imageAsset in resultList) {
  //       String? filePath = await LecleFlutterAbsolutePath.getAbsolutePath(
  //           uri: imageAsset.identifier);
  //       File compressedFile = await FlutterNativeImage.compressImage(filePath!,
  //           quality: 80, percentage: 80);
  //       pickedFile.add(File(compressedFile.path));
  //       isImage = true;
  //       feedType = "image";
  //     }
  //   }
  //   Future.delayed(Duration.zero, () => notifyListeners());
  // }
  
}