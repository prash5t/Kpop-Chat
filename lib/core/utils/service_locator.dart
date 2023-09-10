import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kpopchat/core/firebase/firebase_options.dart';
import 'package:kpopchat/core/utils/schema_helper.dart';
import 'package:kpopchat/data/repository/auth_repo.dart';
import 'package:kpopchat/data/repository/chat_repo.dart';
import 'package:kpopchat/data/repository/virtual_friends_repo.dart';
import 'package:kpopchat/data/repository_implementation/auth_repo_implementation.dart';
import 'package:kpopchat/data/repository_implementation/chat_repo_implementation.dart';
import 'package:kpopchat/data/repository_implementation/virtual_friends_repo_implementation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

setUpLocator() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // locator.registerSingleton<SharedPreferences>(
  //     await SharedPreferences.getInstance());
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
  locator.registerFactory<ChatRepo>(() => ChatRepoImplementation(locator()));
  locator.registerFactory<FirebaseFirestore>(() => FirebaseFirestore.instance);
  locator.registerFactory<VirtualFriendsRepo>(
      () => VirtualFriendsRepoImplementation(locator()));
}
