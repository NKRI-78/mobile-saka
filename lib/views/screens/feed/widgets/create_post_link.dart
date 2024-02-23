import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/providers/feed/feed.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

class CreatePostLink extends StatefulWidget {
  const CreatePostLink({
    Key? key, 
  }) : super(key: key);

  @override
  _CreatePostLinkState createState() => _CreatePostLinkState();
}

class _CreatePostLinkState extends State<CreatePostLink> {
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();
 
  late ScrollController scrollController;
  late TextEditingController captionC;
  late TextEditingController urlC;

  @override 
  void initState() {
    super.initState();
    scrollController = ScrollController();
    captionC = TextEditingController();
    urlC = TextEditingController();
  }

  @override 
  void dispose() {
    scrollController.dispose();
    captionC.dispose();
    urlC.dispose();
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    return buildUI(); 
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          key: globalKey,
          body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (BuildContext context, bool inner) {
              return [
                SliverAppBar(
                  backgroundColor: ColorResources.white,
                  title: Text('Share Media', 
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.black
                    )
                  ),
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: ColorResources.black,
                    ),
                    onPressed: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? () {} : () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? () {} : () async {
                              String caption = captionC.text;
                              String url = urlC.text;
                              if(caption.trim().isNotEmpty) {
                                if(caption.trim().length < 10) {
                                  ShowSnackbar.snackbar(context, getTranslated("CAPTION_MINIMUM", context), "", ColorResources.error);
                                  return;
                                }
                              } 
                              if(caption.trim().length > 1000) {
                                ShowSnackbar.snackbar(context, getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
                                return;
                              }
                              if(url.trim().isEmpty) {
                                ShowSnackbar.snackbar(context, getTranslated("URL_IS_REQUIRED", context), "", ColorResources.error);
                                return;
                              } 
                              bool validURL = Uri.parse(url.trim()).isAbsolute;
                              if(!validURL) {
                                ShowSnackbar.snackbar(context, getTranslated("URL_FORMAT", context), "", ColorResources.error);
                                return;
                              }
                              await context.read<FeedProvider>().sendPostLink(context, caption, url);  
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? null : 80.0,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: ColorResources.primaryOrange,
                                borderRadius: BorderRadius.circular(20.0)
                              ),
                              child: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
                              ? const Loader(
                                  color: ColorResources.white,
                                ) 
                              : Text('Post',
                                textAlign: TextAlign.center,
                                style: robotoRegular.copyWith(
                                  color: ColorResources.white
                                ),
                              ),
                            ),
                          )
                        ]
                      ),
                    )
                  ],
                  centerTitle: false,
                  floating: true, 
                )
              ];
            },  
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                  child: TextField(
                    maxLines: null,
                    controller: captionC,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                    decoration: InputDecoration(
                      labelText: "Caption",
                      labelStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Colors.grey
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      )
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                  child: TextField(
                    controller: urlC,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                    decoration: InputDecoration(
                      labelText: "http://example.com",
                      labelStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Colors.grey
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }

}


