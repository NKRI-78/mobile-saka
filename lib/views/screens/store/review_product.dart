import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/box_shadow.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/screens/store/buyer_transaction_order.dart';

class ReviewProductPage extends StatefulWidget {
  final String productId;
  final String nameProduct;
  final String imgUrl;

  const ReviewProductPage({
    Key? key,
    required this.productId,
    required this.nameProduct,
    required this.imgUrl,
  }) : super(key: key);
  @override
  _ReviewProductPageState createState() => _ReviewProductPageState();
}

class _ReviewProductPageState extends State<ReviewProductPage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController reviewC;

  double productRating = 1.0;

  List<File> files = [];
  List<Asset> images = [];

  Future<void> uploadPic() async {
    List<Asset> resultList = [];
    List<File> before = [];

    resultList = await MultiImagePicker.pickImages(
      iosOptions: const IOSOptions(
        settings: CupertinoSettings(
          selection: SelectionSetting(max: 8)
        )
      ),
      androidOptions: AndroidOptions(
        maxImages: 8
      ),
      selectedAssets: images,
    );
    for (var imageAsset in resultList) {
      String? filePath = await LecleFlutterAbsolutePath.getAbsolutePath(uri: imageAsset.identifier);
      File tempFile = File(filePath!);
      setState(() {
        images = resultList;
        before.add(tempFile);
        files = before.toSet().toList();
      });
    }
  }

  Future<bool> onWillPop() {
    NS.push(context, const TransactionOrderScreen(
      index: 5,
    ));
    return Future.value(true);
  }

  @override 
  void initState() {
    super.initState();

    reviewC = TextEditingController();
  }

  @override 
  void dispose() {
    reviewC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI(); 
  }

  Widget buildUI() {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: globalKey,
        backgroundColor: ColorResources.backgroundColor,
        appBar: AppBar(
          title: Text("Beri Ulasan Barang",
            style: robotoRegular.copyWith(
              color: ColorResources.white, 
              fontWeight: FontWeight.w600
            ),
          ),
          backgroundColor: ColorResources.primaryOrange,
          iconTheme: const IconThemeData(
            color: ColorResources.white
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Platform.isIOS 
              ? Icons.arrow_back_ios 
              : Icons.arrow_back,
              color: ColorResources.white),
            onPressed: () {
              Navigator.pop(context, true);
            }
          ),
        ),
        body: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: CachedNetworkImage(
                                      imageUrl: "${widget.imgUrl}",
                                      fit: BoxFit.cover,
                                      placeholder: (BuildContext context, String url) => Center(
                                        child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                            color: ColorResources.white,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        )
                                      ),
                                      errorWidget: (BuildContext context, String url, dynamic error) =>
                                        Center(
                                        child: Image.asset(
                                        "assets/images/logo/saka.png",
                                        fit: BoxFit.cover,
                                      )
                                      ),
                                    )
                                  )
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                widget.nameProduct.length > 75
                                ? Text(widget.nameProduct.substring(0, 80) + "...",
                                    maxLines: 2,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                : Text(
                                    widget.nameProduct,
                                    maxLines: 2,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Center(
                        child: SizedBox(
                          child: RatingBar(
                            initialRating: 1.0,
                            minRating: 1.0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 50.0,
                            ratingWidget: RatingWidget(
                              full: const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              half: const Icon(Icons.star_half, color: Colors.amber),
                              empty: const Icon(Icons.star_border, color: Colors.amber),
                            ),
                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            onRatingUpdate: (rating) {
                              productRating = rating;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 35.0,
                      ),
                      Center(
                        child: Text("Yuk, Bantu calon pembeli lain dengan \nbagikan pengalamanmu!",
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Text("Fotoin dong barangnya",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault, 
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        height: 100.0,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: files.isEmpty
                      ? Row(
                          children: [
                            GestureDetector(
                              onTap: uploadPic,
                              child: Container(
                                height: 80.0,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.grey[400]!),
                                  color: Colors.grey[350]
                                ),
                                child: Center(
                                child: files.isEmpty
                                ? Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[600],
                                    size: 35.0,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: FadeInImage(
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                      image: FileImage(files.first),
                                      placeholder: const AssetImage("assets/images/logo/saka.png")
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Unggah Gambar Ulasan",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                  )
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text("Maksimum 5 gambar, ukuran minimal 300x300px berformat JPG atau PNG",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Colors.grey[600]
                                  )
                                ),
                              ],
                            ))
                          ],
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: files.length + 1,
                          itemBuilder: (BuildContext context, int i) {
                            if (i < files.length) {
                              return Container(
                                height: 80.0,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.grey[400]!),
                                  color: Colors.grey[350]
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: FadeInImage(
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                      image: FileImage(files[i]),
                                      placeholder: const AssetImage("assets/images/logo/saka.png")
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  if (files.length < 5) {
                                    uploadPic();
                                  } else if (files.length >= 5) {
                                    setState(() {
                                      files.clear();
                                      images.clear();
                                    });
                                  }
                                },
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: Colors.grey[400]!),
                                      color: files.length < 5 ? Colors.grey[350] : Colors.red
                                    ),
                                  child: Center(
                                    child: Icon(
                                      files.length < 5 ? Icons.camera_alt : Icons.delete,
                                      color: files.length < 5 ? Colors.grey[600] : ColorResources.white,
                                      size: 35.0,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text("Apa yang bikin kamu puas?",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault, 
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        maxLength: null,
                        maxLines: null,
                        controller: reviewC,
                        decoration: InputDecoration(
                          hintText: "Ceritakan pengalamanmu terkait barang ini",
                          fillColor: ColorResources.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey[100]!
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        style: robotoRegular
                      ),
                      const SizedBox(
                        height: 60.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60.0,
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  boxShadow: boxShadow
                ),
                child: CustomButton(
                  btnColor: ColorResources.primaryOrange,
                  isBorder: false,
                  isBoxShadow: false,
                  isBorderRadius: true,
                  isLoading: context.watch<StoreProvider>().postDataReviewProductStatus == PostDataReviewProductStatus.loading ? true : false,
                  btnTxt: "Kirim",
                  onTap: () async {
                    await context.read<StoreProvider>().postDataReviewProduct(
                      context,
                      widget.productId,
                      productRating,
                      reviewC.text,
                      files
                    );
                  }
                )
              )
            )
          ],
        ),
      ),
    );
  }
}