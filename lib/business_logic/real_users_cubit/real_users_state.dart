import 'package:kpopchat/data/models/user_model.dart';

abstract class RealUsersState {}

class RealUsersInitialState extends RealUsersState {}

class RealUsersLoadedState extends RealUsersState {
  final List<UserModel> realUsers;

  RealUsersLoadedState(this.realUsers);
}

class ErrorLoadingRealUsersState extends RealUsersState {
  final String errorMsg;

  ErrorLoadingRealUsersState(this.errorMsg);
}
