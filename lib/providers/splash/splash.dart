import 'package:flutter/material.dart';

import 'package:saka/data/repository/splash/splash.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo sr;
  final SharedPreferences sp;
  SplashProvider({
    required this.sr,
    required this.sp
  });

  late List<String> _languageList;
  final int _languageIndex = 0;

  List<String> get languageList => _languageList;
  int get languageIndex => _languageIndex;

  Future<bool> initConfig() {
    _languageList = sr.getLanguageList();
    Future.delayed(Duration.zero, () => notifyListeners());
    return Future.value(true);
  }

  bool isSkipOnboarding() {
    return sr.isSkipOnboarding;
  }
  
  void dispatchOnboarding(bool onboarding) {
    sr.dispatchOnboarding(onboarding);
    notifyListeners();
  }
 
}
