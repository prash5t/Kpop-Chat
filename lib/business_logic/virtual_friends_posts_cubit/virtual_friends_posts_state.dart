import 'package:kpopchat/data/models/virtual_friend_post_model.dart';

abstract class VirtualFriendsPostsState {}

class InitialPostsState extends VirtualFriendsPostsState {}

class PostsLoadedState extends VirtualFriendsPostsState {
  final List<VirtualFriendPostModel> loadedPosts;

  PostsLoadedState({required this.loadedPosts});
}

class ErrorLoadingPostsState extends VirtualFriendsPostsState {
  final String errorMsg;

  ErrorLoadingPostsState({required this.errorMsg});
}
