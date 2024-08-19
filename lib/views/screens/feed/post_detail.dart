import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:saka/maps/src/utils/uuid.dart';

import 'package:saka/data/models/feedv2/feedDetail.dart' as m;
import 'package:saka/data/models/feedv2/feedDetail.dart';

import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/providers/feedv2/feedDetail.dart' as p;
import 'package:saka/providers/feedv2/feedReply.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/utils/date_util.dart';
import 'package:saka/views/screens/dashboard/dashboard.dart';

import 'package:saka/views/screens/feed/widgets/post_doc.dart';
import 'package:saka/views/screens/feed/widgets/post_img.dart';
import 'package:saka/views/screens/feed/widgets/post_link.dart';
import 'package:saka/views/screens/feed/widgets/post_video.dart';
import 'package:saka/views/screens/feed/widgets/post_text.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/button/custom.dart';

class PostDetailScreen extends StatefulWidget {
  final dynamic data;

  const PostDetailScreen({
    Key? key,    
    required this.data,
  }) : super(key: key);

  @override
  PostDetailScreenState createState() => PostDetailScreenState();
}

class PostDetailScreenState extends State<PostDetailScreen> with TickerProviderStateMixin {

  String mentionTrigger = "@";

  String previousText = "";
  String inputText = "";

  late FeedReplyProvider frp;
  late p.FeedDetailProviderV2 feedDetailProvider;
  
  bool deletePostBtn = false;

  Timer? debounce;  

  Future<void> onTextChanged(String text) async {
    if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () async {
        final text = feedDetailProvider.controller.text;
        final RegExp regex = RegExp(r'@\w+');
        final matches = regex.allMatches(text);

        int cursorPosition = feedDetailProvider.controller.selection.baseOffset;

        String activeMention = '';
        // int currentActiveStart = 0;
        // int currentActiveEnd = 0;

        for (final match in matches) {
          final mention = match.group(0)!;
          final start = match.start;
          final end = match.end;

          // Check if the cursor is within the current match
          if (cursorPosition >= start && cursorPosition <= end) {
            // currentActiveStart = start;
            // currentActiveEnd = end;
            activeMention = mention.replaceAll('@', '');
            break;
          }
        }

        String updatedText = activeMention;

        await feedDetailProvider.getUserMentions(context, updatedText);
        
        if(text.isEmpty) {
          feedDetailProvider.toggleShowListUserMention(false);
        }
      });

    setState(() {
      inputText = text;
    });
  }

  void onSuggestionSelected(String suggestion) {
    final cursorPosition = feedDetailProvider.controller.selection.baseOffset;
    final mentionIndex = inputText.lastIndexOf(mentionTrigger, cursorPosition);

    if (mentionIndex != -1) {
      final beforeMention = inputText.substring(0, mentionIndex);
      final afterMention = inputText.substring(cursorPosition);
      final newText = '$beforeMention$mentionTrigger$suggestion $afterMention';

      feedDetailProvider.controller.text = newText;

      final newCursorPosition = mentionIndex + mentionTrigger.length + suggestion.length + 1;
      feedDetailProvider.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newCursorPosition),
      );
    }

    feedDetailProvider.toggleShowListUserMention(false);
  }

  Widget post(BuildContext context) {
    return Consumer<p.FeedDetailProviderV2>(
      builder: (BuildContext context, p.FeedDetailProviderV2 feedDetailProvider, Widget? child) {

        if (feedDetailProvider.feedDetailStatus == p.FeedDetailStatus.loading) {
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

        if (feedDetailProvider.feedDetailStatus == p.FeedDetailStatus.error) {
          return const SizedBox(
            height: 100.0,
            child: Center(
              child: Text("Postingan tidak ditemukan atau sudah dihapus")
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                dense: true,
                leading: CachedNetworkImage(
                imageUrl: feedDetailProvider.feedDetailData.forum!.user?.avatar ?? "-",
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
                title: Text(feedDetailProvider.feedDetailData.forum!.user!.username.toString(),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.black
                  ),
                ),
                subtitle: Text(DateHelper.formatDateTime(feedDetailProvider.feedDetailData.forum!.createdAt!, context),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: ColorResources.dimGrey
                  ),
                ),
                trailing: feedDetailProvider.ar.getUserId() == feedDetailProvider.feedDetailData.forum!.user?.id
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
                margin: const EdgeInsets.only(left: 15.0),
                child: PostText(feedDetailProvider.feedDetailData.forum!.caption ?? "-")
              ),
              if(feedDetailProvider.feedDetailData.forum!.type == "link")
                PostLink(url: feedDetailProvider.feedDetailData.forum!.link ?? "-"),
              if (feedDetailProvider.feedDetailData.forum!.type == "document")
                feedDetailProvider.feedDetailData.forum!.media!.isNotEmpty ? 
                PostDoc(
                  medias: feedDetailProvider.feedDetailData.forum!.media!, 
                ) : Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
              if (feedDetailProvider.feedDetailData.forum!.type == "image")
                feedDetailProvider.feedDetailData.forum!.media!.isNotEmpty ? 
              PostImage(
                feedDetailProvider.feedDetailData.forum!.user!.username,
                feedDetailProvider.feedDetailData.forum!.caption!,
                true,
                feedDetailProvider.feedDetailData.forum!.media!, 
              ): Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
              if (feedDetailProvider.feedDetailData.forum!.type == "video")
                feedDetailProvider.feedDetailData.forum!.media!.isNotEmpty ? 
                PostVideo(
                  media: feedDetailProvider.feedDetailData.forum!.media![0].path,
                ): Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
          
              Container(
                margin: const EdgeInsets.only(
                  top: 5.0, 
                  left: 15.0, 
                  right: 15.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      itemCount: feedDetailProvider.feedDetailData.forum!.like!.likes.length,
                                      itemBuilder: (_, int i) {

                                        final like = feedDetailProvider.feedDetailData.forum!.like!.likes[i];

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
                              child: Icon(Icons.thumb_up,
                                size: 18.0, 
                                color: feedDetailProvider.feedDetailData.forum!.like!.likes.where((el) => el.user!.id == feedDetailProvider.ar.getUserId()).isEmpty 
                                ? ColorResources.black
                                : ColorResources.blue
                              ),
                            ),
                            
                            Text("${feedDetailProvider.feedDetailData.forum!.like!.total}",
                              style: robotoRegular.copyWith(
                                color: ColorResources.black,
                                fontSize: Dimensions.fontSizeDefault
                              )
                            ),
                        
                          ],
                        ),
                      ),
                    ),
    
                    Text('${feedDetailProvider.feedDetailData.forum!.comment!.total} ${getTranslated("COMMENT", context)}',
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
                        backgroundColor: feedDetailProvider.feedDetailData.forum!.like!.likes.where(
                        (el) => el.user!.id == feedDetailProvider.ar.getUserId()).isEmpty 
                        ? null
                        : ColorResources.error
                      ),
                      onPressed: () {
                        context.read<p.FeedDetailProviderV2>().toggleLike(
                          context: context, 
                          forumId: feedDetailProvider.feedDetailData.forum!.id!, 
                          forumLikes: feedDetailProvider.feedDetailData.forum!.like!
                        );
                      }, 
                      child: Text(getTranslated("LIKE", context),
                        style: const TextStyle(
                          color: ColorResources.black,
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
                        feedDetailProvider.focusNode.requestFocus();
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
        
            ]
          ),
        );
      },
    );
  }

  Future<void> getData() async {
    if(!mounted) return;
      await feedDetailProvider.getFeedDetail(context, widget.data["forum_id"]);

    if(!mounted) return;
      feedDetailProvider.clearInput();

    if(widget.data["from"] == "notification-comment") {

      int index = feedDetailProvider.comments.indexWhere((el) => el.id == widget.data["comment_id"]);

      feedDetailProvider.onUpdateHighlightComment(widget.data["comment_id"]);

      Future.delayed(const Duration(milliseconds: 1000), () {
        GlobalKey targetContext = feedDetailProvider.comments[index].key;

        if(targetContext.currentContext != null) {
          Scrollable.ensureVisible(targetContext.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }

      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        feedDetailProvider.onUpdateHighlightComment("");
      });

    }

    if(widget.data["from"] == "notification-reply") {

      int index = feedDetailProvider.comments.indexWhere((el) => el.id == widget.data["comment_id"]);

      feedDetailProvider.onUpdateHighlightReply(widget.data["reply_id"]);

      Future.delayed(const Duration(milliseconds: 1000), () {
        if(feedDetailProvider.comments[index].reply.replies.isNotEmpty) {
          GlobalKey targetContext = feedDetailProvider.comments[index].reply.replies.last.key;

          if(targetContext.currentContext != null) {
            Scrollable.ensureVisible(targetContext.currentContext!,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }

        }
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        feedDetailProvider.onUpdateHighlightReply("");
      });

    }

  }

  @override
  void initState() {  
    super.initState();

    frp = context.read<FeedReplyProvider>();
    feedDetailProvider = context.read<p.FeedDetailProviderV2>();

    Future.microtask(() => getData());
  }

  @override 
  void dispose() {
    debounce?.cancel();
    
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        NS.pushUntil(
          context, 
          DashboardScreen()
        );
      },
      child: Scaffold(
        body: RefreshIndicator.adaptive(
          onRefresh: () {
            return Future.sync(() {
              feedDetailProvider.getFeedDetail(context, widget.data["forum_id"]);
            });
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
          
              SliverAppBar(
                systemOverlayStyle: SystemUiOverlayStyle.light,
                backgroundColor: ColorResources.white,
                title: Text('Post', 
                  style: robotoRegular.copyWith(
                    color: ColorResources.black,
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.fontSizeLarge
                  )
                ),
                leading: CupertinoNavigationBarBackButton(
                  color: ColorResources.black,
                  onPressed: () {
                    NS.pushUntil(
                      context, 
                      DashboardScreen()
                    );
                  },
                ),
                elevation: 0.0,
                centerTitle: true,
                pinned: false,
                floating: true,
              ),

              SliverList(
                delegate: SliverChildListDelegate([
            
                  post(context),
                  
                  Consumer<p.FeedDetailProviderV2>(
                    builder: (BuildContext context, p.FeedDetailProviderV2 feedDetailProvider, Widget? child) {
                      if (feedDetailProvider.feedDetailStatus == p.FeedDetailStatus.loading) {
                        return const Center(
                          child: SpinKitThreeBounce(
                            size: 20.0,
                            color: ColorResources.primaryOrange,
                          )
                        );
                      } 
                      if (feedDetailProvider.feedDetailStatus == p.FeedDetailStatus.error) {
                        return const SizedBox();
                      }
                      if (feedDetailProvider.feedDetailStatus == p.FeedDetailStatus.empty) {
                        return SizedBox(
                          height: 450.0,
                          child: Center(
                            child: Text(getTranslated("THERE_IS_NO_COMMENT", context),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault
                              ),
                            )
                          ),
                        );
                      }
                      return NotificationListener(
                        onNotification: (notification) {
                          if (notification is ScrollEndNotification) {
                            if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                              if (feedDetailProvider.hasMore) {
                                feedDetailProvider.loadMoreComment(context: context, postId: widget.data["forum_id"]);
                              }
                            }
                          }

                          return false;
                        },
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int i) {
                            return const SizedBox(height: 8.0);
                          },
                          physics: const BouncingScrollPhysics(),
                          itemCount: feedDetailProvider.comments.length,
                          itemBuilder: (BuildContext context, int i) {
      
                            m.CommentElement comment = feedDetailProvider.comments[i];
                                            
                            return Container(
                              key: comment.key,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
      
                                  ListTile(
                                    leading: CachedNetworkImage(
                                    imageUrl: comment.user.avatar,
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
                                      decoration: BoxDecoration(
                                        color: context.watch<p.FeedDetailProviderV2>().highlightedComment == comment.id 
                                        ? ColorResources.backgroundLive
                                        : ColorResources.blueGrey,
                                        borderRadius: const BorderRadius.all(
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
                                            
                                            const SizedBox(height: 8.0),
      
                                            DetectableText(
                                              text: comment.comment,
                                              detectionRegExp: atSignRegExp,
                                              detectedStyle: robotoRegular.copyWith(
                                                color: Colors.blue
                                              ),
                                              basicStyle: robotoRegular
                                            )
                                            
                                          ]
                                        ),
                                      ),
                                      trailing: feedDetailProvider.ar.getUserId() == comment.user.id 
                                      ? grantedDeleteComment(context, comment.id, widget.data["forum_id"])
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
                                                            }
                                                          )
                                                        ],
                                                      ) 
                                                    ]
                                                  )
                                                )
                                              );
                                            },
                                          );
                                        }
                                      },
                                    )
                                  ),
      
                                  Container(
                                    width: 140.0,
                                    margin: const EdgeInsets.only(
                                      left: 65.0,
                                      right: 65.0
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
      
                                        Text(comment.like.total.toString(),
                                          style: robotoRegular.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimensions.fontSizeDefault
                                          ),
                                        ),
      
                                        const SizedBox(width: 5.0),
      
                                        InkWell(
                                          onTap: () {
                                            feedDetailProvider.toggleLikeComment(
                                              context: context, 
                                              forumId: widget.data["forum_id"], 
                                              commentId: comment.id, 
                                              commentLikes: comment.like
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              getTranslated("LIKE", context),
                                              style: TextStyle(
                                                color:  comment.like.likes.where(
                                                (el) => el.user!.id == feedDetailProvider.ar.getUserId()
                                                ).isEmpty ? ColorResources.black : ColorResources.blue,
                                                fontSize: Dimensions.fontSizeDefault,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
      
                                        const SizedBox(width: 8.0),
      
                                        InkWell(
                                          onTap: () async {

                                            feedDetailProvider.controller.text = "@${comment.user.mention} ";
      
                                            feedDetailProvider.focusNode.requestFocus();
      
                                            previousText = "@${comment.user.mention} ";

                                            feedDetailProvider.onUpdateType("REPLY");
      
                                            feedDetailProvider.onSelectedReply(
                                              valComment: comment.id,
                                              valReply: Uuid().generateV4()
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(getTranslated("REPLY",context),
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeDefault,
                                                fontWeight: FontWeight.bold
                                              )
                                            ),
                                          ),
                                        ),
      
                                      ]
                                    ),
                                  ),
      
                                  comment.reply.replies.isEmpty 
                                  ? const SizedBox() 
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                        left: 40.0
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: comment.reply.replies.length,
                                        itemBuilder: (BuildContext context, int i) {
      
                                        ReplyElement reply = comment.reply.replies[i];
                                    
                                        return Container(
                                          key: reply.key,
                                          child: ListTile(
                                            leading: CachedNetworkImage(
                                            imageUrl: reply.user.avatar.toString(),
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
                                              decoration: BoxDecoration(
                                              color: context.watch<p.FeedDetailProviderV2>().highlightedReply == reply.id 
                                                ? ColorResources.backgroundLive
                                                : ColorResources.blueGrey,
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(8.0)
                                                )
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                                            
                                                  Text(reply.user.username.toString(),
                                                    style: robotoRegular.copyWith(
                                                      fontSize: Dimensions.fontSizeDefault,
                                                    ),
                                                  ),
                                                  
                                                  Text(DateHelper.formatDateTime(reply.createdAt.toString(), context),
                                                    style: robotoRegular.copyWith(
                                                      fontSize: Dimensions.fontSizeExtraSmall,
                                                      color: ColorResources.dimGrey
                                                    ),
                                                  ),
                                                    
                                                  const SizedBox(height: 8.0),
                                                                          
                                                  DetectableText(
                                                    text: reply.reply,
                                                    detectionRegExp: atSignRegExp,
                                                    detectedStyle: robotoRegular.copyWith(
                                                      color: Colors.blue
                                                    ),
                                                    basicStyle: robotoRegular
                                                  ),
      
                                                  Container(
                                                    width: 140.0,
                                                    margin: const EdgeInsets.only(
                                                      top: 5.0
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
      
                                                        Text(reply.like.total.toString(),
                                                          style: robotoRegular.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: Dimensions.fontSizeDefault
                                                          ),
                                                        ),
      
                                                        const SizedBox(width: 5.0),
      
                                                        InkWell(
                                                          onTap: () {
                                                            feedDetailProvider.toggleLikeReply(
                                                              context: context, 
                                                              commentIdP: comment.id,
                                                              replyIdP: reply.id, 
                                                            );
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text(getTranslated("LIKE", context),
                                                              style: TextStyle(
                                                                color: reply.like.likes.where(
                                                                (el) => el.user!.id == feedDetailProvider.ar.getUserId()
                                                                ).isEmpty ? ColorResources.black : ColorResources.blue,
                                                                fontSize: Dimensions.fontSizeDefault,
                                                                fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                          ),
                                                        ),
      
                                                        const SizedBox(width: 8.0),
      
                                                        InkWell(
                                                          onTap: reply.user.id == feedDetailProvider.ar.getUserId() 
                                                          ? () {} 
                                                          : () {
                                                            feedDetailProvider.controller.text = "@${reply.user.mention} ";
      
                                                            feedDetailProvider.focusNode.requestFocus();
                                                            
                                                            previousText = "@${reply.user.mention} ";

                                                            feedDetailProvider.onUpdateType("REPLY");
      
                                                            feedDetailProvider.onSelectedReply(
                                                              valComment: comment.id,
                                                              valReply: reply.id
                                                            );
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text(getTranslated("REPLY",context),
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeDefault,
                                                                fontWeight: FontWeight.bold
                                                              )
                                                            ),
                                                          ),
                                                        ),
      
                                                      ]
                                                    ),
                                                  ),
                                          
                                                ]
                                              ),
                                            ),
                                            trailing: feedDetailProvider.ar.getUserId() == reply.user.id 
                                            ? grantedDeleteReply(context, widget.data["forum_id"], reply.id)
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
                                        );
                                      },
                                    ),
                                  ),
      
                                ]
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          
                ])
              )
          
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          
            if (context.watch<p.FeedDetailProviderV2>().showListUserMention)
              Container(
                width: double.infinity,
                height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: kElevationToShadow[4]
                ),
                child: Consumer<p.FeedDetailProviderV2>(
                  builder: (__, notifier, _) {
          
                    if(notifier.userMentionStatus == p.UserMentionStatus.loading) {
                      return const Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: ColorResources.primaryOrange,
                        )
                      );
                    }
                    
                    if(notifier.userMentionStatus == p.UserMentionStatus.empty) {
                      return Center(
                        child: Text("User not found",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        )
                      );
                    }
          
                    final data = notifier.userMentions;
          
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(data[i]["display"]),
                            leading: CachedNetworkImage(
                              imageUrl: data[i]["photo"],
                              imageBuilder: (context, imageProvider) {
                                return CircleAvatar(
                                  maxRadius: 20.0,
                                  backgroundImage: imageProvider,
                                );
                              },
                              errorWidget:(context, url, error) {
                                return const CircleAvatar(
                                  maxRadius: 20.0,
                                  backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                );
                              },
                              placeholder: (context, url) {
                                return const CircleAvatar(
                                  maxRadius: 20.0,
                                  backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                );
                              },
                            ),
                            onTap: () => onSuggestionSelected(data[i]["display"]),
                          ),
                        );
                      }
                    );
                  },
                ) 
              ),
          
              DetectableTextField(
                controller: feedDetailProvider.controller,
                focusNode: feedDetailProvider.focusNode,
                onChanged: onTextChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorResources.white,
                  contentPadding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: ColorResources.black,
                    ),
                    onPressed: () async {
                      await feedDetailProvider.postComment(
                        context, 
                        widget.data["forum_id"]
                      );
                    } 
                  ),
                  hintText: '${getTranslated("WRITE_COMMENT", context)} ...',
                  hintStyle: robotoRegular.copyWith(
                    color: ColorResources.greyDarkPrimary,
                    fontSize: Dimensions.fontSizeDefault
                  ),
                ),
              ),
          
            ],
          ),
        )
        
        // Container(
        //   padding: MediaQuery.of(context).viewInsets,
        //   decoration: const BoxDecoration(
        //     color: ColorResources.white
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.max,
        //     children: [
              
        //       Expanded(
        //         child: FlutterMentions(
        //           key: feedDetailProvider.mentionKey,
        //           focusNode: mentionFn,
        //           maxLines: 5,
        //           minLines: 1,
        //           appendSpaceOnAdd: true,
        //           suggestionPosition: SuggestionPosition.Top,
        //           onSearchChanged: (trigger, val) async {
        //             await feedDetailProvider.getUserMentions(context, val);
        //           },
        //           onChanged: (String val) async {
        //             final currentText = feedDetailProvider.mentionKey.currentState!.controller!.text;
  
        //             if (previousText.length - currentText.length == 1) {
        //               feedDetailProvider.onUpdateType("COMMENT"); 
        //             }
        //           },
        //           style: robotoRegular.copyWith(
        //             color: Colors.black,
        //             fontSize: Dimensions.fontSizeDefault
        //           ),
        //           decoration: InputDecoration(
        //             contentPadding: const EdgeInsets.only(
        //               left: 16.0,
        //               right: 16.0
        //             ),
        //             hintText: '${getTranslated("WRITE_COMMENT", context)} ...',
        //             hintStyle: robotoRegular.copyWith(
        //               color: ColorResources.greyDarkPrimary,
        //               fontSize: Dimensions.fontSizeDefault
        //             ),
        //           ),
        //           mentions: [
                    
        //             Mention(
        //               trigger: '@',
        //               style: const TextStyle(
        //                 color: Colors.blue,
        //               ),
        //               disableMarkup: true,
        //               matchAll: true,
        //               data: context.watch<p.FeedDetailProviderV2>().userMentions,
        //               suggestionBuilder: (Map<String, dynamic> data) {
        //                 return  Stack(
        //                   clipBehavior: Clip.none,
        //                   children: [
        //                     IgnorePointer(
        //                       ignoring: true,
        //                       child: Container(
        //                         color: ColorResources.white,
        //                         width: double.infinity,
        //                         height: 60,
        //                         child: const SizedBox(),
        //                       ),
        //                     ),
        //                     Positioned.fill(
        //                       child: 
        //                       Container(
        //                         padding: const EdgeInsets.all(10.0),
        //                         child: Row(
        //                           mainAxisSize: MainAxisSize.max,
        //                           children: [
                                                          
        //                             CachedNetworkImage(
        //                               imageUrl: data['photo'].toString(),
        //                               imageBuilder: (context, imageProvider) {
        //                                 return CircleAvatar(
        //                                   backgroundImage: imageProvider,
        //                                 );
        //                               },
        //                               placeholder: (_, __) {
        //                                 return const CircleAvatar(
        //                                   backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
        //                                 );
        //                               },
        //                               errorWidget: (_, ___, __) {
        //                                 return const CircleAvatar(
        //                                   backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
        //                                 );
        //                               },
        //                             ),
                                                            
        //                             const SizedBox(
        //                               width: 20.0,
        //                             ),
                                                            
        //                             Text('@${data['display']}',
        //                               style: robotoRegular.copyWith(
        //                                 color:Colors.blue
        //                               ),
        //                             )
                                                          
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 );
        //               }
        //             ),

        //           ]
        //         )
        //       ),
              
        //       IconButton(
        //         icon: const Icon(
        //           Icons.send,
        //           color: ColorResources.black,
        //         ),
        //         onPressed: () async {
        //           await feedDetailProvider.postComment(
        //             context, 
        //             widget.data["forum_id"]
        //           );
        //         } 
        //       ),
              
        //     ],
        //   ),
        // )


      ),
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
                          builder: (BuildContext context, Function setStatefulBuilder) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.error
                            ),
                            onPressed: () async { 

                              setStatefulBuilder(() => deletePostBtn = true);

                              try {         
                                await context.read<FeedProviderV2>().deletePost(context, feedDetailProvider.feedDetailData.forum!.id!);               
                                
                                setStatefulBuilder(() => deletePostBtn = false);
                                
                                Navigator.of(context).pop(); 
                                Navigator.of(context).pop();     

                              } catch(e) {
                                
                                setStatefulBuilder(() => deletePostBtn = false);
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

  Widget grantedDeleteReply(
    BuildContext context, 
    String forumId,
    String replyId
  ) {
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
                                                          await context.read<p.FeedDetailProviderV2>().deleteReply(
                                                            context: context,
                                                            forumId: forumId,
                                                            replyId: replyId,
                                                          );               
                                                          setState(() => deletePostBtn = false);     
                                                          Navigator.of(context).pop();       
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

  Widget grantedDeleteComment(
    BuildContext context,
    String commentId,  
    String forumId
  ) {
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
                                await context.read<p.FeedDetailProviderV2>().deleteComment(
                                  context: context, 
                                  forumId: forumId, 
                                  commentId: commentId
                                );               
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
                          }
                        )
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
