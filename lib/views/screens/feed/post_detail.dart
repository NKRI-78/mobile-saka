import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:readmore/readmore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:saka/data/models/feedv2/feedDetail.dart';
import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/providers/feedv2/feedDetail.dart';
import 'package:saka/views/screens/feed/widgets/post_doc.dart';
import 'package:saka/views/screens/feed/widgets/post_img.dart';
import 'package:saka/views/screens/feed/widgets/post_video.dart';
import 'package:timeago/timeago.dart' as timeago;


import 'package:saka/services/navigation.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/feed/feed.dart';
import 'package:saka/providers/profile/profile.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/constant.dart';

import 'package:saka/data/models/feed/comment.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/views/screens/feed/widgets/post_text.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({
    Key? key, 
    required this.postId,
  }) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool deletePostBtn = false;
  late FeedDetailProviderV2 feedDetailProviderV2;
  
  TextEditingController commentC = TextEditingController();
  FocusNode commentFn = FocusNode();

  @override
  void initState() {  
    super.initState();
    feedDetailProviderV2 = context.read<FeedDetailProviderV2>();
    Future.delayed(Duration.zero, () {
      if(mounted) {
        feedDetailProviderV2.getFeedDetail(context, widget.postId);
      }
    });
  }

  Widget commentSticker(BuildContext context, CommentContent comment) {
    return CachedNetworkImage(
      imageUrl: '${AppConstants.baseUrlImg}${comment.url}',
      imageBuilder: (BuildContext context, ImageProvider<Object> image) {
        return Container(
          height: 60.0,
          decoration: BoxDecoration(
            image: DecorationImage(
            alignment: Alignment.centerLeft,
              image: image
            )
          ),
        );
      }
    );
  }

  Widget commentText(BuildContext context, String comment) {
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

  Widget post(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<FeedDetailProviderV2>(
        builder: (BuildContext context, FeedDetailProviderV2 feedDetailProviderV2, Widget? child) {
          if (feedDetailProviderV2.feedDetailStatus == FeedDetailStatus.loading) {
            return const SizedBox(
              height: 100.0,
              child: Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primaryOrange,
                )
              ),
            );
          }
          debugPrint(feedDetailProviderV2.feedDetailData.media!.length.toString());
          return Container(
            margin: const EdgeInsets.only(top: Dimensions.marginSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  leading: CachedNetworkImage(
                  imageUrl: "${AppConstants.baseUrlFeedImg}/${feedDetailProviderV2.feedDetailData.user?.avatar ?? "-"}",
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
                  title: Text(feedDetailProviderV2.feedDetailData.user?.username ?? "-",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.black
                    ),
                  ),
                  subtitle: Text(feedDetailProviderV2.feedDetailData.createdAt!,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: ColorResources.dimGrey
                    ),
                  ),
                  trailing: context.read<ProfileProvider>().userProfile.userId == feedDetailProviderV2.feedDetailData.user?.id
                  ? grantedDeletePost(context) 
                  :  PopupMenuButton(
                      itemBuilder: (BuildContext buildContext) { 
                        return [
                          PopupMenuItem(
                            child: Text("block user",
                              style: robotoRegular.copyWith(
                                color: ColorResources.error,
                                fontSize: Dimensions.fontSizeSmall
                              )
                            ), 
                            value: "/report-user"
                          ),
                          PopupMenuItem(
                            child: Text("It's spam",
                              style: robotoRegular.copyWith(
                                color: ColorResources.error,
                                fontSize: Dimensions.fontSizeSmall
                              )
                            ), 
                            value: "/report-user"
                          ),
                          PopupMenuItem(
                            child: Text("Nudity or sexual activity",
                              style: robotoRegular.copyWith(
                                color: ColorResources.error,
                                fontSize: Dimensions.fontSizeSmall
                              )
                            ), 
                            value: "/report-user"
                          ),
                          PopupMenuItem(
                            child: Text("False Information",
                              style: robotoRegular.copyWith(
                                color: ColorResources.error,
                                fontSize: Dimensions.fontSizeSmall
                              )
                            ), 
                            value: "/report-user"
                          )
                        ];
                      },
                      onSelected: (route) {
                        if(route == "/report-user") {
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
                                  children: [
                                    const SizedBox(height: 10.0),
                                    const Icon(Icons.delete,
                                      color: ColorResources.black,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(getTranslated("ARE_YOU_SURE_REPORT", context),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: Text(getTranslated("NO", context),
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeSmall
                                            )
                                          )
                                        ), 
                                        StatefulBuilder(
                                          builder: (BuildContext context, Function s) {
                                          return ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(
                                              ColorResources.error
                                            ),
                                          ),
                                          onPressed: () async { 
                                            Navigator.of(context, rootNavigator: true).pop(); 
                                          },
                                          child: Text(getTranslated("YES", context), 
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          ),                           
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
                  )
                ),

                const SizedBox(height: 5.0),
                
                PostText(feedDetailProviderV2.feedDetailData.caption ?? "-"),
                if (feedDetailProviderV2.feedDetailData.type == "document")
                  feedDetailProviderV2.feedDetailData.media!.isNotEmpty ? 
                  PostDoc(
                    medias: feedDetailProviderV2.feedDetailData.media!, 
                  ) : Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
                if (feedDetailProviderV2.feedDetailData.type == "image")
                  feedDetailProviderV2.feedDetailData.media!.isNotEmpty ? 
                PostImage(
                  false,
                  feedDetailProviderV2.feedDetailData.media!, 
                ): Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
                if (feedDetailProviderV2.feedDetailData.type == "video")
                  feedDetailProviderV2.feedDetailData.media!.isNotEmpty ? 
                  PostVideo(
                    media: feedDetailProviderV2.feedDetailData.media![0].path,
                  ): Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
  
                // Container(
                //   margin: const EdgeInsets.only(top: Dimensions.marginSizeExtraSmall, left: Dimensions.marginSizeDefault, right: Dimensions.marginSizeDefault),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       SizedBox(
                //         width: 40.0,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(feedProvider.post.body!.numOfLikes.toString(),
                //               style: robotoRegular.copyWith(
                //                 fontSize: Dimensions.fontSizeSmall
                //               )
                //             ),
                //             InkWell(
                //               onTap: () {
                //                 feedProvider.like(context, feedProvider.post.body!.id!, "POST");
                //               },
                //               child: Container(
                //                 padding: const EdgeInsets.all(5.0),
                //                 child: Icon(Icons.thumb_up,
                //                   size: 16.0,
                //                   color: feedProvider.post.body!.liked!.isNotEmpty 
                //                   ? Colors.blue 
                //                   : ColorResources.black
                //                 ),
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //       Text('${feedProvider.post.body!.numOfComments.toString()} ${getTranslated("COMMENT", context)}',
                //         style: robotoRegular.copyWith(
                //           fontSize: Dimensions.fontSizeSmall
                //         ),
                //       ),
                //     ]
                //   )
                // ),

              ]
            ),
          );
        },
      )
    
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Username  : ${feedDetailProviderV2.feedDetailData.user?.username}");
    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              backgroundColor: ColorResources.white,
              title: Text('Post', 
                style: robotoRegular.copyWith(
                  color: ColorResources.black,
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.fontSizeDefault
                )
              ),
              leading: CupertinoNavigationBarBackButton(
                color: ColorResources.black,
                onPressed: () {
                  NS.pop(context);
                },
              ),
              elevation: 0.0,
              pinned: false,
              centerTitle: false,
              floating: true,
            ),
            post(context)
          ];
        },
        body: Consumer<FeedDetailProviderV2>(
          builder: (BuildContext context, FeedDetailProviderV2 feedDetailProviderV2, Widget? child) {
            if (feedDetailProviderV2.feedDetailStatus == FeedDetailStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primaryOrange,
                )
              );
            } 
            if (feedDetailProviderV2.feedDetailStatus == FeedDetailStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_COMMENT", context),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault
                  ),
                )
              );
            }
            return NotificationListener<ScrollNotification>(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int i) {
                  return const SizedBox(height: 8.0);
                },
                physics: const BouncingScrollPhysics(),
                itemCount: feedDetailProviderV2.feedDetailData.comment!.comments.length,
                itemBuilder: (BuildContext context, int i) {
                  CommentElement comment = feedDetailProviderV2.comment[i];
                  // if (comment.comment == i) {
                  //   return const Center(
                  //     child: SpinKitThreeBounce(
                  //       size: 20.0,
                  //       color: ColorResources.primaryOrange
                  //     )
                  //   );
                  // }
                  return Column(
                    children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: ColorResources.transparent,
                        backgroundImage: NetworkImage("${AppConstants.baseUrlImg}${comment.user.avatar}"),
                        radius: 20.0,
                      ),
                      title: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: ColorResources.blueGrey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0)
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment.user.username,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                              // Text(timeago.format(DateTime.parse(feedProvider.c1List[i].created!).toLocal(), locale: 'id'),
                              //   style: robotoRegular.copyWith(
                              //     fontSize: Dimensions.fontSizeExtraSmall,
                              //     color: ColorResources.dimGrey
                              //   ),
                              // ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // if (feedProvider.c1List[i].type == "STICKER")
                                    //   commentSticker(context, feedProvider.c1List[i].content!),
                                    // if (feedProvider.c1List[i].type == "TEXT")
                                      commentText(context, comment.comment)
                                  ],
                                ),
                              ),
                            ]
                          ),
                        ),
                        trailing: context.read<ProfileProvider>().userProfile.userId == comment.user.id 
                        ? const SizedBox()
                        : PopupMenuButton(
                          itemBuilder: (BuildContext buildContext) { 
                            return [
                              PopupMenuItem(
                                child: Text("block user",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.error,
                                    fontSize: Dimensions.fontSizeSmall
                                  )
                                ), 
                                value: "/report-user"
                              ),
                              PopupMenuItem(
                                child: Text("It's spam",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.error,
                                    fontSize: Dimensions.fontSizeSmall
                                  )
                                ), 
                                value: "/report-user"
                              ),
                              PopupMenuItem(
                                child: Text("Nudity or sexual activity",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.error,
                                    fontSize: Dimensions.fontSizeSmall
                                  )
                                ), 
                                value: "/report-user"
                              ),
                              PopupMenuItem(
                                child: Text("False Information",
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.error,
                                    fontSize: Dimensions.fontSizeSmall
                                  )
                                ), 
                                value: "/report-user"
                              )
                            ];
                          },
                          onSelected: (route) {
                            if(route == "/report-user") {
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
                                      children: [
                                        const SizedBox(height: 10.0),
                                        const Icon(Icons.delete,
                                          color: ColorResources.black,
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(getTranslated("ARE_YOU_SURE_REPORT", context),
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text(getTranslated("NO", context),
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeSmall
                                                )
                                              )
                                            ), 
                                            StatefulBuilder(
                                              builder: (BuildContext context, Function s) {
                                              return ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(
                                                  ColorResources.error
                                                ),
                                              ),
                                              onPressed: () async { 
                                                Navigator.of(context, rootNavigator: true).pop(); 
                                              },
                                              child: Text(getTranslated("YES", context), 
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeSmall
                                                ),
                                              ),                           
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
                      )
                    ),
                    SizedBox(
                      width: 150.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(comment.like.total.toString(),
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                                InkWell(
                                  onTap: () {
                                    // feedProvider.like(context, feedProvider.c1List[i].id!, "COMMENT");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(Icons.thumb_up,
                                      size: 16.0,
                                      color: Colors.blue),
                                  ),
                                ),
                              ]
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.push(context,
                              //   MaterialPageRoute(
                              //     builder: (BuildContext context) => RepliesScreen(
                              //       id: feedProvider.c1List[i].id!,
                              //       postId: widget.postId
                              //     ),
                              //   ),
                              // );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${getTranslated("REPLY",context)} (${comment.reply.total})',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                fontStyle: FontStyle.italic)
                              ),
                            )
                          ),
                        ]
                      ),
                    )
                  ]);
                },
              ),
              // onNotification: (ScrollNotification scrollInfo) {
              //   if (scrollInfo.metrics.pixels ==
              //       scrollInfo.metrics.maxScrollExtent) {
              //     if (feedProvider.c1.nextCursor != null) {
              //       feedProvider.fetchListCommentMostRecentLoad(context, widget.postId,feedProvider.c1.nextCursor!);
              //     }
              //   }
              //   return false;
              // },
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
            Material(
              color: ColorResources.white,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  color: ColorResources.black,
                  icon: const Icon(Icons.face),
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      expand: true,
                      context: context,
                      backgroundColor: ColorResources.transparent,
                      builder: (context) => Scaffold(
                       body: SingleChildScrollView(
                        child: Consumer<FeedProvider>(
                          builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
                            if (feedProvider.stickerStatus == StickerStatus.loading) {
                              return const Center(
                                child: SizedBox(
                                  width: 15.0,
                                  height: 15.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryOrange)
                                  )
                                )
                              );
                            }
                            if (feedProvider.stickerStatus == StickerStatus.empty) {
                              return Center(
                                child: Text(getTranslated("THERE_IS_NO_STICKER", context),
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall
                                ),
                              ));
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: feedProvider.sticker.body!.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                                  child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 0.0,
                                      mainAxisSpacing: 0.0,
                                      childAspectRatio: 3 / 1
                                    ),
                                    itemCount: feedProvider.sticker.body![i].stickers!.length,
                                    itemBuilder: (BuildContext ontext, int z) {
                                      return InkWell(
                                        onTap: () async {
                                          await context.read<FeedProvider>().sendComment(context, feedProvider.sticker.body![i].stickers![z].url!, widget.postId, "STICKER");
                                          Navigator.pop(context);
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: '${AppConstants.baseUrlImg}${feedProvider.sticker.body![i].stickers![z].url}',
                                          imageBuilder: (BuildContext context, ImageProvider<Object> image) {
                                            return Container(
                                              padding: const EdgeInsets.all(8.0),
                                              width: 30.0,
                                              height: 30.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: image
                                                )
                                              )
                                            );  
                                          },
                                        )
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          })
                        )
                      )
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: TextField(
                focusNode: commentFn,
                controller: commentC,
                style: robotoRegular.copyWith(
                  color: ColorResources.black,
                  fontSize: Dimensions.fontSizeSmall
                ),
                decoration: InputDecoration.collapsed(
                  hintText: '${getTranslated("WRITE_COMMENT", context)} ...',
                  hintStyle: robotoRegular.copyWith(
                    color: ColorResources.greyDarkPrimary,
                    fontSize: Dimensions.fontSizeSmall
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
                color: ColorResources.black,
              ),
              onPressed: () async {
                String commentText = commentC.text;
                if (commentText.trim().isEmpty) {
                  return;
                }
                commentFn.unfocus();
                commentC.clear();
                await context.read<FeedProvider>().sendComment(context, commentText, widget.postId);
              }
            ),
          ],
        ),
      )
    );
  }

  Widget grantedDeletePost(context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) { 
        return [
          PopupMenuItem(
            child: Text(getTranslated("DELETE_POST", context),
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
                    Text(getTranslated("DELETE_POST", context),
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
                              await context.read<FeedProviderV2>().deletePost(context, feedDetailProviderV2.feedDetailData.id!);               
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
