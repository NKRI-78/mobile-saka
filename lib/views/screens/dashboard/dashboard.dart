import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:badges/badges.dart' as badges;

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/services/navigation.dart';

import 'package:saka/providers/inbox/inbox.dart';

import 'package:saka/utils/box_shadow.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/screens/membernear/membernear.dart';

import 'package:saka/views/screens/event/event.dart';
import 'package:saka/views/screens/inbox/inbox.dart';
import 'package:saka/views/screens/home/home.dart';
import 'package:saka/views/screens/sos/sos.dart';

class DashboardScreen extends StatefulWidget {

  DashboardScreen({
    Key? key 
  }) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin  {
  int selectedIndex = 0;
  
  List widgetOptions = [
    HomeScreen(),
    EventScreen(),
    InboxScreen(),
    MemberNearScreen()
  ];
  
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<bool> willPop() {
    showDialog(context: context,
      builder: (context) => AlertDialog(
        title: Text(getTranslated("EXIT_PAGE", context),
          style: robotoRegular.copyWith(
            color: ColorResources.primaryOrange, 
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w600
          ),
        ),
        content: Text(getTranslated("EXIT_PAGE_FROM_HOME", context),
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(getTranslated("NO", context),
              style: robotoRegular.copyWith(
                color: ColorResources.primaryOrange, 
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(getTranslated("YES", context),
              style: robotoRegular.copyWith(
                color: ColorResources.primaryOrange, 
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w600
              ),
            )
          ),
        ],
      ),
    );
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        body: widgetOptions.elementAt(selectedIndex),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: InkWell(
          onTap: () {
            NS.push(context, SosScreen());
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: boxShadow
            ),
            child: Image.asset('assets/imagesv2/sos.png',
              width: 65.0,
              height: 65.0,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorResources.brown,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              tooltip: "Home",
              icon: Container(
                margin: EdgeInsets.all(15.0),
                child: SvgPicture.asset('assets/imagesv2/svg/home.svg',
                  width: 25.0,
                  height: 25.0,
                  color: selectedIndex == 0 ? ColorResources.primaryOrange : ColorResources.white,
                ),
              ),
              label: ""
            ),
            BottomNavigationBarItem(
              tooltip: "Event",
              icon: Container(
                margin: EdgeInsets.only(right: 20.0),
                child: SvgPicture.asset('assets/imagesv2/svg/calendar.svg',
                  width: 25.0,
                  height: 25.0,
                  color: selectedIndex == 1 ? ColorResources.primaryOrange : ColorResources.white,
                ),
              ),
              label: ""
            ),
            BottomNavigationBarItem(
              tooltip: "Inbox",
              icon: Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Consumer<InboxProvider>(
                  builder: (BuildContext context, InboxProvider inboxProvider, Widget? child) {
                    return badges.Badge(
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: ColorResources.error,
                      ),
                      badgeAnimation: badges.BadgeAnimation.slide(
                        animationDuration: Duration(milliseconds: 300)
                      ),
                      position: badges.BadgePosition.topEnd(top: -5.0, end: -5.0),
                      badgeContent: Text(
                        inboxProvider.inboxStatus == InboxStatus.loading 
                        ? "..." 
                        : inboxProvider.inboxStatus == InboxStatus.error 
                        ? "..."
                        : inboxProvider.readCount.toString(),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: ColorResources.white
                        ),
                      ),
                      child: SvgPicture.asset('assets/imagesv2/svg/inbox.svg',
                        width: 25.0,
                        height: 25.0,
                        color: selectedIndex == 2 ? ColorResources.primaryOrange : ColorResources.bgGrey
                      ),
                    );
                  },
                ),
              ),
              label: ""
            ),
            BottomNavigationBarItem(
              tooltip: "Membernear",
              icon: Container(
                margin: EdgeInsets.all(15.0),
                child: SvgPicture.asset('assets/imagesv2/svg/nearmember.svg',
                  width: 30.0,
                  height: 30.0,
                  color: selectedIndex == 3 ? ColorResources.primaryOrange : ColorResources.bgGrey,
                ),
              ),
              label: ""
            ),
          ],
          currentIndex: selectedIndex,
          onTap: onItemTapped,
        ),
      ),
    );
    
  }
}
