import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class PostText extends StatefulWidget {
  final dynamic text;

  const PostText(
    this.text, 
    {Key? key}
  ) : super(key: key);

  @override
  _PostTextState createState() => _PostTextState();
}

class _PostTextState extends State<PostText> {

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }
  
  Widget buildUI() {
    return Container(
      margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
      width: 250.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ReadMoreText(
            widget.text,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
            trimLines: 2,
            colorClickableText: ColorResources.black,
            trimMode: TrimMode.Line,
            trimCollapsedText: getTranslated("READ_MORE", context),
            trimExpandedText: getTranslated("LESS_MORE", context),
            moreStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall, 
              fontWeight: FontWeight.w600
            ),
            lessStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall, 
              fontWeight: FontWeight.w600
            ),
          ),
        ],
      ) 
    );
  }

}