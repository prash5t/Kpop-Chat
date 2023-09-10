import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? userId;
  String? displayName;
  String? email;
  bool? emailVerified;
  bool? isAnonymous;
  String? photoURL;

  static const String kUid = "uid";
  static const String kDisplayName = "displayName";
  static const String kEmail = "email";
  static const String kEmailVerified = "isEmailVerified";
  static const String kIsAnonymous = "isAnonymous";
  static const String kPhotoURL = "photoURL";

  UserModel.fromFirebaseCurrentUser(User currentUser) {
    userId = currentUser.uid;
    displayName = currentUser.displayName;
    email = currentUser.email;
    emailVerified = currentUser.emailVerified;
    isAnonymous = currentUser.isAnonymous;
    photoURL = currentUser.photoURL;
  }

  Map<String, dynamic> toJson() {
    return {
      kUid: userId,
      kDisplayName: displayName,
      kEmail: email,
      kEmailVerified: emailVerified,
      kIsAnonymous: isAnonymous,
      kPhotoURL: photoURL
    };
  }
}
