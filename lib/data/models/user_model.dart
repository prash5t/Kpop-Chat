import 'package:firebase_auth/firebase_auth.dart';
import 'package:kpopchat/data/models/lat_long_model.dart';

class UserModel {
  String? userId;
  String? displayName;
  String? email;
  bool? emailVerified;
  bool? isAnonymous;
  String? photoURL;
  int? kpopScore;
  LatLong? latLong;
  bool? anonymizeLocation;

  static const String kUid = "uid";
  static const String kDisplayName = "displayName";
  static const String kEmail = "email";
  static const String kEmailVerified = "isEmailVerified";
  static const String kIsAnonymous = "isAnonymous";
  static const String kPhotoURL = "photoURL";
  static const String kScore = "score";
  static const String kLatLong = "lat_long";
  static const String kAnonymizeLocation = "anonymize_Location";

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json[kUid];
    displayName = json[kDisplayName];
    email = json[kEmail];
    emailVerified = json[kEmailVerified];
    isAnonymous = json[kIsAnonymous];
    photoURL = json[kPhotoURL];
    kpopScore = json[kScore];
    latLong = json[kLatLong];
    anonymizeLocation = json[kAnonymizeLocation];
  }

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
      kPhotoURL: photoURL,
      kScore: kpopScore,
      kLatLong: latLong,
      kAnonymizeLocation: anonymizeLocation
    };
  }
}
