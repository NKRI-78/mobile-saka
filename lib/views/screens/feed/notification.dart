import 'dart:io';
import 'package:timeago/timeago.dart' as timeago;

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:saka/providers/feed/feed.dart';

import 'package:saka/views/screens/feed/comment_detail.dart';
import 'package:saka/views/screens/feed/reply_detail.dart';
import 'package:saka/views/screens/feed/post_detail.dart';

import 'package:saka/data/models/feed/notification.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/color_resources.dart';

import 'package:saka/localization/language_constraints.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<FeedProvider>().fetchAllNotification(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
          return [
           
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              backgroundColor: ColorResources.white,
              title: Text(getTranslated("NOTIFICATION", context), 
              style: robotoRegular.copyWith(color: ColorResources.black)),
              leading: IconButton(
                icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: ColorResources.black,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              elevation: 0.0,
              pinned: false,
              centerTitle: false,
              floating: true,
            ),

          ];
        },
        body: Consumer<FeedProvider>(
          builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
            if (feedProvider.notificationStatus == NotificationStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primaryOrange
                )
              );
            }
            if(feedProvider.notificationStatus == NotificationStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_NOTIFICATION", context), 
                  style: robotoRegular
                )
              );
            }
            return NotificationListener<ScrollNotification>(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int i) {
                  return Container(
                    color: Colors.blueGrey[50],
                    height: 20.0,
                  );
                },
                physics: const BouncingScrollPhysics(),
                itemCount: feedProvider.notification.nextCursor != null
                ? feedProvider.notificationList.length + 1
                : feedProvider.notificationList.length,
                itemBuilder: (BuildContext context, int i) {
                  if (feedProvider.notificationList.length == i) {
                    return const Center(
                      child: SpinKitThreeBounce(
                        size: 20.0,
                        color: ColorResources.primaryOrange
                      )
                    );
                  }
                  return InkWell(
                    onTap: () {
                      if (feedProvider.notificationList[i].targetType == TargetType.reply) {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => ReplyDetailScreen(
                              replyId: feedProvider.notificationList[i].targetId!,
                            ),
                          ),
                        );
                      }
                      if (feedProvider.notificationList[i].targetType == TargetType.comment) {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => CommentDetailScreen(
                              postId: "",
                              commentId: feedProvider.notificationList[i].targetId!,
                            ),
                          ),
                        );
                      }
                      if (feedProvider.notificationList[i].targetType == TargetType.post) {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(
                              postId: feedProvider.notificationList[i].targetId!,
                            ),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: ColorResources.black,
                        backgroundImage: NetworkImage("${feedProvider.notificationList[i].refUser!.profilePic!.path}"),
                        radius: 20.0,
                      ),
                      title: Text(
                        feedProvider.notificationList[i].message!,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall
                        ),
                      ),
                      subtitle: Text(
                        timeago.format(DateTime.parse(feedProvider.notificationList[i].created!).toLocal(),locale: 'id'),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall
                        )
                      ),
                    ),
                  );
                },
              ),
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (feedProvider.notification.nextCursor != null) {
                    feedProvider.fetchAllNotificationLoad(context, feedProvider.notification.nextCursor!);
                  }
                }
                return false;
              },
            );
          },
        )
      ),
    );
  }
}