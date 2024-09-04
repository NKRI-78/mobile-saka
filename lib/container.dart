import 'package:get_it/get_it.dart';
import 'package:saka/data/repository/ecommerce/ecommerce.dart';
import 'package:saka/providers/ecommerce/ecommerce.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/data/repository/feed/feed.dart';
import 'package:saka/data/repository/firebase/firebase.dart';
import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/banner/banner.dart';
import 'package:saka/data/repository/feedv2/feed.dart';
import 'package:saka/data/repository/category/category.dart';
import 'package:saka/data/repository/event/event.dart';
import 'package:saka/data/repository/media/media.dart';
import 'package:saka/data/repository/membernear/membernear.dart';
import 'package:saka/data/repository/onboarding/onboarding.dart';
import 'package:saka/data/repository/profile/profile.dart';
import 'package:saka/data/repository/sos/sos.dart';
import 'package:saka/data/repository/splash/splash.dart';

import 'package:saka/services/notification.dart';

import 'package:saka/providers/feed/feed.dart';
import 'package:saka/providers/firebase/firebase.dart';
import 'package:saka/providers/onboarding/onboarding.dart';
import 'package:saka/providers/membernear/membernear.dart';
import 'package:saka/providers/region/region.dart';
import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/providers/feedv2/feedDetail.dart';
import 'package:saka/providers/feedv2/feedReply.dart';
import 'package:saka/providers/store/store.dart';
import 'package:saka/providers/sos/sos.dart';
import 'package:saka/providers/location/location.dart';
import 'package:saka/providers/auth/auth.dart';
import 'package:saka/providers/banner/banner.dart';
import 'package:saka/providers/category/category.dart';
import 'package:saka/providers/localization/localization.dart';
import 'package:saka/providers/news/news.dart';
import 'package:saka/providers/profile/profile.dart';
import 'package:saka/providers/splash/splash.dart';
import 'package:saka/providers/ppob/ppob.dart';
import 'package:saka/providers/inbox/inbox.dart';
import 'package:saka/providers/media/media.dart';
import 'package:saka/providers/event/event.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton(() => NotificationService());

  getIt.registerLazySingleton(() => AuthRepo(
    sp: getIt()
  ));

  getIt.registerLazySingleton(() => EcommerceRepo(sp: getIt()));

  getIt.registerLazySingleton(() => CategoryRepo());
  getIt.registerLazySingleton(() => SosRepo());
  getIt.registerLazySingleton(() => BannerRepo(
    sp: getIt()
  ));

  getIt.registerLazySingleton(() => FirebaseRepo(
    ar: getIt(),
    sp: getIt()
  ));

  getIt.registerLazySingleton(() => MembernearRepo(
    sp: getIt() 
  ));

  getIt.registerLazySingleton(() => EventRepo(
    sp: getIt(),
    ar: getIt()
  ));

  getIt.registerLazySingleton(() => OnboardingRepo(
    sp: getIt()
  ));

  getIt.registerLazySingleton(() => MediaRepo());
  
  getIt.registerLazySingleton(() => ProfileRepo(
    ar: getIt(),
    sp: getIt()
  ));

  getIt.registerLazySingleton(() => FeedRepo(
    sp: getIt(),
  ));
  
  getIt.registerLazySingleton(() => FeedRepoV2(
    sp: getIt(),
  ));

  getIt.registerLazySingleton(() => SplashRepo(
    sp: getIt()
  ));

  getIt.registerFactory(() => FeedProvider(
    ar: getIt(), 
    fr: getIt()
  ));
  getIt.registerFactory(() => FeedProviderV2(
    ar: getIt(), 
    fr: getIt()
  ));
  getIt.registerFactory(() => FeedDetailProviderV2(
    ar: getIt(), 
    fr: getIt()
  ));
  getIt.registerFactory(() => FeedReplyProvider(
    ar: getIt(), 
    fr: getIt()
  ));

  getIt.registerFactory(() => AuthProvider(
    ar: getIt(), 
    sp: getIt(),
  ));

  getIt.registerFactory(() => CategoryProvider(cr: getIt()));
  getIt.registerFactory(() => SosProvider(
    sr: getIt(),
    ar: getIt(),
    lp: getIt(),
  ));

  getIt.registerFactory(() => BannerProvider(
    br: getIt()
  ));

  getIt.registerFactory(() => EcommerceProvider(
    er: getIt()
  ));

  getIt.registerFactory(() => LocationProvider(sp: getIt()));

  getIt.registerFactory(() => OnboardingProvider(  
    or: getIt()
  ));
  
  getIt.registerFactory(() => MediaProvider(
    mr: getIt(),
  ));

  getIt.registerFactory(() => PPOBProvider(
    ap: getIt(),
    sp: getIt()
  ));

  getIt.registerFactory(() => NewsProvider());
  
  getIt.registerFactory(() => MembernearProvider(
    mr: getIt(), 
    sp: getIt(),
    lp: getIt()
  ));

  getIt.registerFactory(() => InboxProvider());
  
  getIt.registerFactory(() => FirebaseProvider(
    ap: getIt(),
    fp: getIt(),
    sp: getIt()
  ));

  getIt.registerFactory(() => RegionProvider());

  getIt.registerFactory(() => EventProvider(
    ar: getIt(),
    er: getIt(),
    sp: getIt()
  ));

  getIt.registerFactory(() => ProfileProvider(
    ar: getIt(),
    pr: getIt()
  ));

  getIt.registerFactory(() => SplashProvider(
    sr: getIt(),
    sp: getIt()
  ));

  getIt.registerFactory(() => LocalizationProvider(sharedPreferences: getIt()));

  // External
  final sp = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sp);
}
