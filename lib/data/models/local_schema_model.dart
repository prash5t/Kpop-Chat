import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kpopchat/core/utils/schema_helper.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';

class LocalSchemaModelOfLoggedInUser {
  List<SchemaVirtualFriendModel>? virtualFriends;
  LocalSchemaModelOfLoggedInUser({this.virtualFriends});
  static const String kVirtualFriends = "virtual_friends";

  /// Provide whole schema in string, id of logged in user and get model of schema for this logged in user
  LocalSchemaModelOfLoggedInUser.fromLocalSchema(
      {required String localSchema}) {
    String? loggedInUserId = locator<FirebaseAuth>().currentUser?.uid;

    List<dynamic>? friendsInSchema = jsonDecode(localSchema)[loggedInUserId];

    virtualFriends ??= [];
    if (friendsInSchema != null) {
      for (Map<String, dynamic> eachVirtualFriend in friendsInSchema) {
        virtualFriends!
            .add(SchemaVirtualFriendModel.fromJson(eachVirtualFriend));
      }
    }
  }

  /// To be used to save virtual friends data from network to local schema
  Future<Map<String, dynamic>> toJson() async {
    String? loggedInUserId = locator<FirebaseAuth>().currentUser?.uid;
    Map<String, dynamic> localSchema =
        jsonDecode(await SchemaHelper().getLocalSchema() ?? "{}");
    List<Map<String, dynamic>> virtualFriendsToStoreInSchema = [];
    for (SchemaVirtualFriendModel vf in virtualFriends!) {
      virtualFriendsToStoreInSchema.add(vf.toJson());
    }

    localSchema[loggedInUserId!] = virtualFriendsToStoreInSchema;

    return localSchema;
  }
}
