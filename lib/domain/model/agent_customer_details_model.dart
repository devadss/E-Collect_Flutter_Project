// To parse this JSON data, do
//
//     final agentCustomerDetailsModel = agentCustomerDetailsModelFromJson(jsonString);

import 'dart:convert';

AgentCustomerDetailsModel agentCustomerDetailsModelFromJson(String str) => AgentCustomerDetailsModel.fromJson(json.decode(str));

String agentCustomerDetailsModelToJson(AgentCustomerDetailsModel data) => json.encode(data.toJson());

class AgentCustomerDetailsModel {
  CustomerList? customerList;

  AgentCustomerDetailsModel({
    this.customerList,
  });

  factory AgentCustomerDetailsModel.fromJson(Map<String, dynamic> json) => AgentCustomerDetailsModel(
    customerList: json["customer_list"] == null ? null : CustomerList.fromJson(json["customer_list"]),
  );

  Map<String, dynamic> toJson() => {
    "customer_list": customerList?.toJson(),
  };
}

class CustomerList {
  List<Datum>? data;

  CustomerList({
    this.data,
  });

  factory CustomerList.fromJson(Map<String, dynamic> json) => CustomerList(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? custId;
  String? refno;
  String? custName;
  String? accNo;
  String? mobile;

  Datum({
    this.custId,
    this.refno,
    this.custName,
    this.accNo,
    this.mobile,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    custId: json["CUST_ID"],
    refno: json["REFNO"],
    custName: json["CUST_NAME"],
    accNo: json["ACC_NO"],
    mobile: json["MOBILE"],
  );

  Map<String, dynamic> toJson() => {
    "CUST_ID": custId,
    "REFNO": refno,
    "CUST_NAME": custName,
    "ACC_NO": accNo,
    "MOBILE": mobile,
  };
}
