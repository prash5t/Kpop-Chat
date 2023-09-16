// below class is used to deserialize data of values in conversations array of each virtual friends stored in schema
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';

class SchemaMessageModel {
  String? role;
  String? content;
  String? createdAt;
  bool? botReplied;
  SchemaMessageModel(
      {this.role, this.content, this.createdAt, this.botReplied});
  static const String kKeyRole = "role";
  static const String kKeyContent = "content";
  static const String kKeyCreatedAt = "createdAt";
  static const String kKeyFollowUpTime = "followupTime";
  static const String kKeybotReplied = "reply";

  /// msg can be from three entity which are (system, assistant and user)
  /// so below static constats are kept
  static const String kKeySystemRole = "system";
  static const String kKeyVirtualFriendRole = "virtual_friend";
  static const String kKeyUserRole = "user";

  SchemaMessageModel.fromJson(Map<String, dynamic> json) {
    role = json[kKeyRole];
    content = json[kKeyContent];
    createdAt = json[kKeyCreatedAt];
    botReplied = json[kKeybotReplied];
  }
  Map<String, dynamic> toJson() {
    return {kKeyRole: role, kKeyContent: content, kKeyCreatedAt: createdAt};
  }

  SchemaMessageModel.fromChatMessage(ChatMessage msg) {
    bool msgIsByUser =
        SharedPrefsHelper.getUserProfile()?.userId == msg.user.id;

    role = msgIsByUser
        ? SchemaMessageModel.kKeyUserRole
        : SchemaMessageModel.kKeyVirtualFriendRole;
    content = msg.text;
    createdAt = msg.createdAt.toString();
  }

  ChatMessage toChatMessage(ChatUser msgSender) {
    return ChatMessage(
        text: content ?? "",
        user: msgSender,
        createdAt: DateTime.parse(createdAt!).toLocal());
  }
}
