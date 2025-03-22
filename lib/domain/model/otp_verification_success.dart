// To parse this JSON data, do
//
//     final otpFailModel = otpFailModelFromJson(jsonString);

import 'dart:convert';

OtpSuccessModel otpFailModelFromJson(String str) => OtpSuccessModel.fromJson(json.decode(str));

String otpFailModelToJson(OtpSuccessModel data) => json.encode(data.toJson());

class OtpSuccessModel {
  String? message;
 // String? status;

  OtpSuccessModel({
    this.message,
   // this.status,
  });

  factory OtpSuccessModel.fromJson(Map<String, dynamic> json) => OtpSuccessModel(
    message: json["message"],
  //  status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
   // "status": status,
  };
}
