import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/constants/firestore_collections_constants.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/core/utils/schema_helper.dart';
import 'package:kpopchat/data/models/local_schema_model.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/data/models/virtual_friend_post_model.dart';
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
  Future<Either<LocalSchemaModelOfLoggedInUser, FailureModel>>
      getVirtualFriends() async {
    try {
// first try to fetch virtual friends locally, if exist locally, provide locally available virtual friends
      LocalSchemaModelOfLoggedInUser locallyExistingFriends =
          LocalSchemaModelOfLoggedInUser.fromLocalSchema(
              localSchema: await SchemaHelper().getLocalSchema() ?? "{}");
      if (locallyExistingFriends.virtualFriends!.isNotEmpty) {
        debugPrint("Locally");
        return Left(locallyExistingFriends);
      }
      debugPrint("From network");
      LocalSchemaModelOfLoggedInUser localSchemaModelOfLoggedInUser =
          LocalSchemaModelOfLoggedInUser(virtualFriends: []);

      QuerySnapshot virtualFriendsSnapshot = await firestore
          .collection(FirestoreCollections.kVirtualFriends)
          .orderBy(VirtualFriendModel.kOrder)
          .get();

      for (DocumentSnapshot friend in virtualFriendsSnapshot.docs) {
        VirtualFriendModel virtualFriend =
            VirtualFriendModel.fromJson(friend.data() as Map<String, dynamic>);

        localSchemaModelOfLoggedInUser.virtualFriends!.add(
            SchemaVirtualFriendModel(info: virtualFriend, chatHistory: []));
      }
      // after fetching virtual friends from network, saving it locally too
      await SchemaHelper().saveLocalSchema(localSchemaModelOfLoggedInUser);
      return Left(localSchemaModelOfLoggedInUser);
    } catch (e) {
      debugPrint("error getting virtual friends: ${e.toString()}");
      return Right(FailureModel(
          message:
              "Sorry, your virtual friends are not available at the moment."));
    }
  }

  @override
  Future<Either<List<VirtualFriendPostModel>, FailureModel>>
      getVirtualFriendsPosts() async {
    try {
      List<VirtualFriendPostModel> posts = [];
      QuerySnapshot postsSnapshot = await firestore
          .collection(FirestoreCollections.kVirtualFriendsPosts)
          .orderBy(VirtualFriendPostModel.kDatePublished, descending: true)
          .get();
      for (DocumentSnapshot post in postsSnapshot.docs) {
        VirtualFriendPostModel postData = VirtualFriendPostModel.fromJson(
            post.data() as Map<String, dynamic>);
        posts.add(postData);
      }
      return Left(posts);
    } catch (e) {
      debugPrint("Error fetching posts: ${e.toString()}");
      return Right(FailureModel(
          message: "Sorry, Could not fetch Kpop Fans posts at the moment."));
    }
  }
}
