import 'package:dartz/dartz.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/core/constants/remote_config_values.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/schema_message_model.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/data/repository/chat_repo.dart';
import 'package:kpopchat/main.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  ChatCubit(this.chatRepo) : super(ChatLoadingState());

  UserModel? loggedInUser = SharedPrefsHelper.getUserProfile();

  /// this property to be used to show interstitial ad
  /// after sending three messages, we are targeting to show  interstitial ad to user
  /// Initializing it with 6 so that every time user sents first msg after opening app, we show ad first
  /// After showing ad, need to reset this to zero, and increase by 1 evertime user sends a msg
  /// again when it reaches 6, we show ad
  int messagesSent = RemoteConfigValues.msgsToAllowAfterShowingOneAd;
  int limit = RemoteConfigValues.msgsToAllowAfterShowingOneAd;
  bool shouldShowChatInterstitialAd() {
    messagesSent += 1;
    if (messagesSent <= limit) {
      return false;
    }
    messagesSent = 0; // resetting
    return true;
  }

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
      bool friendIsTyping = isVirtualFriendTyping[virtualFriend.id] ?? false;
      emit(friendIsTyping
          ? FriendTypingState(
              chatHistory: chatHistoryToEmit,
              typingUsers: [virtualFriend.toChatUser()],
              virtualFriendId: virtualFriend.id!)
          : ChatLoadedState(
              chatHistory: chatHistoryToEmit,
              virtualFriendId: virtualFriend.id!));
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
    response.fold((updatedSchemaMsgs) async {
      SchemaVirtualFriendModel schemaVirtualFriendModel =
          SchemaVirtualFriendModel(
              info: virtualFriend, chatHistory: updatedSchemaMsgs);
      List<ChatMessage> updatedChatHistory =
          schemaVirtualFriendModel.toListOfChatMessages();
      isVirtualFriendTyping[virtualFriendId] = true;
      emit(
          // isVirtualFriendTyping[virtualFriendId] ?? false
          // ?
          FriendTypingState(
              chatHistory: updatedChatHistory,
              typingUsers: [chatUserFriend],
              virtualFriendId: virtualFriendId)
          // :
          // ChatLoadedState(
          //     chatHistory: updatedChatHistory,
          //     virtualFriendId: virtualFriendId)
          );

      final friendMsgResponse =
          await chatRepo.getMsgFromVirtualFriend(schemaVirtualFriendModel);
      friendMsgResponse.fold((friendMsg) async {
        final Either<List<SchemaMessageModel>, FailureModel>
            msgsWithBotNewMsgResp = await chatRepo.getChatHistoryWithThisFriend(
                virtualFriendId: virtualFriendId,
                msgToAdd: friendMsg.toChatMessage(virtualFriend.toChatUser()));
        msgsWithBotNewMsgResp.fold((msgsWithFriendNewMsg) {
          SchemaVirtualFriendModel schemaVirtualFriendModel =
              SchemaVirtualFriendModel(
                  info: virtualFriend, chatHistory: msgsWithFriendNewMsg);
          List<ChatMessage> updatedChatHistoryWithBotNewMsg =
              schemaVirtualFriendModel.toListOfChatMessages();
          emit(ChatLoadedState(
              chatHistory: updatedChatHistoryWithBotNewMsg,
              virtualFriendId: virtualFriendId));
          isVirtualFriendTyping[virtualFriendId] = false;
        }, (r) {
          debugPrint("error saving bot new msg: ${r.message}");
        });
      }, (r) {
        isVirtualFriendTyping[virtualFriendId] = false;
        CommonWidgets.customFlushBar(navigatorKey.currentContext!,
            r.message ?? TextConstants.defaultErrorMsg);
        debugPrint("error getting bot msg: ${r.message}");
      });
    }, (r) {
      isVirtualFriendTyping[virtualFriendId] = false;
      debugPrint("error saving user msg: ${r.message}");
    });
  }
}
