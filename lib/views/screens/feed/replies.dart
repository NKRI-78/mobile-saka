import 'dart:io';

import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/providers/feedv2/feedReply.dart';
import 'package:saka/providers/profile/profile.dart';
import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:saka/data/models/feed/singlecomment.dart';
import 'package:saka/data/models/feedv2/feedReply.dart';

import 'package:saka/providers/feedv2/feedDetail.dart';

import 'package:saka/utils/date_util.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/screens/feed/widgets/post_text.dart';

import 'package:saka/localization/language_constraints.dart';

class RepliesScreen extends StatefulWidget {
  final String id;
  final String postId;
  final int index;

  const RepliesScreen({Key? key, 
    required this.id,
    required this.postId,
    required this.index
  }) : super(key: key);

  @override
  _RepliesScreenState createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {
  TextEditingController replyTextEditingController = TextEditingController();
  FocusNode replyFocusNode = FocusNode();
  
  bool isExpanded = false;
  bool deletePostBtn = false;

  late FeedReplyProvider frv;
  late FeedDetailProviderV2 fdv2;

  @override
  void initState() {  
    super.initState();
    frv = context.read<FeedReplyProvider>();
    fdv2 = context.read<FeedDetailProviderV2>();
    frv.commentC = TextEditingController();

    Future.delayed(Duration.zero, () {
      if(mounted) {
        frv.getFeedReply(context: context, commentId: widget.id);
      }
    });
  }

  Widget commentSticker(SingleCommentBody comment) {
    return CachedNetworkImage(
      imageUrl:'${comment.content!.url}',
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

  Widget grantedDeleteReply(context, replyId) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) { 
        return [
          PopupMenuItem(
            child: Text(getTranslated("DELETE_REPLY", context),
              style: robotoRegular.copyWith(
                color: ColorResources.primaryOrange,
                fontSize: Dimensions.fontSizeSmall
              )
            ), 
            value: "/delete-post"
          )
        ];
      },
      onSelected: (route) {
        if(route == "/delete-post") {
          showAnimatedDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.only(
                      left: 25.0,
                      right: 25.0
                    ),
                    child: CustomDialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      minWidth: 180.0,
                      child: Transform.rotate(
                        angle: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: ColorResources.white,
                              width: 1.0
                            )
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Transform.rotate(
                                    angle: 56.5,
                                    child: Container(
                                      margin: const EdgeInsets.all(5.0),
                                      height: 270.0,
                                      decoration: BoxDecoration(
                                        color: ColorResources.white,
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 50.0,
                                        left: 25.0,
                                        right: 25.0,
                                        bottom: 25.0
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

                                          Image.asset("assets/imagesv2/remove.png",
                                            width: 60.0,
                                            height: 60.0,
                                          ),
                                          
                                          const SizedBox(height: 15.0),

                                          Text(getTranslated("DELETE_POST", context),
                                            style: poppinsRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: ColorResources.black
                                            ),
                                          ),

                                          const SizedBox(height: 20.0),

                                          StatefulBuilder(
                                            builder: (BuildContext context, Function setState) {
                                              return  Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                
                                                  Expanded(
                                                    child: CustomButton(
                                                      isBorderRadius: true,
                                                      isBoxShadow: true,
                                                      btnColor: ColorResources.error,
                                                      isBorder: false,
                                                      onTap: () {
                                                        Navigator.of(context).pop();
                                                      }, 
                                                      btnTxt: getTranslated("NO", context)
                                                    ),
                                                  ),
                                
                                                  const SizedBox(width: 8.0),
                                
                                                  Expanded(
                                                    child: CustomButton(
                                                      isBorderRadius: true,
                                                      isBoxShadow: true,
                                                      btnColor: ColorResources.success,
                                                      onTap: () async {
                                                        setState(() => deletePostBtn = true);
                                                        try {         
                                                          await context.read<FeedProviderV2>().deleteReply(context, replyId);               
                                                          setState(() => deletePostBtn = false);        
                                                        } catch(e, stacktrace) {
                                                          setState(() => deletePostBtn = false);
                                                          debugPrint(stacktrace.toString()); 
                                                        }
                                                      }, 
                                                      btnTxt: deletePostBtn 
                                                      ? "..." 
                                                      : getTranslated("YES", context)
                                                    ),
                                                  )
                                
                                                ],
                                              );
                                            },
                                          ),

                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ) 
                        ),
                      ),
                    ),
                  );
                },
              ); 
            },
          );
        }
      },
    );
  }

  Widget commentText(String comment) {
    return ReadMoreText(
      comment,
      style: robotoRegular.copyWith(
        fontSize: Dimensions.fontSizeDefault
      ),
      trimLines: 2,
      colorClickableText: ColorResources.black,
      trimMode: TrimMode.Line,
      trimCollapsedText: getTranslated("READ_MORE", context),
      trimExpandedText: getTranslated("LESS_MORE", context),
      moreStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
      lessStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
    );
  }

  Widget replyText(String reply) {
    return ReadMoreText(
      reply,
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
        builder: (BuildContext context, FeedReplyProvider frv, Widget? child) {
          if(frv.feedReplyDetailStatus == FeedReplyDetailStatus.loading) {
            return const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primaryOrange,
              ),
            );
          }
          if(frv.feedReplyDetailStatus == FeedReplyDetailStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_COMMENT", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              )
            );
          }
          if(frv.feedReplyStatus == FeedReplyStatus.error) {
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
              imageUrl: "${frv.feedReplyData.comment!.user?.avatar ?? "-"}",
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
                  Text(frv.feedReplyData.comment!.user?.username ?? "-",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                  Text(frv.feedReplyData.comment!.createdAt!,
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
                  PostText(frv.feedReplyData.comment!.caption!)
                ],
              )
            ),
            const SizedBox(height: 8.0),
            Container(
              margin: const EdgeInsets.only(top: Dimensions.marginSizeExtraSmall, left: Dimensions.marginSizeDefault, right: Dimensions.marginSizeDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(fdv2.comments[widget.index].like.total.toString(),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall
                            )
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                              fdv2.toggleLikeComment(
                                context: context, 
                                feedId: widget.postId, 
                                commentId: fdv2.comments[widget.index].id, 
                                feedLikes: fdv2.comments[widget.index].like
                              );
                              });
                            }, 
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.thumb_up,
                                size: 16.0,
                                color: fdv2.comments[widget.index].like.likes.where(
                                  (el) => el.user!.id == fdv2.ar.getUserId()
                                ).isEmpty ? Colors.black : ColorResources.blue,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text('${frv.feedReplyData.comment!.reply!.total} ${getTranslated("REPLY", context)}',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
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
      body: Consumer<FeedReplyProvider>(
        builder: (BuildContext context, FeedReplyProvider frv, Widget? child) {
          if (frv.feedReplyStatus == FeedReplyStatus.loading) {
            return const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primaryOrange
              )
            );
          }
          if (frv.feedReplyStatus == FeedReplyStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_REPLY", context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              )
            );
          }
          return RefreshIndicator(
            onRefresh: () {
              return Future.sync(() {
                frv.getFeedReply(context: context, commentId: widget.id);
              });
            },
            child: NotificationListener(
              onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    if (frv.hasMore) {
                      frv.loadMoreReply(context: context, commentId: widget.id);
                    }
                  }
                }
                return false;
              },
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int i) {
                  return const SizedBox(
                    height: 0.0
                  );
                },
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: frv.reply.length,
                itemBuilder: (BuildContext context, int i) {
                ReplyElement reply = frv.reply[i]; 
                  if (frv.reply.length == i) {
                    return const Center(
                      child: CupertinoActivityIndicator()
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Column(
                      children: [
                      ListTile(
                        trailing: context.read<ProfileProvider>().userProfile.userId == reply.user.id 
                        ? grantedDeleteReply(context, reply.id) 
                        : const SizedBox(),
                        leading: CachedNetworkImage(
                        imageUrl: "${reply.user.avatar}",
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
                            Text(reply.user.username,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(DateHelper.formatDateTime(reply.createdAt, context),
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall
                                ),
                              )
                            ),
              
                            Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commentText(reply.reply),
                                ],
                              )
                            ),
                            
                            SizedBox(
                              width: 50.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  // Text(
                                  //   frv.replyList[i].numOfLikes.toString(),
                                  //   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                                  // ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     frv.like(context, frv.replyList[i].id!, "REPLY");
                                  //   },
                                  //   child: Container(
                                  //     padding: const EdgeInsets.all(5.0),
                                  //     child: Icon(Icons.thumb_up,
                                  //       size: 16.0,
                                  //       color: frv.replyList[i].liked!.isNotEmpty
                                  //       ? Colors.blue
                                  //       : ColorResources.black
                                  //     ),
                                  //   ),
                                  // )
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
            ),
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
            controller: frv.commentC,
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
            await frv.postReply(context, widget.postId, widget.id);
          }
        ),
      ],
    )));
  }

  Widget grantedDeleteComment(context, String idComment) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) { 
        return [
          PopupMenuItem(
            child: Text(getTranslated("DELETE_REPLY", context),
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeSmall
              )
            ), 
            value: "/delete-post"
          )
        ];
      },
      onSelected: (route) {
        if(route == "/delete-post") {
          showAnimatedDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                height: 150.0,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10.0),
                    const Icon(
                      Icons.delete,
                      color: ColorResources.white,
                    ),
                    const SizedBox(height: 10.0),
                    Text(getTranslated("DELETE_REPLY", context),
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(getTranslated("NO", context),
                            style: robotoRegular,
                          )
                        ), 
                        StatefulBuilder(
                          builder: (BuildContext context, Function s) {
                          return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.error
                          ),
                          onPressed: () async { 
                          s(() => deletePostBtn = true);
                            try {         
                              await frv.deleteReply(context: context, feedId: frv.feedReplyData.comment!.id!, deleteId: idComment);               
                              s(() => deletePostBtn = false);
                              Navigator.of(context).pop();             
                            } catch(e) {
                              s(() => deletePostBtn = false);
                              debugPrint(e.toString()); 
                            }
                          },
                          child: deletePostBtn 
                          ? const Loader(
                              color: ColorResources.white,
                            )
                          : Text(getTranslated("YES", context),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall
                              ),
                            )
                          );
                        })
                      ],
                    ) 
                  ])
                )
              );
            },
          );
        }
      },
    );
  }
}