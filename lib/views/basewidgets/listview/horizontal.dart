
import 'package:flutter/material.dart';

import 'package:saka/utils/border_radius.dart';
import 'package:saka/utils/box_shadow.dart';
import 'package:saka/utils/dimensions.dart';

class ListViewHorizontal extends StatelessWidget {
  const ListViewHorizontal({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              width: 150.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: boxShadow,
                borderRadius: borderRadius
              ),
              margin: const EdgeInsets.only(left: Dimensions.marginSizeLarge),
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            );
          },
        ),
      ),
    );
  }
}