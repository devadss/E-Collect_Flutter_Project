class RdclCustomerListModel {
  final CustomerList customerList;

  RdclCustomerListModel({required this.customerList});

  factory RdclCustomerListModel.fromJson(Map<String, dynamic> json) {
    return RdclCustomerListModel(
      customerList: CustomerList.fromJson(json['CustomerList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustomerList': customerList.toJson(),
    };
  }
}

class CustomerList {
  final List<CustomerData> data;
  final int totalCount;

  CustomerList({required this.data, required this.totalCount});

  factory CustomerList.fromJson(Map<String, dynamic> json) {
    return CustomerList(
      data: List<CustomerData>.from(
        json['data'].map((x) => CustomerData.fromJson(x)),
      ),
      totalCount: json['TotalCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((x) => x.toJson()).toList(),
      'TotalCount': totalCount,
    };
  }
}

class CustomerData {
  final String custId;
  final String custName;
  final String rdclGlobalAccNo;
  final String schName;
  final String schCode;

  CustomerData({
    required this.custId,
    required this.custName,
    required this.rdclGlobalAccNo,
    required this.schName,
    required this.schCode,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      custId: json['Cust_Id'],
      custName: json['Cust_Name'],
      rdclGlobalAccNo: json['RDCL_GlobalAccNo'],
      schName: json['Sch_Name'],
      schCode: json['Sch_Code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Cust_Id': custId,
      'Cust_Name': custName,
      'RDCL_GlobalAccNo': rdclGlobalAccNo,
      'Sch_Name': schName,
      'Sch_Code': schCode,
    };
  }
}





// class RdclCustomerListModel {
//   final List<Customer> data;
//
//   RdclCustomerListModel({required this.data});
//
//   factory RdclCustomerListModel.fromJson(Map<String, dynamic> json) {
//     return RdclCustomerListModel(
//       data: List<Customer>.from(
//         (json['CustomerList']?['data'] ?? []).map((x) => Customer.fromJson(x)),
//       ),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "CustomerList": {
//       "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     },
//   };
// }
//
// class Customer {
//   final String custId;
//   final String custName;
//   final String rdclGlobalAccNo;
//   final String schName;
//   final String schCode;
//
//   Customer({
//     required this.custId,
//     required this.custName,
//     required this.rdclGlobalAccNo,
//     required this.schName,
//     required this.schCode,
//   });
//
//   factory Customer.fromJson(Map<String, dynamic> json) {
//     return Customer(
//       custId: json['Cust_Id'] ?? '',
//       custName: json['Cust_Name'] ?? '',
//       rdclGlobalAccNo: json['RDCL_GlobalAccNo'] ?? '',
//       schName: json['Sch_Name'] ?? '',
//       schCode: json['Sch_Code'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "Cust_Id": custId,
//     "Cust_Name": custName,
//     "RDCL_GlobalAccNo": rdclGlobalAccNo,
//     "Sch_Name": schName,
//     "Sch_Code": schCode,
//   };
// }
