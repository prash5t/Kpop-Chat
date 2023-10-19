import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kpopchat/admin_controls/admin_repo.dart';
import 'package:kpopchat/core/constants/env_keys_constants.dart';
import 'package:kpopchat/core/firebase/firebase_options.dart';
import 'package:kpopchat/core/network/client/base_client.dart';
import 'package:kpopchat/core/network/client/base_client_impl.dart';
import 'package:kpopchat/core/utils/schema_helper.dart';
import 'package:kpopchat/data/repository/auth_repo.dart';
import 'package:kpopchat/data/repository/chat_repo.dart';
import 'package:kpopchat/data/repository/data_filter_repo.dart';
import 'package:kpopchat/data/repository/real_users_repo.dart';
import 'package:kpopchat/data/repository/remote_config_repo.dart';
import 'package:kpopchat/data/repository/virtual_friends_repo.dart';
import 'package:kpopchat/data/repository_implementation/auth_repo_impl.dart';
import 'package:kpopchat/data/repository_implementation/chat_repo_impl.dart';
import 'package:kpopchat/data/repository_implementation/real_users_repo_impl.dart';
import 'package:kpopchat/data/repository_implementation/remote_config_repo_impl.dart';
import 'package:kpopchat/data/repository_implementation/virtual_friends_repo_impl.dart';
import 'package:location/location.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

setUpLocator() async {
  Mixpanel mixpanel =
      await Mixpanel.init(EnvKeys.mixpanelToken, trackAutomaticEvents: true);
  mixpanel.setLoggingEnabled(true);
  locator.registerSingleton<Mixpanel>(mixpanel);
  if (kDebugMode) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  }
  OneSignal.initialize(EnvKeys.oneSignalAppId);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FirebaseRemoteConfig rc = FirebaseRemoteConfig.instance;
  locator.registerSingleton<SharedPreferences>(prefs);
  locator.registerFactory(() => FirebaseAuth.instance);
  locator.registerSingleton(InternetConnectionChecker());
  locator.registerSingleton(FirebaseAnalytics.instance);
  locator.registerSingleton(FlutterLocalNotificationsPlugin());
  locator.registerFactory<FlutterSecureStorage>(
      () => const FlutterSecureStorage());
  locator.registerFactory<GoogleSignIn>(() => GoogleSignIn(
      clientId: DefaultFirebaseOptions.currentPlatform.iosClientId));
  locator.registerFactory<AuthRepo>(
      () => AuthRepoImplementation(locator(), locator()));
  locator.registerFactory(() => SchemaHelper());
  locator.registerFactory<BaseClient>(() => BaseClientImplementation());
  locator.registerFactory<ChatRepo>(
      () => ChatRepoImplementation(locator(), locator()));
  locator.registerFactory<FirebaseFirestore>(() => FirebaseFirestore.instance);
  locator.registerFactory<VirtualFriendsRepo>(
      () => VirtualFriendsRepoImplementation(locator()));
  locator.registerFactory<RealUsersRepo>(() => RealUsersRepoImpl(locator()));

  locator.registerSingleton<FirebaseRemoteConfig>(rc);
  locator.registerFactory<RemoteConfigRepo>(
      () => RemoteConfigRepoImpl(client: locator()));
  locator.registerSingleton(Location());
  locator.registerFactory<DataFilterRepo>(() => DataFilterRepo());
  locator.registerFactory<AdminRepo>(() => AdminRepo(locator()));

  // fetching values from network during service locator invokation
  Future.wait([
    locator<RemoteConfigRepo>().getUserInfoFromIP(),
  ]);
}
