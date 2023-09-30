import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/constants/location_constants.dart';
import 'package:kpopchat/core/constants/network_constants.dart';
import 'package:kpopchat/core/network/client/base_client.dart';
import 'package:kpopchat/core/network/failure_model.dart';
import 'package:kpopchat/core/network/functions/get_parsed_data.dart';
import 'package:kpopchat/data/models/lat_long_model.dart';
import 'package:kpopchat/data/models/user_info_from_ip_model.dart';
import 'package:kpopchat/data/repository/remote_config_repo.dart';

class RemoteConfigRepoImpl implements RemoteConfigRepo {
  final BaseClient _client;

  RemoteConfigRepoImpl({required BaseClient client}) : _client = client;

  @override
  Future<void> getUserInfoFromIP() async {
    final response = await _client.getRequest(
        path: NetworkConstants.urlForIPInfo, requiresAuthorization: false);
    Either<UserInfoFromIPModel, FailureModel> infoFromIP =
        await getParsedData(response, UserInfoFromIPModel.fromJson);
    infoFromIP.fold((receivedInfo) {
      LocationConstants.userLocationFromIP =
          LatLong(lat: receivedInfo.lat, long: receivedInfo.lon);
      debugPrint("REMOTE CONFIG: values from IP received");
    }, (r) {
      debugPrint("error receiving info from ip: ${r.message}");
    });
  }
}
