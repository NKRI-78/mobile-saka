import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

class PDFScreen extends StatefulWidget {
  final String path;
  final String title;

  PDFScreen({
    Key? key, 
    required this.path,
    required this.title  
  }) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  Completer<PDFViewController> controller = Completer<PDFViewController>();

  int page = 0;
  int total = 0;
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        backgroundColor: ColorResources.brown,
        iconTheme: IconThemeData(
          color: ColorResources.white
        ),
        title: Text(widget.title,
          style: robotoRegular.copyWith(
            color: ColorResources.white
          ),
        ),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
        PDFView(
          filePath: widget.path,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          fitEachPage: true,
          pageFling: true,
          pageSnap: true,
          defaultPage: currentPage,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: false,
          onRender: (_pages) {
            setState(() {
              pages = _pages!;
              isReady = true;
            });
          },
          onError: (error) {
            setState(() {
              errorMessage = error.toString();
            });
          },
          onPageError: (page, error) {
            setState(() {
              errorMessage = '$page: ${error.toString()}';
            });
            debugPrint('$page: ${error.toString()}');
          },
          onViewCreated: (PDFViewController pdfViewController) {
            controller.complete(pdfViewController);
          },
          onLinkHandler: (String? uri) {
            debugPrint('goto uri: $uri');
          },
          onPageChanged: (int? _page, int? _total) {
            setState(() {
              page = _page! + 1; 
              total = _total!;
              currentPage = _page;
            });
          },
        ),
        errorMessage.isEmpty
        ? !isReady
          ? Center(
              child: Loader(
                color: ColorResources.brown,
              ),
            )
          : Container()
        : Center(
            child: Text(errorMessage),
          ),
        ],
      ),
    );
  }
}