// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/event/event.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/dio.dart';
import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/screens/dashboard/dashboard.dart';

class EventScannerJoinScreen extends StatefulWidget {
  const EventScannerJoinScreen({ super.key });

  @override
  State<EventScannerJoinScreen> createState() => EventScannerJoinScreenState();
}

class EventScannerJoinScreenState extends State<EventScannerJoinScreen> {
  GlobalKey<AnimatorWidgetState> basicAnimation = GlobalKey<AnimatorWidgetState>();

  @override 
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      basicAnimation.currentState!.animator!.loop(pingPong: true);

      if(mounted) {
        context.read<EventProvider>().checkEvent(context);
      }
    });
  }

  @override 
  void dispose() {
    basicAnimation.currentState!.animator!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/banner-event.png'),
                          fit: BoxFit.fitWidth  
                        )
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 15.0,
                      left: 15.0
                    ),
                    child: BackButton(
                      color: ColorResources.black,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Consumer<EventProvider>(
                  builder: (BuildContext context, EventProvider eventProvider, Widget? child) {
                    if(eventProvider.eventCheckStatus == EventCheckStatus.loading) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 200.0,
                            left: 80.0,
                            right: 80.0
                          ),
                          child: BounceIn(
                            key: basicAnimation,
                            child: CustomButton(
                              isBorderRadius: true,
                              isBorder: false,
                              isBoxShadow: true,
                              btnColor: ColorResources.primaryOrange,
                              onTap: () {}, 
                              btnTxt: "..."
                            ),
                          )
                        ),
                      );
                    }
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 200.0,
                          left: 80.0,
                          right: 80.0
                        ),
                        child: BounceIn(
                          key: basicAnimation,
                          child: CustomButton(
                            isBorderRadius: true,
                            isBorder: false,
                            isBoxShadow: true,
                            btnColor: ColorResources.primaryOrange,
                            onTap: () {
                              if(eventProvider.checkEventExist) {
                                ShowSnackbar.snackbar("Anda sudah terdaftar di Event Jambore Nasional XI", "", ColorResources.error);
                                return false;
                              } else {
                                NS.push(context, QRViewScreen(
                                  title: "${getTranslated("EVENT", context)} - Saka Dirgantara",
                                ));
                              }
                            }, 
                            btnTxt: "Klik Disini"
                          ),
                        )
                      ),
                    );
                  },
                ),
              ],
            );    
          },
        ) 
      ) 
    );
  }

}

class QRViewScreen extends StatefulWidget {
  final String? title;
  
  const QRViewScreen({
    super.key, 
    this.title
  });

  @override
  State<StatefulWidget> createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> globalKey2 = GlobalKey<ScaffoldState>();

  Barcode? result;
  QRViewController? qrC;
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  
  @override 
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      qrC!.pauseCamera();
    }
    qrC!.resumeCamera();
  }

  @override
  void dispose() {
    qrC?.dispose();

    super.dispose();
  }

  Future<void> checkEvent(BuildContext context) async {
    try { 
      Dio dio = DioManager.shared.getClient();
      await dio.post("${AppConstants.baseUrl}/content-service/scanner-joins/joining");
      ShowSnackbar.snackbar("Terima kasih sudah berpartisipasi!", "", ColorResources.success);
      NS.pushReplacement(context, DashboardScreen());
    } on DioException catch(e) {
      debugPrint(e.error.toString());
      if(e.response!.statusCode == 400) {
        ShowSnackbar.snackbar("${json.decode(e.response!.data)["error"]}", "", ColorResources.error);
        NS.pushReplacement(context, DashboardScreen());
      } 
      NS.pushReplacement(context, DashboardScreen());
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      NS.pushReplacement(context, DashboardScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Column(
        children: [
          Expanded(
            flex: 4, 
            child: buildQrView(
              context, 
              title: widget.title!
            )
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (result != null)
                  FutureBuilder(
                    future: checkEvent(context),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryOrange),
                          ),
                        );
                      }
                      if(snapshot.hasError) {
                        return Center(
                          child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.bold,
                              color: ColorResources.error
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                if(result == null)
                  Text('Scan a code',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

 

  Widget buildQrView(BuildContext context, {required String title}) {
    double scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    return Scaffold(
      key: globalKey2,
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: ColorResources.white,
        title: Text(title,
          style: robotoRegular.copyWith(
            color: ColorResources.black,
            fontSize: Dimensions.fontSizeDefault
          )
        ),
        leading: BackButton(
          color: ColorResources.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red[200]!,
          borderRadius: 10.0,
          borderLength: 20,
          borderWidth: 10.0,
          cutOutSize: scanArea
        ),
        onPermissionSet: (QRViewController qrV, bool p) => onPermissionSet(context, qrV, p),
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() => qrC = controller);
    controller.scannedDataStream.listen((scanData) {
      if(scanData.code!.isNotEmpty) {
        controller.pauseCamera();
      }
      setState(() {
        result = scanData;
      });
    });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) async {
    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    } 
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('no Permission',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault
            ),
          )
        ),
      );
    }
  }
}