import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kpopchat/core/network/client/base_client.dart';
import 'package:kpopchat/core/network/functions/get_header.dart';
import 'package:kpopchat/presentation/common_widgets/network_call_loading_widgets.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class BaseClientImplementation extends BaseClient {
  @override
  Future<Response<dynamic>?> getRequest({
    String baseUrl = "",
    Map<String, String>? optionalHeaders,
    Map<String, dynamic>? queryParameters,
    required String path,
    bool showDialog = false,
    bool shouldCache = true,
    bool requiresAuthorization = true,
  }) async {
    Response? response;
    if (showDialog) {
      showLoadingDialog();
    }

    try {
      Map<String, String> header =
          getHeader(requiresAuthorization: requiresAuthorization);
      if (optionalHeaders != null) {
        header.addAll(optionalHeaders);
      }
      Dio dio = Dio();
      if (kDebugMode) {
        dio.interceptors.add(PrettyDioLogger(
          error: true,
          requestBody: true,
          requestHeader: true,
          request: false,
          responseBody: false,
        ));
      }
      response = await dio.get(
        baseUrl + path,
        options: Options(
          headers: header,
          sendTimeout: const Duration(seconds: 40),
          receiveTimeout: const Duration(seconds: 40),
        ),
      );
      debugPrint("post req resp: $response");
    } catch (e) {
      debugPrint("post req exception: $e");
    }
    if (showDialog) hideLoadingDialog();
    return response;
  }

  @override
  Future<Response<dynamic>?> postRequest({
    String baseUrl = "",
    Map<String, String>? optionalHeaders,
    Map<String, dynamic>? data,
    required String path,
    bool showDialog = false,
    bool requiresAuthorization = true,
  }) async {
    Response? response;
    if (showDialog) {
      showLoadingDialog();
    }
    try {
      Map<String, String> header =
          getHeader(requiresAuthorization: requiresAuthorization);
      if (optionalHeaders != null) {
        header.addAll(optionalHeaders);
      }

      Dio dio = Dio();
      if (kDebugMode) {
        dio.interceptors.add(PrettyDioLogger(
          error: true,
          requestBody: true,
          requestHeader: true,
          request: false,
          responseBody: false,
        ));
      }
      response = await dio.post(
        baseUrl + path,
        options: Options(
          headers: header,
          sendTimeout: const Duration(seconds: 40),
          receiveTimeout: const Duration(seconds: 40),
        ),
        data: data,
      );
      debugPrint("post req resp: $response");
    } catch (e) {
      debugPrint("post req exception: $e");
    }
    if (showDialog) hideLoadingDialog();
    return response;
  }
}
