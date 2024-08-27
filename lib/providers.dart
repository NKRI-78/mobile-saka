import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:saka/providers/auth/auth.dart';
import 'package:saka/providers/banner/banner.dart';
import 'package:saka/providers/category/category.dart';
import 'package:saka/providers/event/event.dart';
import 'package:saka/providers/feed/feed.dart';
import 'package:saka/providers/feedv2/feed.dart';
import 'package:saka/providers/feedv2/feedDetail.dart';
import 'package:saka/providers/feedv2/feedReply.dart';
import 'package:saka/providers/firebase/firebase.dart';
import 'package:saka/providers/inbox/inbox.dart';
import 'package:saka/providers/localization/localization.dart';
import 'package:saka/providers/location/location.dart';
import 'package:saka/providers/media/media.dart';
import 'package:saka/providers/membernear/membernear.dart';
import 'package:saka/providers/news/news.dart';
import 'package:saka/providers/onboarding/onboarding.dart';
import 'package:saka/providers/profile/profile.dart';
import 'package:saka/providers/region/region.dart';
import 'package:saka/providers/sos/sos.dart';
import 'package:saka/providers/splash/splash.dart';
import 'package:saka/providers/ppob/ppob.dart';
import 'package:saka/providers/store/store.dart';

import 'container.dart' as c;

List<SingleChildWidget> providers = [
  ...independentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider(create: (_) => c.getIt<AuthProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<CategoryProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<SosProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<EventProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<MediaProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<StoreProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FeedProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FeedProviderV2>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FeedDetailProviderV2>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FeedReplyProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<NewsProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<InboxProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<BannerProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FirebaseProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<OnboardingProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<ProfileProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<SplashProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<PPOBProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<MembernearProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<RegionProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocalizationProvider>()),
  Provider.value(value: Map<String, dynamic>())
];
