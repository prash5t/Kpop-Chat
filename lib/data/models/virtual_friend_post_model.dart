import 'package:kpopchat/data/models/virtual_friend_model.dart';

class VirtualFriendPostModel {
  String? postId;
  DateTime? datePublished;
  VirtualFriendModel? poster;
  String? caption;
  int? viewsCount;

  VirtualFriendPostModel(
      {this.postId,
      this.datePublished,
      this.poster,
      this.caption,
      this.viewsCount});

  static const String kDatePublished = "date_published";
  static const String kPostId = "post_id";
  static const String kPoster = "poster";
  static const String kCaption = "caption";
  static const String kViewsCount = "views_count";

  Map<String, dynamic> toJson() => {
        kDatePublished: datePublished,
        kPostId: postId,
        kPoster: poster?.toJson(),
        kCaption: caption,
        kViewsCount: viewsCount
      };

  VirtualFriendPostModel.fromJson(Map<String, dynamic> json) {
    postId = json[kPostId];
    datePublished = json[kDatePublished].toDate();
    poster = VirtualFriendModel.fromJson(json[kPoster]);
    caption = json[kCaption];
    viewsCount = json[kViewsCount];
  }
}
