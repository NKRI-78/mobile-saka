import 'package:flutter/material.dart';

import 'package:saka/data/models/banner/banner.dart';
import 'package:saka/data/repository/banner/banner.dart';

enum BannerStatus { loading, loaded, empty, error }

class BannerProvider extends ChangeNotifier {

  final BannerRepo br;
  BannerProvider({
    required this.br
  });

  BannerStatus _bannerStatus = BannerStatus.loading;
  BannerStatus get bannerStatus => _bannerStatus;

  List<Map<String, dynamic>> _bannerListMap = [];
  List<Map<String, dynamic>> get bannerListMap => [..._bannerListMap];
  
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setStateBannerStatus(BannerStatus bannerStatus) {
    _bannerStatus = bannerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getBanner(BuildContext context) async {
    try {
      List<BannerData> bannerList = await br.getBanner(context);
      _bannerListMap = [];
      for (int i = 0; i < bannerList.length; i++) {
        for (int z = 0; z < bannerList[i].media!.length; z++) {
          _bannerListMap.add({
            "id": z,
            "path": bannerList[i].media![z].path,
            "link": bannerList[i].name
          });
        }
      } 
      setStateBannerStatus(BannerStatus.loaded);
      if(bannerListMap.isEmpty) {
        setStateBannerStatus(BannerStatus.empty);
      }
    } catch(_) {
      setStateBannerStatus(BannerStatus.error);
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

}
