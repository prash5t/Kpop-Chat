import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';

class LocalSchemaModelOfLoggedInUser {
  List<SchemaVirtualFriendModel>? virtualFriends;
  LocalSchemaModelOfLoggedInUser({this.virtualFriends});
  static const String kVirtualFriends = "virtual_friends";

  /// Provide whole schema in string, id of logged in user and get model of schema for this logged in user
  LocalSchemaModelOfLoggedInUser.fromJson({required String localSchema}) {
    String? loggedInUserId = locator<FirebaseAuth>().currentUser?.uid;
    Map<String, dynamic> schemaSavedForThisUser =
        jsonDecode(localSchema)[loggedInUserId];
    List<Map<String, dynamic>>? friendsInSchema =
        schemaSavedForThisUser[kVirtualFriends];
    if (friendsInSchema != null) {
      for (Map<String, dynamic> eachVirtualFriend in friendsInSchema) {
        virtualFriends
            ?.add(SchemaVirtualFriendModel.fromJson(eachVirtualFriend));
      }
    }
  }
}
