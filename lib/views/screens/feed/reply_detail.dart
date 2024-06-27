import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:saka/providers/feed/feed.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/data/models/feed/reply.dart';

class ReplyDetailScreen extends StatefulWidget {
  final String replyId;

  const ReplyDetailScreen({
    Key? key, 
    required this.replyId
  }) : super(key: key);

  @override
  _ReplyDetailScreenState createState() => _ReplyDetailScreenState();
}

class _ReplyDetailScreenState extends State<ReplyDetailScreen> {

  Widget replyText(ReplyBody reply) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ReadMoreText(
        reply.content!.text!,
        trimLines: 2,
        colorClickableText: ColorResources.black,
        trimMode: TrimMode.Line,
        trimCollapsedText: getTranslated("READ_MORE", context),
        trimExpandedText:  getTranslated("LESS", context),
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
        moreStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
        lessStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
      ),
    ]);
  }

  Widget reply(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
          if(feedProvider.replyStatus == ReplyStatus.loading) {
            return const SizedBox(
              height: 150.0,
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primaryOrange,
              ),
            ); 
          }
          if(feedProvider.replyStatus == ReplyStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_REPLY", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              )
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(feedProvider.singleReply.body!.user!.nickname!,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage("${feedProvider.singleReply.body!.user!.profilePic!.path}"),
                  radius: 20.0,
                ),
                subtitle: Text(timeago.format(DateTime.parse(feedProvider.singleReply.body!.created!).toLocal(), locale: 'id'), 
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall
                  ),
                ),
              ),
            SizedBox(
              width: 250.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReadMoreText(
                    feedProvider.singleReply.body!.content!.text!,
                    trimLines: 2,
                    colorClickableText: ColorResources.black,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: getTranslated("READ_MORE", context),
                    trimExpandedText: getTranslated("LESS", context),
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    moreStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
                    lessStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max, 
                children: [
                  SizedBox(
                    width: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(feedProvider.singleReply.body!.numOfLikes.toString(),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall
                          )
                        ),
                        InkWell(
                          onTap: () {
                            feedProvider.like(context, feedProvider.singleReply.body!.id!, "REPLY");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.thumb_up,
                              size: 16.0,
                              color: feedProvider.singleReply.body!.liked!.isNotEmpty 
                              ? ColorResources.blue 
                              : ColorResources.black
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              )
            ),
          ]
        );
      }
    )
  );
}

  @override 
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<FeedProvider>().fetchAllReply(context, widget.replyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: ColorResources.white,
            title: Text(getTranslated("REPLY_COMMENT", context), 
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.black
              )
            ),
            leading: IconButton(
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: ColorResources.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            elevation: 0.0,
            pinned: false,
            centerTitle: false,
            floating: true,
          ),
          reply(context)
        ]
      )
    );
  }
}
