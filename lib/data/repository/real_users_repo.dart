import 'package:dartz/dartz.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/data/models/user_model.dart';

abstract class RealUsersRepo {
  Future<Either<List<UserModel>, FailureModel>> fetchRealUsersData();
  Future<void> updateUserLocationAndGhostModeStatus(UserModel updatedUserData);
}
