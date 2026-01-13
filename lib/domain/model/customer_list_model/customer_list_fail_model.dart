class CustomerListFailResponse {
  final String error;
  final int totalCount;

  CustomerListFailResponse({
    required this.error,
    required this.totalCount,
  });

  factory CustomerListFailResponse.fromJson(Map<String, dynamic> json) {
    return CustomerListFailResponse(
      error: json['error'] as String,
      totalCount: json['TotalCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'TotalCount': totalCount,
    };
  }

  @override
  String toString() {
    return 'CustomerList(error: $error, totalCount: $totalCount)';
  }
}

class CustomerListResponse {
  final CustomerListFailResponse customerList;

  CustomerListResponse({
    required this.customerList,
  });

  factory CustomerListResponse.fromJson(Map<String, dynamic> json) {
    return CustomerListResponse(
      customerList: CustomerListFailResponse.fromJson(json['CustomerList'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustomerList': customerList.toJson(),
    };
  }

  @override
  String toString() {
    return 'CustomerListResponse(customerList: $customerList)';
  }
}