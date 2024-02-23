import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/providers/feed/feed.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

class CreatePostText extends StatefulWidget {
  const CreatePostText({
    Key? key, 
  }) : super(key: key);

  @override
  _CreatePostTextState createState() => _CreatePostTextState();
}

class _CreatePostTextState extends State<CreatePostText> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late ScrollController scrollController;
  late TextEditingController captionC;
 
  @override 
  void initState() {
    super.initState();
    scrollController = ScrollController();
    captionC = TextEditingController();
  }

  @override 
  void dispose() {
    scrollController.dispose();
    captionC.dispose();
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
                  title: Text(getTranslated("CREATE_POST", context), 
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
                    onPressed: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? () {} : () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? () {} : () async {
                              String caption = captionC.text;
                              if(caption.trim().isEmpty) {
                                ShowSnackbar.snackbar(context, getTranslated("CAPTION_IS_REQUIRED", context), "", ColorResources.error);
                                return;
                              }
                              if(caption.trim().length > 1000) {
                                ShowSnackbar.snackbar(context, getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
                                return;
                              }
                              await context.read<FeedProvider>().sendPostText(context, caption);   
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
                )
              ];
            },  
            body: Container(
              margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    maxLines: null,
                    controller: captionC,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                    decoration: InputDecoration(
                      labelText: getTranslated("WRITE_POST", context),
                      labelStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Colors.grey
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey, 
                          width: 0.5
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey, 
                          width: 0.5
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        );
      },
    );
  }
}