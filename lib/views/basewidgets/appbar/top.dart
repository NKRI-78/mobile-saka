import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class TopBar extends StatefulWidget {
  final String? barTitle;
  late final double? barTitleFontSize;
  final Color barTitleColor;
  final Widget? primaryAction;
  final Widget? secondaryAction;

  TopBar({
    Key? key,
    this.barTitle, 
    this.barTitleColor = ColorResources.white,
    this.primaryAction,
    this.secondaryAction,
  })  : super(key: key) {
    barTitleFontSize = Dimensions.fontSizeDefault;
  }

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late double deviceHeight;

  late double deviceWidth;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return buildUI();
  }  

  Widget buildUI() {
    return SizedBox(
      height: deviceHeight * 0.10,
      width: deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(widget.secondaryAction != null) widget.secondaryAction!,
          titleBar(),
          if(widget.primaryAction != null) widget.primaryAction!
        ],
      ),
    );
  }

  Widget titleBar() {
    return Text(
      widget.barTitle!, 
      overflow: TextOverflow.ellipsis,
      style: robotoRegular.copyWith(
        color: widget.barTitleColor,
        fontSize: widget.barTitleFontSize,
        fontWeight: FontWeight.w700
      ),
    );
  }
}

class TopBarChat extends StatefulWidget {
  final String? avatar;
  final String? barTitle;
  final String? subTitle;
  late final double? barTitleFontSize;
  late final double? barSubtitleFontSize;
  final Color barTitleColor;
  final Color? barSubtitleColor;
  final Widget? primaryAction;
  final Widget? secondaryAction;


  TopBarChat({
    Key? key,
    this.avatar,
    this.barTitle, 
    this.subTitle,
    this.barTitleColor = ColorResources.white,
    this.barSubtitleColor = ColorResources.white,
    this.primaryAction,
    this.secondaryAction,
  }) : super(key : key) {
    barTitleFontSize = 14.0;
    barSubtitleFontSize = 8.0;
  }

  @override
  State<TopBarChat> createState() => _TopBarChatState();
}

class _TopBarChatState extends State<TopBarChat> {
  late double deviceHeight;
  late double deviceWidth;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return buildUI();
  }  

  Widget buildUI() {
    return Container(
      width: deviceWidth,
      decoration: const BoxDecoration(
        color: ColorResources.brown
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(widget.secondaryAction != null) widget.secondaryAction!,
          widget.avatar != null && widget.avatar != '' ? ava() : Container(),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleBar(),
                const SizedBox(height: 5.0),
                subTitleBar()
              ],
            ),
          ),
          if(widget.primaryAction != null) widget.primaryAction!
        ],
      ),
    );
  }

  Widget ava() {
    return CachedNetworkImage(
      width: 30.0,
      height: 30.0,
      imageUrl: widget.avatar!,
      imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
        return CircleAvatar(
          backgroundImage: imageProvider,
          backgroundColor: ColorResources.white,
          radius: 20.0,
        );
      },
      placeholder: (BuildContext context, String url) {
        return const CircleAvatar(
          backgroundImage: AssetImage('assets/images/default_image.png'),
          backgroundColor: ColorResources.white,
          radius: 20.0,
        );
      },
      errorWidget: (BuildContext context, String url, dynamic error) {
        return const CircleAvatar(
          backgroundImage: AssetImage('assets/images/default_image.png'),
          backgroundColor: ColorResources.white,
          radius: 20.0,
        );
      },
    );
  }

  Widget titleBar() {
    return Text(
      widget.barTitle!, 
      overflow: TextOverflow.ellipsis,
      style: robotoRegular.copyWith(
        color: widget.barTitleColor,
        fontSize: widget.barTitleFontSize,
        fontWeight: FontWeight.w700
      ),
    );
  }

  Widget subTitleBar() {
    return Text(
      widget.subTitle!, 
      overflow: TextOverflow.ellipsis,
      style: robotoRegular.copyWith(
        color: widget.barSubtitleColor,
        fontSize: widget.barSubtitleFontSize,
        fontWeight: FontWeight.w700
      ),
    );
  }
}