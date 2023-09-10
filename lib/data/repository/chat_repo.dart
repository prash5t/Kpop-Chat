import 'package:dartz/dartz.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/data/models/schema_message_model.dart';

abstract class ChatRepo {
  Future<Either<List<SchemaMessageModel>, FailureModel>> getChatWithThisFriend(
      String virtualFriendId);
}
