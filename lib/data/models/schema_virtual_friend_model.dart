import 'package:kpopchat/data/models/schema_message_model.dart';
import 'virtual_friend_model.dart';

class SchemaVirtualFriendModel {
  VirtualFriendModel? info;
  List<SchemaMessageModel>? chatHistory;

  static const String kInfo = "info";
  static const String kChatHistory = "chat_history";

  SchemaVirtualFriendModel.fromJson(Map<String, dynamic> json) {
    info = VirtualFriendModel.fromJson(json[kInfo]);
    json[kChatHistory].forEach((Map<String, dynamic> msg) {
      chatHistory!.add(SchemaMessageModel.fromJson(msg));
    });
  }
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> history = [];
    for (SchemaMessageModel msg in chatHistory ?? []) {
      history.add(msg.toJson());
    }
    return {kInfo: info?.toJson(), kChatHistory: history};
  }
}
