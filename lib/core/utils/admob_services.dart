import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kpopchat/core/constants/analytics_constants.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/main.dart';

class AdMobServices {
  static BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) {
      if (!kDebugMode) {
        logEventInAnalytics(AnalyticsConstants.kEventBannerAdLoaded);
      }
      debugPrint('Ad loaded.');
    },
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('ad failed to load: $error');
    },
    onAdOpened: (ad) {
      if (!kDebugMode) {
        logEventInAnalytics(AnalyticsConstants.kEventBannerAdOpened);
      }
      debugPrint('Ad opened');
    },
    onAdClosed: (ad) => debugPrint('Ad closed'),
    onAdClicked: (ad) {
      if (!kDebugMode) {
        logEventInAnalytics(AnalyticsConstants.kEventBannerAdClicked);
      }
      debugPrint('Ad clicked');
    },
    onPaidEvent: (ad, valueMicros, precision, currencyCode) {
      if (!kDebugMode) {
        logEventInAnalytics(AnalyticsConstants.kEventBannerAdApproxPaid);
      }
      debugPrint('Ad paid event');
    },
  );

  static Future<BannerAd> getBannerAdByGivingAdId(String bannerAdId) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(navigatorKey.currentContext!).size.width.truncate());
    return BannerAd(
        size: size ?? AdSize.banner,
        adUnitId: bannerAdId,
        listener: AdMobServices.bannerAdListener,
        request: const AdRequest());
  }
}
