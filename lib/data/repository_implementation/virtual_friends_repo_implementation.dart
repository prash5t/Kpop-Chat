import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/constants/firestore_collections_constants.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/data/repository/virtual_friends_repo.dart';
import 'package:uuid/uuid.dart';

class VirtualFriendsRepoImplementation implements VirtualFriendsRepo {
  final FirebaseFirestore firestore;

  VirtualFriendsRepoImplementation(this.firestore);
  @override
  Future<Either<bool, FailureModel>> createVirtualFriend(
      {required VirtualFriendModel virtualFriendInfo}) async {
    try {
      String virtualFriendId = const Uuid().v1();
      virtualFriendInfo.id = virtualFriendId;
      await firestore
          .collection(FirestoreCollections.kVirtualFriends)
          .doc(virtualFriendId)
          .set(virtualFriendInfo.toJson());
      return const Left(true);
    } catch (e) {
      debugPrint("error creating virtual friend: ${e.toString()}");
      return Right(
          FailureModel(message: "Sorry, your virtual friend was not created."));
    }
  }

  @override
  Future<Either<List<VirtualFriendModel>, FailureModel>>
      getVirtualFriends() async {
    try {
      List<VirtualFriendModel> virtualFriends = [];
      QuerySnapshot virtualFriendsSnapshot = await firestore
          .collection(FirestoreCollections.kVirtualFriends)
          .orderBy(VirtualFriendModel.kOrder)
          .get();

      for (DocumentSnapshot friend in virtualFriendsSnapshot.docs) {
        VirtualFriendModel virtualFriend =
            VirtualFriendModel.fromJson(friend.data() as Map<String, dynamic>);
        virtualFriends.add(virtualFriend);
      }
      return Left(virtualFriends);
    } catch (e) {
      debugPrint("error getting virtual friends: ${e.toString()}");
      return Right(FailureModel(
          message:
              "Sorry, your virtual friends are not available at the moment."));
    }
  }
}
