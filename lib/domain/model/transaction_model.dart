// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());

class TransactionModel {
  List<Result>? result;
  dynamic exception;
  Pagination? pagination;

  TransactionModel({
    this.result,
    this.exception,
    this.pagination,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    exception: json["exception"],
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "exception": exception,
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  bool? isList;
  int? pageSize;
  int? pageNo;
  int? totalPages;
  int? totalElements;

  Pagination({
    this.isList,
    this.pageSize,
    this.pageNo,
    this.totalPages,
    this.totalElements,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    isList: json["isList"],
    pageSize: json["pageSize"],
    pageNo: json["pageNo"],
    totalPages: json["totalPages"],
    totalElements: json["totalElements"],
  );

  Map<String, dynamic> toJson() => {
    "isList": isList,
    "pageSize": pageSize,
    "pageNo": pageNo,
    "totalPages": totalPages,
    "totalElements": totalElements,
  };
}

class Result {
  Transaction? transaction;
  dynamic balance;

  Result({
    this.transaction,
    this.balance,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    transaction: json["transaction"] == null ? null : Transaction.fromJson(json["transaction"]),
    balance: json["balance"],
  );

  Map<String, dynamic> toJson() => {
    "transaction": transaction?.toJson(),
    "balance": balance,
  };
}

class Transaction {
  String? amount;
  double? balance;
  TransactionType? transactionType;
  Type? type;
  int? time;
  int? txRef;
  dynamic businessId;
  YName? beneficiaryName;
  dynamic beneficiaryType;
  String? beneficiaryId;
  String? description;
  YName? otherPartyName;
  String? otherPartyId;
  TxnOrigin? txnOrigin;
  TransactionStatus? transactionStatus;
  dynamic status;
  YourWallet? yourWallet;
  dynamic yourWalletCurrency;
  String? beneficiaryWallet;
  String? externalTransactionId;
  dynamic retrivalReferenceNo;
  dynamic authCode;
  dynamic billRefNo;
  String? bankTid;
  dynamic acquirerId;
  dynamic mcc;
  double? convertedAmount;
  dynamic networkType;
  dynamic limitCurrencyCode;
  String? kitNo;
  String? sorTxnId;
  dynamic transactionCurrencyCode;
  dynamic fxConvDetails;
  dynamic convDetails;
  dynamic disputedDto;
  dynamic disputeRef;
  dynamic accountNo;

  Transaction({
    this.amount,
    this.balance,
    this.transactionType,
    this.type,
    this.time,
    this.txRef,
    this.businessId,
    this.beneficiaryName,
    this.beneficiaryType,
    this.beneficiaryId,
    this.description,
    this.otherPartyName,
    this.otherPartyId,
    this.txnOrigin,
    this.transactionStatus,
    this.status,
    this.yourWallet,
    this.yourWalletCurrency,
    this.beneficiaryWallet,
    this.externalTransactionId,
    this.retrivalReferenceNo,
    this.authCode,
    this.billRefNo,
    this.bankTid,
    this.acquirerId,
    this.mcc,
    this.convertedAmount,
    this.networkType,
    this.limitCurrencyCode,
    this.kitNo,
    this.sorTxnId,
    this.transactionCurrencyCode,
    this.fxConvDetails,
    this.convDetails,
    this.disputedDto,
    this.disputeRef,
    this.accountNo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    amount: json["amount"],
    balance: json["balance"]?.toDouble(),
    transactionType: transactionTypeValues.map[json["transactionType"]]!,
    type: typeValues.map[json["type"]]!,
    time: json["time"],
    txRef: json["txRef"],
    businessId: json["businessId"],
    beneficiaryName: yNameValues.map[json["beneficiaryName"]]!,
    beneficiaryType: json["beneficiaryType"],
    beneficiaryId: json["beneficiaryId"],
    description: json["description"],
    otherPartyName: yNameValues.map[json["otherPartyName"]]!,
    otherPartyId: json["otherPartyId"],
    txnOrigin: txnOriginValues.map[json["txnOrigin"]]!,
    transactionStatus: transactionStatusValues.map[json["transactionStatus"]]!,
    status: json["status"],
    yourWallet: yourWalletValues.map[json["yourWallet"]]!,
    yourWalletCurrency: json["yourWalletCurrency"],
    beneficiaryWallet: json["beneficiaryWallet"],
    externalTransactionId: json["externalTransactionId"],
    retrivalReferenceNo: json["retrivalReferenceNo"],
    authCode: json["authCode"],
    billRefNo: json["billRefNo"],
    bankTid: json["bankTid"],
    acquirerId: json["acquirerId"],
    mcc: json["mcc"],
    convertedAmount: json["convertedAmount"]?.toDouble(),
    networkType: json["networkType"],
    limitCurrencyCode: json["limitCurrencyCode"],
    kitNo: json["kitNo"],
    sorTxnId: json["sorTxnId"],
    transactionCurrencyCode: json["transactionCurrencyCode"],
    fxConvDetails: json["fxConvDetails"],
    convDetails: json["convDetails"],
    disputedDto: json["disputedDto"],
    disputeRef: json["disputeRef"],
    accountNo: json["accountNo"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "balance": balance,
    "transactionType": transactionTypeValues.reverse[transactionType],
    "type": typeValues.reverse[type],
    "time": time,
    "txRef": txRef,
    "businessId": businessId,
    "beneficiaryName": yNameValues.reverse[beneficiaryName],
    "beneficiaryType": beneficiaryType,
    "beneficiaryId": beneficiaryId,
    "description": description,
    "otherPartyName": yNameValues.reverse[otherPartyName],
    "otherPartyId": otherPartyId,
    "txnOrigin": txnOriginValues.reverse[txnOrigin],
    "transactionStatus": transactionStatusValues.reverse[transactionStatus],
    "status": status,
    "yourWallet": yourWalletValues.reverse[yourWallet],
    "yourWalletCurrency": yourWalletCurrency,
    "beneficiaryWallet": beneficiaryWallet,
    "externalTransactionId": externalTransactionId,
    "retrivalReferenceNo": retrivalReferenceNo,
    "authCode": authCode,
    "billRefNo": billRefNo,
    "bankTid": bankTid,
    "acquirerId": acquirerId,
    "mcc": mcc,
    "convertedAmount": convertedAmount,
    "networkType": networkType,
    "limitCurrencyCode": limitCurrencyCode,
    "kitNo": kitNo,
    "sorTxnId": sorTxnId,
    "transactionCurrencyCode": transactionCurrencyCode,
    "fxConvDetails": fxConvDetails,
    "convDetails": convDetails,
    "disputedDto": disputedDto,
    "disputeRef": disputeRef,
    "accountNo": accountNo,
  };
}

enum YName {
  PARVATHY,
  SRIRAM,
  SRIRAM_KS
}

final yNameValues = EnumValues({
  "PARVATHY": YName.PARVATHY,
  "Sriram": YName.SRIRAM,
  "Sriram KS": YName.SRIRAM_KS
});

enum TransactionStatus {
  PAYMENT_SUCCESS
}

final transactionStatusValues = EnumValues({
  "PAYMENT_SUCCESS": TransactionStatus.PAYMENT_SUCCESS
});

enum TransactionType {
  C2_C,
  M2_C,
  PURCHASE
}

final transactionTypeValues = EnumValues({
  "C2C": TransactionType.C2_C,
  "M2C": TransactionType.M2_C,
  "PURCHASE": TransactionType.PURCHASE
});

enum TxnOrigin {
  MOBILE
}

final txnOriginValues = EnumValues({
  "MOBILE": TxnOrigin.MOBILE
});

enum Type {
  CREDIT,
  DEBIT
}

final typeValues = EnumValues({
  "CREDIT": Type.CREDIT,
  "DEBIT": Type.DEBIT
});

enum YourWallet {
  GENERAL
}

final yourWalletValues = EnumValues({
  "GENERAL": YourWallet.GENERAL
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
