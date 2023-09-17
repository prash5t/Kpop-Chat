class AnalyticsConstants {
  /// to be used when sign in with google btn is clicked
  static const String kEventSignInClick = "sign_in_clicked";

  /// to be used when user is actually signed in and navigated to dashboard
  static const String kEventSignedIn = "signed_in";
  static const String kEventMenuScreenClicked = "menu_clicked";
  static const String kEventSignOut = "signed_out";
  static const String kEventPolicyClicked = "policy_clicked";
  static const String kProperyMsgSentCount = "total_messages_sent";
  static const String kPropertyEdenAiCreditSpent = "edenai_credit_spent";

  // below is ad events and properties
  static const String kEventBannerAdLoaded = "banner_ad_loaded";
  static const String kEventBannerAdOpened = "banner_ad_opened";
  static const String kEventBannerAdClicked = "banner_ad_clicked";
  static const String kEventBannerAdApproxPaid = "banner_ad_paid";

  static const String kEventInterstitialAdShowed = "interstitial_ad_shown";
}
