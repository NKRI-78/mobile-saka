import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:saka/data/models/feedv2/feedDetail.dart' as m;
import 'package:saka/data/models/feed/comment.dart';

import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/providers/feedv2/feedDetail.dart' as p;
import 'package:saka/providers/profile/profile.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/utils/date_util.dart';

import 'package:saka/views/screens/feed/replies.dart';
import 'package:saka/views/screens/feed/widgets/post_doc.dart';
import 'package:saka/views/screens/feed/widgets/post_img.dart';
import 'package:saka/views/screens/feed/widgets/post_link.dart';
import 'package:saka/views/screens/feed/widgets/post_video.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/localization/language_constraints.dart';

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
  late p.FeedDetailProviderV2 feedDetailProviderV2;
  
  FocusNode commentFn = FocusNode();

  @override
  void initState() {  
    super.initState();
    feedDetailProviderV2 = context.read<p.FeedDetailProviderV2>();
    feedDetailProviderV2.commentC = TextEditingController();
    Future.delayed(Duration.zero, () {
      if(mounted) {
        feedDetailProviderV2.getFeedDetail(context, widget.postId);
      }
    });
  }

  Widget commentSticker(BuildContext context, CommentContent comment) {
    return CachedNetworkImage(
      imageUrl: '${comment.url}',
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
      child: Consumer<p.FeedDetailProviderV2>(
        builder: (BuildContext context, p.FeedDetailProviderV2 feedDetailProviderV2, Widget? child) {
          if (feedDetailProviderV2.feedDetailStatus == p.FeedDetailStatus.loading) {
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
          return Container(
            margin: const EdgeInsets.only(top: Dimensions.marginSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  leading: CachedNetworkImage(
                  imageUrl: "${feedDetailProviderV2.feedDetailData.forum!.user?.avatar ?? "-"}",
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
                  title: Text(feedDetailProviderV2.feedDetailData.forum!.user?.username ?? "-",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.black
                    ),
                  ),
                  subtitle: Text(DateHelper.formatDateTime(feedDetailProviderV2.feedDetailData.forum!.createdAt!, context),
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: ColorResources.dimGrey
                    ),
                  ),
                  trailing: context.read<ProfileProvider>().userProfile.userId == feedDetailProviderV2.feedDetailData.forum!.user?.id
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
                
                Container(
                  margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                  child: PostText(feedDetailProviderV2.feedDetailData.forum!.caption ?? "-")
                ),
                if(feedDetailProviderV2.feedDetailData.forum!.type == "link")
                  PostLink(url: feedDetailProviderV2.feedDetailData.forum!.link ?? "-"),
                if (feedDetailProviderV2.feedDetailData.forum!.type == "document")
                  feedDetailProviderV2.feedDetailData.forum!.media!.isNotEmpty ? 
                  PostDoc(
                    medias: feedDetailProviderV2.feedDetailData.forum!.media!, 
                  ) : Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
                if (feedDetailProviderV2.feedDetailData.forum!.type == "image")
                  feedDetailProviderV2.feedDetailData.forum!.media!.isNotEmpty ? 
                PostImage(
                  true,
                  feedDetailProviderV2.feedDetailData.forum!.media!, 
                ): Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
                if (feedDetailProviderV2.feedDetailData.forum!.type == "video")
                  feedDetailProviderV2.feedDetailData.forum!.media!.isNotEmpty ? 
                  PostVideo(
                    media: feedDetailProviderV2.feedDetailData.forum!.media![0].path,
                  ): Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
            
                Container(
                  margin: const EdgeInsets.only(top: Dimensions.marginSizeExtraSmall, left: Dimensions.marginSizeDefault, right: Dimensions.marginSizeDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${feedDetailProviderV2.feedDetailData.forum!.like!.total}",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall
                              )
                            ),
                            InkWell(
                              onTap: () async => context.read<p.FeedDetailProviderV2>().toggleLike(context: context, feedId: feedDetailProviderV2.feedDetailData.forum!.id!, feedLikes: feedDetailProviderV2.feedDetailData.forum!.like!)
                              ,
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Icons.thumb_up,
                                  size: 16.0,
                                  color:  feedDetailProviderV2.feedDetailData.forum!.like!.likes.where((el) => el.user!.id ==  feedDetailProviderV2.ar.getUserId()).isEmpty ? ColorResources.black : ColorResources.blue
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text('${feedDetailProviderV2.feedDetailData.forum!.comment!.total} ${getTranslated("COMMENT", context)}',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall
                        ),
                      ),
                    ]
                  )
                ),
          
              ]
            ),
          );
        },
      )
    
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: Consumer<p.FeedDetailProviderV2>(
          builder: (BuildContext context, p.FeedDetailProviderV2 feedDetailProviderV2, Widget? child) {
            if (feedDetailProviderV2.feedDetailStatus == p.FeedDetailStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primaryOrange,
                )
              );
            } 
            if (feedDetailProviderV2.feedDetailStatus == p.FeedDetailStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_COMMENT", context),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault
                  ),
                )
              );
            }
            return RefreshIndicator(
              onRefresh: () {
              return Future.sync(() {
                  feedDetailProviderV2.getFeedDetail(context, widget.postId);
                });
              },
              child: NotificationListener(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    if (feedDetailProviderV2.hasMore) {
                      feedDetailProviderV2.loadMoreComment(context: context, postId: widget.postId);
                    }
                  }
                }
                return false;
                },
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int i) {
                    return const SizedBox(height: 8.0);
                  },
                  physics: const BouncingScrollPhysics(),
                  itemCount: feedDetailProviderV2.comments.length,
                  itemBuilder: (BuildContext context, int i) {
                    m.CommentElement comment = feedDetailProviderV2.comments[i];
                    // if (comment.comment.length == i) {
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
                        leading: CachedNetworkImage(
                        imageUrl: "${comment.user.avatar}",
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
                                Text(DateHelper.formatDateTime(comment.createdAt, context),
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: ColorResources.dimGrey
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        commentText(context, comment.comment)
                                    ],
                                  ),
                                ),
                              ]
                            ),
                          ),
                          trailing: context.read<ProfileProvider>().userProfile.userId == comment.user.id 
                          ? grantedDeleteComment(context, comment.id)
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
                                      feedDetailProviderV2.toggleLikeComment(
                                        context: context, 
                                        feedId: widget.postId, 
                                        commentId: comment.id, 
                                        feedLikes: comment.like
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.thumb_up,
                                        size: 16.0,
                                        color: comment.like.likes.where(
                                          (el) => el.user!.id == feedDetailProviderV2.ar.getUserId()
                                        ).isEmpty ? ColorResources.black : ColorResources.blue),
                                    ),
                                  ),
                                ]
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, NS.fromLeft(RepliesScreen(
                                  id: comment.id,
                                  postId: widget.postId,
                                  index: i,
                                ))).then((_) => setState(() {
                                  feedDetailProviderV2.getFeedDetail(context, widget.postId);
                                }));
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
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 16.0),
            Expanded(
              child: TextField(
                focusNode: commentFn,
                controller: feedDetailProviderV2.commentC,
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
                await feedDetailProviderV2.postComment(context, widget.postId);
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
                              await context.read<FeedProviderV2>().deletePost(context, feedDetailProviderV2.feedDetailData.forum!.id!);               
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

  Widget grantedDeleteComment(context, String idComment) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) { 
        return [
          PopupMenuItem(
            child: Text(getTranslated("DELETE_COMMENT", context),
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
                    Text(getTranslated("DELETE_COMMENT", context),
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
                              await context.read<p.FeedDetailProviderV2>().deleteComment(context: context, feedId: feedDetailProviderV2.feedDetailData.forum!.id!, deleteId: idComment);               
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
