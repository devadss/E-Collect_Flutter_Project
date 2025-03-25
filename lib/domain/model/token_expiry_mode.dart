// To parse this JSON data, do
//
//     final tokenExpireModel = tokenExpireModelFromJson(jsonString);

import 'dart:convert';

TokenExpireModel tokenExpireModelFromJson(String str) => TokenExpireModel.fromJson(json.decode(str));

String tokenExpireModelToJson(TokenExpireModel data) => json.encode(data.toJson());

class TokenExpireModel {
  bool? isExpired;

  TokenExpireModel({
    this.isExpired,
  });

  factory TokenExpireModel.fromJson(Map<String, dynamic> json) => TokenExpireModel(
    isExpired: json["isExpired"],
  );

  Map<String, dynamic> toJson() => {
    "isExpired": isExpired,
  };
}
