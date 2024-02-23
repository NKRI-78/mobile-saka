import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/views/screens/dashboard/dashboard.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/data/models/feed/feedposttype.dart';
import 'package:saka/data/models/feed/groups.dart';

import 'package:saka/providers/feed/feed.dart';
import 'package:saka/providers/profile/profile.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/screens/feed/widgets/post_video.dart';
import 'package:saka/views/screens/feed/widgets/post_doc.dart';
import 'package:saka/views/screens/feed/widgets/post_img.dart';
import 'package:saka/views/screens/feed/widgets/post_link.dart';
import 'package:saka/views/screens/feed/widgets/post_text.dart';
import 'package:saka/views/screens/feed/post_detail.dart';

class Posts extends StatefulWidget {
  final int i;
  final List<GroupsBody> groupsBody;
   
  const Posts({Key? key, 
    required this.i,
    required this.groupsBody,
  }) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  bool deletePostBtn = false;

  @override 
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailScreen(
        postId: widget.groupsBody[widget.i].id!
      ))),
      child: Container(
        margin: const EdgeInsets.only(top: Dimensions.marginSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [ 
            ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage("${AppConstants.baseUrlImg}/${widget.groupsBody[widget.i].user!.profilePic!.path}"),
                radius: 20.0,
              ),
              title: Text(widget.groupsBody[widget.i].user!.nickname!,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: ColorResources.black
                ),
              ),
              subtitle: Text(timeago.format((DateTime.parse(widget.groupsBody[widget.i].created!).toLocal()), locale: 'id'),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: ColorResources.dimGrey
                ),
              ),
              trailing: context.read<ProfileProvider>().userProfile.userId == widget.groupsBody[widget.i].user!.userId! 
              ? grantedDeletePost(context) 
              : PopupMenuButton(
                  itemBuilder: (BuildContext buildContext) { 
                    return [
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
                  onSelected: (route) {
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

            const SizedBox(height: 5.0),
            
            if(widget.groupsBody[widget.i].postType == PostType.text) 
              PostText(widget.groupsBody[widget.i].content),
            if(widget.groupsBody[widget.i].postType == PostType.link)
              PostLink(url: widget.groupsBody[widget.i].content!.url, caption: widget.groupsBody[widget.i].content!.caption!),
            if(widget.groupsBody[widget.i].postType == PostType.document)
              PostDoc(
                medias: widget.groupsBody[widget.i].content!.medias!, 
                caption: widget.groupsBody[widget.i].content!.caption!
              ),
            if(widget.groupsBody[widget.i].postType == PostType.image)
              PostImage(
                false,
                widget.groupsBody[widget.i].content!.medias!, 
                widget.groupsBody[widget.i].content!.caption!
              ),
            if(widget.groupsBody[widget.i].postType == PostType.video)
              PostVideo(
                media: widget.groupsBody[widget.i].content!.medias![0],
                caption: widget.groupsBody[widget.i].content!.caption!,
              ),
          
            Container(
              margin: const EdgeInsets.only(
                top: Dimensions.marginSizeExtraSmall, 
                bottom: Dimensions.marginSizeDefault, 
                left: Dimensions.marginSizeDefault, 
                right: Dimensions.marginSizeDefault
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.groupsBody[widget.i].numOfLikes.toString(), 
                          style: robotoRegular.copyWith(
                            color: ColorResources.black,
                            fontSize: Dimensions.fontSizeSmall
                          )
                        ),
                        InkWell(
                          onTap: () => context.read<FeedProvider>().like(context, widget.groupsBody[widget.i].id!, "POST"),
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.thumb_up,
                              size: 16.0,
                              color: widget.groupsBody[widget.i].liked!.isNotEmpty 
                              ? ColorResources.blue 
                              : ColorResources.black
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text('${widget.groupsBody[widget.i].numOfComments.toString()} ${getTranslated("COMMENT", context)}',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall
                    ),
                  )
                ]
              )
            ), 
            
        ],
      ),
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
                                                          await context.read<FeedProvider>().deletePost(context, widget.groupsBody[widget.i].id!);               
                                                          setState(() => deletePostBtn = false);
                                                          NS.push(context, DashboardScreen());            
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
} 