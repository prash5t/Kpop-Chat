import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:kpopchat/core/constants/firebase_remote_config_keys.dart';
import 'package:kpopchat/core/constants/network_constants.dart';
import 'package:kpopchat/core/constants/prompt_constants.dart';
import 'package:kpopchat/core/utils/service_locator.dart';

/// contains diff services to initialize at beginning
class RequiredInitializations {
  static void initializeFirebaseRemoteConfig() {
    FirebaseRemoteConfig rc = locator<FirebaseRemoteConfig>();

    rc.fetchAndActivate();
    NetworkConstants.edenAIKey = rc.getString(RemoteConfigKeys.kKeyEdenAI);
    PromptConstants.systemMsg = rc.getString(RemoteConfigKeys.kKeySystemMsg);
    PromptConstants.temperature =
        rc.getDouble(RemoteConfigKeys.kKeyTemperature);
    PromptConstants.maxTokens = rc.getInt(RemoteConfigKeys.kKeyMaxTokens);
    PromptConstants.maxMessagesToTake =
        rc.getInt(RemoteConfigKeys.kKeyMaxMsgsToTake);
  }
}
