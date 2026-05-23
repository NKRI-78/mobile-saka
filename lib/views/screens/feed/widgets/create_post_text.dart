import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/providers/profile/profile.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/screens/feed/widgets/create_post_doc.dart';
import 'package:saka/views/screens/feed/widgets/create_post_image.dart';
import 'package:saka/views/screens/feed/widgets/create_post_image_camera.dart';
import 'package:saka/views/screens/feed/widgets/create_post_link.dart';
import 'package:saka/views/screens/feed/widgets/create_post_video.dart';
// HAPUS: lecle_flutter_absolute_path
// import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';

import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:path_provider/path_provider.dart'; // <— TAMBAHAN
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:video_compress/video_compress.dart';
import 'package:permission_handler/permission_handler.dart'; // <— TAMBAHAN (izin kamera)

class CreatePostText extends StatefulWidget {
  const CreatePostText({super.key});

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

  static const int _maxBytes = 100 * 1024 * 1024;

  Future<File> _assetToTempFile(Asset asset) async {
    final byteData = await asset.getByteData();
    final bytes = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );

    final tempDir = await getTemporaryDirectory();
    final safeName = (asset.name.isNotEmpty == true)
        ? asset.name
        : 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final f = File('${tempDir.path}/$safeName');
    return f.writeAsBytes(bytes, flush: true);
  }

  Future<void> uploadPic() async {
    imageSource = await showDialog<ImageSource?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          getTranslated("SOURCE_IMAGE", context),
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: ColorResources.primaryOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              getTranslated("CAMERA", context),
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: ColorResources.black,
              ),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text(
              getTranslated("GALLERY", context),
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: ColorResources.black,
              ),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (imageSource == null) return;

    files = [];

    if (imageSource == ImageSource.camera) {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        NS.push(context, CreatePostImageCameraScreen(pickedFile));
      }
      return;
    }

    if (imageSource == ImageSource.gallery) {
      resultList = await MultiImagePicker.pickImages(
        iosOptions: const IOSOptions(
          settings: CupertinoSettings(selection: SelectionSetting(max: 8)),
        ),
        androidOptions: const AndroidOptions(maxImages: 8),
        selectedAssets: images,
      );

      for (final asset in resultList) {
        final f = await _assetToTempFile(asset); // <— ganti absolute path
        setState(() => files.add(f));
      }
    }

    if (files.isNotEmpty) {
      NS.push(context, CreatePostImageScreen(files: files));
    }
  }

  void postLink() {
    NS.push(context, const CreatePostLink());
  }

  // =========================================================
  // ===============  VIDEO: Kamera atau Galeri  =============
  // =========================================================

  /// Dialog pilih sumber video: Kamera / Galeri
  Future<ImageSource?> _askVideoSource() async {
    return showDialog<ImageSource?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          getTranslated("SOURCE_VIDEO", context),
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: ColorResources.primaryOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              getTranslated("CAMERA", context),
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: ColorResources.black,
              ),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text(
              getTranslated("GALLERY", context),
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: ColorResources.black,
              ),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  /// Pastikan izin kamera jika ambil dari kamera (graceful di iOS/Android)
  Future<void> _ensureCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      if (status.isPermanentlyDenied) {
        ShowSnackbar.snackbar(
          getTranslated("CAMERA_PERMISSION_REQUIRED", context),
          "",
          ColorResources.error,
        );
        openAppSettings();
      }
    } catch (_) {
      // ignore jika plugin tidak expose izin tertentu
    }
  }

  /// Ambil video dari kamera
  Future<File?> _pickVideoFromCamera() async {
    await _ensureCameraPermission();
    final XFile? x = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(
        minutes: 5,
      ), // batasi durasi agar ukuran wajar
    );
    if (x == null) return null;
    return File(x.path);
  }

  /// Pilih video dari galeri
  Future<File?> _pickVideoFromGallery() async {
    // Bisa via ImagePicker (lebih aman Scoped Storage)…
    final XFile? x = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (x != null) return File(x.path);

    // …atau fallback ke FilePicker jika mau (tetap dipertahankan agar kompatibel)
    final pr = ProgressDialog(context: context);
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.video,
      allowMultiple: false,
      compressionQuality: 50,
      withData: false,
      withReadStream: true,
      onFileLoading: (FilePickerStatus s) {
        if (s == FilePickerStatus.picking) {
          pr.show(
            max: 2,
            msg: "${getTranslated("PLEASE_WAIT", context)}...",
            borderRadius: 10.0,
            backgroundColor: ColorResources.white,
            progressBgColor: ColorResources.primaryOrange,
            progressValueColor: ColorResources.white,
          );
        }
        if (s == FilePickerStatus.done) {
          pr.close();
        }
      },
    );
    if (result == null) return null;
    return File(result.files.single.path!);
  }

  /// Compress video jika > 100MB (medium quality). Return file terpakai & size.
  Future<(File file, int bytes, bool compressed)> _maybeCompress(File f) async {
    final originalSize = await f.length();
    if (originalSize <= _maxBytes) {
      return (f, originalSize, false);
    }

    final pr = ProgressDialog(context: context);
    pr.show(
      max: 100,
      msg: getTranslated("COMPRESSING_VIDEO", context),
      borderRadius: 10.0,
      backgroundColor: ColorResources.white,
      progressBgColor: ColorResources.primaryOrange,
      progressValueColor: ColorResources.white,
    );

    try {
      final MediaInfo? out = await VideoCompress.compressVideo(
        f.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false, // jangan hapus original
        includeAudio: true,
      );
      pr.close();

      if (out != null && out.path != null) {
        final cf = File(out.path!);
        final csize = await cf.length();
        return (cf, csize, true);
      } else {
        return (f, originalSize, false);
      }
    } catch (_) {
      pr.close();
      return (f, originalSize, false);
    }
  }

  /// Generate thumbnail aman (dari file path)
  Future<Uint8List?> _makeThumb(String path) async {
    try {
      return await VideoCompress.getByteThumbnail(path);
    } catch (_) {
      return null;
    }
  }

  /// Flow utama: pilih sumber → ambil/pilih video → cek ukuran → compress jika perlu → kirim ke screen berikutnya
  Future<void> uploadVid() async {
    final src = await _askVideoSource();
    if (src == null) return;

    // Ambil file sesuai sumber
    File? f;
    if (src == ImageSource.camera) {
      f = await _pickVideoFromCamera();
    } else {
      f = await _pickVideoFromGallery();
    }
    if (f == null) return;

    // Cek & compress jika perlu
    final (usableFile, sizeBytes, wasCompressed) = await _maybeCompress(f);

    // Jika masih > 100MB setelah compress → tolak
    if (sizeBytes > _maxBytes) {
      ShowSnackbar.snackbar(
        getTranslated("SIZE_MAXIMUM", context), // pastikan string ini 100MB
        "",
        ColorResources.error,
      );
      return;
    }

    // Simpan ke state
    setState(() => fileVideo = usableFile);

    // Thumbnail
    thumbnail = await _makeThumb(usableFile.path);

    // Push ke CreatePostVideoScreen
    NS.push(
      context,
      CreatePostVideoScreen(
        file: usableFile,
        thumbnail: thumbnail,
        videoSize: filesize(sizeBytes, 0),
        // Kalau kamu butuh info tambahan:
        // wasCompressed: wasCompressed,
      ),
    );
  }

  void uploadDoc() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        "pdf",
        "doc",
        "docx",
        "xls",
        "xlsx",
        "ppt",
        "ppt",
        "pptx",
        "txt",
      ],
    );
    if (result != null) {
      for (int i = 0; i < result.files.length; i++) {
        if (result.files[i].size > 50000000) {
          ShowSnackbar.snackbar(
            getTranslated("SIZE_MAXIMUM", context),
            "",
            ColorResources.error,
          );
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
    VideoCompress.setLogLevel(0); // optional: kurangi log
  }

  @override
  void dispose() {
    scrollController.dispose();
    fd.postC.dispose();
    // Optional: bersihkan cache compress
    VideoCompress.deleteAllCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorResources.white,
        title: Text(
          getTranslated("CREATE_POST", context),
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.bold,
            color: ColorResources.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorResources.black),
          onPressed:
              context.watch<FeedProviderV2>().writePostStatus ==
                  WritePostStatus.loading
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
                  onTap:
                      context.watch<FeedProviderV2>().writePostStatus ==
                          WritePostStatus.loading
                      ? () {}
                      : () async {
                          await fd.post(context, "text", []);
                        },
                  child: Container(
                    width:
                        context.watch<FeedProviderV2>().writePostStatus ==
                            WritePostStatus.loading
                        ? null
                        : 80.0,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: ColorResources.primaryOrange,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child:
                        context.watch<FeedProviderV2>().writePostStatus ==
                            WritePostStatus.loading
                        ? const Loader(color: ColorResources.white)
                        : Text(
                            'Post',
                            textAlign: TextAlign.center,
                            style: robotoRegular.copyWith(
                              color: ColorResources.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
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
                color: ColorResources.primaryOrange,
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
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Consumer<ProfileProvider>(
              builder:
                  (
                    BuildContext context,
                    ProfileProvider profileProvider,
                    Widget? child,
                  ) {
                    return CachedNetworkImage(
                      imageUrl: "${profileProvider.userProfile.profilePic}",
                      imageBuilder:
                          (BuildContext context, dynamic imageProvider) =>
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                // ignore: avoid_dynamic_calls
                                backgroundImage: imageProvider,
                                radius: 20.0,
                              ),
                      placeholder: (BuildContext context, String url) =>
                          const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(
                              'assets/images/default_avatar.jpg',
                            ),
                            radius: 20.0,
                          ),
                      errorWidget:
                          (BuildContext context, String url, dynamic error) =>
                              const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                  'assets/images/default_avatar.jpg',
                                ),
                                radius: 20.0,
                              ),
                    );
                  },
            ),
            const SizedBox(width: 20.0),
            Flexible(
              child: TextField(
                maxLines: null,
                minLines: 3,
                cursorColor: ColorResources.black,
                controller: fd.postC,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                ),
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: getTranslated("WRITE_POST", context),
                  labelStyle: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.black,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: ColorResources.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: ColorResources.black),
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
