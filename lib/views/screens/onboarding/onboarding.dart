import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/providers/onboarding/onboarding.dart';
import 'package:saka/providers/splash/splash.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/views/screens/auth/sign_in.dart';

class OnBoardingScreen extends StatefulWidget {
  final Color indicatorColor;
  final Color selectedIndicatorColor;

  OnBoardingScreen({
    this.indicatorColor = Colors.grey,
    this.selectedIndicatorColor = Colors.black,
  });

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  int selectedIndex = 0;

  late SplashProvider sp;
  late OnboardingProvider op;

  @override 
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if(mounted) {
        op.initBoardingList();
      } 
    }); 
  }

  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (BuildContext context) {
      
      op = context.read<OnboardingProvider>();
      sp = context.read<SplashProvider>();

      return Scaffold(
        backgroundColor: ColorResources.backgroundColor,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorResources.brown,
                  ColorResources.primaryOrange,
                ]
              )
            ),
            child: Consumer<OnboardingProvider>(
              builder: (BuildContext context, OnboardingProvider onboardingProvider, Widget? child) => Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      itemCount: onboardingProvider.onBoardingList.length,
                      controller: pageController,
                      itemBuilder: (BuildContext context, int i) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                if(i == 0)
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Image.asset('assets/imagesv2/onboarding/1.png',
                                        height: 450.0,
                                        fit: BoxFit.fill,
                                      )
                                    ),
                                  ),
                                if(i == 1)
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Image.asset('assets/imagesv2/onboarding/2.png',
                                        height: 450.0,
                                        fit: BoxFit.fill,
                                      )
                                    ),
                                  ),
                                if(i == 2)
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Image.asset('assets/imagesv2/onboarding/3.png',
                                        height: 450.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                if(i == 3)
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Image.asset('assets/imagesv2/onboarding/3.png',
                                        height: 250.0,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: Dimensions.marginSizeExtraLarge,
                                  right: Dimensions.marginSizeExtraLarge,
                                  bottom: Dimensions.marginSizeExtraLarge,
                                ),
                                padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
                                decoration: BoxDecoration(
                                  color: ColorResources.white, 
                                  borderRadius: BorderRadius.circular(12.0)
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                  if(i == 0)
                                    Text("Selamat Datang",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge, 
                                        color: ColorResources.dimGrey
                                      ),
                                    ),
                                    
                                  if(i == 1)
                                    Text("News & Event",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge, 
                                        color: ColorResources.redOnboarding
                                      ),
                                    ),
                                  if(i == 2)
                                    Text("SOS",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge, 
                                        color: ColorResources.redOnboarding
                                      ),
                                    ),
                                  if(i == 3)
                                    Text("Saka Mart",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge, 
                                        color: ColorResources.redOnboarding
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text("Di Aplikasi",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault, 
                                            color: ColorResources.dimGrey
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        Text("Saka",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault, 
                                            color: ColorResources.redOnboarding
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    Container(
                                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Text(
                                        onboardingProvider.onBoardingList[i].description,
                                        textAlign: TextAlign.center,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.dimGrey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimensions.marginSizeLarge,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: pageIndicators(onboardingProvider.onBoardingList),
                                      ),
                                    ),
                                    Container(
                                      height: 45.0,
                                      width: double.infinity,
                                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6.0),
                                        color: ColorResources.brown,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          if (selectedIndex == onboardingProvider.onBoardingList.length - 1) {
                                            sp.dispatchOnboarding(true);
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));
                                          } else {
                                            setState(() {
                                              pageController.jumpToPage(++selectedIndex);
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: Text(
                                            selectedIndex == onboardingProvider.onBoardingList.length - 1 ? getTranslated("GET_STARTED", context) : getTranslated("NEXT", context),
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.white, 
                                              fontSize: Dimensions.fontSizeDefault,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    selectedIndex == onboardingProvider.onBoardingList.length - 1 
                                    ? SizedBox(
                                      height: 10.0,
                                    ) 
                                    : TextButton(
                                      onPressed: () {
                                        sp.dispatchOnboarding(true);
                                         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));
                                      },
                                      child: Text(getTranslated("SKIP_FOR_NOW", context),
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.dimGrey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      onPageChanged: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      },
    );
  }

  List<Widget> pageIndicators(var onboardingList) {
    List<Container> indicators = [];
    for (int i = 0; i < onboardingList.length; i++) {
      indicators.add(Container(
        width: i == selectedIndex ? 18.0 : 7.0,
        height: 7.0,
        margin: EdgeInsets.only(right: 5.0),
        color: i == selectedIndex 
        ? ColorResources.brown 
        : ColorResources.grey
      ));
    }
    return indicators;
  }
}
