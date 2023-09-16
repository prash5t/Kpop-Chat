import 'package:dash_chat_2/dash_chat_2.dart';

class VirtualFriendModel {
  String? id;
  int? order;
  String? name;
  String? country;
  String? city;
  String? displayPictureUrl;
  String? profession;
  String? lastUnlockedTime;
  List<dynamic>? hobbies;
  int? age;
  VirtualFriendModel(
      {this.id,
      this.order,
      this.name,
      this.country,
      this.city,
      this.displayPictureUrl,
      this.profession,
      this.lastUnlockedTime,
      this.hobbies});

  static const String kId = "id";
  static const String kOrder = "order";
  static const String kName = "name";
  static const String kCountry = "country";
  static const String kCity = "city";
  static const String kDisplayPictureUrl = "display_picture_url";
  static const String kProfession = "profession";
  static const String kLastUnlockedTime = "last_unlocked_time";
  static const String kHobbies = "hobbies";
  static const String kAge = "age";

  VirtualFriendModel.fromJson(Map<String, dynamic> json) {
    id = json[kId];
    order = json[kOrder];
    name = json[kName];
    country = json[kCountry];
    city = json[kCity];
    displayPictureUrl = json[kDisplayPictureUrl];
    profession = json[kProfession];
    lastUnlockedTime = json[kLastUnlockedTime];
    hobbies = json[kHobbies];
    age = json[kAge];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json[kId] = id;
    json[kOrder] = order;
    json[kName] = name;
    json[kCountry] = country;
    json[kCity] = city;
    json[kDisplayPictureUrl] = displayPictureUrl;
    json[kProfession] = profession;
    json[kLastUnlockedTime] = lastUnlockedTime;
    json[kHobbies] = hobbies;
    json[kAge] = age;
    return json;
  }

  ChatUser toChatUser() {
    return ChatUser(id: id!, profileImage: displayPictureUrl, firstName: name);
  }
}
