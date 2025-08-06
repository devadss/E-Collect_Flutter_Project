// To parse this JSON data, do
//
//     final collectionLoanModel = collectionLoanModelFromJson(jsonString);

import 'dart:convert';

CollectionLoanModel collectionLoanModelFromJson(String str) => CollectionLoanModel.fromJson(json.decode(str));

String collectionLoanModelToJson(CollectionLoanModel data) => json.encode(data.toJson());

class CollectionLoanModel {
  String? status;
  String? message;
  int? totalRecords;
  int? currentPage;
  int? pageSize;
  List<Datum>? data;

  CollectionLoanModel({
    this.status,
    this.message,
    this.totalRecords,
    this.currentPage,
    this.pageSize,
    this.data,
  });

  factory CollectionLoanModel.fromJson(Map<String, dynamic> json) => CollectionLoanModel(
    status: json["status"],
    message: json["message"],
    totalRecords: json["totalRecords"],
    currentPage: json["currentPage"],
    pageSize: json["pageSize"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "totalRecords": totalRecords,
    "currentPage": currentPage,
    "pageSize": pageSize,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? loanId;
  String? loanCode;
  String? loanNumber;
  String? customerName;
  String? scheme;
  String? corpCode;
  String? accountNo;
  double? outstandingAmount;
  int? tenorDays;
  String? collectionFrequency;
  double? collectionAmount;
  double? emi;
  double? dueAmount;
  String? status;
  String? region;
  String? customerId;
  String? phoneNumber;
  String? customerEmail;
  DateTime? lastRepaymentDate;
  String? assignedAgent;
  DateTime? createdAt;

  Datum({
    this.loanId,
    this.loanCode,
    this.loanNumber,
    this.customerName,
    this.scheme,
    this.corpCode,
    this.accountNo,
    this.outstandingAmount,
    this.tenorDays,
    this.collectionFrequency,
    this.collectionAmount,
    this.emi,
    this.dueAmount,
    this.status,
    this.region,
    this.customerId,
    this.phoneNumber,
    this.customerEmail,
    this.lastRepaymentDate,
    this.assignedAgent,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    loanId: json["LoanId"],
    loanCode: json["LoanCode"],
    loanNumber: json["LoanNumber"],
    customerName: json["CustomerName"],
    scheme: json["Scheme"],
    corpCode: json["CorpCode"],
    accountNo: json["AccountNo"],
    outstandingAmount: json["OutstandingAmount"],
    tenorDays: json["TenorDays"],
    collectionFrequency: json["CollectionFrequency"],
    collectionAmount: json["CollectionAmount"],
    emi: json["EMI"],
    dueAmount: json["DueAmount"],
    status: json["Status"],
    region: json["Region"],
    customerId: json["CustomerId"],
    phoneNumber: json["PhoneNumber"],
    customerEmail: json["CustomerEmail"],
    lastRepaymentDate: json["LastRepaymentDate"] == null ? null : DateTime.parse(json["LastRepaymentDate"]),
    assignedAgent: json["AssignedAgent"],
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "LoanId": loanId,
    "LoanCode": loanCode,
    "LoanNumber": loanNumber,
    "CustomerName": customerName,
    "Scheme": scheme,
    "CorpCode": corpCode,
    "AccountNo": accountNo,
    "OutstandingAmount": outstandingAmount,
    "TenorDays": tenorDays,
    "CollectionFrequency": collectionFrequency,
    "CollectionAmount": collectionAmount,
    "EMI": emi,
    "DueAmount": dueAmount,
    "Status": status,
    "Region": region,
    "CustomerId": customerId,
    "PhoneNumber": phoneNumber,
    "CustomerEmail": customerEmail,
    "LastRepaymentDate": lastRepaymentDate?.toIso8601String(),
    "AssignedAgent": assignedAgent,
    "CreatedAt": createdAt?.toIso8601String(),
  };
}
