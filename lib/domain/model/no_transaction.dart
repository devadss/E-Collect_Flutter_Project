// To parse this JSON data, do
//
//     final noTransactionModel = noTransactionModelFromJson(jsonString);

import 'dart:convert';

NoTransactionModel noTransactionModelFromJson(String str) => NoTransactionModel.fromJson(json.decode(str));

String noTransactionModelToJson(NoTransactionModel data) => json.encode(data.toJson());

class NoTransactionModel {
  String? message;
  String? status;

  NoTransactionModel({
    this.message,
    this.status,
  });

  factory NoTransactionModel.fromJson(Map<String, dynamic> json) => NoTransactionModel(
    message: json["Message"],
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
  };
}
