import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/network/failure_model.dart';

List<int> successStatusCodes = [200, 201, 202, 204];

Future<Either<T, FailureModel>> getParsedData<T>(
    Response? response, dynamic fromJson) async {
  if (response != null && successStatusCodes.contains(response.statusCode)) {
    //handle success here
    if (response.data is Map) {
      try {
        return Left(fromJson(response.data));
      } catch (e) {
        debugPrint("Error parsing data: $e");
        // return Right(Failure.fromJson({}));
        return Right(FailureModel.fromJson(response.data));
      }
    } else if (response.statusCode == 204) {
      // status code 204 means success but no response data
      return left(fromJson);
    } else {
      return Right(
        FailureModel.fromJson({}),
      );
    }
  } else {
    Map<String, dynamic>? failedRespData;
    try {
      failedRespData = response?.data;
    } catch (e) {
      debugPrint("Could not parse backend response as map");
      failedRespData = {};
    }

    return Right(
      FailureModel.fromJson(failedRespData ?? {}),
    );
  }
}
