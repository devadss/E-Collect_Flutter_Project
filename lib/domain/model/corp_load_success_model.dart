// To parse this JSON data, do
//
//     final corpLoadlSuccessModel = corpLoadlSuccessModelFromJson(jsonString);

import 'dart:convert';

CorpLoadlSuccessModel corpLoadlSuccessModelFromJson(String str) => CorpLoadlSuccessModel.fromJson(json.decode(str));

String corpLoadlSuccessModelToJson(CorpLoadlSuccessModel data) => json.encode(data.toJson());

class CorpLoadlSuccessModel {
  Result? result;
  dynamic exception;
  dynamic pagination;

  CorpLoadlSuccessModel({
    this.result,
    this.exception,
    this.pagination,
  });

  factory CorpLoadlSuccessModel.fromJson(Map<String, dynamic> json) => CorpLoadlSuccessModel(
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
    exception: json["exception"],
    pagination: json["pagination"],
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
    "exception": exception,
    "pagination": pagination,
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
