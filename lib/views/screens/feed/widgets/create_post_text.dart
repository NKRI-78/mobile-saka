
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

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
  late FeedProviderV2 fdv2;
 
  @override 
  void initState() {
    super.initState();
    fdv2 = context.read<FeedProviderV2>();
    scrollController = ScrollController();
    fdv2.postC = TextEditingController();
  }

  @override 
  void dispose() {
    scrollController.dispose();
    fdv2.postC.dispose();
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
                    onPressed: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading ? () {} : () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading ? () {} : () async {
                              await fdv2.post(context, "text", []);   
                            },
                            child: Container(
                              width: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading ? null : 80.0,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: ColorResources.primaryOrange,
                                borderRadius: BorderRadius.circular(20.0)
                              ),
                              child: context.watch<FeedProviderV2>().writePostStatus == WritePostStatus.loading 
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
                    controller: fdv2.postC,
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