import 'package:dartz/dartz.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';

abstract class VirtualFriendsRepo {
  Future<Either<bool, FailureModel>> createVirtualFriend(
      {required VirtualFriendModel virtualFriendInfo});
  Future<Either<List<VirtualFriendModel>, FailureModel>> getVirtualFriends();
}
