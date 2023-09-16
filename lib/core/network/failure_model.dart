import 'package:kpopchat/core/constants/text_constants.dart';

class FailureModel {
  String? message;

  FailureModel({this.message});

  FailureModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? TextConstants.defaultErrorMsg;
  }
}
