import 'package:kpopchat/data/models/local_schema_model.dart';

abstract class VirtualFriendsListState {}

class VirtualFriendsInitialState extends VirtualFriendsListState {}

class VirtualFriendsLoadedState extends VirtualFriendsListState {
  final LocalSchemaModelOfLoggedInUser localSchemaModelOfLoggedInUser;

  VirtualFriendsLoadedState(this.localSchemaModelOfLoggedInUser);
}

class ErrorLoadingVirtualFriendsState extends VirtualFriendsListState {
  final String errorMsg;

  ErrorLoadingVirtualFriendsState(this.errorMsg);
}
