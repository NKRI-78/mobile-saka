import 'package:flutter/material.dart';
import 'package:saka/utils/color_resources.dart';

class Loader extends StatelessWidget {
  final Color? color;
  const Loader({Key? key, 
    this.color
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 16.0,
        height: 16.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? ColorResources.white),
        ),
      ),
    );
  }
}
