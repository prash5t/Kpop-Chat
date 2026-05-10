import 'package:kpopchat/env.dart';

/// Backwards-compatible ad unit ID lookups. Eight historic placement
/// constants from the previous AdMob account map to the awarself-standard
/// 3-unit rationalization (1 banner / 1 interstitial / 1 rewarded reused
/// across all placements) per the kpopchat revival plan. Real values come
/// from `.env.json` via `lib/env.dart`; in debug or when env values are
/// missing, [Env] returns Google's public test units.
class GoogleAdId {
  GoogleAdId._();

  // Banner placements — all 4 historic constants now point to the single
  // production banner unit (or the test unit per [Env.useTestAds]).
  static String get homeScreenBannerAdId => Env.bannerUnitIdAndroid;
  static String get menuScreenBannerAdId => Env.bannerUnitIdAndroid;
  static String get friendProfileScreenBannerAdId => Env.bannerUnitIdAndroid;
  static String get chatScreenBannerAdId => Env.bannerUnitIdAndroid;

  // Interstitial placements — all 3 historic constants now point to the
  // single production interstitial unit.
  static String get switchThemeInterstitialAdId =>
      Env.interstitialUnitIdAndroid;
  static String get msgInterstitialAdId => Env.interstitialUnitIdAndroid;
  static String get friendProfileScreenInterstitialAdId =>
      Env.interstitialUnitIdAndroid;

  // Rewarded — single placement, single unit.
  static String get unlockFriendRewardedAdId => Env.rewardedUnitIdAndroid;
}
