import 'dart:io';

import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/feedv2/feed.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

class CreatePostImageScreen extends StatefulWidget {
  final List<File>? files;
  const CreatePostImageScreen({
    Key? key, 
    this.files,
  }) : super(key: key);
  @override
  CreatePostImageScreenState createState() => CreatePostImageScreenState();
}

class CreatePostImageScreenState extends State<CreatePostImageScreen> {
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();

  late FeedProviderV2 fdv2;
  int current = 0;
  
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

  Widget displaySinglePictures() {
    File file = File(widget.files!.first.path);
    return SizedBox(
      height: 180.0,
      child: Image.file(file,
        fit: BoxFit.fitHeight,
        width: double.infinity,
      )
    );
  }

  Widget displayListPictures() {
    List<File> listFile = widget.files!.map((file) => File(file.path)).toList();
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() => current = index);
              }
            ),
            items: listFile.map((i) {
              File demoImage = File(i.path);
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200.0,
                        child: Image.file(
                          demoImage,
                          fit: BoxFit.fill,
                        )
                      ),
                    ]
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: listFile.map((i) {
              int index = listFile.indexOf(i);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current == index
                  ? const Color.fromRGBO(0, 0, 0, 0.9)
                  : const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
          )
        ]
      ),
    ); 
  }


  @override
  Widget build(BuildContext context) {
    return buildUI() ;
  }
  
  Widget buildUI() {
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
                color: ColorResources.black,
              ),
              onPressed: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading 
              ? () {} : () {
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
                        await fdv2.post(context, "image", widget.files!); 
                      },
                      child: Container(
                        width:context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading 
                        ? null : 80.0,
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
              margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall, bottom: Dimensions.marginSizeSmall),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(widget.files!.length > 1)
                          displayListPictures()
                        else 
                          displaySinglePictures()
                      ],
                    ),
                  ),
                  TextField(
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
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                  ),
                ]
              ),
            )
          )

        ]
      ),
    );
  }
}