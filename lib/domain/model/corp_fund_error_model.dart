// To parse this JSON data, do
//
//     final corpFundErrorModel = corpFundErrorModelFromJson(jsonString);

import 'dart:convert';

CorpFundErrorModel corpFundErrorModelFromJson(String str) => CorpFundErrorModel.fromJson(json.decode(str));

String corpFundErrorModelToJson(CorpFundErrorModel data) => json.encode(data.toJson());

class CorpFundErrorModel {
  String? message;
  String? status;

  CorpFundErrorModel({
    this.message,
    this.status,
  });

  factory CorpFundErrorModel.fromJson(Map<String, dynamic> json) => CorpFundErrorModel(
    message: json["Message"],
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
  };
}
