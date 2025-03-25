// To parse this JSON data, do
//
//     final balanceModel = balanceModelFromJson(jsonString);

import 'dart:convert';

BalanceModel balanceModelFromJson(String str) => BalanceModel.fromJson(json.decode(str));

String balanceModelToJson(BalanceModel data) => json.encode(data.toJson());

class BalanceModel {
  List<Result>? result;
  dynamic exception;
  dynamic pagination;

  BalanceModel({
    this.result,
    this.exception,
    this.pagination,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
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
  num? lienBalance;

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
