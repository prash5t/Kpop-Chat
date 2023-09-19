import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/constants/remote_config_values.dart';
import 'package:kpopchat/core/constants/shared_preferences_keys.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static void clearAll() {
    locator<SharedPreferences>().remove(SharedPrefsKeys.kUserProfile);
  }

  static void saveUserProfile(User? userToSave) {
    if (userToSave != null) {
      Map<String, dynamic> userData =
          UserModel.fromFirebaseCurrentUser(userToSave).toJson();
      locator<SharedPreferences>()
          .setString(SharedPrefsKeys.kUserProfile, jsonEncode(userData));
    }
  }

  static void setNewUnlockTime(String virtualFriendId) {
    Map<String, dynamic> unlockRecords = jsonDecode(locator<SharedPreferences>()
            .getString(SharedPrefsKeys.kFriendLastUnlockTime) ??
        "{}");
    unlockRecords[virtualFriendId] = DateTime.now().toString();
    locator<SharedPreferences>().setString(
        SharedPrefsKeys.kFriendLastUnlockTime, jsonEncode(unlockRecords));
  }

  static bool lastUnlockWasWithinAnHour(String virtualFriendId) {
    Map<String, dynamic> unlockRecords = jsonDecode(locator<SharedPreferences>()
            .getString(SharedPrefsKeys.kFriendLastUnlockTime) ??
        "{}");
    String? lastUnlock = unlockRecords[virtualFriendId];

    if (lastUnlock == null) {
      return false;
    }
    DateTime lastUnlockTime = DateTime.parse(lastUnlock);
    Duration difference = DateTime.now().difference(lastUnlockTime);
    debugPrint("Time difference in minutes: ${difference.inMinutes}");
    return difference.inMinutes < RemoteConfigValues.chatRewardUnlockTimeInMins
        ? true
        : false;
  }

  static UserModel? getUserProfile() {
    String? userData =
        locator<SharedPreferences>().getString(SharedPrefsKeys.kUserProfile);
    if (userData == null) {
      return null;
    }
    return UserModel.fromJson(jsonDecode(userData));
  }
}
