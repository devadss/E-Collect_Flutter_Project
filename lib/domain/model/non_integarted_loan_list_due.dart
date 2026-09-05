class NonIntegratedLoanDueList {
  final bool success;
  final String status;
  final String agentCode;
  final Summary summary;
  final int currentPage;
  final int pageSize;
  final List<CustomerDue> data;

  NonIntegratedLoanDueList({
    required this.success,
    required this.status,
    required this.agentCode,
    required this.summary,
    required this.currentPage,
    required this.pageSize,
    required this.data,
  });

  factory NonIntegratedLoanDueList.fromJson(Map<String, dynamic> json) {
    return NonIntegratedLoanDueList(
      success: json['success'] ?? false,
      status: json['status']?.toString() ?? '',
      agentCode: json['agentCode']?.toString() ?? '',
      summary: Summary.fromJson(json['summary'] ?? {}),
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => CustomerDue.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'agentCode': agentCode,
      'summary': summary.toJson(),
      'currentPage': currentPage,
      'pageSize': pageSize,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class Summary {
  final int totalCustomersDue;
  final double totalDueAmount;
  final double totalEmiAmount;

  Summary({
    required this.totalCustomersDue,
    required this.totalDueAmount,
    required this.totalEmiAmount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalCustomersDue:
      (json['totalCustomersDue'] as num?)?.toInt() ?? 0,

      totalDueAmount:
      (json['totalDueAmount'] as num?)?.toDouble() ?? 0.0,

      totalEmiAmount:
      (json['totalEmiAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCustomersDue': totalCustomersDue,
      'totalDueAmount': totalDueAmount,
      'totalEmiAmount': totalEmiAmount,
    };
  }
}

class CustomerDue {
  final int id;
  final String accountNumber;
  final String customerName;
  final String mobileNumber;
  final String productType;
  final String branchCode;
  final double dueAmount;
  final int emiAmount;
  final int outstandingAmount;
  final String emiFrequency;
  final String nextDueDate;
  final String lastPaidDate;
  final int daysPastDue;
  final String riskCategory;
  final String assignedAgentCode;
  final String assignedAgentName;
  final String status;

  CustomerDue({
    required this.id,
    required this.accountNumber,
    required this.customerName,
    required this.mobileNumber,
    required this.productType,
    required this.branchCode,
    required this.dueAmount,
    required this.emiAmount,
    required this.outstandingAmount,
    required this.emiFrequency,
    required this.nextDueDate,
    required this.lastPaidDate,
    required this.daysPastDue,
    required this.riskCategory,
    required this.assignedAgentCode,
    required this.assignedAgentName,
    required this.status,
  });

  factory CustomerDue.fromJson(Map<String, dynamic> json) {
    return CustomerDue(
      id: (json['id'] as num?)?.toInt() ?? 0,

      accountNumber: json['accountNumber']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      mobileNumber: json['mobileNumber']?.toString() ?? '',
      productType: json['productType']?.toString() ?? '',
      branchCode: json['branchCode']?.toString() ?? '',

      // double fields
      dueAmount:
      (json['dueAmount'] as num?)?.toDouble() ?? 0.0,

      // int fields
      emiAmount:
      (json['emiAmount'] as num?)?.toInt() ?? 0,

      outstandingAmount:
      (json['outstandingAmount'] as num?)?.toInt() ?? 0,

      emiFrequency: json['emiFrequency']?.toString() ?? '',
      nextDueDate: json['nextDueDate']?.toString() ?? '',
      lastPaidDate: json['lastPaidDate']?.toString() ?? '',

      daysPastDue:
      (json['daysPastDue'] as num?)?.toInt() ?? 0,

      riskCategory: json['riskCategory']?.toString() ?? '',
      assignedAgentCode:
      json['assignedAgentCode']?.toString() ?? '',
      assignedAgentName:
      json['assignedAgentName']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'productType': productType,
      'branchCode': branchCode,
      'dueAmount': dueAmount,
      'emiAmount': emiAmount,
      'outstandingAmount': outstandingAmount,
      'emiFrequency': emiFrequency,
      'nextDueDate': nextDueDate,
      'lastPaidDate': lastPaidDate,
      'daysPastDue': daysPastDue,
      'riskCategory': riskCategory,
      'assignedAgentCode': assignedAgentCode,
      'assignedAgentName': assignedAgentName,
      'status': status,
    };
  }
}
