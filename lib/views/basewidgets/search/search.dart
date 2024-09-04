import 'package:flutter/material.dart';

import 'package:saka/utils/box_shadow.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

class SearchWidget extends StatelessWidget {
  final String? hintText;
  final String? type;
  const SearchWidget({Key? key, 
    this.hintText,
    this.type
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
      
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black26,
          boxShadow: boxShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Icons.search,
                    size: 20.0,
                    color: ColorResources.white,
                  ),
                  const SizedBox(width: 10.0),
                  Text(hintText!, 
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: ColorResources.white 
                    ),
                    overflow: TextOverflow.ellipsis
                  )
                ],
              ) 
            ),
          ], 
        ),
      ),
    );

  }
}
