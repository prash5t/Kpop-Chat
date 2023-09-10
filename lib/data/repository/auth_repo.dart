import 'package:firebase_auth/firebase_auth.dart';

/// User authentication related repo for this app, Have methods to sign in, sign out methods
abstract class AuthRepo {
  Future<bool> signInWithGoogle();
  Future<void> registerUserProfile(User userInfo);
}
