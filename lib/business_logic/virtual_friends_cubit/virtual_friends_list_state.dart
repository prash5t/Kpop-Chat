import 'package:kpopchat/data/models/virtual_friend_model.dart';

abstract class VirtualFriendsListState {}

class VirtualFriendsInitialState extends VirtualFriendsListState {}

class VirtualFriendsLoadedState extends VirtualFriendsListState {
  final List<VirtualFriendModel> virtualFriends;

  VirtualFriendsLoadedState(this.virtualFriends);
}

class ErrorLoadingVirtualFriendsState extends VirtualFriendsListState {
  final String errorMsg;

  ErrorLoadingVirtualFriendsState(this.errorMsg);
}
