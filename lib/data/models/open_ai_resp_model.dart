class OpenAIResponseModel {
  Openai? openai;

  OpenAIResponseModel({this.openai});

  OpenAIResponseModel.fromJson(Map<String, dynamic> json) {
    openai = json['openai'] != null ? Openai.fromJson(json['openai']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (openai != null) {
      data['openai'] = openai!.toJson();
    }
    return data;
  }
}

class Openai {
  String? status;
  String? generatedText;
  List<Message>? message;
  double? cost;

  Openai({this.status, this.generatedText, this.message, this.cost});

  Openai.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    generatedText = json['generated_text'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['generated_text'] = generatedText;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    data['cost'] = cost;
    return data;
  }
}

class Message {
  String? role;
  String? message;

  Message({this.role, this.message});

  Message.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['message'] = message;
    return data;
  }
}
