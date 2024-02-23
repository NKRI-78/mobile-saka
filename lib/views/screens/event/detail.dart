import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dimensions.dart';

class DetailEventScreen extends StatefulWidget {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime date;

  DetailEventScreen({
    Key? key,
    required this.title, 
    required this.content, 
    required this.imageUrl, 
    required this.date
  }) : super(key: key);
  @override
  _DetailEventPageState createState() => _DetailEventPageState();
}

class _DetailEventPageState extends State<DetailEventScreen> {
  String? imageUrl;
  String? title;
  String? content;
  String? titleMore;
  DateTime? date;
  
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

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    if (widget.title.length > 24) {
      titleMore = widget.title.substring(0, 24);
    } else {
      titleMore = widget.title;
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    imageUrl = widget.imageUrl;
    title = widget.title;
    content = widget.content;
    date = widget.date;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
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
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: "${AppConstants.baseUrlImg}$imageUrl",
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (BuildContext context, String url, error) => Center(
                        child: Image.asset(
                          "assets/images/profile.png",
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
                    color: ColorResources.black, 
                    fontSize: Dimensions.fontSizeDefault,
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
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      DateFormat('dd MMM yyyy kk:mm').format(date!),
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
                    child: Text(content!,
                    textAlign: TextAlign.justify,
                      style: robotoRegular.copyWith(
                        height: 1.8
                      ),
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
