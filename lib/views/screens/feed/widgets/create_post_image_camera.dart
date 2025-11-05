import 'dart:io';

import 'package:flutter/material.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

class CreatePostImageCameraScreen extends StatefulWidget {
  final XFile? file;

  const CreatePostImageCameraScreen(
    this.file, {Key? key}
  ) : super(key: key);

  @override
  CreatePostImageCameraScreenState createState() => CreatePostImageCameraScreenState();
}

class CreatePostImageCameraScreenState extends State<CreatePostImageCameraScreen> {
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();

  late FeedProviderV2 fdv2;

  
  @override 
  void initState() {
    super.initState();
    fdv2 = context.read<FeedProviderV2>();
    fdv2.postC = TextEditingController();
  }

  @override 
  void dispose() {
    fdv2.postC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        File file = File(widget.file!.path);
        return Scaffold(
          key: globalKey,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverAppBar(
                backgroundColor: ColorResources.white,
                centerTitle: false,
                floating: true,
                title: Text(getTranslated("CREATE_POST", context), 
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.black 
                  )
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: ColorResources.black
                  ),
                  onPressed: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading ? () {} : () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading 
                          ? () {} 
                          : () async {                
                            fdv2.feedType = "image";
                            await fdv2.postImageCamera(context, "image", file);
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
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 200.0,
                        child: Image.file(
                          file,
                          fit: BoxFit.fill,
                        )
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                        child: TextField(
                          maxLines: null,
                          controller: fdv2.postC,
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
                      ),
                    ],
                  ),
                )
              )
            ]
          )
        );
      },
    );
  }
}
