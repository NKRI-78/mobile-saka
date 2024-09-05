import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/services.dart';

import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import 'package:saka/providers/profile/profile.dart';

import 'package:saka/data/models/feedv2/feed.dart';
import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/feedv2/feed.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/exceptions.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

enum FeedStatus { idle, loading, loaded, empty, error }
enum WritePostStatus { idle, loading, loaded, empty, error }

enum FeedRecentStatus { idle, loading, loaded, empty, error }
enum FeedPopulerStatus { idle, loading, loaded, empty, error }
enum FeedSelfStatus { idle, loading, loaded, empty, error }

class FeedProviderV2 with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepoV2 fr;
  
  FeedProviderV2({
    required this.ar,
    required this.fr
  });

  bool hasMore = true;
  bool hasMore2 = true;
  bool hasMore3 = true;
  int pageKey = 1;
  int pageKey2 = 1;
  int pageKey3 = 1;

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

  FeedRecentStatus _feedRecentStatus = FeedRecentStatus.loading;
  FeedRecentStatus get feedRecentStatus => _feedRecentStatus;
  FeedPopulerStatus _feedPopulerStatus = FeedPopulerStatus.loading;
  FeedPopulerStatus get feedPopulerStatus => _feedPopulerStatus;
  FeedSelfStatus _feedSelfStatus = FeedSelfStatus.loading;
  FeedSelfStatus get feedSelfStatus => _feedSelfStatus;

  WritePostStatus _writePostStatus = WritePostStatus.idle;
  WritePostStatus get writePostStatus => _writePostStatus;

  void resetFeedType() {
    feedType = "text";

    notifyListeners();
  }

  void setStateFeedRecentStatus(FeedRecentStatus feedRecentStatus) {
    _feedRecentStatus = feedRecentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  void setStateFeedPopulerStatus(FeedPopulerStatus feedPopulerStatus) {
    _feedPopulerStatus = feedPopulerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  void setStateFeedSelfStatus(FeedSelfStatus feedSelfStatus) {
    _feedSelfStatus = feedSelfStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateWritePost(WritePostStatus writePostStatus) {
    _writePostStatus = writePostStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  FeedData _fd = FeedData();
  FeedData get fd => _fd;

  final List<Forum> _forum1 = [];
  List<Forum> get forum1 => [..._forum1];
  final List<Forum> _forum2 = [];
  List<Forum> get forum2 => [..._forum2];
  final List<Forum> _forum3 = [];
  List<Forum> get forum3 => [..._forum3];

  Future<void> fetchFeedMostRecent(BuildContext context) async {
    pageKey = 1;
    hasMore = true;

    try {

      FeedModel? g = await fr.fetchFeedMostRecent(context, pageKey, ar.getUserId().toString());
      _fd = g!.data!;

      _forum1.clear();
      _forum1.addAll(g.data!.forums!);
      setStateFeedRecentStatus(FeedRecentStatus.loaded);

      if (_forum1.isEmpty) {
        setStateFeedRecentStatus(FeedRecentStatus.empty);
      }
    } on CustomException catch (e) {
      setStateFeedRecentStatus(FeedRecentStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedRecentStatus(FeedRecentStatus.error);
    }
  }

  Future<void> fetchFeedPopuler(BuildContext context) async {
    setStateFeedPopulerStatus(FeedPopulerStatus.loading);
    pageKey2 = 1;
    hasMore2 = true;

    try {
      FeedModel? g = await fr.fetchFeedPopuler(context, pageKey, ar.getUserId().toString());
      _fd = g!.data!;

      _forum2.clear();
      _forum2.addAll(g.data!.forums!);
      setStateFeedPopulerStatus(FeedPopulerStatus.loaded);

      if (_forum2.isEmpty) {
        setStateFeedPopulerStatus(FeedPopulerStatus.empty);
      }
    } on CustomException catch (e) {
      setStateFeedPopulerStatus(FeedPopulerStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedPopulerStatus(FeedPopulerStatus.error);
    }
  }

  Future<void> fetchFeedSelf(BuildContext context) async {
    setStateFeedSelfStatus(FeedSelfStatus.loading);
    pageKey3 = 1;
    hasMore3 = true;

    try {
      FeedModel? g = await fr.fetchFeedSelf(context, pageKey, ar.getUserId().toString());
      _fd = g!.data!;

      _forum3.clear();
      _forum3.addAll(g.data!.forums!);
      setStateFeedSelfStatus(FeedSelfStatus.loaded);

      if (_forum3.isEmpty) {
        setStateFeedSelfStatus(FeedSelfStatus.empty);
      }
    } on CustomException catch (e) {
      setStateFeedSelfStatus(FeedSelfStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedSelfStatus(FeedSelfStatus.error);
    }
  }

  Future<void> loadMoreRecent({required BuildContext context}) async {
    pageKey++;

    FeedModel? g = await fr.fetchFeedMostRecent(context, pageKey, ar.getUserId().toString());

    hasMore = g!.data!.pageDetail!.hasMore!;
    _forum1.addAll(g.data!.forums!);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> loadMorePopuler({required BuildContext context}) async {
    pageKey2++;

    FeedModel? g = await fr.fetchFeedPopuler(context, pageKey2, ar.getUserId().toString());

    hasMore2 = g!.data!.pageDetail!.hasMore!;
    _forum2.addAll(g.data!.forums!);
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  Future<void> loadMoreSelf({required BuildContext context}) async {
    pageKey3++;

    FeedModel? g = await fr.fetchFeedSelf(context, pageKey3, ar.getUserId().toString());

    hasMore3 = g!.data!.pageDetail!.hasMore!;
    _forum3.addAll(g.data!.forums!);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> post(BuildContext context,String type, List<File> files) async {
    String forumId = const Uuid().v4();
    
    if (postC.text.trim().isEmpty) {
      setStateWritePost(WritePostStatus.error);
      return ShowSnackbar.snackbar(getTranslated("CAPTION_IS_REQUIRED", context), "", ColorResources.error);
    }

    if(postC.text.trim().length > 1000) {
      setStateWritePost(WritePostStatus.error);
      ShowSnackbar.snackbar(getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
      return;
    }

    setStateWritePost(WritePostStatus.loading);

    if (feedType == "text") {
      await fr.post(
        forumId: forumId,
        appName: 'saka', 
        userId: ar.getUserId().toString(), 
        feedType: type, 
        media: 'media.jpg', 
        caption: postC.text, 
        link: '', 
      );

      Navigator.of(context).pop();
    }

    if (feedType == "image") {

      for (File p in files) {
        Map<String, dynamic>? d = await fr.uploadMedia(folder: "images", media: File(p.path));
      
        await fr.postMedia(forumId: forumId, path: d!["data"]["path"], size: d["data"]["size"]);
      }

      await fr.post(
        forumId: forumId,
        appName: 'saka', 
        userId: ar.getUserId().toString(), 
        feedType: type, 
        media: 'media.jpg',
        link: '', 
        caption: postC.text, 
      );

      for (int i = 0; i < 2; i++) {
        Navigator.of(context).pop();
      }

    }

    setStateWritePost(WritePostStatus.loaded);

    Future.delayed(Duration.zero, () {
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });
  }

  Future<void> postImageCamera(BuildContext context,String type, File files) async {
    String forumId = const Uuid().v4();
    
    if (postC.text.trim().isEmpty) {
      setStateWritePost(WritePostStatus.error);
      return ShowSnackbar.snackbar(getTranslated("CAPTION_IS_REQUIRED", context), "", ColorResources.error);
    }

    if(postC.text.trim().length > 1000) {
      setStateWritePost(WritePostStatus.error);
      ShowSnackbar.snackbar(getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
      return;
    }

    setStateWritePost(WritePostStatus.loading);

    if (feedType == "image") {
      Map<String, dynamic>? d = await fr.uploadMedia(folder: "images", media: File(files.path));
      
      await fr.post(
        forumId: forumId,
        appName: 'saka', 
        userId: ar.getUserId().toString(), 
        feedType: type, 
        media: d!["data"]["path"], 
        link: '',
        caption: postC.text, 
      );

      await fr.postMedia(forumId: forumId, path: d["data"]["path"], size: d["data"]["size"]);

    }

    for (int i = 0; i < 2; i++) {
      Navigator.of(context).pop();
    }

    setStateWritePost(WritePostStatus.loaded);

    Future.delayed(Duration.zero, () {
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });
  }

  Future<void> postVideo(BuildContext context,String type, File files) async {
    String forumId = const Uuid().v4();
    
    if (postC.text.trim().isEmpty) {
      setStateWritePost(WritePostStatus.error);
      return ShowSnackbar.snackbar(getTranslated("CAPTION_IS_REQUIRED", context), "", ColorResources.error);
    }

    if(postC.text.trim().length > 1000) {
      setStateWritePost(WritePostStatus.error);
      ShowSnackbar.snackbar(getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
      return;
    }

    setStateWritePost(WritePostStatus.loading);

    if (feedType == "video") {

      Map<String, dynamic>? d = await fr.uploadMedia(folder: "videos", media: files);
      
      await fr.post(
        forumId: forumId,
        appName: 'saka', 
        userId: ar.getUserId().toString(), 
        feedType: type, 
        media: d!["data"]["path"], 
        link: '',
        caption: postC.text, 
      );

      await fr.postMedia(forumId: forumId, path: d["data"]["path"], size: d["data"]["size"]);

      for (int i = 0; i < 2; i++) {
        Navigator.of(context).pop();
      }
    }

    setStateWritePost(WritePostStatus.loaded);
    
    Future.delayed(Duration.zero, () {
      fetchFeedMostRecent(context);
    });
  }

  Future<void> postLink(BuildContext context,String type, String link) async {

    setStateWritePost(WritePostStatus.loading);
    String forumId = const Uuid().v4();
    
    if (postC.text.trim().isEmpty) {
      setStateWritePost(WritePostStatus.error);
      return ShowSnackbar.snackbar(getTranslated("CAPTION_IS_REQUIRED", context), "", ColorResources.error);
    }

    if(postC.text.trim().length > 1000) {
      setStateWritePost(WritePostStatus.error);
      ShowSnackbar.snackbar(getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
      return;
    }

    if(postC.text.trim().isNotEmpty) {
      if(postC.text.trim().length < 10) {
        setStateWritePost(WritePostStatus.error);
        ShowSnackbar.snackbar(getTranslated("CAPTION_MINIMUM", context), "", ColorResources.error);
        return;
      }
    } 

    if(link.trim().isEmpty) {
      setStateWritePost(WritePostStatus.error);
      ShowSnackbar.snackbar(getTranslated("URL_IS_REQUIRED", context), "", ColorResources.error);
      return;
    } 

    bool validURL = Uri.parse(link.trim()).isAbsolute;

    if(!validURL) {
      setStateWritePost(WritePostStatus.error);
      ShowSnackbar.snackbar(getTranslated("URL_FORMAT", context), "", ColorResources.error);
      return;
    }

    if (feedType == "link") {
      await fr.post(
        forumId: forumId,
        appName: 'saka', 
        userId: ar.getUserId().toString(), 
        feedType: type, 
        media: 'media.jpg',
        link: link, 
        caption: postC.text, 
      );
    }

    setStateWritePost(WritePostStatus.loaded);

    for (int i = 0; i < 2; i++) {
      Navigator.of(context).pop();
    }

    Future.delayed(Duration.zero, () {
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });
  }

  Future<void> postVDoc(BuildContext context, String caption ,String type, File files) async {
    setStateWritePost(WritePostStatus.loading);
    String forumId = const Uuid().v4();
    
    if (caption.trim().isEmpty) {
      setStateWritePost(WritePostStatus.error);
      return ShowSnackbar.snackbar(getTranslated("CAPTION_IS_REQUIRED", context), "", ColorResources.error);
    }

    if(caption.trim().length > 1000) {
      setStateWritePost(WritePostStatus.error);
      ShowSnackbar.snackbar(getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
      return;
    }

    Map<String, dynamic>? d = await fr.uploadMedia(folder: "documents", media: files);

    await fr.post(
      forumId: forumId,
      appName: 'saka', 
      userId: ar.getUserId().toString(), 
      feedType: type, 
      media: "media.jpg", 
      link: d!["data"]["path"],
      caption: caption, 
    );
    
    await fr.postMedia( 
      forumId: forumId, 
      path: d["data"]["path"], 
      size: d["data"]["size"]
    );

    setStateWritePost(WritePostStatus.loaded);

    for (int i = 0; i < 2; i++) {
      Navigator.of(context).pop();
    }
    
    Future.delayed(Duration.zero, () {
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });
  }

  Future<void> deletePost(BuildContext context, String postId, String from) async {
    await fr.deletePost(context, postId);

    Future.delayed(Duration.zero, () {
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });

    if(from == "index") {
      for (int i = 0; i < 1; i++) {
        Navigator.of(context).pop();
      }
    } else {
      for (int i = 0; i < 2; i++) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> deleteReply(BuildContext context, String replyId) async {
    await fr.deleteReply(context, replyId);

    Future.delayed(Duration.zero, () {
      fetchFeedSelf(context);
      fetchFeedMostRecent(context);
      fetchFeedPopuler(context);
    });
  }

  Future<void> toggleLike({
    required BuildContext context,
    required String forumId, 
    required ForumLikes feedLikes
  }) async {
    try {
      
      int idxLikes = feedLikes.likes.indexWhere((el) => el.user!.id == ar.getUserId().toString());

      if (idxLikes != -1) {
        feedLikes.likes.removeAt(idxLikes);

        feedLikes.total = feedLikes.total - 1;
      } else {
        feedLikes.likes.add(UserLikes(
          user: User(
          id: context.read<ProfileProvider>().userProfile.userId.toString(),
          avatar: context.read<ProfileProvider>().userProfile.profilePic.toString(),
          username: context.read<ProfileProvider>().userProfile.fullname.toString()
        )));
        
        feedLikes.total = feedLikes.total + 1;
      }

      await fr.toggleLike(context: context, forumId: forumId, userId: ar.getUserId().toString());

      notifyListeners();

    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
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