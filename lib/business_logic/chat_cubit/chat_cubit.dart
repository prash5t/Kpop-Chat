import 'package:dartz/dartz.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/schema_message_model.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/data/repository/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  ChatCubit(this.chatRepo) : super(ChatLoadingState());

  UserModel? loggedInUser = SharedPrefsHelper.getUserProfile();

  Map<String, dynamic> chatScreenOpen = {};
  void loadChatHistory(VirtualFriendModel virtualFriend) async {
    final Either<List<SchemaMessageModel>, FailureModel> response =
        await chatRepo.getChatWithThisFriend(virtualFriend.id!);
    List<ChatMessage> chatHistoryToEmit = [];
    response.fold((l) {
      final List<SchemaMessageModel> chatHistory = l;
      for (SchemaMessageModel eachMsg in chatHistory) {
        final bool msgIsByUser =
            eachMsg.role == SchemaMessageModel.kKeyUserRole;
        ChatUser msgSender = msgIsByUser
            ? ChatUser(
                id: loggedInUser!.userId!,
                profileImage: loggedInUser!.photoURL,
                firstName: loggedInUser!.displayName)
            : ChatUser(
                id: virtualFriend.id!,
                profileImage: virtualFriend.displayPictureUrl,
                firstName: virtualFriend.name);
        final ChatMessage message = ChatMessage(
            text: eachMsg.content!,
            user: msgSender,
            createdAt: DateTime.parse(eachMsg.createdAt!).toLocal());
        chatHistoryToEmit.add(message);
      }
      emit(ChatLoadedState(
          chatHistory: chatHistoryToEmit, virtualFriendId: virtualFriend.id!));
    }, (r) {
      debugPrint("error fetching chat history: ${r.message}");
      emit(ChatLoadedState(
          chatHistory: chatHistoryToEmit, virtualFriendId: virtualFriend.id!));
    });
  }
}
