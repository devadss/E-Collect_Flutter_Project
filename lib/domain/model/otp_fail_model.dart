// To parse this JSON data, do
//
//     final otpFailModel = otpFailModelFromJson(jsonString);

import 'dart:convert';

OtpFailModel otpFailModelFromJson(String str) => OtpFailModel.fromJson(json.decode(str));

String otpFailModelToJson(OtpFailModel data) => json.encode(data.toJson());

class OtpFailModel {
  String? message;
  String? status;

  OtpFailModel({
    this.message,
    this.status,
  });

  factory OtpFailModel.fromJson(Map<String, dynamic> json) => OtpFailModel(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
