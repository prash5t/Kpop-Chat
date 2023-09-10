part of 'chat_cubit.dart';

abstract class ChatState {
  const ChatState();
}

class ChatLoadingState extends ChatState {
  String? virtualFriendId;
  ChatLoadingState({this.virtualFriendId});
}

class ErrorReceivingBotMsgState extends ChatState {
  ErrorReceivingBotMsgState();
}

class ChatLoadedState extends ChatState {
  List<ChatMessage> conversationHistory;
  String virtualFriendId;
  ChatLoadedState(
      {required this.conversationHistory, required this.virtualFriendId});
}

class BotTypingState extends ChatState {
  List<ChatMessage> conversationHistory;
  List<ChatUser> typingUsers;
  String virtualFriendId;
  BotTypingState(
      {required this.conversationHistory,
      required this.typingUsers,
      required this.virtualFriendId});
}

class ErrorState extends ChatState {}
