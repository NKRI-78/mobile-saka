// ignore: implementation_imports
import 'package:timeago/src/messages/lookupmessages.dart';

import 'package:saka/data/models/language/language.dart';

class AppConstants {
  static const String baseUrl = 'https://saka.inovatif78.com';
  static const String baseUrlDisbursementDenom = 'https://pg-$switchTo.connexist.id/disbursement/pub/v1/disbursement/denom';
  static const String baseUrlEcommerceDeliveryTimeslots = '$switchToBaseUrl/commerce-saka/pub/v1/ninja/deliveryTimeSlots';
  static const String baseUrlDisbursementBank = 'https://pg-$switchTo.connexist.id/disbursement/pub/v1/disbursement/bank';
  static const String baseUrlDisbursementEmoney = 'https://pg-$switchTo.connexist.id/disbursement/pub/v1/disbursement/emoney';
  static const String baseUrlDisbursement = 'https://pg-$switchTo.connexist.id/disbursement/api/v1';
  static const String baseUrlImg = 'http://feedapi.connexist.id/d/f';
  static const String baseUrlFeed = '$switchToBaseUrlFeed';
  static const String baseUrlFeedV2 = '$switchToBaseUrlFeedV2';
  static const String baseUrlFeedMedia = 'http://167.99.76.66:9000/p/f';
  static const String baseUrlFeedImg = 'http://167.99.76.66:9000/d/f';
  static const String baseUrlSocketFeed = 'https://feedapi.connexist.id:5091'; 
  static const String baseUrlEcommerce = '$switchToBaseUrl/commerce-saka/api/v1';
  static const String baseUrlPpob = '$switchToBaseUrl/ppob/api/v1';
  static const String baseUrlPpobV2 = 'https://api-pg.inovasi78.com';
  static const String baseUrlAirmen = 'https://void.idserverhost.com:8024/stream';
  static const String baseUrlVa = 'https://pg-$switchTo.connexist.id/payment/pub/v2/payment/channels';
  static const String baseUrlPaymentBilling = 'https://pg-$switchTo.connexist.id/payment/page/guidance';
  static const String baseUrlHelpPayment = 'https://pg-$switchTo.connexist.id/payment/help/howto';
  static const String baseUrlHelpInboxPayment = 'https://pg-$switchTo.connexist.id/payment/help/howto/trx';
  static const String baseUrlEcommercePickupTimeslots = '$switchToBaseUrl/commerce-saka/pub/v1/ninja/pickupTimeSlots';
  static const String baseUrlEcommerceDimensionSize = '$switchToBaseUrl/commerce-saka/pub/v1/ninja/dimensionSizes';
  static const String baseUrlEcommerceApproximatelyVolumes = '$switchToBaseUrl/commerce-saka/pub/v1/ninja/pickupApproxVolumes';

  static const String switchTo = "prod";
  static const String switchToBaseUrlFeed = "https://feedapi.connexist.id/api/v1";
  static const String switchToBaseUrlFeedV2 = "https://api-forum-general.inovatif78.com";
  static const String switchToBaseUrl = "https://smsapi.connexist.com:8443";

  static const String xContextId = '603659477896';
  static const String mobileUa = 'Mozilla/5.0 (Linux; Android 7.0; SM-G930V Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36';
  static const String productId = 'dfadf7e6-6a8d-4704-a082-9025289cb37e';

  // va prod https://pg-prod.sandbox.connexist.id/payment/pub/v1/payment/channels
  // va dev https://pg-sandbox.connexist.id/payment/pub/v1/payment/channels
  // feed prod https://feedapi.connexist.id/api/v1
  // feed dev https://apidev.cxid.xyz:7443/api/v1
  // e-commerce dev https://apidev.cxid.xyz:8443/commerce-ppdi/api/v1
  // e-commerce prod https://smsapi.connexist.com:8443/commerce-ppdi/api/v1

  // SharedPreferences
  static const String apiKeyGmaps = "AIzaSyBFRpXPf8BXaR22nDvvx2ghBfbUbGGX8N8";

  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String theme = 'theme';

  static const double padding = 35.0;
  static const double avatarRadius = 45.0;

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'Indonesia', countryCode: 'ID', languageCode: 'id')
  ];
}

/// Indonesian messages
class CustomLocalDate implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'yang lalu';
  @override
  String suffixFromNow() => 'dari sekarang';
  @override
  String lessThanOneMinute(int seconds) => '1 detik';
  @override
  String aboutAMinute(int minutes) => '1 menit';
  @override
  String minutes(int minutes) => '$minutes menit';
  @override
  String aboutAnHour(int minutes) => '1 jam';
  @override
  String hours(int hours) => '$hours jam';
  @override
  String aDay(int hours) => 'sehari';
  @override
  String days(int days) => '$days hari';
  @override
  String aboutAMonth(int days) => 'sekitar sebulan';
  @override
  String months(int months) => '$months bulan';
  @override
  String aboutAYear(int year) => 'sekitar setahun';
  @override
  String years(int years) => '$years tahun';
  @override
  String wordSeparator() => ' ';
}
