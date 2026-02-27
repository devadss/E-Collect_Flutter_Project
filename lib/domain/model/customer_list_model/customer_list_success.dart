import 'dart:convert';
CustomerListSuccessResponse parseCustomerSuccess(String body) {
  return CustomerListSuccessResponse.fromRawJson(body);
}

class CustomerListSuccessResponse {
  final CustomerList? customerList;

  const CustomerListSuccessResponse({
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
  final List<Customer>? data;
  final int? totalCount;

  const CustomerList({
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
  final String? custId;
  final String? custName;
  final String? rdclGlobalAccNo;
  final String? schName;
  final String? schCode;

  const Customer({
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