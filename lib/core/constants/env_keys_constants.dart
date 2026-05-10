import 'package:kpopchat/env.dart';

/// Backwards-compatible facade over [Env]. Existing code references
/// `EnvKeys.X` everywhere; this file used to hold hardcoded credential
/// values and was gitignored. After the awarself baseline migration the
/// values live in `.env.json` (gitignored) and are surfaced via
/// `lib/env.dart`. This file is now safe to commit because it holds
/// no secret values — only `static const` aliases to `Env`'s
/// `String.fromEnvironment` lookups (compile-time constants, so callers
/// like `firebase_options.dart` that need `const FirebaseOptions(...)`
/// keep working unchanged).
class EnvKeys {
  EnvKeys._();

  // Firebase — manual init values (mirror google-services.json /
  // GoogleService-Info.plist). Restricted by package name + SHA-1 in the
  // Cloud Console.
  static const String apiKeyAndroid = Env.firebaseApiKeyAndroid;
  static const String apiKeyIos = Env.firebaseApiKeyIos;
  static const String appIdAndroid = Env.firebaseAppIdAndroid;
  static const String appIdIos = Env.firebaseAppIdIos;
  static const String iosClientId = Env.firebaseIosClientId;
  static const String messagingSenderId = Env.firebaseMessagingSenderId;
  static const String projectId = Env.firebaseProjectId;
  static const String storageBucket = Env.firebaseStorageBucket;
  static const String bundleId = Env.bundleId;

  // Mixpanel.
  static const String mixpanelToken = Env.mixpanelToken;

  // Telegram admin notifier (dev-only paths).
  static const String telegramAPIKey = Env.telegramBotApiKey;
  static const String telegramAdminChatID = Env.telegramAdminChatId;
  static const String telegramBaruasChatId = Env.telegramBaruasChatId;
  static const String telegramBaseUrl = Env.telegramBaseUrl;
}
