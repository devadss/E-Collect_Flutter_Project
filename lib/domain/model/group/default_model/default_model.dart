// To parse this JSON data, do
//
//     final defaultModel = defaultModelFromJson(jsonString);

import 'dart:convert';

DefaultModel defaultModelFromJson(String str) => DefaultModel.fromJson(json.decode(str));

String defaultModelToJson(DefaultModel data) => json.encode(data.toJson());

class DefaultModel {
  bool? status;
  String? message;

  DefaultModel({
    this.status,
    this.message,
  });

  factory DefaultModel.fromJson(Map<String, dynamic> json) => DefaultModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
