// To parse this JSON data, do
//
//     final cashTranscation = cashTranscationFromJson(jsonString);

import 'dart:convert';

CashTranscation cashTranscationFromJson(String str) => CashTranscation.fromJson(json.decode(str));

String cashTranscationToJson(CashTranscation data) => json.encode(data.toJson());

class CashTranscation {
  String? status;
  int? amount;
  String? transactionId;
  String? message;

  CashTranscation({
    this.status,
    this.amount,
    this.transactionId,
    this.message,
  });

  factory CashTranscation.fromJson(Map<String, dynamic> json) => CashTranscation(
    status: json["status"],
    amount: json["amount"],
    transactionId: json["transactionId"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "amount": amount,
    "transactionId": transactionId,
    "message": message,
  };
}
