
import 'package:flutter/material.dart';

import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/data/models/feedv2/feed.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/feedv2/feedDetail.dart';
import 'package:saka/providers/feedv2/feed.dart';

import 'package:saka/utils/date_util.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/screens/feed/widgets/terms_popup.dart';
import 'package:saka/views/screens/feed/post_detail.dart';
// FOR TEMPORARY
// import 'package:saka/views/screens/feed/widgets/post_video.dart';
import 'package:saka/views/screens/feed/widgets/post_doc.dart';
import 'package:saka/views/screens/feed/widgets/post_img.dart';
import 'package:saka/views/screens/feed/widgets/post_link.dart';
import 'package:saka/views/screens/feed/widgets/post_text.dart';

class Posts extends StatefulWidget {
  final Forum forum;

  const Posts({
    Key? key, 
    required this.forum,
  }) : super(key: key);

  @override
  PostsState createState() => PostsState();
}

class PostsState extends State<Posts> {

  late FeedProviderV2 feedProviderV2;

  bool deletePostBtn = false;

  @override 
  void initState() {
    super.initState();

    feedProviderV2 = context.read<FeedProviderV2>();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [ 
    
        ListTile(
          dense: true,
          leading: CachedNetworkImage(
          imageUrl: widget.forum.user!.avatar!,
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
          title: Text(widget.forum.user!.username!,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.black
            ),
          ),
          subtitle: Text(DateHelper.formatDateTime(widget.forum.createdAt!, context),
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: ColorResources.dimGrey
            ),
          ),
          trailing: feedProviderV2.ar.getUserId() == widget.forum.user!.id! 
          ? grantedDeletePost(context) 
          : PopupMenuButton(
              itemBuilder: (BuildContext buildContext) { 
                return widget.forum.type == "video" 
                ? [
                    PopupMenuItem(
                      child: Text("Download Video",
                        style: robotoRegular.copyWith(
                          color: Colors.blue,
                          fontSize: Dimensions.fontSizeSmall
                        )
                      ), 
                      value: "/download-video"
                    ),
                    PopupMenuItem(
                      child: Text("Block content",
                        style: robotoRegular.copyWith(
                          color: ColorResources.error,
                          fontSize: Dimensions.fontSizeSmall
                        )
                      ), 
                      value: "/report-user"
                    ),
                    PopupMenuItem(
                      child: Text("Block user",
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
                  ] 
                : [
                  PopupMenuItem(
                    child: Text("Block content",
                      style: robotoRegular.copyWith(
                        color: ColorResources.error,
                        fontSize: Dimensions.fontSizeSmall
                      )
                    ), 
                    value: "/report-user"
                  ),
                  PopupMenuItem(
                    child: Text("Block user",
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
              onSelected: (route) async {
                if(route == "/download-video") {
                  ProgressDialog pr = ProgressDialog(context: context);
                  try {
                    PermissionStatus statusStorage = await Permission.storage.status;
                    if(!statusStorage.isGranted) {
                      await Permission.storage.request();
                    } 
                    pr.show(
                      max: 1,
                      msg: '${getTranslated("DOWNLOADING", context)}...'
                    );
                    await GallerySaver.saveVideo("${widget.forum.media![0].path}");
                    pr.close();
                    ShowSnackbar.snackbar(context, getTranslated("SAVE_TO_GALLERY", context), "", ColorResources.success);
                  } catch(_) {
                    pr.close();
                    ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
                  }
                }
                if(route == "/report-user") {
                  showAnimatedDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                        height: 150.0,
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(
                          top: 10.0, 
                          bottom: 10.0, 
                          left: 16.0, 
                          right: 16.0
                        ),
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
     
        Container(
          margin: const EdgeInsets.only(
            top: 5.0,
            bottom: 5.0, 
            left: 15.0,
            right: 15.0
          ),
          child: PostText(widget.forum.caption!)
        ),
    
        if(widget.forum.type == "link")
          PostLink(url: widget.forum.link!),
        if(widget.forum.type == "document")
          PostDoc(medias: widget.forum.media!),
        if(widget.forum.type == "image")
          PostImage(widget.forum.user!.username!, widget.forum.caption!, false, widget.forum.media!),
        if(widget.forum.type == "video")
          // PostVideo(
          //   media: widget.forum.media![0].path!, 
          // ),
      
        Container(
          margin: const EdgeInsets.only(
            top: 5.0,
            bottom: 5.0, 
            left: 15.0, 
            right: 15.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
    
              SizedBox(
                width: 40.0,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context, 
                      builder: (context) {
                        return Container(
                          height: 300.0,
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
    
                              ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: widget.forum.like!.likes.length,
                                itemBuilder: (_, int i) {
    
                                  final like = widget.forum.like!.likes[i];
    
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                    
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                    
                                            CachedNetworkImage(
                                              imageUrl: like.user!.avatar.toString(),
                                              imageBuilder: (context, imageProvider) {
                                                return CircleAvatar(
                                                  maxRadius: 25.0,
                                                  backgroundImage: imageProvider,
                                                );
                                              },
                                              placeholder: (context, url) {
                                                return const CircleAvatar(
                                                  maxRadius: 25.0,
                                                  backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                                );
                                              },
                                              errorWidget: (context, url, error) {
                                                return const CircleAvatar(
                                                  maxRadius: 25.0,
                                                  backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                                );
                                              },
                                            ),
                                    
                                            const SizedBox(width: 14.0),
                                    
                                            Text(like.user!.username.toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0
                                              ),
                                            )
                                    
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
    
                            ],
                          )
                        );
                      },
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                         
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.thumb_up,
                          size: 18.0,
                          color: ColorResources.black 
                        ),
                      ),
                  
                      Text('${widget.forum.like!.total}', 
                        style: robotoRegular.copyWith(
                          color: ColorResources.black,
                          fontSize: Dimensions.fontSizeDefault
                        )
                      ),
                  
                    ],
                  ),
                ),
              ),
    
              Text('${widget.forum.comment!.total.toString()} ${getTranslated("COMMENT", context)}',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              ),
    
            ]
          )
        ), 
    
        Container(
          margin: const EdgeInsets.only(
            top: 5.0,
            bottom: 15.0,
            left: 15.0, 
            right: 15.0
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
    
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.forum.like!.likes.where((el) => el.user!.id == context.read<FeedProviderV2>().ar.getUserId()).isEmpty 
                    ? null
                    :ColorResources.error 
                  ),
                  onPressed: () {
                    context.read<FeedProviderV2>().toggleLike(
                      context: context, 
                      forumId: widget.forum.id!, 
                      feedLikes: widget.forum.like!
                    );
                  }, 
                  child: Text(getTranslated("LIKE", context),
                    style: TextStyle(
                      color: widget.forum.like!.likes.where((el) => el.user!.id == context.read<FeedProviderV2>().ar.getUserId()).isEmpty 
                      ? ColorResources.black
                       :ColorResources.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  )
                ),
              ),
    
              const SizedBox(width: 12.0),
    
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                     NS.push(context, PostDetailScreen(
                      from: "index",
                      data: {
                        "forum_id": widget.forum.id,
                        "comment_id": "",
                        "reply_id": "",
                        "from": "click"
                      },
                    )).then((_) {
                      context.read<FeedProviderV2>().fetchFeedMostRecent(context);
                    });
                  }, 
                  child: Text(getTranslated("COMMENT", context),
                    style: const TextStyle(
                      color: ColorResources.black,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  )
                ),
              ),
    
            ],
          ),
        ),
    
        widget.forum.comment!.comments!.isEmpty 
        ? const SizedBox()
        : Container(
          margin: const EdgeInsets.only(
            top: 10.0,
            bottom: 15.0,
            left: 15.0, 
            right: 15.0
          ),
          child: Column(
            children: [
    
              ListTile(
                leading: CachedNetworkImage(
                imageUrl: widget.forum.comment!.comments!.last.user!.avatar.toString(),
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
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    color: ColorResources.blueGrey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0)
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.forum.comment!.comments!.last.user!.username.toString(),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                        
                        Text(DateHelper.formatDateTime(widget.forum.comment!.comments!.last.createdAt.toString(), context),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: ColorResources.dimGrey
                          ),
                        ),
                          
                        const SizedBox(height: 8.0),
    
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DetectableText(
                              text: widget.forum.comment!.comments!.last.comment!,
                              detectionRegExp: atSignRegExp,
                              detectedStyle: robotoRegular.copyWith(
                                color: Colors.blue
                              ),
                              basicStyle: robotoRegular
                            )
                          ],
                        ),
                      ]
                    ),
                  ),
                  trailing: feedProviderV2.ar.getUserId() == widget.forum.comment!.comments!.last.user!.id.toString()
                  ? grantedDeleteComment(context, widget.forum.comment!.comments!.last.id.toString(), widget.forum.id.toString())
                  : TermsPopup()
              ),
    
            ],
          )
        )
      ],
    );
  }


  Widget grantedDeleteComment(context, String commentId, String forumId) {
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
            value: "/delete-comment"
          )
        ];
      },
      onSelected: (route) {
        if(route == "/delete-comment") {
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
                          builder: (BuildContext context, Function setStateBuilder) {
                          return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.error
                          ),
                          onPressed: () async { 
                            setStateBuilder(() => deletePostBtn = true);
                            await context.read<FeedDetailProviderV2>().deleteComment(
                              context: context, 
                              forumId: forumId, 
                              commentId: commentId
                            );
                            await context.read<FeedProviderV2>().fetchFeedMostRecent(
                              context
                            );  
                            setStateBuilder(() => deletePostBtn = false);           
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

  // Widget commentText(BuildContext context, String comment) {
  //   return ReadMoreText(
  //     comment,
  //     style: robotoRegular.copyWith(
  //       fontSize: Dimensions.fontSizeDefault
  //     ),
  //     trimLines: 2,
  //     colorClickableText: ColorResources.black,
  //     trimMode: TrimMode.Line,
  //     trimCollapsedText: getTranslated("READ_MORE", context),
  //     trimExpandedText: getTranslated("LESS_MORE", context),
  //     moreStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
  //     lessStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
  //   );
  // }

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
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeSmall
                            ),
                          )
                        ), 
                        StatefulBuilder(
                          builder: (BuildContext context, Function setStateBuilder) {
                          return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.error
                          ),
                          onPressed: () async { 
                            setStateBuilder(() => deletePostBtn = true);
                            await context.read<FeedProviderV2>().deletePost(
                              context,
                              widget.forum.id!,
                              "index"
                            );               
                            setStateBuilder(() => deletePostBtn = false);
                          },
                          child: deletePostBtn 
                          ? const Loader(
                              color: ColorResources.white,
                            )
                          : Text(getTranslated("YES", context),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: ColorResources.white
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
          // showAnimatedDialog(
          //   barrierDismissible: true,
          //   context: context,
          //   builder: (BuildContext context) {
          //     return Builder(
          //       builder: (BuildContext context) {
          //         return Container(
          //           margin: const EdgeInsets.only(
          //             left: 25.0,
          //             right: 25.0
          //           ),
          //           child: CustomDialog(
          //             backgroundColor: Colors.transparent,
          //             elevation: 0.0,
          //             minWidth: 180.0,
          //             child: Transform.rotate(
          //               angle: 0.0,
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                   color: Colors.transparent,
          //                   borderRadius: BorderRadius.circular(20.0),
          //                   border: Border.all(
          //                     color: ColorResources.white,
          //                     width: 1.0
          //                   )
          //                 ),
          //                 child: Column(
          //                   mainAxisSize: MainAxisSize.min,
          //                   children: [
          //                     Stack(
          //                       clipBehavior: Clip.none,
          //                       children: [
          //                         Transform.rotate(
          //                           angle: 56.5,
          //                           child: Container(
          //                             margin: const EdgeInsets.all(5.0),
          //                             height: 270.0,
          //                             decoration: BoxDecoration(
          //                               color: ColorResources.white,
          //                               borderRadius: BorderRadius.circular(20.0),
          //                             ),
          //                           ),
          //                         ),
          //                         Align(
          //                           alignment: Alignment.center,
          //                           child: Container(
          //                             margin: const EdgeInsets.only(
          //                               top: 50.0,
          //                               left: 25.0,
          //                               right: 25.0,
          //                               bottom: 25.0
          //                             ),
          //                             child: Column(
          //                               crossAxisAlignment: CrossAxisAlignment.center,
          //                               mainAxisSize: MainAxisSize.min,
          //                               children: [

          //                                 Image.asset("assets/imagesv2/remove.png",
          //                                   width: 60.0,
          //                                   height: 60.0,
          //                                 ),
                                          
          //                                 const SizedBox(height: 15.0),

          //                                 Text(getTranslated("DELETE_POST", context),
          //                                   style: poppinsRegular.copyWith(
          //                                     fontSize: Dimensions.fontSizeDefault,
          //                                     color: ColorResources.black
          //                                   ),
          //                                 ),

          //                                 const SizedBox(height: 20.0),

          //                                 StatefulBuilder(
          //                                   builder: (BuildContext context, Function setStatefulBuilder) {
          //                                     return  Row(
          //                                       mainAxisAlignment: MainAxisAlignment.center,
          //                                       mainAxisSize: MainAxisSize.max,
          //                                       children: [
                                
          //                                         Expanded(
          //                                           child: CustomButton(
          //                                             isBorderRadius: true,
          //                                             isBoxShadow: true,
          //                                             btnColor: ColorResources.error,
          //                                             isBorder: false,
          //                                             onTap: () {
          //                                               Navigator.of(context).pop();
          //                                             }, 
          //                                             btnTxt: getTranslated("NO", context)
          //                                           ),
          //                                         ),
                                
          //                                         const SizedBox(width: 8.0),
                                
          //                                         Expanded(
          //                                           child: CustomButton(
          //                                             isBorderRadius: true,
          //                                             isBoxShadow: true,
          //                                             btnColor: ColorResources.success,
          //                                             onTap: () async {
          //                                               setStatefulBuilder(() => deletePostBtn = true);
          //                                               await context.read<FeedProviderV2>().deletePost(
          //                                                 context,
          //                                                 widget.forum.id!
          //                                               );               
          //                                               setStatefulBuilder(() => deletePostBtn = false);    
          //                                             }, 
          //                                             btnTxt: deletePostBtn 
          //                                             ? "..." 
          //                                             : getTranslated("YES", context)
          //                                           ),
          //                                         )
                                
          //                                       ],
          //                                     );
          //                                   },
          //                                 ),

          //                               ],
          //                             ),
          //                           ),
          //                         )
          //                       ],
          //                     ),
          //                   ],
          //                 ) 
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ); 
          //   },
          // );
        }
      },
    );
  }
} 