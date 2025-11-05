import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final SharedPreferences sp;
  SplashRepo({required this.sp});

 
  List<String> getLanguageList() {
    List<String> languageList = ['English', 'Indonesia'];
    return languageList;
  }

  void dispatchOnboarding(bool isOnboarding) {
    sp.setBool("onboarding", isOnboarding);
  }

  bool get isSkipOnboarding => sp.getBool("onboarding") == null ? false : true;
}