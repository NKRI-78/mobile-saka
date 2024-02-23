import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:saka/data/repository/auth/auth.dart';

import 'package:saka/data/repository/profile/profile.dart';
import 'package:saka/data/models/user/single_user.dart';

import 'package:saka/data/models/profile/profile.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/media/media.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

enum ProfileStatus { idle, loading, loaded, error }
enum UpdateProfileStatus { idle, loading, loaded, error }
enum SingleUserDataStatus { idle, loading, loaded, error } 

class ProfileProvider extends ChangeNotifier {
  final AuthRepo ar;
  final ProfileRepo pr;
  ProfileProvider({
    required this.ar,
    required this.pr
  });

  ProfileStatus _profileStatus = ProfileStatus.loading;
  ProfileStatus get profileStatus => _profileStatus;

  UpdateProfileStatus _updateProfileStatus = UpdateProfileStatus.idle;
  UpdateProfileStatus get updateProfileStatus => _updateProfileStatus;

  SingleUserDataStatus _singleUserDataStatus = SingleUserDataStatus.idle;
  SingleUserDataStatus get singleUserDataStatus => _singleUserDataStatus;
  
  ProfileData _userProfile = ProfileData();
  ProfileData get userProfile => _userProfile;

  SingleUserData _singleUserData = SingleUserData();
  SingleUserData get singleUserData => _singleUserData;

  void setStateProfileStatus(ProfileStatus profileStatus) {
    _profileStatus = profileStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateUpdateProfileStatus(UpdateProfileStatus updateProfileStatus) {
    _updateProfileStatus = updateProfileStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSingleUserDataStatus(SingleUserDataStatus singleUserDataStatus) {
    _singleUserDataStatus = singleUserDataStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getSingleUser(BuildContext context, String userId) async {
    try {
      setStateSingleUserDataStatus(SingleUserDataStatus.loading);
      SingleUserData singleUserData = await pr.getUserSingleData(context, userId);
      _singleUserData = singleUserData;
      setStateSingleUserDataStatus(SingleUserDataStatus.loaded);
    } catch(e) {
      debugPrint(e.toString());
      setStateSingleUserDataStatus(SingleUserDataStatus.error);
    }
  }
  
  Future<void> getUserProfile(BuildContext context) async {
    try {
      ProfileData profileData = await pr.getUserProfile(context);
      _userProfile = profileData;
      setStateProfileStatus(ProfileStatus.loaded);
    } catch(e) {
      debugPrint(e.toString());
      setStateProfileStatus(ProfileStatus.error);
    }
  }

  Future<void> updateProfile(BuildContext context, ProfileData profileData, File? file) async {
    try {
      setStateUpdateProfileStatus(UpdateProfileStatus.loading);
      if(file != null) {
        Response? res = await Provider.of<MediaProvider>(context, listen: false).postMedia(context, file);
        Map map = json.decode(res!.data);
        profileData.profilePic = map['body']['path'];
      }
      await pr.updateProfile(context, profileData);
      getUserProfile(context);
      Navigator.of(context).pop();
      ShowSnackbar.snackbar(context, getTranslated("UPDATE_ACCOUNT_SUCCESSFUL", context), "", ColorResources.success);
      setStateUpdateProfileStatus(UpdateProfileStatus.loaded);
    } catch(e) {
      debugPrint(e.toString());
      setStateUpdateProfileStatus(UpdateProfileStatus.error);
    }
  }

  String get getUserPhoneNumber => ar.getUserPhoneNumber()!; 

  String get getUserEmail => ar.getUserEmail()!;

  String get getSingleUserPhoneNumber => pr.getSingleUserPhoneNumber; 

  String get getSingleUserProfilePic => pr.getSingleUserProfilePic; 
}
