// To parse this JSON data, do
//
//     final cardLoadSuccessStatusResponseModel = cardLoadSuccessStatusResponseModelFromJson(jsonString);

import 'dart:convert';

CardLoadSuccessStatusResponseModel cardLoadSuccessStatusResponseModelFromJson(String str) => CardLoadSuccessStatusResponseModel.fromJson(json.decode(str));

String cardLoadSuccessStatusResponseModelToJson(CardLoadSuccessStatusResponseModel data) => json.encode(data.toJson());

class CardLoadSuccessStatusResponseModel {
  String? message;
  String? status;
  String? orderId;
  String? txnId;

  CardLoadSuccessStatusResponseModel({
    this.message,
    this.status,
    this.orderId,
    this.txnId,
  });

  factory CardLoadSuccessStatusResponseModel.fromJson(Map<String, dynamic> json) => CardLoadSuccessStatusResponseModel(
    message: json["Message"],
    status: json["Status"],
    orderId: json["OrderId"],
    txnId: json["TxnId"],
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
    "OrderId": orderId,
    "TxnId": txnId,
  };
}
