// To parse this JSON data, do
//
//     final regCustFailResponse = regCustFailResponseFromJson(jsonString);

import 'dart:convert';

RegCustFailResponse regCustFailResponseFromJson(String str) => RegCustFailResponse.fromJson(json.decode(str));

String regCustFailResponseToJson(RegCustFailResponse data) => json.encode(data.toJson());

class RegCustFailResponse {
  String? message;
  String? status;

  RegCustFailResponse({
    this.message,
    this.status,
  });

  factory RegCustFailResponse.fromJson(Map<String, dynamic> json) => RegCustFailResponse(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
