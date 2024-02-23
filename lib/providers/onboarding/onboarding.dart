import 'package:flutter/material.dart';

import 'package:saka/data/models/onboarding/onboarding.dart';
import 'package:saka/data/repository/onboarding/onboarding.dart';

class OnboardingProvider with ChangeNotifier {
  final OnboardingRepo or;

  OnboardingProvider({
    required this.or
  });

  List<OnboardingModel> _onBoardingList = [];
  List<OnboardingModel> get onBoardingList => _onBoardingList;

  int _selectedIndex = 0;
  int get selectedIndex =>_selectedIndex;

  void changeSelectIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> initBoardingList() async {
    _onBoardingList.clear();
    _onBoardingList.addAll(or.getOnBoardingList());
    Future.delayed(Duration.zero, () => notifyListeners());
  }
}
