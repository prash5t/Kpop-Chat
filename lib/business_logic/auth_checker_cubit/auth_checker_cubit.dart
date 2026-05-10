import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kpopchat/business_logic/virtual_friends_list_cubit/virtual_friends_list_cubit.dart';
import 'package:kpopchat/core/constants/firestore_collections_constants.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/main.dart';

class AuthCheckerCubit extends Cubit<AuthStates> {
  AuthCheckerCubit() : super(AuthStates.loadingState);
  GoogleSignIn googleSignIn = locator<GoogleSignIn>();
  FirebaseAuth firebaseAuth = locator<FirebaseAuth>();

  /// Emits loggedOutState if firebase currentUser is null,
  /// otherwise emits loggedInState
  void checkUserAuth() async {
    await Future.delayed(Duration.zero);
    final User? loggedInUser = firebaseAuth.currentUser;

    emit(loggedInUser != null
        ? AuthStates.loggedInState
        : AuthStates.loggedOutState);
  }

  /// Sign out from google and navigate to sign in screen
  void signOutUser() async {
    SharedPrefsHelper.clearAll();
    locator<FlutterSecureStorage>().deleteAll();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    emit(AuthStates.loggedOutState);
    Navigator.of(navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil(AppRoutes.signInScreen, (route) => false);
    BlocProvider.of<VirtualFriendsListCubit>(navigatorKey.currentContext!)
        .resetVirtualFriendsListState();
  }

  /// In-app account deletion. Permanently removes the Firestore profile
  /// doc, the Firebase Auth user, the Google Sign-In token, and all local
  /// shared-prefs / secure-storage values.
  ///
  /// Returns a [DeletionOutcome] so the menu screen can surface the right
  /// message. Mirrors the path described in the public account-deletion
  /// policy page: in-app + email fallback.
  Future<DeletionOutcome> deleteUserAccount() async {
    final User? user = firebaseAuth.currentUser;
    if (user == null) {
      // Already signed out — treat as success and bounce to sign-in.
      _navigateToSignIn();
      return DeletionOutcome.success;
    }
    final String uid = user.uid;

    // Best-effort cleanup of the Firestore profile doc. We do this BEFORE
    // auth.delete so we still have a valid auth context if security rules
    // require it. Failures here aren't fatal — the auth.delete call is the
    // critical step for Play compliance.
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.kUsers)
          .doc(uid)
          .delete();
    } catch (e) {
      debugPrint("Could not delete Firestore user profile: $e");
    }

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      // 'requires-recent-login' — Firebase enforces fresh credentials for
      // destructive ops. The user must re-sign-in within the last few
      // minutes. Surface this so the menu screen falls back to the email
      // path (which the public policy page also documents).
      if (e.code == 'requires-recent-login') {
        return DeletionOutcome.requiresReauth;
      }
      debugPrint("Firebase user delete failed: ${e.code} ${e.message}");
      return DeletionOutcome.failed;
    }

    // Auth user is gone — sweep local state and Google session.
    SharedPrefsHelper.clearAll();
    await locator<FlutterSecureStorage>().deleteAll();
    try {
      await googleSignIn.disconnect();
    } catch (_) {}
    try {
      await googleSignIn.signOut();
    } catch (_) {}

    _navigateToSignIn();
    return DeletionOutcome.success;
  }

  void _navigateToSignIn() {
    emit(AuthStates.loggedOutState);
    Navigator.of(navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil(AppRoutes.signInScreen, (route) => false);
  }
}

enum DeletionOutcome { success, requiresReauth, failed }

enum AuthStates { loadingState, loggedInState, loggedOutState }
