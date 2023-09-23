import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kpopchat/core/constants/firebase_remote_config_keys.dart';
import 'package:kpopchat/core/constants/network_constants.dart';
import 'package:kpopchat/core/constants/remote_config_values.dart';
import 'package:kpopchat/core/utils/service_locator.dart';

/// contains diff services to initialize at beginning
class RequiredInitializations {
  static void initializeFirebaseRemoteConfig() {
    FirebaseRemoteConfig rc = locator<FirebaseRemoteConfig>();

    rc.fetchAndActivate();
    NetworkConstants.edenAIKey = rc.getString(RemoteConfigKeys.kKeyEdenAI);
    RemoteConfigValues.systemMsg = rc.getString(RemoteConfigKeys.kKeySystemMsg);
    RemoteConfigValues.temperature =
        rc.getDouble(RemoteConfigKeys.kKeyTemperature);
    RemoteConfigValues.maxTokens = rc.getInt(RemoteConfigKeys.kKeyMaxTokens);
    RemoteConfigValues.maxMessagesToTake =
        rc.getInt(RemoteConfigKeys.kKeyMaxMsgsToTake);
    RemoteConfigValues.chatRewardUnlockTimeInMins =
        rc.getInt(RemoteConfigKeys.kKeyChatRewardUnlockTimeInMins);
    RemoteConfigValues.msgsToAllowAfterShowingOneAd =
        rc.getInt(RemoteConfigKeys.kKeyMessagesToAllowAfterShowingOneAd);
  }

  static void initializeMobileAds() {
    MobileAds.instance.initialize();
  }
}
