import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:saka/data/models/profile/profile.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/images.dart';

import 'package:saka/providers/profile/profile.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/views/screens/profile/edit.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  late TabController tabController;

  late FocusNode fullnameFn;
  late FocusNode addressFn;
  late FocusNode cardNumberFn;
  late FocusNode shortBioFn;

  late TextEditingController fullnameC;
  late TextEditingController addressC;
  late TextEditingController cardNumberC;
  late TextEditingController shortBioC;
  
  ImagePicker picker = ImagePicker();
  ProfileData profileData = ProfileData();

  late File file;
  late String selectedGender;
  
  int tabbarIndex = 0;

  List<String> genders = [
    "Male",
    "Female",
  ];

  Future<void> chooseProfileAvatar() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 70,
      maxHeight: 500, 
      maxWidth: 500
    );
    if (pickedFile != null) {
      setState(() => file = File(pickedFile.path));
    }
  }

  Future<void> updateProfile(context) async {
    String fullname = fullnameC.text;
    String address = addressC.text;
    String shortBio = shortBioC.text;
    profileData.fullname = fullname;
    profileData.address = address;
    profileData.shortBio = shortBio;
    profileData.gender = selectedGender;
    await context.read<ProfileProvider>().updateProfile(context, profileData, file);
    ShowSnackbar.snackbar(context, getTranslated("UPDATE_ACCOUNT_SUCCESSFUL" ,context), "", Colors.green);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    fullnameC = TextEditingController();
    addressC = TextEditingController();
    cardNumberC = TextEditingController();
    shortBioC = TextEditingController();

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    fullnameC.dispose();
    addressC.dispose();
    cardNumberC.dispose();
    shortBioC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(getTranslated("MY_PROFILE", context),
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeDefault
          ),
        ),
        backgroundColor: ColorResources.brown,
        iconTheme: IconThemeData(
          color: ColorResources.white
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [

          Stack(
            clipBehavior: Clip.none,
            children: [
              
              ClipPath(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  color: ColorResources.brown
                ),
                clipper: CustomClipPath(),
              ),
              
              Align(  
                alignment: Alignment.bottomCenter,
                child: Consumer<ProfileProvider>(
                  builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
                    return CachedNetworkImage(
                      imageUrl: "${profileProvider.userProfile.profilePic}",
                      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                        return Container(
                          margin: EdgeInsets.only(top: 40.0),
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundColor: ColorResources.white,
                            backgroundImage: imageProvider
                          ),
                        );
                      },
                      errorWidget: (BuildContext context, String url, dynamic error) {
                        return Container(
                          width: 80.0,
                          height: 80.0,
                          margin: EdgeInsets.only(top: 40.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(
                              width: 1.0,
                              color: ColorResources.white
                            ),
                            color: ColorResources.primaryOrange
                          ),
                          child: SvgPicture.asset("assets/images/svg/user.svg",
                            width: double.infinity,
                            height: double.infinity,
                            color: ColorResources.white,
                          )
                        );
                      },  
                      placeholder: (BuildContext context, String url) {
                        return Container(
                          width: 80.0,
                          height: 80.0,
                          margin: EdgeInsets.only(top: 40.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(
                              width: 1.0,
                              color: ColorResources.white
                            ),
                            color: ColorResources.primaryOrange
                          ),
                          child: SvgPicture.asset("assets/images/svg/user.svg",
                            width: double.infinity,
                            height: double.infinity,
                            color: ColorResources.white,
                          )
                        );
                      },
                    );
                  },
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Consumer<ProfileProvider>(
                  builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
                    return Container(
                      margin: EdgeInsets.only(top: 130.0),
                      child: Text(profileProvider.profileStatus == ProfileStatus.loading  
                      ? "..." 
                      : profileProvider.profileStatus == ProfileStatus.error 
                      ? "..." 
                      : profileProvider.userProfile.fullname!, 
                        style: robotoRegular.copyWith(
                          color: ColorResources.black,
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      )
                    ); 
                  },
                )
              )
    
            ],
          ),

          TabBar(
            controller: tabController,
            onTap: (int i) {
              setState(() => tabbarIndex = i);
            },
            indicatorColor: ColorResources.black,
            labelColor: ColorResources.black,
            labelStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault
            ),
            unselectedLabelColor: ColorResources.dimGrey,
            tabs: [
              Tab(
                text: getTranslated("PROFILE", context),
              ),
              Tab(
                text: getTranslated("CARD_DIGITAL", context),
              ),
            ],
          ),

          Builder(
            builder:(BuildContext context) {
              if(tabbarIndex == 0) {
                return profileWidget(context);
              } 
              return digitalCard(context);
            },
          )        
        ],  
      ) 
    );
  }

  Widget profileWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Container(
          //   margin: EdgeInsets.only(bottom: 5.0, left: 14.0),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     children: [
              
          //       Row(
          //         mainAxisSize: MainAxisSize.max,
          //         children: [
          //           Text(getTranslated("MY_BALANCE", context),
          //             style: robotoRegular.copyWith(
          //               fontSize: Dimensions.fontSizeSmall,
          //               fontWeight: FontWeight.w600,
          //               color:  ColorResources.black
          //             ),
          //           ),
          //           SizedBox(width: 10.0),
          //           Consumer<PPOBProvider>(
          //             builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
          //               return Text(ppobProvider.balanceStatus == BalanceStatus.loading 
          //                 ? "..." 
          //                 : ppobProvider.balanceStatus == BalanceStatus.error 
          //                 ? "-"
          //                 : Helper.formatCurrency(double.parse(ppobProvider.balance.toString())),
          //                 style: robotoRegular.copyWith(
          //                   fontSize: Dimensions.fontSizeSmall,
          //                   fontWeight: FontWeight.normal
          //                 ),
          //               );
          //             },
          //           )
          //         ],
          //       ),

          //       SizedBox(width: 15.0),
                
          //       InkWell(
          //         onTap: () => context.read<PPOBProvider>().getBalance(context),
          //         child: Icon(
          //           Icons.refresh,
          //           color: ColorResources.black,
          //         ),
          //       ),

          //     ],
          //   ),
          // ),

          // Container(
          //   margin: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 13.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     mainAxisSize: MainAxisSize.max,
          //     children: [

          //       FittedBox(
          //         child: Container(
          //           height: 30.0,
          //           child: ElevatedButton(
          //             style: ElevatedButton.styleFrom(
          //               elevation: 0.0,
          //               backgroundColor: ColorResources.primaryOrange,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(10.0)
          //               )
          //             ),
          //             onPressed: () {
          //               NS.push(context, TopUpScreen());
          //             }, 
          //             child: Text(getTranslated("TOPUP", context),
          //               style: robotoRegular.copyWith(
          //                 fontSize: Dimensions.fontSizeSmall,
          //                 color: ColorResources.white
          //               ),
          //             )
          //           ),
          //         ),
          //       ),

          //       SizedBox(width: 10.0),
                
          //       FittedBox(
          //         child: Container(
          //           height: 30.0,
          //           child: ElevatedButton(
          //             style: ElevatedButton.styleFrom(
          //               elevation: 0.0,
          //               backgroundColor: ColorResources.primaryOrange,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(10.0)
          //               )
          //             ),
          //             onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TopUpHistoryScreen())), 
          //             child: Text(getTranslated("HISTORY_BALANCE", context),
          //               style: robotoRegular.copyWith(
          //                 fontSize: Dimensions.fontSizeSmall,
          //                 color: ColorResources.white
          //               ),
          //             )
          //           ),
          //         ),
          //       ),
  
          //     ],
          //   ),
          // ),
          
          Consumer<ProfileProvider>(
            builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
              return Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.0),
                    profileListAccount(context, "Lanud", profileProvider.profileStatus == ProfileStatus.loading
                    ? "..."
                    : profileProvider.profileStatus == ProfileStatus.error 
                    ? "..."
                    : profileProvider.userProfile.lanud!
                    ),
                  ],  
                ),
              );
            },
          ),
          
          Consumer<ProfileProvider>(
            builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
              return Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.0),
                    profileListAccount(context, getTranslated("PROVINCE", context), profileProvider.profileStatus == ProfileStatus.loading
                    ? "..."
                    : profileProvider.profileStatus == ProfileStatus.error 
                    ? "..."
                    : profileProvider.userProfile.province!
                    ),
                  ],
                ),
              );
            },
          ),

          Consumer<ProfileProvider>(
            builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
              return Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.0),
                    profileListAccount(context, getTranslated("CITY", context), profileProvider.profileStatus == ProfileStatus.loading
                    ? "..."
                    : profileProvider.profileStatus == ProfileStatus.error 
                    ? "..."
                    : profileProvider.userProfile.city!
                    ),
                  ],
                ),
              );
            },
          ),
          Consumer<ProfileProvider>(
            builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
              return Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.0),
                    profileListAccount(context, getTranslated("ADDRESS", context), profileProvider.profileStatus == ProfileStatus.loading
                    ? "..."
                    : profileProvider.profileStatus == ProfileStatus.error 
                    ? "..."
                    : profileProvider.userProfile.address!
                    ),
                  ],
                ),
              );
            },
          ),
          Consumer<ProfileProvider>(
            builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
              return Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: profileListAccount(context, getTranslated("FULL_NAME", context), profileProvider.profileStatus == ProfileStatus.loading
                ? "..."
                : profileProvider.profileStatus == ProfileStatus.error 
                ? "..."
                : profileProvider.userProfile.fullname!
                ),
              ); 
            },
          ),
          Consumer<ProfileProvider>(
            builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
              return Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: profileListAccount(context, getTranslated("PHONE_NUMBER", context), profileProvider.profileStatus == ProfileStatus.loading
                ? "..."
                : profileProvider.profileStatus == ProfileStatus.error 
                ? "..."
                : profileProvider.getUserPhoneNumber
                ),
              );                 
            },
          ),
          Consumer<ProfileProvider>(
            builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
              return Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: profileListAccount(context, getTranslated("EMAIL", context), profileProvider.profileStatus == ProfileStatus.loading
                ? "..."
                : profileProvider.profileStatus == ProfileStatus.error 
                ? "..."
                : profileProvider.getUserEmail
                ),
              );
            },
          ),
          SizedBox(height: 10.0),
          Center(
            child: FittedBox(
              child: Container(
                margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                height: 30.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: ColorResources.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileEditScreen()),
                    );
                  }, 
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.edit,
                        size: 16.0,
                        color: ColorResources.white
                      ),
                      SizedBox(width: 10.0),
                      Text(getTranslated("EDIT", context),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: ColorResources.white
                        ),
                      )
                    ],
                  )
                ),
              ),
            ),
          ),

        ],
      )
    );
  }
 
  Widget digitalCard(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      
        Container(
          margin: EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              
              Image.asset(Images.card),
             
              Positioned(
                top: 40.0,
                left: 40.0,
                child: CachedNetworkImage(
                  imageUrl: "${context.read<ProfileProvider>().userProfile.profilePic}",
                  imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                    return CircleAvatar(
                      radius: 50.0,
                      backgroundColor: ColorResources.white,
                      backgroundImage: imageProvider,
                    );
                  },
                  placeholder: (BuildContext context, String url) {
                    return CircleAvatar(
                      radius: 50.0,
                      backgroundColor: ColorResources.primaryOrange,
                      child: Icon(
                        Icons.person,
                        color: ColorResources.white,
                        size: 50.0,
                      ),
                    );
                  },
                  errorWidget: (BuildContext context, String url, dynamic error) {
                    return CircleAvatar(
                      radius: 50.0,
                      backgroundColor: ColorResources.primaryOrange,
                      child: Icon(
                        Icons.person,
                        color: ColorResources.white,
                        size: 50.0,
                      ),
                    );
                  },
                )
              ),  

              Positioned(
                top: 90.0,
                right: 30.0,
                child:  Consumer<ProfileProvider>(
                  builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
                    return Text(profileProvider.profileStatus == ProfileStatus.loading  
                    ? "..." 
                    : profileProvider.profileStatus == ProfileStatus.error 
                    ? "-" 
                    : profileProvider.userProfile.fullname!,
                      style: robotoRegular.copyWith(
                        color: ColorResources.brown,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fontSizeLarge
                      ),
                    );
                  },
                )
              ),

              Positioned(
                top: 120.0,
                right: 30.0,
                child:  Consumer<ProfileProvider>(
                  builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
                    return Text(profileProvider.profileStatus == ProfileStatus.loading  
                    ? "..." 
                    : profileProvider.profileStatus == ProfileStatus.error 
                    ? "-" 
                    : profileProvider.userProfile.noMember!,
                      style: robotoRegular.copyWith(
                        color: ColorResources.brown,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fontSizeDefault
                      ),
                    );
                  },
                )
              ),

            ],
          ),
        ),
        
      ],
    );
  }

  Widget profileListAccount(BuildContext context, String label, String title) {
    return  Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault
            ),
          ),
          SizedBox(height: 5.0),
          Text(title,
            style: robotoRegular.copyWith(
              color: ColorResources.primaryOrange,
              fontSize: Dimensions.fontSizeDefault
            ),
          ),
          Divider(
            height: 1.0,
          )
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
    path.lineTo(size.width / 2, size.height * 0.8 + 10);
    path.lineTo(size.width, 0.0);
     path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
