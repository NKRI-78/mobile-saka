import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class PostLink extends StatefulWidget {
  final String url;

  const PostLink({
    Key? key, 
    required this.url,
  }) : super(key: key);

  @override
  State<PostLink> createState() => _PostLinkState();
}

class _PostLinkState extends State<PostLink> {
  Map<String, PreviewData> datas = {};

  @override
  Widget build(BuildContext context) {
    return buildUI(); 
  } 
  
  Widget buildUI() {
    List<String?> urls =  [
      widget.url
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12.0),
        Container(
          margin: const EdgeInsets.only(
            left: Dimensions.marginSizeDefault, 
            right: Dimensions.marginSizeDefault
          ),
          child: LinkPreview(
            linkStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall
            ),
            textStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall
            ),
            padding: EdgeInsets.zero,
            enableAnimation: true,
            onPreviewDataFetched: (data) {
              setState(() {
                datas = {
                  ...datas,
                  urls[0]!: data,
                };
              });
            },
            previewData: datas[urls[0]],
            text: urls[0]!,
            width: MediaQuery.of(context).size.width,
          ),
        )

      ],
    );
  }
  
}