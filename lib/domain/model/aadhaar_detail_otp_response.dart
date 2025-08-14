// To parse this JSON data, do
//
//     final aadhaarDetailOtpRequestModel = aadhaarDetailOtpRequestModelFromJson(jsonString);

import 'dart:convert';

AadhaarDetailOtpRequestModel aadhaarDetailOtpRequestModelFromJson(String str) => AadhaarDetailOtpRequestModel.fromJson(json.decode(str));

String aadhaarDetailOtpRequestModelToJson(AadhaarDetailOtpRequestModel data) => json.encode(data.toJson());

class AadhaarDetailOtpRequestModel {
  String? refId;
  String? status;
  String? message;

  AadhaarDetailOtpRequestModel({
    this.refId,
    this.status,
    this.message,
  });

  factory AadhaarDetailOtpRequestModel.fromJson(Map<String, dynamic> json) => AadhaarDetailOtpRequestModel(
    refId: json["ref_id"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "ref_id": refId,
    "status": status,
    "message": message,
  };
}
