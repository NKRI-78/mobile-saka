import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saka/providers/feedv2/feedDetail.dart';
import 'package:saka/providers/feedv2/feedReply.dart';
import 'package:saka/views/screens/feed/widgets/post_text.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/providers/feed/feed.dart';

import 'package:saka/data/models/feed/reply.dart';
import 'package:saka/data/models/feed/singlecomment.dart';

class RepliesScreen extends StatefulWidget {
  final String id;
  final String postId;

  const RepliesScreen({Key? key, 
    required this.id,
    required this.postId
  }) : super(key: key);

  @override
  _RepliesScreenState createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {
  TextEditingController replyTextEditingController = TextEditingController();
  FocusNode replyFocusNode = FocusNode();
  bool isExpanded = false;
  late FeedReplyProvider fdv2;

  @override
  void initState() {  
    super.initState();
    fdv2 = context.read<FeedReplyProvider>();
    fdv2.commentC = TextEditingController();

    Future.delayed(Duration.zero, () {
      if(mounted) {
        fdv2.getFeedReply(context: context, commentId: widget.id);
      }
    });
  }

  Widget commentSticker(SingleCommentBody comment) {
    return CachedNetworkImage(
      imageUrl:'${AppConstants.baseUrlImg}${comment.content!.url}',
      imageBuilder: (BuildContext context, ImageProvider<Object> image) {
        return Container(
          height: 60.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.centerLeft,
              image: image
            ),
          )            
        );
      },
    );
  }

  Widget commentText(String comment) {
    return ReadMoreText(
      comment,
      trimLines: 2,
      colorClickableText: ColorResources.black,
      trimMode: TrimMode.Line,
      trimCollapsedText: getTranslated("READ_MORE", context),
      trimExpandedText: getTranslated("LESS", context),
      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
      moreStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
      lessStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
    );
  }

  Widget replyText(ReplyBody reply) {
    return ReadMoreText(
      reply.content!.text!,
      trimLines: 2,
      colorClickableText: ColorResources.black,
      trimMode: TrimMode.Line,
      trimCollapsedText: getTranslated("READ_MORE", context),
      trimExpandedText: getTranslated("LESS", context),
      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
      moreStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
      lessStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
    );
  }

  Widget comment(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<FeedReplyProvider>(
        builder: (BuildContext context, FeedReplyProvider fdv2, Widget? child) {
          debugPrint("Caption : ${fdv2.feedReplyData.comment!.user?.id ?? "-"}");
          if(fdv2.feedReplyStatus == FeedReplyStatus.loading) {
            return const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primaryOrange,
              ),
            );
          }
          if(fdv2.feedReplyStatus == FeedReplyStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_COMMENT", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              )
            );
          }
          if(fdv2.feedReplyStatus == FeedReplyStatus.error) {
            return Center(
              child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              )
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ListTile(
              leading: CachedNetworkImage(
              imageUrl: "${AppConstants.baseUrlImg}/${fdv2.feedReplyData.comment!.user?.avatar ?? "-"}",
                imageBuilder: (BuildContext context, dynamic imageProvider) => CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: imageProvider,
                  radius: 20.0,
                ),
                placeholder: (BuildContext context, String url) => const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                  radius: 20.0,
                ),
                errorWidget: (BuildContext context, String url, dynamic error) => const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                  radius: 20.0,
                )
              ),
              title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fdv2.feedReplyData.comment!.user?.username ?? "-",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                  Text(fdv2.feedReplyData.comment!.createdAt!,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall
                    ),
                  ),
                ]
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (fdv2.singleComment.body!.type == "STICKER")
                  //   commentSticker(fdv2.singleComment.body!),
                  // if (fdv2.singleComment.body!.type == "TEXT")
                  PostText(fdv2.feedReplyData.comment!.caption!)
                ],
              )
            ),
            const SizedBox(height: 8.0),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text(fdv2.singleComment.body!.numOfLikes.toString(),
                          //   style: robotoRegular.copyWith(
                          //     fontSize: Dimensions.fontSizeSmall
                          //   )
                          // ),
                          // InkWell(
                          //   onTap: () =>  fdv2.like(context, fdv2.singleComment.body!.id!, "COMMENT"),
                          //   child: Container(
                          //     padding: const EdgeInsets.all(5.0),
                          //     child: Icon(Icons.thumb_up,
                          //       size: 16.0,
                          //       color: fdv2.singleComment.body!.liked!.isNotEmpty ? Colors.blue : ColorResources.black,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    // Text('${fdv2.singleComment.body!.numOfReplies.toString()} ${getTranslated("REPLY", context)}',
                    //   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    // ),
                  ]
                )
              ),
            ]
          );
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
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
            onPressed: () => Navigator.of(context).pop()
          ),
          elevation: 0.0,
          pinned: false,
          centerTitle: false,
          floating: true,
        ),
          comment(context)
        ];
      }, 
      body: Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
          if (feedProvider.replyStatus == ReplyStatus.loading) {
            return const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primaryOrange
              )
            );
          }
          if (feedProvider.replyStatus == ReplyStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_REPLY", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              )
            );
          }
          return NotificationListener<ScrollNotification>(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int i) {
                return const SizedBox(
                  height: 16.0
                );
              },
              physics: const BouncingScrollPhysics(),
              itemCount: feedProvider.reply.nextCursor != null ? feedProvider.replyList.length + 1 : feedProvider.replyList.length,
              itemBuilder: (BuildContext context, int i) {
                if (feedProvider.replyList.length == i) {
                  return const Center(
                    child: CupertinoActivityIndicator()
                  );
                }
                return Container(
                  margin: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Column(
                    children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage("${AppConstants.baseUrlImg}${feedProvider.replyList[i].user!.profilePic!.path}"),
                        radius: 20.0,
                      ),
                      title: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: ColorResources.blueGrey,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(feedProvider.replyList[i].user!.nickname!,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.black
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              timeago.format(DateTime.parse(feedProvider.replyList[i].created!).toLocal(), locale: 'id'),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall
                              ),
                            )
                          ),

                          Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (feedProvider.replyList[i].type == "TEXT")
                                  replyText(feedProvider.replyList[i]),
                              ],
                            )
                          ),
                          
                          SizedBox(
                            width: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  feedProvider.replyList[i].numOfLikes.toString(),
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                                ),
                                InkWell(
                                  onTap: () {
                                    feedProvider.like(context, feedProvider.replyList[i].id!, "REPLY");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(Icons.thumb_up,
                                      size: 16.0,
                                      color: feedProvider.replyList[i].liked!.isNotEmpty
                                      ? Colors.blue
                                      : ColorResources.black
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),

                          

                        ]
                      ),
                    ),
                  ),
                ]
              ),
            );
          },
        ),
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if (feedProvider.reply.nextCursor != null) {
              feedProvider.fetchAllReplyLoad(context, widget.id, feedProvider.reply.nextCursor!);
            }
          }
            return false;
          },
        );

      },
    )
  ),
  bottomNavigationBar: Container(
    padding: MediaQuery.of(context).viewInsets,
    decoration: const BoxDecoration(
      color: ColorResources.white
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            focusNode: replyFocusNode,
            controller: replyTextEditingController,
            style: robotoRegular.copyWith(
              color: ColorResources.black,
              fontSize: Dimensions.fontSizeSmall
            ),
            decoration: InputDecoration.collapsed(
              hintText: '${getTranslated("WRITE_REPLY", context)} ...',
              hintStyle: robotoRegular.copyWith(
                color: ColorResources.dimGrey,
                fontSize: Dimensions.fontSizeSmall
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.send,
            color: ColorResources.black
          ),
          onPressed: () async {
            String replyText = replyTextEditingController.text;
            if (replyTextEditingController.text.trim().isEmpty) {
              return;
            }
            try {
              replyFocusNode.unfocus();
              replyTextEditingController.clear();
              await context.read<FeedProvider>().sendReply(context, replyText, widget.id, widget.postId);
            } catch (e) {
              debugPrint(e.toString());
            }
          }
        ),
      ],
    )));
  }
}