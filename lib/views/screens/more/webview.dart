// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
// import 'package:saka/views/basewidgets/loader/square.dart';

// import 'package:saka/utils/color_resources.dart';
// import 'package:saka/utils/constant.dart';

// class WebViewScreen extends StatefulWidget {
//   final String title;
//   final String url;
//   WebViewScreen({required this.url, required this.title});

//   @override
//   _WebViewScreenState createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   final Completer<WebViewController> controller = Completer<WebViewController>();
//   WebViewController? controllerGlobal;
//   bool isLoading = true;

//   launchURL(url) async {
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: exitApp,
//       child: Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [

//               CustomAppBar(title: widget.title),

//               Expanded(
//                 child: Stack(
//                   children: [
//                     WebView(
//                       javascriptMode: JavascriptMode.unrestricted,
//                       initialUrl: widget.url,
//                       userAgent: AppConstants.mobileUa,
//                       gestureNavigationEnabled: true,
//                       onWebViewCreated: (WebViewController webViewController) {
//                         controller.future.then((value) => controllerGlobal = value);
//                         controller.complete(webViewController);
//                       },
//                       navigationDelegate: (NavigationRequest request) {             
//                         if (request.url.contains('tel:')) {
//                           launchURL(Uri.parse(request.url));
//                           return NavigationDecision.prevent;
//                         } else if(request.url.contains('whatsapp:')) {
//                           launchURL(request.url);
//                           return NavigationDecision.prevent; 
//                         } else if(request.url.contains('mailto:')) {
//                           launchURL(Uri.parse(request.url));
//                           return NavigationDecision.prevent; 
//                         }
//                         return NavigationDecision.navigate;
//                       },
//                       onPageStarted: (String url) async {
//                         setState(() => isLoading = true);
//                       },
//                       onPageFinished: (String url) {
//                         setState(() => isLoading = false);
//                       },
//                     ),
//                     isLoading ? Center(
//                       child: SquareLoader(
//                         color: ColorResources.brown
//                       ),
//                     ) : SizedBox.shrink(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<bool> exitApp() async {
//     if(controllerGlobal != null) {
//       if (await controllerGlobal!.canGoBack()) {
//         controllerGlobal!.goBack();
//         return Future.value(false);
//       } else {
//         return Future.value(true);
//       }
//     } else {
//       return Future.value(true);
//     }
//   }
// }

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;
  const WebViewScreen({Key? key, 
    required this.url, 
    required this.title
  }) : super(key: key);

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  late WebViewController webViewController;
  bool isLoading = true;

  Future<void> launchURL(String url) async {
    Uri u = Uri.parse(url);
    if (await canLaunchUrl(u)) {
      await launchUrl(u);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

    webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {

        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) async {
          if(request.url.contains('tel:')) {
            await launchURL(request.url);
            return NavigationDecision.prevent;
          } else if(request.url.contains('whatsapp:')) {
            await launchURL(request.url);
            return NavigationDecision.prevent; 
          } else if(request.url.contains('mailto:')) {
            await launchURL('mailto:customcare@inovasi78.com');
            return NavigationDecision.navigate;
          }
          return NavigationDecision.navigate;
        },
      ),
    )..loadRequest(Uri.parse(widget.url));
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        backgroundColor: ColorResources.brown,
        centerTitle: true,
        elevation: 0.0,
        title: Text(widget.title, 
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w600,
            color: ColorResources.white,
          ),
        ),
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.white,
          onPressed: () {
            NS.pop(context);
          },
        ),
      ),
      body: WebViewWidget(
        controller: webViewController
      )
      // SafeArea(
        // child: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [

            // CustomAppBar(title: widget.title),

            // Expanded(
            //   child: Stack(
            //     clipBehavior: Clip.none,
            //     children: [
                  // WebView(
                  //   javascriptMode: JavascriptMode.unrestricted,
                  //   initialUrl: widget.url,
                  //   userAgent: AppConstants.mobileUa,
                  //   gestureNavigationEnabled: true,
                  //   onWebViewCreated: (WebViewController webViewController) {
                  //     controller.future.then((value) => cg = value);
                  //     controller.complete(webViewController);
                  //   },
                  //   navigationDelegate: (NavigationRequest request) async {             
                  //     if (request.url.contains('tel:')) {
                  //       await launchURL(request.url);
                  //       return NavigationDecision.prevent;
                  //     } else if(request.url.contains('whatsapp:')) {
                  //       await launchURL(request.url);
                  //       return NavigationDecision.prevent; 
                  //     } else if(request.url.contains('mailto:')) {
                  //       await launchURL('mailto:customcare@inovasi78.com');
                  //       return NavigationDecision.prevent;
                  //     }
                  //     return NavigationDecision.navigate;
                  //   },
                  //   onPageStarted: (String url) async {
                  //     setState(() => isLoading = true);
                  //   },
                  //   onPageFinished: (String url) {
                  //     setState(() => isLoading = false);
                  //   },
                  // ),
                  // isLoading 
                  // ? Container()
                  // : const SizedBox.shrink(),

            //     ],
            //   ),
            // ),
          // ],
        // ),
      // ),
    );
  }

  // Future<bool> exitApp() async {
  //   if(cg != null) {
  //     if (await cg!.canGoBack()) {
  //       cg!.goBack();
  //       return Future.value(false);
  //     } else {
  //       return Future.value(true);
  //     }
  //   } else {
  //     return Future.value(true);
  //   }
  // }
}