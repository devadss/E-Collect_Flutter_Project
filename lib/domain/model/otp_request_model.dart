// To parse this JSON data, do
//
//     final otpRequestResponse = otpRequestResponseFromJson(jsonString);

import 'dart:convert';

OtpRequestResponse otpRequestResponseFromJson(String str) => OtpRequestResponse.fromJson(json.decode(str));

String otpRequestResponseToJson(OtpRequestResponse data) => json.encode(data.toJson());

class OtpRequestResponse {
  String? message;
  //String? status;

  OtpRequestResponse({
    this.message,
  //  this.status,
  });

  factory OtpRequestResponse.fromJson(Map<String, dynamic> json) => OtpRequestResponse(
    message: json["message"],
  //  status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
   // "status": status,
  };
}
