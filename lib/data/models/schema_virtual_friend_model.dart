import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/schema_message_model.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'virtual_friend_model.dart';

class SchemaVirtualFriendModel {
  VirtualFriendModel? info;
  List<SchemaMessageModel>? chatHistory;
  SchemaVirtualFriendModel({this.info, this.chatHistory});
  static const String kInfo = "info";
  static const String kChatHistory = "chat_history";

  SchemaVirtualFriendModel.fromJson(Map<String, dynamic> json) {
    info = VirtualFriendModel.fromJson(json[kInfo]);
    chatHistory ??= [];
    for (Map<String, dynamic> msg in json[kChatHistory] ?? []) {
      chatHistory?.add(SchemaMessageModel.fromJson(msg));
    }
  }
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> history = [];
    for (SchemaMessageModel msg in chatHistory ?? []) {
      history.add(msg.toJson());
    }
    return {kInfo: info?.toJson(), kChatHistory: history};
  }

  List<ChatMessage> toListOfChatMessages() {
    List<ChatMessage> listOfChatMessages = [];
    UserModel? loggedInUser = SharedPrefsHelper.getUserProfile();
    ChatUser user = ChatUser(
        id: loggedInUser!.userId!,
        profileImage: loggedInUser.photoURL,
        firstName: loggedInUser.displayName);
    ChatUser friend = ChatUser(
        id: info!.id!,
        profileImage: info!.displayPictureUrl,
        firstName: info!.name);
    for (SchemaMessageModel eachMsg in chatHistory!) {
      final bool msgIsByUser = eachMsg.role == SchemaMessageModel.kKeyUserRole;
      final ChatMessage msg =
          eachMsg.toChatMessage(msgIsByUser ? user : friend);

      listOfChatMessages.add(msg);
    }
    return listOfChatMessages;
  }
}
