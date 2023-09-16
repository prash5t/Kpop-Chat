import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/constants/firestore_collections_constants.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/main.dart';
import 'package:kpopchat/data/repository/auth_repo.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepoImplementation implements AuthRepo {
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;

  AuthRepoImplementation(this.googleSignIn, this.firestore);
  @override
  Future<bool> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return false;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential googleUserCredential = await locator<FirebaseAuth>()
          .signInWithCredential(googleAuthCredential);

      User? loggedInUser = googleUserCredential.user;
      SharedPrefsHelper.saveUserProfile(loggedInUser);
      setUserIdInAnalytics(SharedPrefsHelper.getUserProfile());
      final bool isNewUser =
          googleUserCredential.additionalUserInfo?.isNewUser ?? true;
      if (isNewUser) {
        registerUserProfile(loggedInUser);
      }

      debugPrint("user creds: ${googleUserCredential.user.toString()}");
      CommonWidgets.customFlushBar(
          navigatorKey.currentContext!, "sign in success");

      return true;
    } catch (e) {
      debugPrint("error sign in with google: ${e.toString()}");
      CommonWidgets.customFlushBar(
          navigatorKey.currentContext!, "sign in fail");
      return false;
    }
  }

  @override
  Future<void> registerUserProfile(User? userInfo) async {
    try {
      if (userInfo != null) {
        Map<String, dynamic> userData =
            UserModel.fromFirebaseCurrentUser(userInfo).toJson();

        await firestore
            .collection(FirestoreCollections.kUsers)
            .doc(userInfo.uid)
            .set(userData);
      }
    } catch (e) {
      debugPrint("Could not register user profile: ${e.toString()}");
    }
  }
}
