import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kpopchat/core/constants/firestore_collections_constants.dart';
import 'package:kpopchat/core/constants/location_constants.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/core/utils/loading_utils.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:kpopchat/data/repository/auth_repo.dart';
import 'package:kpopchat/main.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';

class AuthRepoImplementation implements AuthRepo {
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;

  AuthRepoImplementation(this.googleSignIn, this.firestore);

  @override
  Future<bool> signInWithGoogle() async {
    LoadingUtils.showLoadingDialog();
    final GoogleSignInAccount account;
    try {
      // google_sign_in v7 — authenticate() throws on cancel/error;
      // returns a non-null account on success (vs v6's nullable signIn()).
      account = await googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      LoadingUtils.hideLoadingDialog();
      debugPrint("google sign-in cancelled or failed: ${e.code} ${e.description}");
      return false;
    }

    // v7 split: authentication carries idToken; access token (when needed)
    // comes from authorizationClient. For Firebase Auth, idToken alone is
    // sufficient — accessToken is no longer required by GoogleAuthProvider.
    final GoogleSignInAuthentication googleAuth = account.authentication;

    final OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final UserCredential googleUserCredential = await locator<FirebaseAuth>()
        .signInWithCredential(googleAuthCredential);

    User? loggedInUser = googleUserCredential.user;

    SharedPrefsHelper.saveUserProfileFromLogin(loggedInUser);
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
  }

  @override
  Future<void> registerUserProfile(User? userInfo) async {
    try {
      if (userInfo != null) {
        UserModel userData = UserModel.fromFirebaseCurrentUser(userInfo);
        userData.anonymizeLocation = true;
        userData.latLong = LocationConstants.userLocationFromIP;

        await firestore
            .collection(FirestoreCollections.kUsers)
            .doc(userInfo.uid)
            .set(userData.toJson());
      }
    } catch (e) {
      debugPrint("Could not register user profile: ${e.toString()}");
    }
  }
}
