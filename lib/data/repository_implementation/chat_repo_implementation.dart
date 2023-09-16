import 'package:dartz/dartz.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/core/utils/schema_helper.dart';
import 'package:kpopchat/data/models/local_schema_model.dart';
import 'package:kpopchat/data/models/schema_message_model.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';
import 'package:kpopchat/data/repository/chat_repo.dart';

class ChatRepoImplementation implements ChatRepo {
  final SchemaHelper schemaHelper;

  ChatRepoImplementation(this.schemaHelper);
  @override
  Future<Either<List<SchemaMessageModel>, FailureModel>>
      getChatHistoryWithThisFriend(
          {required String virtualFriendId, ChatMessage? msgToAdd}) async {
    try {
      final String? localSchema = await schemaHelper.getLocalSchema();
      // if (localSchema == null) {
      //   return Left(chatHistory);
      // }
      LocalSchemaModelOfLoggedInUser schemaModelOfLoggedInUser =
          LocalSchemaModelOfLoggedInUser.fromLocalSchema(
              localSchema: localSchema ?? "{}");

      for (SchemaVirtualFriendModel virtualFriend
          in schemaModelOfLoggedInUser.virtualFriends ?? []) {
        if (virtualFriendId == virtualFriend.info?.id) {
          if (msgToAdd != null) {
            SchemaMessageModel schemaMessage =
                SchemaMessageModel.fromChatMessage(msgToAdd);
            // sync msg locally
            virtualFriend.chatHistory!.insert(0, schemaMessage);
            await SchemaHelper().saveLocalSchema(schemaModelOfLoggedInUser);
          }
          return Left(virtualFriend.chatHistory!);
        }
      }

      // if there is no records of virtual friend with provided id then also return empty chat history
      return const Left([]);
    } catch (e) {
      debugPrint("exception at chat_repo_implementation.dart: ${e.toString()}");
      return Right(
          FailureModel(message: "Could not fetch chat history at the moment."));
    }
  }
}
