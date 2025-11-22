// To parse this JSON data, do
//
//     final agentCustomerDetailsModel = agentCustomerDetailsModelFromJson(jsonString);

import 'dart:convert';
class AgentCustomerDetailsModel {
  final int totalCount;
  final List<Customer> data;

  AgentCustomerDetailsModel({
    required this.totalCount,
    required this.data,
  });

  factory AgentCustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    // Access the nested CustomerList object
    final customerList = json['CustomerList'] as Map<String, dynamic>?;

    return AgentCustomerDetailsModel(
      totalCount: customerList?['TotalCount'] ?? 0,
      data: (customerList?['data'] as List<dynamic>? ?? [])
          .map((item) => Customer.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CustomerList": {
        "TotalCount": totalCount,
        "data": data.map((c) => c.toJson()).toList(),
      }
    };
  }
}

class Customer {
  final String custId;
  final String custName;
  final String depGlobalAccNo;
  final String schName;
  final String schCode;

  Customer({
    required this.custId,
    required this.custName,
    required this.depGlobalAccNo,
    required this.schName,
    required this.schCode,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      custId: json['Cust_Id']?.toString() ?? "",
      custName: json['Cust_Name']?.toString() ?? "",
      depGlobalAccNo: json['Dep_GlobalAccNo']?.toString() ?? "",
      schName: json['Sch_Name']?.toString() ?? "",
      schCode: json['Sch_Code']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Cust_Id": custId,
      "Cust_Name": custName,
      "Dep_GlobalAccNo": depGlobalAccNo,
      "Sch_Name": schName,
      "Sch_Code": schCode,
    };
  }
}

// AgentCustomerDetailsModel agentCustomerDetailsModelFromJson(String str) => AgentCustomerDetailsModel.fromJson(json.decode(str));
//
// String agentCustomerDetailsModelToJson(AgentCustomerDetailsModel data) => json.encode(data.toJson());
//
// class AgentCustomerDetailsModel {
//   CustomerList? customerList;
//
//   AgentCustomerDetailsModel({
//     this.customerList,
//   });
//
//   factory AgentCustomerDetailsModel.fromJson(Map<String, dynamic> json) => AgentCustomerDetailsModel(
//     customerList: json["customer_list"] == null ? null : CustomerList.fromJson(json["customer_list"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "customer_list": customerList?.toJson(),
//   };
// }
//
// class CustomerList {
//   List<Datum>? data;
//
//   CustomerList({
//     this.data,
//   });
//
//   factory CustomerList.fromJson(Map<String, dynamic> json) => CustomerList(
//     data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//   };
// }
//
// class Datum {
//   String? custId;
//   String? refno;
//   String? custName;
//   String? accNo;
//   String? mobile;
//
//   Datum({
//     this.custId,
//     this.refno,
//     this.custName,
//     this.accNo,
//     this.mobile,
//   });
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     custId: json["CUST_ID"],
//     refno: json["REFNO"],
//     custName: json["CUST_NAME"],
//     accNo: json["ACC_NO"],
//     mobile: json["MOBILE"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "CUST_ID": custId,
//     "REFNO": refno,
//     "CUST_NAME": custName,
//     "ACC_NO": accNo,
//     "MOBILE": mobile,
//   };
// }
