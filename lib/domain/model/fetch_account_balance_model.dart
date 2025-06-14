// To parse this JSON data, do
//
//     final fetchBalanceModel = fetchBalanceModelFromJson(jsonString);

import 'dart:convert';

FetchBalanceModel fetchBalanceModelFromJson(String str) => FetchBalanceModel.fromJson(json.decode(str));

String fetchBalanceModelToJson(FetchBalanceModel data) => json.encode(data.toJson());

class FetchBalanceModel {
  List<Result>? result;
  dynamic exception;
  dynamic pagination;

  FetchBalanceModel({
    this.result,
    this.exception,
    this.pagination,
  });

  factory FetchBalanceModel.fromJson(Map<String, dynamic> json) => FetchBalanceModel(
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    exception: json["exception"],
    pagination: json["pagination"],
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "exception": exception,
    "pagination": pagination,
  };
}

class Result {
  String? entityId;
  String? productId;
  double? balance;
  double? lienBalance;

  Result({
    this.entityId,
    this.productId,
    this.balance,
    this.lienBalance,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    entityId: json["entityId"],
    productId: json["productId"],
    balance: json["balance"]?.toDouble(),
    lienBalance: json["lienBalance"],
  );

  Map<String, dynamic> toJson() => {
    "entityId": entityId,
    "productId": productId,
    "balance": balance,
    "lienBalance": lienBalance,
  };
}
