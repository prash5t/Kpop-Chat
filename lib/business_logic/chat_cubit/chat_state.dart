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
  List<ChatMessage> chatHistory;
  String virtualFriendId;
  ChatLoadedState({required this.chatHistory, required this.virtualFriendId});
}

class FriendTypingState extends ChatState {
  List<ChatMessage> chatHistory;
  List<ChatUser> typingUsers;
  String virtualFriendId;
  FriendTypingState(
      {required this.chatHistory,
      required this.typingUsers,
      required this.virtualFriendId});
}

class ErrorState extends ChatState {}
