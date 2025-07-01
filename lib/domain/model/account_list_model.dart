class RdclCustomerListModel {
  final List<Customer> data;

  RdclCustomerListModel({required this.data});

  factory RdclCustomerListModel.fromJson(Map<String, dynamic> json) {
    return RdclCustomerListModel(
      data: List<Customer>.from(
        (json['CustomerList']?['data'] ?? []).map((x) => Customer.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "CustomerList": {
      "data": List<dynamic>.from(data.map((x) => x.toJson())),
    },
  };
}

class Customer {
  final String custId;
  final String custName;
  final String rdclGlobalAccNo;
  final String schName;
  final String schCode;

  Customer({
    required this.custId,
    required this.custName,
    required this.rdclGlobalAccNo,
    required this.schName,
    required this.schCode,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      custId: json['Cust_Id'] ?? '',
      custName: json['Cust_Name'] ?? '',
      rdclGlobalAccNo: json['RDCL_GlobalAccNo'] ?? '',
      schName: json['Sch_Name'] ?? '',
      schCode: json['Sch_Code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "Cust_Id": custId,
    "Cust_Name": custName,
    "RDCL_GlobalAccNo": rdclGlobalAccNo,
    "Sch_Name": schName,
    "Sch_Code": schCode,
  };
}
