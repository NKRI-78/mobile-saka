import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

class DetailNewsScreen extends StatefulWidget {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime date;

  DetailNewsScreen({
    Key? key,
    required this.title, 
    required this.content, 
    required this.imageUrl, 
    required this.date
  }) : super(key: key);
  @override
  _DetailInfoPageState createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailNewsScreen> {

  late ScrollController scrollController;

  String? imageUrl;
  String? title;
  String? content;
  String? titleMore;
  DateTime? date;

  bool lastStatus = true;

  void scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return scrollController.hasClients && scrollController.offset > (250 - kToolbarHeight);
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    if (widget.title.length > 24) {
      titleMore = widget.title.substring(0, 24);
    } else {
      titleMore = widget.title;
    }
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    imageUrl = this.widget.imageUrl;
    title = this.widget.title;
    content = this.widget.content;
    date = this.widget.date;

    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: isShrink ? Colors.black : Colors.white,
            ),
            pinned: true,
            expandedHeight: 250.0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(8),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: isShrink ? null : Colors.black54
                ),
                child: Center(
                  child: Platform.isIOS
                    ? Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Icon(Icons.arrow_back_ios
                    )
                  )
                  : Icon(Icons.arrow_back)
                )
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8.0),
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: isShrink ? null : Colors.black54
                ),
                child: Builder(
                  builder: (BuildContext ctx) {
                    return PopupMenuButton(
                      onSelected: (int i) async {
                        ProgressDialog pr = ProgressDialog(context: context);
                        try {
                          PermissionStatus statusStorage = await Permission.storage.status;
                          if(!statusStorage.isGranted) {
                            await Permission.storage.request();
                          } 
                          pr.show(
                            max: 1,
                            msg: 'Downloading...'
                          );
                          Response response = await Dio().get('${widget.imageUrl}');
                          await ImageGallerySaver.saveImage(
                            Uint8List.fromList(response.data),
                            quality: 60,
                          );
                          pr.close();
                          ShowSnackbar.snackbar(ctx, "Gambar telah disimpan di galeri", "", ColorResources.success);
                        } catch(e, stacktrace) {
                          debugPrint(stacktrace.toString());
                          pr.close();
                          ShowSnackbar.snackbar(ctx, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
                        }
                      },
                      icon: const Icon(Icons.more_horiz),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          textStyle: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall
                          ),
                          child: Text(getTranslated("DOWNLOAD", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.black
                            )
                          ),
                          value: 1,
                        ),
                      ]
                    );                 
                  },
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: "$imageUrl",
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) => Loader(
                          color: ColorResources.primaryOrange,
                        ),
                        errorWidget: (BuildContext context, String url, dynamic error) => Center(
                        child: Image.asset("assets/images/profile.png",
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              title: AnimatedOpacity(
                opacity: isShrink ? 1.0 : 0.0,
                duration: Duration(milliseconds: 150),
                child: Text(
                  titleMore! + "...",
                  maxLines: 1,
                  style: robotoRegular.copyWith(
                    color: Colors.black, 
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([

            Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: AnimatedOpacity(
                      opacity: isShrink ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 250),
                      child: Text(title!,
                      textAlign: TextAlign.start,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: ColorResources.black,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(date!),
                      style: robotoRegular.copyWith(
                        color: Colors.grey, 
                        fontSize: Dimensions.fontSizeDefault
                      ),
                    )
                  ),
                  Divider(
                    height: 4.0,
                    thickness: 1.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                    child: Html(
                      onLinkTap: (url, _, __) async {                       
                        await launchUrl(
                          Uri.parse(url!),
                        );
                      },
                      style: {
                        'span': Style(
                          color: Colors.black
                        ),
                        'p': Style(
                          color: ColorResources.black
                        ),
                      },
                      data: content
                    )
                  ),
                ],
              ),
            )

          ]))
        ],
      ),
    );
  }

}
