import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/constants/firestore_collections_constants.dart';
import 'package:kpopchat/core/constants/shared_preferences_keys.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:kpopchat/data/repository/real_users_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RealUsersRepoImpl extends RealUsersRepo {
  final FirebaseFirestore firestore;

  RealUsersRepoImpl(this.firestore);

  @override
  Future<Either<List<UserModel>, FailureModel>> fetchRealUsersData() async {
    try {
      List<UserModel> realUsers = [];
      // Get real users data excluding logged in user
      QuerySnapshot realUsersSnapshot =
          await firestore.collection(FirestoreCollections.kUsers).get();

      for (DocumentSnapshot realUser in realUsersSnapshot.docs) {
        UserModel user =
            UserModel.fromJson(realUser.data() as Map<String, dynamic>);
        realUsers.add(user);
      }
      return Left(realUsers);
    } catch (e) {
      debugPrint("error getting real users data: ${e.toString()}");
      return Right(
          FailureModel(message: "Failed to retreive other users information"));
    }
  }

  @override
  Future<void> updateUserLocationAndGhostModeStatus(
      UserModel updatedUserData) async {
    try {
      await firestore
          .collection(FirestoreCollections.kUsers)
          .doc(updatedUserData.userId)
          .set(updatedUserData.toJson());
      locator<SharedPreferences>().setString(
          SharedPrefsKeys.kUserProfile, jsonEncode(updatedUserData.toJson()));
      debugPrint("User location data updated");
    } catch (e) {
      debugPrint("error updating user loc and ghost mode: ${e.toString()}");
    }
  }
}
