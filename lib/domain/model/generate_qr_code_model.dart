// To parse this JSON data, do
//
//     final generateQrModel = generateQrModelFromJson(jsonString);

import 'dart:convert';

GenerateQrModel generateQrModelFromJson(String str) => GenerateQrModel.fromJson(json.decode(str));

String generateQrModelToJson(GenerateQrModel data) => json.encode(data.toJson());

class GenerateQrModel {
  String? action;
  String? cfPaymentId;
  String? channel;
  Data? data;
  int? paymentAmount;
  String? paymentMethod;

  GenerateQrModel({
    this.action,
    this.cfPaymentId,
    this.channel,
    this.data,
    this.paymentAmount,
    this.paymentMethod,
  });

  factory GenerateQrModel.fromJson(Map<String, dynamic> json) => GenerateQrModel(
    action: json["action"],
    cfPaymentId: json["cf_payment_id"],
    channel: json["channel"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    paymentAmount: json["payment_amount"],
    paymentMethod: json["payment_method"],
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "cf_payment_id": cfPaymentId,
    "channel": channel,
    "data": data?.toJson(),
    "payment_amount": paymentAmount,
    "payment_method": paymentMethod,
  };
}

class Data {
  dynamic url;
  Payload? payload;
  dynamic contentType;
  dynamic method;

  Data({
    this.url,
    this.payload,
    this.contentType,
    this.method,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    url: json["url"],
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
    contentType: json["content_type"],
    method: json["method"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "payload": payload?.toJson(),
    "content_type": contentType,
    "method": method,
  };
}

class Payload {
  String? qrcode;

  Payload({
    this.qrcode,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    qrcode: json["qrcode"],
  );

  Map<String, dynamic> toJson() => {
    "qrcode": qrcode,
  };
}
