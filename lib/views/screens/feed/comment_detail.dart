import 'dart:io';

import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/providers/feed/feed.dart';

import 'package:saka/data/models/feed/reply.dart';


class CommentDetailScreen extends StatefulWidget {
  final String commentId;
  final String postId;

  const CommentDetailScreen({
    Key? key, 
    required this.commentId,
    required this.postId
  }) : super(key: key);

  @override
  _CommentDetailScreenState createState() => _CommentDetailScreenState();
}

class _CommentDetailScreenState extends State<CommentDetailScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late TextEditingController replyC;
  late FocusNode replyFocusNode;

  Widget replyText(ReplyBody reply) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ReadMoreText(reply.content!.text!,
          trimLines: 2,
          colorClickableText: ColorResources.black,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Tampilkan Lebih',
          trimExpandedText: 'Tutup',
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault
          ),
          moreStyle: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall, 
            fontWeight: FontWeight.w600
          ),
          lessStyle: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall, 
            fontWeight: FontWeight.w600
          ),
        ),
      ]
    );
  }

  Widget comment(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
          if(feedProvider.singleCommentStatus == SingleCommentStatus.loading) {
            return SizedBox(
              height: 100.0,
              child: Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primaryOrange,
                ),
              )
            );
          }
          if(feedProvider.singleCommentStatus == SingleCommentStatus.empty) {
            return SizedBox(
              height: 100.0,
              child: Center(
                child: Text(getTranslated("THERE_IS_NO_COMMENT", context),
                  style: robotoRegular,
                )
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(feedProvider.singleComment.body!.user!.nickname!),
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage("${feedProvider.singleComment.body!.user!.profilePic!.path}"),
                  radius: 20.0,
                ),
                subtitle: Text(
                  timeago.format(DateTime.parse(feedProvider.singleComment.body!.created!).toLocal(), 
                  locale: 'id'),
                  style: robotoRegular,
                ),
              ),
              Container(
                width: 250.0,
                margin: const EdgeInsets.only(left: 70.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  if (feedProvider.singleComment.body!.type == "STICKER")
                    Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.centerLeft,
                          image: NetworkImage('${feedProvider.singleComment.body!.content!.url}') 
                        )
                      ),
                    ),
                  if (feedProvider.singleComment.body!.type == "TEXT")
                    ReadMoreText(
                      feedProvider.singleComment.body!.content!.text!,                       
                      trimLines: 2,
                      colorClickableText: ColorResources.black,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: getTranslated("READ_MORE", context),
                      trimExpandedText: getTranslated("LESS", context),
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                      moreStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
                      lessStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
                    ),
                  ],
                ) 
              ),
              const SizedBox(height: 5.0),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text(feedProvider.singleComment.body!.numOfLikes.toString(),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall
                          )
                        ),
                        InkWell(
                          onTap: () {
                            feedProvider.like(context, feedProvider.singleComment.body!.id!, "COMMENT");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.thumb_up,
                              size: 16.0,
                              color: feedProvider.singleComment.body!.liked!.isNotEmpty ? Colors.blue : ColorResources.black
                            ),
                          ),
                        )
                        ],
                      ),
                    ),
                    Text('${feedProvider.singleComment.body!.numOfReplies.toString()} Balasan',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall
                      ),
                    ),
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
  void initState() {
    super.initState();

    replyC = TextEditingController();
    replyFocusNode = FocusNode();
    
    Future.delayed(Duration.zero, () {
      if(mounted) {
        context.read<FeedProvider>().fetchComment(context, widget.commentId);
      }
      if(mounted) {
        context.read<FeedProvider>().fetchAllReply(context, widget.commentId);
      }
    });
  }

  @override 
  void dispose() {
    super.dispose();
    replyC.dispose();
    replyFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: globalKey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [
            SliverAppBar(
              backgroundColor: ColorResources.white,
              title: Text(getTranslated("COMMENT", context), 
                style: robotoRegular.copyWith(
                  color: ColorResources.black,
                  fontSize: Dimensions.fontSizeDefault
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
            comment(context)
          ];
        },
        body: Consumer<FeedProvider>(
          builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
            if (feedProvider.replyStatus == ReplyStatus.loading) {
              return const SizedBox(
                height: 80.0,
                  child: Center(
                    child: SpinKitThreeBounce(
                    size: 20.0,
                    color: ColorResources.primaryOrange,
                  ),
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
                  return const SizedBox(height: 16.0);
                },
                physics: const BouncingScrollPhysics(),
                itemCount: feedProvider.reply.nextCursor != null 
                ? feedProvider.replyList.length + 1
                : feedProvider.replyList.length,
                itemBuilder: (BuildContext context, int i) {
                  if (feedProvider.replyList.length == i) {
                    return const Center(
                      child: SizedBox(
                      width: 15.0,
                      height: 15.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryOrange)),
                      )
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            backgroundImage: NetworkImage("${feedProvider.replyList[i].user!.profilePic!.path}"),
                            radius: 20.0,
                          ),
                          title: Container( 
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text(feedProvider.replyList[i].user!.nickname!,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(timeago.format(DateTime.parse(feedProvider.replyList[i].created!).toLocal(), locale: 'id'),
                                  style: robotoRegular.copyWith(
                                    fontSize: 12.0
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    if(feedProvider.replyList[i].type == "TEXT")
                                      replyText(feedProvider.replyList[i]),
                                      Row(
                                        children: [
                                         Text(feedProvider.replyList[i].numOfLikes.toString(),
                                            style: robotoRegular.copyWith(fontSize: 15.0),
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
                                          ),
                                        ]
                                      )
                                    ],
                                  )
                                ),
                              ]
                            ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (feedProvider.reply.nextCursor != null) {
                    feedProvider.fetchAllReplyLoad(context, widget.commentId, feedProvider.reply.nextCursor!);
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
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 16.0),
            Expanded(
              child: TextField(
                focusNode: replyFocusNode,
                controller: replyC,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                decoration: InputDecoration.collapsed(
                  hintText: getTranslated("WRITE_REPLY", context),
                  hintStyle: robotoRegular.copyWith(
                    color: ColorResources.grey
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                String reply = replyC.text;
                if (reply.isEmpty) {   
                  return;
                }    
                try {
                  replyFocusNode.unfocus();
                  replyC.clear();
                  context.read<FeedProvider>().sendReply(context, reply,  widget.commentId, widget.postId);
                } catch(e) {
                  debugPrint(e.toString());
                }                              
              }
            ),
          ],
        ),
      ),
    );
  }
}