import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/models/user/single_user.dart';
import 'package:saka/data/models/profile/profile.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

class ProfileRepo {
  final AuthRepo ar;
  final SharedPreferences sp;
  ProfileRepo({
    required this.ar,
    required this.sp
  });

  ProfileData? profileData;
  SingleUserData? singleUserData;
  
  Future<SingleUserData> getUserSingleData(BuildContext context, String userId) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response res = await dio.get("${AppConstants.baseUrl}/user-service/users/$userId");
      SingleUserModel singleUserModel = SingleUserModel.fromJson(json.decode(res.data));
      singleUserData = singleUserModel.body!;
    } catch(e, stackctrace) {
      debugPrint(stackctrace.toString());
    }
    return singleUserData!;
  }

  Future<ProfileData> getUserProfile(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response res = await dio.get("${AppConstants.baseUrl}/user-service/profile/${ar.getUserId()}");
      Map<String, dynamic> data = json.decode(res.data);
      return compute(parseProfile, data);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    } 
    return profileData!;
  }

  Future<void> updateProfile(BuildContext context, ProfileData profileData) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      await dio.put("${AppConstants.baseUrl}/user-service/profile/${ar.getUserId()}",
        data: {
          "address" : profileData.address,
          "fullname" : profileData.fullname,
          "gender" : "",
          "id_card_number": "",
          "body_style": "",
          "profile_pic": profileData.profilePic,
          "sub_modal": "",
          "short_bio": "",
        } 
      );
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  String get getUserName => sp.getString("userName") ?? "-";
  
  String get getUserEmail => sp.getString("emailAddress") ?? "-";

  String get getUserPhoneNumber => sp.getString("phoneNumber") ?? "-";

  String get getUserType => sp.getString("userType") ?? "-";

  String get getUserRole => sp.getString("role")!;

  String get getSingleUserPhoneNumber => singleUserData?.phoneNumber ?? "-";
  
  String get getSingleUserFullname => singleUserData?.fullname ?? "-";

  String get getSingleUserProfilePic => singleUserData?.profilePic ?? "";

  String get getUserFullname => profileData?.fullname ?? "-";

  String get getUserAddress => profileData?.address ?? "-";

  String get getUserGender => profileData?.gender ?? "-";

  String get getUserShortBio => profileData?.shortBio ?? "-";

  String get getUserProfilePic => profileData?.profilePic ?? "";

}

ProfileData parseProfile(dynamic data) {
  ProfileModel profileModel = ProfileModel.fromJson(data);
  ProfileData profileData = profileModel.data!;
  return profileData;
}
