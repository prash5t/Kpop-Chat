import 'package:dartz/dartz.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/schema_message_model.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/data/repository/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  ChatCubit(this.chatRepo) : super(ChatLoadingState());

  UserModel? loggedInUser = SharedPrefsHelper.getUserProfile();

  /// to track  chat screen is open or not with any virtual friends
  Map<String, bool> chatScreenOpen = {};

  /// to track what logged in user is currently typing so that draft(unsent/msg in textfield) msg can be preserved back when user comes back from other screen to chat screen
  Map<String, String> userMsgOnTextfield = {};

  /// to track virtual friends who are typing
  Map<String, bool> isVirtualFriendTyping = {};

  /// to get chat history between logged in user and selected virtual friend
  void loadChatHistory(VirtualFriendModel virtualFriend) async {
    final Either<List<SchemaMessageModel>, FailureModel> response =
        await chatRepo.getChatHistoryWithThisFriend(
            virtualFriendId: virtualFriend.id!);
    List<ChatMessage> chatHistoryToEmit = [];
    response.fold((chatHistory) {
      SchemaVirtualFriendModel schemaVirtualFriendModel =
          SchemaVirtualFriendModel(
              info: virtualFriend, chatHistory: chatHistory);
      chatHistoryToEmit = schemaVirtualFriendModel.toListOfChatMessages();

      emit(ChatLoadedState(
          chatHistory: chatHistoryToEmit, virtualFriendId: virtualFriend.id!));
    }, (r) {
      debugPrint("error fetching chat history: ${r.message}");
      emit(ChatLoadedState(
          chatHistory: chatHistoryToEmit, virtualFriendId: virtualFriend.id!));
    });
  }

  void sendNewMsgToFriend(
      ChatMessage userNewMsg, VirtualFriendModel virtualFriend) async {
    String virtualFriendId = virtualFriend.id!;
    ChatUser chatUserFriend = virtualFriend.toChatUser();

    final Either<List<SchemaMessageModel>, FailureModel> response =
        await chatRepo.getChatHistoryWithThisFriend(
            virtualFriendId: virtualFriendId, msgToAdd: userNewMsg);
    response.fold((updatedSchemaMsgs) {
      SchemaVirtualFriendModel schemaVirtualFriendModel =
          SchemaVirtualFriendModel(
              info: virtualFriend, chatHistory: updatedSchemaMsgs);
      List<ChatMessage> updatedChatHistory =
          // SchemaVirtualFriendModel()
          schemaVirtualFriendModel.toListOfChatMessages(
              // virtualFriend, updatedSchemaMsgs
              );
      emit(isVirtualFriendTyping[virtualFriendId] ?? false
          ? FriendTypingState(
              chatHistory: updatedChatHistory,
              typingUsers: [chatUserFriend],
              virtualFriendId: virtualFriendId)
          : ChatLoadedState(
              chatHistory: updatedChatHistory,
              virtualFriendId: virtualFriendId));
    }, (r) {
      debugPrint("error saving user msg: ${r.message}");
    });
  }
}
