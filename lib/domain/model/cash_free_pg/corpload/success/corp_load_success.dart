// To parse this JSON data, do
//
//     final corpLoadSuccessModel = corpLoadSuccessModelFromJson(jsonString);

import 'dart:convert';

CorpLoadSuccessModel corpLoadSuccessModelFromJson(String str) => CorpLoadSuccessModel.fromJson(json.decode(str));

String corpLoadSuccessModelToJson(CorpLoadSuccessModel data) => json.encode(data.toJson());

class CorpLoadSuccessModel {
  dynamic exception;
  dynamic pagination;
  Result? result;

  CorpLoadSuccessModel({
    this.exception,
    this.pagination,
    this.result,
  });

  factory CorpLoadSuccessModel.fromJson(Map<String, dynamic> json) => CorpLoadSuccessModel(
    exception: json["exception"],
    pagination: json["pagination"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "exception": exception,
    "pagination": pagination,
    "result": result?.toJson(),
  };
}

class Result {
  int? txId;

  Result({
    this.txId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    txId: json["txId"],
  );

  Map<String, dynamic> toJson() => {
    "txId": txId,
  };
}
