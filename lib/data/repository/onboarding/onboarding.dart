import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/data/models/onboarding/onboarding.dart';

class OnboardingRepo{
  final SharedPreferences sp;
  OnboardingRepo({
    required this.sp
  });

  List<OnboardingModel> getOnBoardingList() {
    List<OnboardingModel> onboarding = [
      OnboardingModel('assets/imagesv2/onboarding/1.png','Di Aplikasi','Aplikasi yang memberikan kemudahan untuk seluruh anggota Saka Dirgantara tentang informasi dan layanan'),
      OnboardingModel('assets/imagesv2/onboarding/2.png','Di Aplikasi','Aplikasi ini terdapat tombol Panic Button bertujuan untuk panggilan darurat atau emergency secara cepat dan tepat'),
      OnboardingModel('assets/imagesv2/onboarding/3.png','Di Aplikasi','Aplikasi yang memberikan kemudahan untuk seluruh anggota Saka Dirgantara dalam mencari kebutuhan yang diinginkan'),
    ];
    return onboarding;
  }
}