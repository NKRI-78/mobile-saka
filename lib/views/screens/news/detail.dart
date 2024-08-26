import 'dart:io';

// import 'package:flutter_html/flutter_html.dart';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';

import 'package:saka/providers/news/news.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

class DetailNewsScreen extends StatefulWidget {
  final String contentId;

  DetailNewsScreen({
    Key? key,
    required this.contentId
  }) : super(key: key);
  @override
  DetailInfoPageState createState() => DetailInfoPageState();
}

class DetailInfoPageState extends State<DetailNewsScreen> {

  late ScrollController scrollController;

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

  Future<void> getData() async {
    if(!mounted) return;
      await context.read<NewsProvider>().getNewsSingle(
        context, widget.contentId
      );
  }

  @override
  void initState() {

    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    
    // if (widget.title.length > 24) {
    //   titleMore = widget.title.substring(0, 24);
    // } else {
    //   titleMore = widget.title;
    // }

    Future.microtask(() => getData());

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      body: Consumer<NewsProvider>(
        builder: (__, notifier, _) {
          
          if(notifier.getNewsSingleStatus == GetNewsSingleStatus.loading) {
            return Center(
              child: CircularProgressIndicator()
            );
          }

          return CustomScrollView(
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
                                msg: '${getTranslated("DOWNLOADING", context)}...'
                              );
                              await GallerySaver.saveImage('${notifier.singleNewsData.first.media!.first.path}');
                              pr.close();
                              ShowSnackbar.snackbar(context, getTranslated("SAVE_TO_GALLERY", context), "", ColorResources.success);
                            } catch(_) {
                              pr.close();
                              ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
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
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: "${notifier.singleNewsData.first.media!.first.path}",
                            fit: BoxFit.cover,
                            placeholder: (BuildContext context, String url) => Center(
                            child: Image.asset("assets/images/default_image.png",
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                            errorWidget: (BuildContext context, String url, dynamic error) => Center(
                            child: Image.asset("assets/images/default_image.png",
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
                      notifier.singleNewsData.first.title.toString(),
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
                            child: Text(notifier.singleNewsData.first.title.toString(),
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
                            DateFormat('dd MMM yyyy').format(notifier.singleNewsData.first.created!),
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
                          child: HtmlWidget(
                            notifier.singleNewsData.first.content.toString(),
                            onTapUrl: (url) async {
                              await launchUrl(
                                Uri.parse(url),
                              );
                              return false;
                            },
                          )                          
                          // Html(
                          //   onLinkTap: (url, _, __) async {                       
                          //     await launchUrl(
                          //       Uri.parse(url!),
                          //     );
                          //   },
                          //   style: {
                          //     'span': Style(
                          //       color: Colors.black
                          //     ),
                          //     'p': Style(
                          //       color: ColorResources.black
                          //     ),
                          //   },
                          //   data: notifier.singleNewsData.first.content.toString()
                          // )
                        ),
                      ],
                    ),
                  )

                ])
              )
            ],
          );
        },
      )
    );
  }

}
