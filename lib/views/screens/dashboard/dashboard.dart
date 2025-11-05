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
import 'package:saka/views/screens/media/media.dart';

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
  
  List<Widget> widgetOptions = [
    HomeScreen(),
    EventScreen(),
    InboxScreen(),
    MediaScreen()
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
            fontWeight: FontWeight.bold
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
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(getTranslated("YES", context),
              style: robotoRegular.copyWith(
                color: ColorResources.primaryOrange, 
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.bold
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
    return Scaffold(
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
              margin: EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/imagesv2/svg/home.svg',
                    width: 25.0,
                    height: 25.0,
                    color: selectedIndex == 0 ? ColorResources.primaryOrange : ColorResources.white,
                  ),
                  const SizedBox(height: 8.0),
                  Text("Beranda",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.white
                    ),
                  )
                ],
              ) 
            ),
            label: "Home"
          ),
          BottomNavigationBarItem(
            tooltip: "Event",
            icon:  Container(
              margin: EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/imagesv2/svg/calendar.svg',
                    width: 25.0,
                    height: 25.0,
                    color: selectedIndex == 1 ? ColorResources.primaryOrange : ColorResources.white,
                  ),
                  const SizedBox(height: 8.0),
                  Text("Kegiatan",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.white
                    ),
                  )
                ],
              ) 
            ),
            label: "Kegiatan"
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/imagesv2/svg/inbox.svg',
                          width: 25.0,
                          height: 25.0,
                          color: selectedIndex == 2 ? ColorResources.primaryOrange : ColorResources.white,
                        ),
                        const SizedBox(height: 8.0),
                        Text("Pesan",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.white
                          ),
                        )
                      ],
                    ) 
                  );
                },
              ),
            ),
            label: "Pesan"
          ),
          BottomNavigationBarItem(
            tooltip: "Media",
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/media.png',
                  width: 25.0,
                  height: 25.0,
                  color: selectedIndex == 3 ? ColorResources.primaryOrange : ColorResources.white,
                ),
                const SizedBox(height: 8.0),
                Text("Media",
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.bold,
                    color: ColorResources.white
                  ),
                )
              ],
            ),
            label: "Media"
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }

}
