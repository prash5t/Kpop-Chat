import 'package:dio/dio.dart';

abstract class BaseClient {
  Future<Response<dynamic>?> getRequest({
    String baseUrl = "",
    Map<String, String>? optionalHeaders,
    Map<String, dynamic>? queryParameters,
    required String path,
    bool showDialog = false,
    bool shouldCache = true,
    bool requiresAuthorization = true,
  });

  Future<Response<dynamic>?> postRequest({
    String baseUrl = "",
    Map<String, String>? optionalHeaders,
    Map<String, dynamic>? data,
    required String path,
    bool showDialog = false,
    bool requiresAuthorization = true,
  });
}
