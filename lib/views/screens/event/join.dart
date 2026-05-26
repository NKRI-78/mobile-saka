import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/data/models/event/event.dart';
import 'package:saka/localization/language_constraints.dart';
import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class EventJoinScreen extends StatelessWidget {
  final List<Join> joins;
  
  const EventJoinScreen({
    required this.joins,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: ColorResources.brown,
        title: Text(getTranslated("JOINED_MEMBERS", context),
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontWeight: FontWeight.bold,
            fontSize: Dimensions.fontSizeDefault
          ),
        ),
        leading: BackButton(
          color: ColorResources.white,
          onPressed: () {
            NS.pop();
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 25.0,
          bottom: 25.0,
          left: 10.0, 
          right: 10.0
        ),
        child: joins.isEmpty 
        ? Center(
            child: Text(getTranslated("NO_ONE_JOINED_YET", context),
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.black
              ),
            )
          )
        : ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: joins.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              onTap: () {

              },
              title: Text(joins[i].fullname,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              ),
              leading: CachedNetworkImage(
                imageUrl: joins[i].profilePic,
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                  );
                },
                errorWidget: (context, url, error) {
                  return CircleAvatar(
                    backgroundImage: AssetImage('assets/images/default_avatar.jpg')
                  );
                },
                placeholder: (context, url) {
                  return CircleAvatar(
                    backgroundImage: AssetImage('assets/images/default_avatar.jpg')
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
