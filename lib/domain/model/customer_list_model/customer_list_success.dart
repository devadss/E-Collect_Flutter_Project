import 'dart:convert';

class CustomerListSuccessResponse {
  CustomerList? customerList;

  CustomerListSuccessResponse({
    this.customerList,
  });

  factory CustomerListSuccessResponse.fromRawJson(String str) =>
      CustomerListSuccessResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerListSuccessResponse.fromJson(Map<String, dynamic> json) =>
      CustomerListSuccessResponse(
        customerList: json["CustomerList"] == null
            ? null
            : CustomerList.fromJson(json["CustomerList"]),
      );

  Map<String, dynamic> toJson() => {
    "CustomerList": customerList?.toJson(),
  };
}

class CustomerList {
  List<Customer>? data;
  int? totalCount;

  CustomerList({
    this.data,
    this.totalCount,
  });

  factory CustomerList.fromRawJson(String str) =>
      CustomerList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerList.fromJson(Map<String, dynamic> json) => CustomerList(
    data: json["data"] == null
        ? []
        : List<Customer>.from(
        json["data"]!.map((x) => Customer.fromJson(x))),
    totalCount: json["TotalCount"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "TotalCount": totalCount,
  };
}

class Customer {
  String? custId;
  String? custName;
  String? rdclGlobalAccNo;
  String? schName;
  String? schCode;

  Customer({
    this.custId,
    this.custName,
    this.rdclGlobalAccNo,
    this.schName,
    this.schCode,
  });

  factory Customer.fromRawJson(String str) =>
      Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    custId: json["Cust_Id"],
    custName: json["Cust_Name"],
    rdclGlobalAccNo: json["RDCL_GlobalAccNo"],
    schName: json["Sch_Name"],
    schCode: json["Sch_Code"],
  );

  Map<String, dynamic> toJson() => {
    "Cust_Id": custId,
    "Cust_Name": custName,
    "RDCL_GlobalAccNo": rdclGlobalAccNo,
    "Sch_Name": schName,
    "Sch_Code": schCode,
  };
}