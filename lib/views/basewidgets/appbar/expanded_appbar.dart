import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class CustomExpandedAppBar extends StatelessWidget {
  final String? title;
  final Widget? child;
  final Widget? bottomChild;
  final bool isGuestCheck;
  const CustomExpandedAppBar({Key? key, 
    required this.title, 
    required this.child, 
    this.bottomChild, 
    this.isGuestCheck = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        floatingActionButton: bottomChild,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            
            Positioned(
              top: 50.0,
              left: Dimensions.marginSizeLarge,
              right: Dimensions.marginSizeLarge,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CupertinoNavigationBarBackButton(
                    color: ColorResources.greyDarkPrimary, 
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                  Text(title!, 
                    style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600, 
                    color: ColorResources.greyDarkPrimary
                  ), 
                    overflow: TextOverflow.ellipsis
                  ),
                ]
              ),
            ),
    
            Container(
              margin: const EdgeInsets.only(top: 120.0),
              decoration: const BoxDecoration(
                color: ColorResources.bgGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0), 
                  topRight: Radius.circular(20.0)
                ),
              ),
              child: child,
            ),
            
          ]
        ),
      ),
    );
  }
}