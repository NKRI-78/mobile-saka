import 'package:flutter/material.dart';

import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';

class ComingSoonScreen extends StatefulWidget {
  final String title;

  const ComingSoonScreen({ 
    required this.title,
    Key? key 
  }) : super(key: key);

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return buildUI();
  } 

  Widget buildUI() {
    return Scaffold(
      key: globalKey,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomAppBar(title: widget.title),
          Center(
            child: Image.asset("assets/images/maintenance.png")
          )
        ],
      ) 
    );
  }
}