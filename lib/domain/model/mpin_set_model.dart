// To parse this JSON data, do
//
//     final mpinSetResponse = mpinSetResponseFromJson(jsonString);

import 'dart:convert';

MpinSetResponse mpinSetResponseFromJson(String str) => MpinSetResponse.fromJson(json.decode(str));

String mpinSetResponseToJson(MpinSetResponse data) => json.encode(data.toJson());

class MpinSetResponse {
  String? message;
  String? status;

  MpinSetResponse({
    this.message,
    this.status,
  });

  factory MpinSetResponse.fromJson(Map<String, dynamic> json) => MpinSetResponse(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
