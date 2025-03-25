// To parse this JSON data, do
//
//     final transactionFailModel = transactionFailModelFromJson(jsonString);

import 'dart:convert';

TransactionFailModel transactionFailModelFromJson(String str) => TransactionFailModel.fromJson(json.decode(str));

String transactionFailModelToJson(TransactionFailModel data) => json.encode(data.toJson());

class TransactionFailModel {
  String? message;
  String? status;

  TransactionFailModel({
    this.message,
    this.status,
  });

  factory TransactionFailModel.fromJson(Map<String, dynamic> json) => TransactionFailModel(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
