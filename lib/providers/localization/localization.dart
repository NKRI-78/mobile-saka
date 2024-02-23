import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/utils/constant.dart';

class LocalizationProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  LocalizationProvider({required this.sharedPreferences}) {
    _loadCurrentLanguage();
    _checkLanguage();
  }

  Locale _locale = const Locale('en', 'US');
  final bool _isLtr = true;
  late int _languageIndex;

  bool _isIndonesian = false;
  bool get isIndonesian => _isIndonesian;

  bool _isEnglish = false;
  bool get isIEnglish => _isEnglish;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int get languageIndex => _languageIndex;

  void setLanguage(Locale locale) {
    if(locale.languageCode == 'en'){
      _locale = const Locale('en', 'US');
    }else {
      _locale = const Locale('id', 'ID');
    }
    for (var language in AppConstants.languages) {
      if(language.languageCode == _locale.languageCode) {
        _languageIndex = AppConstants.languages.indexOf(language);
      }
    }
    _saveLanguage(_locale);
    notifyListeners();
  }

  _loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(AppConstants.languageCode) 
    ?? 'en', sharedPreferences.getString(AppConstants.countryCode) 
    ?? 'US');
    for (var language in AppConstants.languages) {
      if(language.languageCode == _locale.languageCode) {
        _languageIndex = AppConstants.languages.indexOf(language);
      }
    }
    notifyListeners();
  }

  _checkLanguage() {
    if(sharedPreferences.getString(AppConstants.languageCode) == "id") {
      _isIndonesian = true;
      _isEnglish = false;
    } else {
      _isEnglish = true;
      _isIndonesian = false;
    }
    notifyListeners();
  }
  
  toggleLanguage() {
    _isIndonesian = !_isIndonesian;
    if(_isIndonesian) {
      _isIndonesian = true;
      _isEnglish = false;
      setLanguage(Locale(
        AppConstants.languages[0].languageCode!,
        AppConstants.languages[0].countryCode,
      ));
    } else {
      _isIndonesian = false;
      _isEnglish = true;
      setLanguage(Locale(
        AppConstants.languages[1].languageCode!,
        AppConstants.languages[1].countryCode,
      ));
    }
    notifyListeners();
  }

  _saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
  }
}