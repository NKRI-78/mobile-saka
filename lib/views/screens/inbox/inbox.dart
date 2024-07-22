import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/inbox/inbox.dart';
import 'package:saka/providers/profile/profile.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/images.dart';

import 'package:saka/views/screens/inbox/detail.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>  with TickerProviderStateMixin {
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  int tabbarview = 0;
  String tabbarname = "sos";
  late TabController tabController;

  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              backgroundColor: ColorResources.brown,
              title: Text(getTranslated("INBOX", context), 
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.white,
                )
              ),
              elevation: 0.0,
              pinned: false,
              centerTitle: true,
              floating: true,
              automaticallyImplyLeading: false,
            ),
            SliverToBoxAdapter(
              child: TabBar(
                onTap: (val) {
                  switch (val) {
                    case 0:
                      setState(() {
                        tabbarview = val;       
                        tabbarname = "sos";
                      });
                    break;
                    case 1:
                      setState(() {
                        tabbarview = val;       
                        tabbarname = "payment";
                      });
                    break;
                    case 2:
                      setState(() {
                        tabbarview = val;       
                        tabbarname = "other";
                      });
                    break;
                    default:
                  }
                },
                controller: tabController,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: ColorResources.white,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 32.0,
                  indicatorRadius: 6.0,
                  indicatorColor: ColorResources.brown,
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                labelStyle: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall
                ),
                tabs: [
                  Tab(text: "SOS"),
                  Tab(text: "Pembayaran"),
                  Tab(text: "Lainnya"),
                ]
              ),
            )
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            if(tabbarname == "sos")
              return getInbox(context, "sos");
            if(tabbarname == "payment")
              return getInbox(context, "payment");
            return getInbox(context, "other");
          },
        )
      )
    );
  }
  Widget tabSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: TabBar(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorResources.brown,
        indicator: BubbleTabIndicator(
          indicatorHeight: 32.0,
          indicatorRadius: 6.0,
          indicatorColor: ColorResources.brown,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        labelStyle: robotoRegular,
        tabs: [
          Tab(text: "SOS"),
          Tab(text: "Pembayaran"),
          Tab(text: "Lainnya"),
        ]
      ),
    );
  }  

  Widget getInbox(BuildContext context, String type) {
    
    Provider.of<InboxProvider>(context, listen: false).getInbox(context, type);

    return Consumer<InboxProvider>(
      builder: (BuildContext context, InboxProvider inboxProvider, Widget? child) {
        if(inboxProvider.inboxStatus == InboxStatus.loading) {
          return Loader(
            color: ColorResources.primaryOrange,
          );
        }
        if(inboxProvider.inboxStatus == InboxStatus.error) {
          return Center(
            child: Text(getTranslated("THERE_WAS_PROBLEM", context),
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault
              ),
            ),
          );
        }
        if(inboxProvider.inboxStatus == InboxStatus.empty) {
          return RefreshIndicator(
            backgroundColor: ColorResources.brown,
            color: ColorResources.white,
            onRefresh: () {
              return Future.sync(() {
                context.read<InboxProvider>().getInbox(context, type);
              });       
            },
            child: ListView(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Center(
                    child: Text(getTranslated("NO_INBOX_AVAILABLE", context),
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault
                      )
                    ),
                  ),
                ),
              ]
            ),
          );
        }
        return RefreshIndicator(
          backgroundColor: ColorResources.brown,
          color: ColorResources.white,
          onRefresh: () {
            return Future.sync(() {
              Provider.of<InboxProvider>(context, listen: false).getInbox(context, type);         
            }); 
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: inboxProvider.inboxes.length,
            itemBuilder: (BuildContext context, int i) {
              
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 0.0,
                  child: ListTile(
                    onTap: () async {
                      await Provider.of<InboxProvider>(context, listen: false).updateInbox(context, inboxProvider.inboxes[i].inboxId!, type);
                      if(inboxProvider.inboxes[i].subject == "Emergency") {
                        Provider.of<ProfileProvider>(context, listen: false).getSingleUser(context, inboxProvider.inboxes[i].senderId!);

                        showAnimatedDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                  
                            return Dialog(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Consumer<ProfileProvider>(
                                  builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        SizedBox(height: 20.0),

                                        Container(
                                          child: profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                          ? SizedBox(
                                              width: 18.0,
                                              height: 18.0,
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(ColorResources.white),
                                              ),
                                            )
                                          : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                          ? CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              backgroundImage: NetworkImage("assets/images/profile.png"),
                                              radius: 30.0,
                                            )
                                          : CachedNetworkImage(
                                            imageUrl: "${profileProvider.userProfile.profilePic}",
                                            imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                              return CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                backgroundImage: imageProvider,
                                                radius: 30.0,
                                              );
                                            },
                                            errorWidget: (BuildContext context, String url, dynamic error) {
                                              return CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                backgroundImage: AssetImage("assets/images/profile.png"),
                                                radius: 30.0,
                                              );
                                            },
                                            placeholder: (BuildContext context, String text) => SizedBox(
                                              width: 18.0,
                                              height: 18.0,
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(ColorResources.white)),
                                              ),
                                          ),
                                        ),

                                        SizedBox(height: 16.0),

                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                          child: Card(
                                            elevation: 3.0,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Text("Nama",
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault
                                                        )
                                                      ),
                                                      Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                      ? "..." 
                                                      : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                      ? "..." 
                                                      : profileProvider.singleUserData.fullname!,
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault
                                                        ),
                                                      )
                                                    ]
                                                  ),
                                                  SizedBox(height: 12.0),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Text("No HP",
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault
                                                        )
                                                      ),
                                                      Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                      ? "..." 
                                                      : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                      ? "..." 
                                                      : profileProvider.singleUserData.phoneNumber!,
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault
                                                        ),
                                                      )
                                                    ]
                                                  ),
                                                ],
                                              )
                                            ),
                                          ),
                                        ),

                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                          child: Card(
                                            elevation: 3.0,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [

                                                  Text(getTranslated("${inboxProvider.inboxes[i].body!.split('-')[0].toString()}", context) + " " + getTranslated("${inboxProvider.inboxes[i].body!.split('-')[1].toString()}", context),
                                                    textAlign: TextAlign.justify,
                                                    style: robotoRegular.copyWith(
                                                      height: 1.4,
                                                      fontSize: Dimensions.fontSizeDefault
                                                    ),
                                                  ),

                                                  SizedBox(height: 10.0),

                                                    Text(inboxProvider.inboxes[i].body!.split('-')[2].toString(),
                                                    textAlign: TextAlign.justify,
                                                    style: robotoRegular.copyWith(
                                                      height: 1.4,
                                                      fontSize: Dimensions.fontSizeDefault
                                                    ),
                                                  ),

                                                  SizedBox(height: 10.0),

                                                  FractionallySizedBox(
                                                    widthFactor: 1.0,
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          // ElevatedButton(
                                                          //   style: ElevatedButton.styleFrom(
                                                          //     elevation: 3.0,
                                                          //     backgroundColor: ColorResources.success
                                                          //   ),
                                                          //   onPressed: profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                          //   ? () {} 
                                                          //   : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                          //   ? () {}
                                                          //   : () async {
                                                          //     try {
                                                          //       await launchUrl(Uri.parse("whatsapp://send?phone=${profileProvider.getUserPhoneNumber}"));
                                                          //     } catch(e) {
                                                          //       print(e);
                                                          //     }
                                                          //   },
                                                          //   child: Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                          //     ? "..."
                                                          //     : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                          //     ? "..."
                                                          //     : "Whatsapp",
                                                          //     style: robotoRegular.copyWith(
                                                          //       color: ColorResources.white
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                          // ElevatedButton(
                                                          //   style: ElevatedButton.styleFrom(
                                                          //     elevation: 3.0,
                                                          //     backgroundColor: ColorResources.blue,
                                                          //   ),
                                                          //   onPressed: profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                          //   ? () {} 
                                                          //   : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                          //   ? () {}
                                                          //   : () async {
                                                          //     try {
                                                          //       await launchUrl(Uri.parse("tel:${profileProvider.getSingleUserPhoneNumber}"));
                                                          //     } catch(e) {
                                                          //       print(e);
                                                          //     }
                                                          //   },
                                                          //   child: Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                          //     ? "..."
                                                          //     : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                          //     ? "..."
                                                          //     : "Phone",
                                                          //     style: robotoRegular.copyWith(
                                                          //       color: ColorResources.white
                                                          //     ),
                                                          //   )
                                                          // )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  
                                                
                                                ],
                                              )
                                            ),
                                          ),
                                        )
                              
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                              
                          },
                          animationType: DialogTransitionType.scale,
                          curve: Curves.fastOutSlowIn,
                          duration: Duration(seconds: 1),
                        );
                      } else {
                        NS.push(context, InboxDetailScreen(
                          inboxId: inboxProvider.inboxes[i].inboxId,
                          type: inboxProvider.inboxes[i].type!,
                          body: inboxProvider.inboxes[i].body!,
                          subject: inboxProvider.inboxes[i].subject,
                          field1: inboxProvider.inboxes[i].field1,
                          field2: inboxProvider.inboxes[i].field2,
                          field3: inboxProvider.inboxes[i].field3,
                          field4: inboxProvider.inboxes[i].field4,
                          field5: inboxProvider.inboxes[i].field5,
                          field6: inboxProvider.inboxes[i].field6,
                          field7: inboxProvider.inboxes[i].field7,
                          created: inboxProvider.inboxes[i].created,
                          read: inboxProvider.inboxes[i].read,
                          recepientId: inboxProvider.inboxes[i].recepientId,
                          senderId: inboxProvider.inboxes[i].senderId,
                          updated: inboxProvider.inboxes[i].updated,
                          typeInbox: inboxProvider.inboxes[i].type,
                        ));
                      }
                    },
                    isThreeLine: true,
                    dense: true,
                    leading: inboxProvider.inboxes[i].subject == "Emergency"  
                    ? Image.asset(
                        Images.sos,
                        width: 25.0,
                        height: 25.0,
                      ) 
                    : inboxProvider.inboxes[i].type == "payment.waiting" ||
                      inboxProvider.inboxes[i].type == "payment.paid" || 
                      inboxProvider.inboxes[i].type == "payment.expired"
                    ? Image.asset(
                        Images.money,
                        width: 25.0,
                        height: 25.0,
                        color: ColorResources.success,
                      ) 
                    :
                    Icon(
                      inboxProvider.inboxStatus == InboxStatus.loading  
                      ? Icons.label
                      : inboxProvider.inboxStatus == InboxStatus.error 
                      ? Icons.label
                      : Icons.info,
                      color: inboxProvider.inboxes[i].type == "payment.waiting" ||
                      inboxProvider.inboxes[i].type == "payment.paid" || 
                      inboxProvider.inboxes[i].type == "payment.expired"
                      ? ColorResources.success
                      : ColorResources.blueGrey,
                    ),
                    title: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        inboxProvider.inboxStatus == InboxStatus.loading 
                        ? "..."
                        : inboxProvider.inboxStatus == InboxStatus.error 
                        ? "..." 
                        : inboxProvider.inboxes[i].subject!,
                        style: robotoRegular.copyWith(
                          fontWeight: inboxProvider.inboxes[i].read! 
                          ? FontWeight.normal 
                          : FontWeight.w600,
                          fontSize: Dimensions.fontSizeSmall
                        ),  
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(inboxProvider.inboxStatus == InboxStatus.loading 
                          ? "..."
                          : inboxProvider.inboxStatus == InboxStatus.error 
                          ? "..."
                          : inboxProvider.inboxes[i].subject == "Emergency" 
                          ? getTranslated("${inboxProvider.inboxes[i].body!.split('-')[0].toString()}", context) + " " + getTranslated("${inboxProvider.inboxes[i].body!.split('-')[1].toString()}", context) 
                          : inboxProvider.inboxes[i].body!,
                            overflow: inboxProvider.inboxes[i].subject == "Emergency" 
                          ? TextOverflow.fade
                          : TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(
                              height: 1.6,
                              fontSize: Dimensions.fontSizeSmall
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(inboxProvider.inboxStatus == InboxStatus.loading 
                          ? "..."
                          : inboxProvider.inboxStatus == InboxStatus.error 
                          ? "..."
                          : DateFormat('dd MMM yyyy kk:mm').format(inboxProvider.inboxes[i].created!),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall
                            ),
                          ),
                        )
                      ],
                    ) 
                  ),
                ),
                Divider()
              ]
            );
                          


            },
          ),
        );   
      },
    );
  }
}

