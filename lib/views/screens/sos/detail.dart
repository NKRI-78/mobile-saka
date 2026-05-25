import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog_updated/flutter_animated_dialog.dart' as fad;
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/providers/sos/sos.dart';

import 'package:saka/utils/images.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/localization/language_constraints.dart';

class SosDetailScreen extends StatefulWidget {
  final String label;
  final String content;
  final String obj;

  const SosDetailScreen({super.key, required this.label, required this.content, required this.obj});

  @override
  State<SosDetailScreen> createState() => SosDetailScreenState();
}

class SosDetailScreenState extends State<SosDetailScreen> {
  bool _isAgreementDialogOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showAgreementDialog() async {
    if (_isAgreementDialogOpen) return;

    setState(() {
      _isAgreementDialogOpen = true;
    });

    bool isContinueClicked = false;

    await fad.showAnimatedDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext dialogContext, StateSetter setDialogState) {
            final SosStatus sosStatus = context.watch<SosProvider>().sosStatus;
            final bool isLoading = sosStatus == SosStatus.loading;
            final bool isContinueDisabled = isContinueClicked || isLoading;

            return Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: fad.CustomDialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                minWidth: 180.0,
                child: Transform.rotate(
                  angle: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: ColorResources.white, width: 1.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Transform.rotate(
                              angle: 56.5,
                              child: Container(
                                margin: const EdgeInsets.all(5.0),
                                height: 270.0,
                                decoration: BoxDecoration(
                                  color: ColorResources.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 25.0,
                                  right: 25.0,
                                  bottom: 10.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assets/imagesv2/ambulance.png",
                                      width: 50.0,
                                      height: 50.0,
                                    ),

                                    const SizedBox(height: 15.0),

                                    Text(
                                      getTranslated("AGREEMENT_SOS", context),
                                      textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ColorResources.black,
                                      ),
                                    ),

                                    const SizedBox(height: 8.0),

                                    Text(
                                      getTranslated("INFO_SOS", context),
                                      textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: ColorResources.black,
                                      ),
                                    ),

                                    const SizedBox(height: 15.0),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: IgnorePointer(
                                            ignoring: isContinueDisabled,
                                            child: Opacity(
                                              opacity: isContinueDisabled ? 0.5 : 1.0,
                                              child: CustomButton(
                                                isBorderRadius: true,
                                                isBoxShadow: true,
                                                fontSize: Dimensions.fontSizeSmall,
                                                btnColor: ColorResources.error,
                                                isBorder: false,
                                                onTap: () {
                                                  Navigator.of(dialogContext).pop();
                                                },
                                                btnTxt: getTranslated("CANCEL", context),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 8.0),

                                        Expanded(
                                          child: IgnorePointer(
                                            ignoring: isContinueDisabled,
                                            child: Opacity(
                                              opacity: isContinueDisabled ? 0.5 : 1.0,
                                              child: CustomButton(
                                                isBorderRadius: true,
                                                isBoxShadow: true,
                                                fontSize: Dimensions.fontSizeSmall,
                                                btnColor: ColorResources.success,
                                                onTap: () async {
                                                  if (isContinueClicked || isLoading) return;

                                                  setDialogState(() {
                                                    isContinueClicked = true;
                                                  });

                                                  await context.read<SosProvider>().sendSos(
                                                    context,
                                                    label: widget.label,
                                                    content: widget.content,
                                                    obj: widget.obj,
                                                  );
                                                },
                                                btnTxt: isContinueDisabled
                                                    ? "..."
                                                    : getTranslated("CONTINUE", context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (!mounted) return;

    setState(() {
      _isAgreementDialogOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back, color: ColorResources.white),
        ),
        backgroundColor: ColorResources.brown,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 160.0,
              color: ColorResources.brown,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 130.0),
            alignment: Alignment.center,
            child: ListView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.zero,
              children: [
                Center(
                  child: Text(
                    "SOS (${widget.label})",
                    style: robotoRegular.copyWith(
                      color: ColorResources.primaryOrange,
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  width: 80.0,
                  height: 80.0,
                  child: Image.asset(Images.sos_detail),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                  child: Text(
                    getTranslated(widget.content, context),
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: ConfirmationSlider(
                    foregroundColor: ColorResources.brown,
                    text: getTranslated("SLIDE_TO_CONFIRM", context),
                    onConfirmation: () async {
                      await _showAgreementDialog();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 140);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 140);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
