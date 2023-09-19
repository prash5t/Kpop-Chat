import 'package:dartz/dartz.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/constants/analytics_constants.dart';
import 'package:kpopchat/core/constants/network_constants.dart';
import 'package:kpopchat/core/constants/remote_config_values.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/network/client/base_client.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/core/utils/schema_helper.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/local_schema_model.dart';
import 'package:kpopchat/data/models/open_ai_resp_model.dart';
import 'package:kpopchat/data/models/schema_message_model.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';
import 'package:kpopchat/data/repository/chat_repo.dart';

class ChatRepoImplementation implements ChatRepo {
  final SchemaHelper schemaHelper;
  final BaseClient baseClient;

  ChatRepoImplementation(this.schemaHelper, this.baseClient);
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

  @override
  Future<Either<SchemaMessageModel, FailureModel>> getMsgFromVirtualFriend(
      SchemaVirtualFriendModel schemaVirtualFriend) async {
    Map<String, dynamic>? userInfo =
        SharedPrefsHelper.getUserProfile()?.toJson();
    List<Map<String, dynamic>> previousHistory =
        schemaVirtualFriend.toListOfJsonMessages();
    Map<String, dynamic> payloadForEdenAI = {
      "providers": "openai",
      "text": schemaVirtualFriend.chatHistory?.first.message ?? "Hello",
      "chatbot_global_action":
          "${RemoteConfigValues.systemMsg} ${schemaVirtualFriend.info?.toJson()} ${userInfo != null ? "and information of user you are responding to is: $userInfo" : ""}",
      "previous_history":
          previousHistory.take(RemoteConfigValues.maxMessagesToTake).toList(),
      "temperature": RemoteConfigValues.temperature,
      "max_tokens": RemoteConfigValues.maxTokens
    };
    try {
      final response = await baseClient.postRequest(
        baseUrl: NetworkConstants.edenAIbaseUrl,
        path: NetworkConstants.edenAIChatPath,
        data: payloadForEdenAI,
      );
      OpenAIResponseModel friendResp =
          OpenAIResponseModel.fromJson(response?.data);

      // log credit consumed to mixpanel
      increasePropertyCount(AnalyticsConstants.kPropertyEdenAiCreditSpent,
          friendResp.openai?.cost ?? 0);
      SchemaMessageModel virtualFriendMsg = SchemaMessageModel(
          role: SchemaMessageModel.kKeyVirtualFriendRole,
          message: friendResp.openai?.generatedText ?? "Listening...",
          createdAt: DateTime.now().toString());

      return Left(virtualFriendMsg);
    } catch (e) {
      debugPrint("Exception getting eden ai resp: ${e.toString()}");
      return Right(FailureModel(message: TextConstants.defaultErrorMsg));
    }
  }
}
