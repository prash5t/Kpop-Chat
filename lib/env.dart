import 'package:flutter/foundation.dart' show kDebugMode;

/// Compile-time environment variables, sourced exclusively from `.env.json`
/// via `--dart-define-from-file=.env.json` at build time.
///
/// **No hardcoded fallbacks for credentials.** Per awarself rule:
/// third-party tokens (Mixpanel project token, AdMob app id + ad unit ids,
/// Telegram bot, etc.) live in `.env.json` only — gitignored at the per-app
/// level and the framework's `/apps/` rule keeps it out of the main repo.
/// This file is committed and must therefore stay clean of credential values.
///
/// Run / build the app via the wrappers in `scripts/` so the dart-define is
/// always passed:
///   * `scripts/run.sh` — debug run
///   * `scripts/build_release.sh` — release build
///
/// If a value is missing at build time, the corresponding `has*` getter
/// returns `false` and the consuming service is expected to no-op gracefully
/// (Mixpanel skips init, AdMob falls back to test ads, Telegram notifier
/// skips, etc.).
class Env {
  Env._();

  // ---- Mixpanel ----
  static const String mixpanelToken = String.fromEnvironment(
    'MIXPANEL_TOKEN',
    defaultValue: '',
  );

  static bool get hasMixpanel => mixpanelToken.isNotEmpty;

  // ---- AdMob ----
  // The AndroidManifest meta-data references this app id at build time
  // (read from .env.json by the gradle script); keep both in sync.
  static const String admobAppIdAndroid = String.fromEnvironment(
    'ADMOB_APP_ID_ANDROID',
    defaultValue: '',
  );

  static bool get hasAdMob => admobAppIdAndroid.isNotEmpty;

  static const String _envBannerAndroid = String.fromEnvironment(
    'ADMOB_BANNER_ANDROID',
    defaultValue: '',
  );
  static const String _envInterstitialAndroid = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ANDROID',
    defaultValue: '',
  );
  static const String _envRewardedAndroid = String.fromEnvironment(
    'ADMOB_REWARDED_ANDROID',
    defaultValue: '',
  );

  // Public Google test units — Google publishes these for anyone to use
  // during development. Not credentials, safe to embed.
  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';

  static const String _envUseTestAds = String.fromEnvironment(
    'USE_TEST_ADS',
    defaultValue: 'auto',
  );

  /// Resolution order for the test-ads switch:
  ///   USE_TEST_ADS = "true"  -> always test ads
  ///   USE_TEST_ADS = "false" -> always real ads
  ///   USE_TEST_ADS = "auto"  -> debug build = test ads, release = real ads
  ///
  /// Defensive fallback: if any production AdMob unit ID is empty (env
  /// didn't load — common when running `flutter build` directly instead of
  /// via `scripts/build_release.sh`), force test ads regardless of the flag.
  static bool get useTestAds {
    if (_admobCredentialsMissing) return true;
    final v = _envUseTestAds.toLowerCase().trim();
    if (v == 'true') return true;
    if (v == 'false') return false;
    return kDebugMode;
  }

  static bool get _admobCredentialsMissing =>
      _envBannerAndroid.isEmpty ||
      _envInterstitialAndroid.isEmpty ||
      _envRewardedAndroid.isEmpty;

  static bool get admobCredentialsMissing => _admobCredentialsMissing;

  static String get bannerUnitIdAndroid =>
      useTestAds ? _testBannerAndroid : _envBannerAndroid;
  static String get interstitialUnitIdAndroid =>
      useTestAds ? _testInterstitialAndroid : _envInterstitialAndroid;
  static String get rewardedUnitIdAndroid =>
      useTestAds ? _testRewardedAndroid : _envRewardedAndroid;

  // ---- Telegram admin notifier (dev/admin-only paths) ----
  static const String telegramBotApiKey = String.fromEnvironment(
    'TELEGRAM_BOT_API_KEY',
    defaultValue: '',
  );
  static const String telegramAdminChatId = String.fromEnvironment(
    'TELEGRAM_ADMIN_CHAT_ID',
    defaultValue: '',
  );
  static const String telegramBaruasChatId = String.fromEnvironment(
    'TELEGRAM_BARUAS_CHAT_ID',
    defaultValue: '',
  );
  static const String telegramBaseUrl = 'https://api.telegram.org/';

  static bool get hasTelegram => telegramBotApiKey.isNotEmpty;

  // ---- Firebase (manual init values; mirror google-services.json values) ----
  // The Firebase Android API key is restricted by package name + SHA-1 in the
  // Cloud Console, so it is not a hard secret — but kept in env for parity.
  static const String firebaseApiKeyAndroid = String.fromEnvironment(
    'FIREBASE_API_KEY_ANDROID',
    defaultValue: '',
  );
  static const String firebaseApiKeyIos = String.fromEnvironment(
    'FIREBASE_API_KEY_IOS',
    defaultValue: '',
  );
  static const String firebaseAppIdAndroid = String.fromEnvironment(
    'FIREBASE_APP_ID_ANDROID',
    defaultValue: '',
  );
  static const String firebaseAppIdIos = String.fromEnvironment(
    'FIREBASE_APP_ID_IOS',
    defaultValue: '',
  );
  static const String firebaseIosClientId = String.fromEnvironment(
    'FIREBASE_IOS_CLIENT_ID',
    defaultValue: '',
  );
  /// OAuth 2.0 web client ID from google-services.json `oauth_client` with
  /// `client_type: 3`. Required by `GoogleSignIn.instance.initialize(...)`
  /// as `serverClientId` so the resulting ID token is suitable for
  /// `FirebaseAuth.signInWithCredential` on Android (google_sign_in v7+
  /// uses Android Credential Manager which needs an explicit audience).
  static const String firebaseWebClientId = String.fromEnvironment(
    'FIREBASE_WEB_CLIENT_ID',
    defaultValue: '',
  );
  static const String firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '',
  );
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );
  static const String firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: '',
  );

  static const String bundleId = 'com.awarself.kpopchat';

  // ---- Useful flags ----
  static bool get isReleaseBuild =>
      const bool.fromEnvironment('dart.vm.product');
}
