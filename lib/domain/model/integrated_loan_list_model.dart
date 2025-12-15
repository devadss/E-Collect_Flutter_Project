class IntegratedLoanListResponse {
  final List<CustomerData> data;

  IntegratedLoanListResponse({required this.data});

  factory IntegratedLoanListResponse.fromJson(Map<String, dynamic> json) {
    return IntegratedLoanListResponse(
      data: (json['CustomerList']['data'] as List)
          .map((e) => CustomerData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustomerList': {
        'data': data.map((e) => e.toJson()).toList(),
      }
    };
  }
}

class CustomerData {
  final String custId;
  final String custName;
  final String lnGlobalAccNo;
  final String schName;
  final String schCode;

  CustomerData({
    required this.custId,
    required this.custName,
    required this.lnGlobalAccNo,
    required this.schName,
    required this.schCode,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      custId: json['Cust_Id'] ?? '',
      custName: json['Cust_Name'] ?? '',
      lnGlobalAccNo: json['Ln_GlobalAccNo'] ?? '',
      schName: json['Sch_Name'] ?? '',
      schCode: json['Sch_Code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Cust_Id': custId,
      'Cust_Name': custName,
      'Ln_GlobalAccNo': lnGlobalAccNo,
      'Sch_Name': schName,
      'Sch_Code': schCode,
    };
  }
}
