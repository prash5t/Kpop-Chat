import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'firebase_options.dart';

class FirebaseSetup {
  //Constructor for Firebase Setup
  FirebaseSetup();

  //Initilalizing firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
        name: Platform.isAndroid ? (TextConstants.appName) : null,
        options: DefaultFirebaseOptions.currentPlatform);

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
