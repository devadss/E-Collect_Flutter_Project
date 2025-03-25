// To parse this JSON data, do
//
//     final balanceFailModel = balanceFailModelFromJson(jsonString);

import 'dart:convert';

BalanceFailModel balanceFailModelFromJson(String str) => BalanceFailModel.fromJson(json.decode(str));

String balanceFailModelToJson(BalanceFailModel data) => json.encode(data.toJson());

class BalanceFailModel {
  String? message;
  String? status;

  BalanceFailModel({
    this.message,
    this.status,
  });

  factory BalanceFailModel.fromJson(Map<String, dynamic> json) => BalanceFailModel(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
