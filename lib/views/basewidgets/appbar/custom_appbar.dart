import 'package:flutter/cupertino.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool isBackButtonExist;
  final IconData? icon;
  final Function? onPressed;

  const CustomAppBar({
    Key? key, 
    required this.title, 
    this.isBackButtonExist = true, 
    this.icon, 
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: 50.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorResources.brown,
            ColorResources.brown.withOpacity(0.6)
          ]
        )
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
        isBackButtonExist 
        ? Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 15.0),
            child: CupertinoNavigationBarBackButton(
            onPressed: () { 
              Navigator.of(context).pop(); 
            },
            color: ColorResources.white,
          )
        )
        : const SizedBox.shrink(),
        Center(
          child: Text(title,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault, 
              fontWeight: FontWeight.w600,
              color: ColorResources.white
            ),
          ),
        ),
      ]),
    );
  }
}
