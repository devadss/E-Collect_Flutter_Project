// To parse this JSON data, do
//
//     final authFailtResponse = authFailtResponseFromJson(jsonString);

import 'dart:convert';

AuthFailtResponse authFailtResponseFromJson(String str) => AuthFailtResponse.fromJson(json.decode(str));

String authFailtResponseToJson(AuthFailtResponse data) => json.encode(data.toJson());

class AuthFailtResponse {
  String? message;
  String? status;

  AuthFailtResponse({
    this.message,
    this.status,
  });

  factory AuthFailtResponse.fromJson(Map<String, dynamic> json) => AuthFailtResponse(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
