// To parse this JSON data, do
//
//     final cashDepositModel = cashDepositModelFromJson(jsonString);

import 'dart:convert';

CashDepositModel cashDepositModelFromJson(String str) => CashDepositModel.fromJson(json.decode(str));

String cashDepositModelToJson(CashDepositModel data) => json.encode(data.toJson());

class CashDepositModel {
  Receipt? receipt;

  CashDepositModel({
    this.receipt,
  });

  factory CashDepositModel.fromJson(Map<String, dynamic> json) => CashDepositModel(
    receipt: json["receipt"] == null ? null : Receipt.fromJson(json["receipt"]),
  );

  Map<String, dynamic> toJson() => {
    "receipt": receipt?.toJson(),
  };
}

class Receipt {
  Data? data;

  Receipt({
    this.data,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  String? accNo;
  String? tranId;
  String? name;
  String? mobile;
  String? oldBalance;
  String? depositAmount;
  num? currentBalance;
  String? depositDate;
  String? status;

  Data({
    this.accNo,
    this.tranId,
    this.name,
    this.mobile,
    this.oldBalance,
    this.depositAmount,
    this.currentBalance,
    this.depositDate,
    this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accNo: json["ACC_NO"],
    tranId: json["TRAN_ID"],
    name: json["NAME"],
    mobile: json["MOBILE"],
    oldBalance: json["OLD_BALANCE"],
    depositAmount: json["DEPOSIT_AMOUNT"],
    currentBalance: json["CURRENT_BALANCE"],
    depositDate: json["DEPOSIT_DATE"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "ACC_NO": accNo,
    "TRAN_ID": tranId,
    "NAME": name,
    "MOBILE": mobile,
    "OLD_BALANCE": oldBalance,
    "DEPOSIT_AMOUNT": depositAmount,
    "CURRENT_BALANCE": currentBalance,
    "DEPOSIT_DATE": depositDate,
    "status": status,
  };
}
