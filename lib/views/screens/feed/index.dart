// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animated_dialog_updated/flutter_animated_dialog.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:visibility_detector/visibility_detector.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/providers/profile/profile.dart';
import 'package:saka/providers/feedv2/feedDetail.dart';

import 'package:saka/utils/date_util.dart';

import 'package:saka/data/models/feedv2/feed.dart';

import 'package:saka/views/screens/dashboard/dashboard.dart';
import 'package:saka/views/screens/feed/post_detail.dart';
import 'package:saka/views/screens/feed/widgets/input_post.dart';
import 'package:saka/views/screens/feed/widgets/post_doc.dart';
import 'package:saka/views/screens/feed/widgets/post_img.dart';
import 'package:saka/views/screens/feed/widgets/post_link.dart';
import 'package:saka/views/screens/feed/widgets/post_text.dart';
import 'package:saka/views/screens/feed/widgets/post_video.dart';
import 'package:saka/views/screens/feed/widgets/terms_popup.dart';

// FOR TEMPORARY
// import 'package:saka/views/screens/feed/posts.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

bool _isValidVisibleUsername(String? username) {
  final value = username?.trim();

  if (value == null || value.isEmpty) {
    return false;
  }

  return !value.contains("-");
}

bool _isValidVisibleUser(User? user) {
  return _isValidVisibleUsername(user?.username);
}

class FeedIndex extends StatefulWidget {
  const FeedIndex({super.key});

  @override
  FeedIndexState createState() => FeedIndexState();
}

class FeedIndexState extends State<FeedIndex> with TickerProviderStateMixin {
  late TabController tabController;
  late FeedProviderV2 feedProvider;
  late ProfileProvider profileProvider;

  late ScrollController sc;

  final Map<int, bool> videoStates = {};

  void playVideo(int index) {
    setState(() {
      videoStates[index] = true;
    });
  }

  void pauseVideo(int index) {
    setState(() {
      videoStates[index] = false;
    });
  }

  void onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction <= 0.5) {
      setState(() {
        for (var key in videoStates.keys) {
          videoStates[key] = false;
        }
      });
    }
  }

  bool isPlaying = false;
  bool deletePostBtn = false;

  List<UserLikes> visibleLikes(Forum forum) {
    return (forum.like?.likes ?? []).where((like) => _isValidVisibleUser(like.user)).toList();
  }

  List<CommentElement> visibleComments(Forum forum) {
    return (forum.comment?.comments ?? [])
        .where((comment) => _isValidVisibleUser(comment.user))
        .toList();
  }

  Future<void> getData() async {
    if (!mounted) return;
    await feedProvider.fetchFeedMostRecent(context);

    if (!mounted) return;
    await profileProvider.getUserProfile(context);
  }

  @override
  void initState() {
    super.initState();

    feedProvider = context.read<FeedProviderV2>();

    profileProvider = context.read<ProfileProvider>();

    tabController = TabController(length: 1, vsync: this, initialIndex: 0);

    sc = ScrollController();

    Future.microtask(() => getData());
  }

  @override
  void dispose() {
    tabController.dispose();
    sc.dispose();

    super.dispose();
  }

  Widget tabSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: TabBar(
        controller: tabController,
        unselectedLabelColor: ColorResources.primaryOrange,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorResources.white,
        indicator: const BubbleTabIndicator(
          indicatorHeight: 30.0,
          indicatorRadius: 10.0,
          padding: EdgeInsets.zero,
          indicatorColor: ColorResources.primaryOrange,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        labelStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
        tabs: [Tab(text: getTranslated("LATEST", context))],
      ),
    );
  }

  Widget tabbarviewsection(BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: tabController,
      children: [
        Consumer<FeedProviderV2>(
          builder: (BuildContext context, FeedProviderV2 feedProvider, Widget? child) {
            if (feedProvider.feedRecentStatus == FeedRecentStatus.loading) {
              return const Center(
                child: SpinKitThreeBounce(size: 20.0, color: ColorResources.primaryOrange),
              );
            }

            if (feedProvider.feedRecentStatus == FeedRecentStatus.empty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_POST", context), style: robotoRegular),
              );
            }

            if (feedProvider.feedRecentStatus == FeedRecentStatus.error) {
              return Center(
                child: Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
              );
            }

            final visibleForums = feedProvider.forum1
                .where((forum) => _isValidVisibleUser(forum.user))
                .toList();

            if (visibleForums.isEmpty) {
              return Center(
                child: Text(getTranslated("THERE_IS_NO_POST", context), style: robotoRegular),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    if (feedProvider.hasMore) {
                      feedProvider.loadMoreRecent(context: context);
                    }
                  }
                }

                return false;
              },
              child: RefreshIndicator.adaptive(
                onRefresh: () {
                  return Future.sync(() {
                    feedProvider.fetchFeedMostRecent(context);
                  });
                },
                child: ListView.separated(
                  key: const PageStorageKey<String>('feedRecentListView'),
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int i) {
                    return Container(color: Colors.blueGrey[50], height: 10.0);
                  },
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: visibleForums.length,
                  itemBuilder: (BuildContext content, int i) {
                    if (visibleForums.length == i) {
                      return const Center(
                        child: SpinKitThreeBounce(size: 20.0, color: ColorResources.primaryOrange),
                      );
                    }

                    Forum forum = visibleForums[i];

                    if (!_isValidVisibleUser(forum.user)) {
                      return const SizedBox.shrink();
                    }

                    final isPlaying = videoStates[i] ?? false;
                    final currentUserId = feedProvider.ar.getUserId();

                    final filteredLikes = visibleLikes(forum);
                    final filteredComments = visibleComments(forum);

                    final isLiked = filteredLikes.any((el) => el.user?.id == currentUserId);

                    final lastComment = filteredComments.isNotEmpty ? filteredComments.last : null;

                    return InkWell(
                      onTap: () async {
                        NS
                            .push(
                              context,
                              PostDetailScreen(
                                from: "index",
                                data: {
                                  "forum_id": forum.id,
                                  "comment_id": "",
                                  "reply_id": "",
                                  "from": "click",
                                },
                              ),
                            )
                            .then((value) {
                              setState(() {
                                for (var key in videoStates.keys) {
                                  videoStates[key] = false;
                                }
                              });
                            });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            dense: true,
                            leading: CachedNetworkImage(
                              imageUrl: forum.user?.avatar ?? "",
                              imageBuilder: (BuildContext context, dynamic imageProvider) =>
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: imageProvider,
                                    radius: 20.0,
                                  ),
                              placeholder: (BuildContext context, String url) => const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                radius: 20.0,
                              ),
                              errorWidget: (BuildContext context, String url, dynamic error) =>
                                  const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                    radius: 20.0,
                                  ),
                            ),
                            title: Text(
                              forum.user?.username ?? "",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                            subtitle: Text(
                              DateHelper.formatDateTime(forum.createdAt ?? "", context),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: ColorResources.dimGrey,
                              ),
                            ),
                            trailing: feedProvider.ar.getUserId() == forum.user?.id
                                ? grantedDeletePost(context, forum.id)
                                : PopupMenuButton(
                                    itemBuilder: (BuildContext buildContext) {
                                      return forum.type == "video"
                                          ? [
                                              PopupMenuItem(
                                                value: "/download-video",
                                                child: Text(
                                                  "Download Video",
                                                  style: robotoRegular.copyWith(
                                                    color: Colors.blue,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: "/report-user",
                                                child: Text(
                                                  "Block content",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.error,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: "/report-user",
                                                child: Text(
                                                  "Block user",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.error,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: "/report-user",
                                                child: Text(
                                                  "It's spam",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.error,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: "/report-user",
                                                child: Text(
                                                  "Nudity or sexual activity",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.error,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: "/report-user",
                                                child: Text(
                                                  "False Information",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.error,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                            ]
                                          : [
                                              PopupMenuItem(
                                                value: "/report-user",
                                                child: Text(
                                                  "Block content",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.error,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: "/report-user",
                                                child: Text(
                                                  "Block user",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.error,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: "/report-user",
                                                child: Text(
                                                  "It's spam",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.error,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: "/report-user",
                                                child: Text(
                                                  "Nudity or sexual activity",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.error,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: "/report-user",
                                                child: Text(
                                                  "False Information",
                                                  style: robotoRegular.copyWith(
                                                    color: ColorResources.error,
                                                    fontSize: Dimensions.fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                            ];
                                    },
                                    onSelected: (route) async {
                                      if (route == "/download-video") {
                                        ProgressDialog pr = ProgressDialog(context: context);

                                        try {
                                          pr.show(
                                            max: 1,
                                            msg: '${getTranslated("DOWNLOADING", context)}...',
                                          );

                                          // await GallerySaver.saveVideo("${forum.media![0].path}");

                                          pr.close();

                                          ShowSnackbar.snackbar(
                                            getTranslated("SAVE_TO_GALLERY", context),
                                            "",
                                            ColorResources.success,
                                          );
                                        } catch (_) {
                                          pr.close();

                                          ShowSnackbar.snackbar(
                                            getTranslated("THERE_WAS_PROBLEM", context),
                                            "",
                                            ColorResources.error,
                                          );
                                        }
                                      }

                                      if (route == "/report-user") {
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
                                                  right: 16.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(height: 10.0),
                                                    const Icon(
                                                      Icons.delete,
                                                      color: ColorResources.black,
                                                    ),
                                                    const SizedBox(height: 10.0),
                                                    Text(
                                                      getTranslated("ARE_YOU_SURE_REPORT", context),
                                                      style: robotoRegular.copyWith(
                                                        fontSize: Dimensions.fontSizeSmall,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () =>
                                                              Navigator.of(context).pop(),
                                                          child: Text(
                                                            getTranslated("NO", context),
                                                            style: robotoRegular.copyWith(
                                                              fontSize: Dimensions.fontSizeSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        StatefulBuilder(
                                                          builder:
                                                              (BuildContext context, Function s) {
                                                                return ElevatedButton(
                                                                  style: ButtonStyle(
                                                                    backgroundColor:
                                                                        WidgetStateProperty.all(
                                                                          ColorResources.error,
                                                                        ),
                                                                  ),
                                                                  onPressed: () async {
                                                                    Navigator.of(
                                                                      context,
                                                                      rootNavigator: true,
                                                                    ).pop();
                                                                  },
                                                                  child: Text(
                                                                    getTranslated("YES", context),
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize:
                                                                          Dimensions.fontSizeSmall,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                              left: 15.0,
                              right: 15.0,
                            ),
                            child: PostText(forum.caption ?? ""),
                          ),
                          if (forum.type == "link") PostLink(url: forum.link ?? ""),
                          if (forum.type == "document") PostDoc(medias: forum.media ?? []),
                          if (forum.type == "image")
                            PostImage(
                              forum.user?.username ?? "",
                              forum.caption ?? "",
                              false,
                              forum.media ?? [],
                            ),
                          if (forum.type == "video" && (forum.media ?? []).isNotEmpty)
                            VisibilityDetector(
                              key: Key('video-widget-${forum.id ?? i}'),
                              onVisibilityChanged: onVisibilityChanged,
                              child: PostVideo(
                                media: forum.media!.first.path ?? "",
                                isPlaying: isPlaying,
                                onPlay: () => playVideo(i),
                                onPause: () => pauseVideo(i),
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                              left: 15.0,
                              right: 15.0,
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
                                            decoration: const BoxDecoration(color: Colors.white),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount: filteredLikes.length,
                                                  itemBuilder: (_, int likeIndex) {
                                                    final like = filteredLikes[likeIndex];

                                                    return Padding(
                                                      padding: const EdgeInsets.all(20.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl: like.user?.avatar ?? "",
                                                                imageBuilder:
                                                                    (context, imageProvider) {
                                                                      return CircleAvatar(
                                                                        maxRadius: 25.0,
                                                                        backgroundImage:
                                                                            imageProvider,
                                                                      );
                                                                    },
                                                                placeholder: (context, url) {
                                                                  return const CircleAvatar(
                                                                    maxRadius: 25.0,
                                                                    backgroundImage: AssetImage(
                                                                      'assets/images/default_avatar.jpg',
                                                                    ),
                                                                  );
                                                                },
                                                                errorWidget: (context, url, error) {
                                                                  return const CircleAvatar(
                                                                    maxRadius: 25.0,
                                                                    backgroundImage: AssetImage(
                                                                      'assets/images/default_avatar.jpg',
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              const SizedBox(width: 14.0),
                                                              Text(
                                                                like.user?.username ?? "",
                                                                style: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 18.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
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
                                          child: const Icon(
                                            Icons.thumb_up,
                                            size: 18.0,
                                            color: ColorResources.black,
                                          ),
                                        ),
                                        Text(
                                          '${filteredLikes.length}',
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black,
                                            fontSize: Dimensions.fontSizeDefault,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  '${filteredComments.length} ${getTranslated("COMMENT", context)}',
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 15.0,
                              left: 15.0,
                              right: 15.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isLiked ? ColorResources.error : null,
                                    ),
                                    onPressed: () {
                                      context.read<FeedProviderV2>().toggleLike(
                                        context: context,
                                        forumId: forum.id ?? "",
                                        feedLikes: forum.like!,
                                      );
                                    },
                                    child: Text(
                                      getTranslated("LIKE", context),
                                      style: TextStyle(
                                        color: isLiked
                                            ? ColorResources.white
                                            : ColorResources.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimensions.fontSizeDefault,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      NS
                                          .push(
                                            context,
                                            PostDetailScreen(
                                              from: "index",
                                              data: {
                                                "forum_id": forum.id,
                                                "comment_id": "",
                                                "reply_id": "",
                                                "from": "click",
                                              },
                                            ),
                                          )
                                          .then((_) {
                                            context.read<FeedProviderV2>().fetchFeedMostRecent(
                                              context,
                                            );
                                          });
                                    },
                                    child: Text(
                                      getTranslated("COMMENT", context),
                                      style: const TextStyle(
                                        color: ColorResources.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimensions.fontSizeDefault,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          lastComment == null
                              ? const SizedBox()
                              : Container(
                                  margin: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 15.0,
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: CachedNetworkImage(
                                          imageUrl: lastComment.user?.avatar ?? "",
                                          imageBuilder:
                                              (BuildContext context, dynamic imageProvider) =>
                                                  CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    backgroundImage: imageProvider,
                                                    radius: 20.0,
                                                  ),
                                          placeholder: (BuildContext context, String url) =>
                                              const CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                backgroundImage: AssetImage(
                                                  'assets/images/default_avatar.jpg',
                                                ),
                                                radius: 20.0,
                                              ),
                                          errorWidget:
                                              (BuildContext context, String url, dynamic error) =>
                                                  const CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    backgroundImage: AssetImage(
                                                      'assets/images/default_avatar.jpg',
                                                    ),
                                                    radius: 20.0,
                                                  ),
                                        ),
                                        title: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: const BoxDecoration(
                                            color: ColorResources.blueGrey,
                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                lastComment.user?.username ?? "",
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeDefault,
                                                ),
                                              ),
                                              Text(
                                                DateHelper.formatDateTime(
                                                  lastComment.createdAt ?? "",
                                                  context,
                                                ),
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeExtraSmall,
                                                  color: ColorResources.dimGrey,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  DetectableText(
                                                    text: lastComment.comment ?? "",
                                                    detectionRegExp: atSignRegExp,
                                                    detectedStyle: robotoRegular.copyWith(
                                                      color: Colors.blue,
                                                    ),
                                                    basicStyle: robotoRegular,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        trailing: currentUserId == lastComment.user?.id.toString()
                                            ? grantedDeleteComment(
                                                context,
                                                lastComment.id.toString(),
                                                forum.id.toString(),
                                              )
                                            : TermsPopup(),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),

                      // FOR TEMPRORARY
                      // Posts(
                      //   forum: feedProvider.forum1[i],
                      // ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget grantedDeletePost(context, forumId) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) {
        return [
          PopupMenuItem(
            value: "/delete-post",
            child: Text(
              getTranslated("DELETE_POST", context),
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),
          ),
        ];
      },
      onSelected: (route) {
        if (route == "/delete-post") {
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
                      const Icon(Icons.delete, color: ColorResources.error),
                      const SizedBox(height: 10.0),
                      Text(
                        getTranslated("DELETE_POST", context),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              getTranslated("NO", context),
                              style: robotoRegular.copyWith(
                                color: Colors.black,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                          ),
                          StatefulBuilder(
                            builder: (BuildContext context, Function setStatefulBuilder) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorResources.error,
                                ),
                                onPressed: () async {
                                  setStatefulBuilder(() => deletePostBtn = true);

                                  try {
                                    await context.read<FeedProviderV2>().deletePost(
                                      context,
                                      forumId,
                                      "index",
                                    );

                                    setStatefulBuilder(() => deletePostBtn = false);
                                  } catch (e) {
                                    setStatefulBuilder(() => deletePostBtn = false);
                                    debugPrint(e.toString());
                                  }
                                },
                                child: deletePostBtn
                                    ? const Loader(color: ColorResources.white)
                                    : Text(
                                        getTranslated("YES", context),
                                        style: robotoRegular.copyWith(
                                          color: Colors.white,
                                          fontSize: Dimensions.fontSizeSmall,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget grantedDeleteComment(context, String commentId, String forumId) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) {
        return [
          PopupMenuItem(
            value: "/delete-comment",
            child: Text(
              getTranslated("DELETE_COMMENT", context),
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),
          ),
        ];
      },
      onSelected: (route) {
        if (route == "/delete-comment") {
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
                      const Icon(Icons.delete, color: ColorResources.error),
                      const SizedBox(height: 10.0),
                      Text(
                        getTranslated("DELETE_COMMENT", context),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(getTranslated("NO", context), style: robotoRegular),
                          ),
                          StatefulBuilder(
                            builder: (BuildContext context, Function setStateBuilder) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorResources.error,
                                ),
                                onPressed: () async {
                                  setStateBuilder(() => deletePostBtn = true);

                                  await context.read<FeedDetailProviderV2>().deleteComment(
                                    context: context,
                                    forumId: forumId,
                                    commentId: commentId,
                                  );

                                  await context.read<FeedProviderV2>().fetchFeedMostRecent(context);

                                  setStateBuilder(() => deletePostBtn = false);
                                },
                                child: deletePostBtn
                                    ? const Loader(color: ColorResources.white)
                                    : Text(
                                        getTranslated("YES", context),
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        setState(() {
          for (var key in videoStates.keys) {
            videoStates[key] = false;
          }
        });

        if (sc.position.pixels == 0.0) {
          NS.push(context, DashboardScreen());
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            sc.animateTo(
              sc.position.minScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          });
        }
      },
      child: Scaffold(
        body: NestedScrollView(
          controller: sc,
          physics: const ScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return [
              SliverAppBar(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: ColorResources.white,
                automaticallyImplyLeading: false,
                toolbarHeight: 150.0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo/logo.png', width: 70.0),
                    const SizedBox(height: 8.0),
                    Text(
                      'Forum',
                      style: robotoRegular.copyWith(
                        color: ColorResources.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.fontSizeOverLarge,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      "Saka Dirgantara",
                      style: TextStyle(
                        color: ColorResources.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ],
                ),
                leading: BackButton(
                  color: ColorResources.black,
                  onPressed: () {
                    setState(() {
                      for (var key in videoStates.keys) {
                        videoStates[key] = false;
                      }
                    });

                    if (sc.position.pixels == 0.0) {
                      NS.push(context, DashboardScreen());
                    } else {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        sc.animateTo(
                          sc.position.minScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      });
                    }
                  },
                ),
                elevation: 0.0,
                forceElevated: true,
                pinned: false,
                centerTitle: true,
                floating: true,
              ),
              const InputPostWidget(),
            ];
          },
          body: tabbarviewsection(context),
        ),
      ),
    );
  }
}
