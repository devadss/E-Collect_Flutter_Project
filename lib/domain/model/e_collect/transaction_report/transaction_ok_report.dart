class TransactionOkReport {
  final bool success;
  final List<PaymentTransaction> data;
  final Pagination pagination;
  final DateTime timestamp;


  TransactionOkReport({
    required this.success,
    required this.data,
    required this.pagination,
    required this.timestamp,
  });

  factory TransactionOkReport.fromJson(Map<String, dynamic> json) {
    return TransactionOkReport(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PaymentTransaction.fromJson(e))
          .toList() ??
          [],
      pagination: Pagination.fromJson(
        json['pagination'] ?? {},
      ),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class PaymentTransaction {
  final int id;
  final String orderId;
  final String transactionId;
  final String paymentGatewayTransactionId;
  final double amount;
  final String currency;
  final String description;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String paymentMode;
  final String paymentChannel;
  final String? bankCode;
  final String status;
  final int responseCode;
  final String responseMessage;
  final String? errorDescription;
  final String? agentName;
  final String? agentCode;
  final String? agentOriginId;
  final String? agentPhone;
  final String? agentEmail;
  final String? udf1;
  final String? udf2;
  final String? udf3;
  final String? udf4;
  final String? udf5;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? dueDate;
  final int merchantId;
  final String merchantName;
  final String? corpCode;
  final double? tdrAmount;
  final double? taxOnTdrAmount;
  final double? tdrPercentage;
  final double? tdrFixedFee;

  PaymentTransaction({
    required this.id,
    required this.orderId,
    required this.transactionId,
    required this.paymentGatewayTransactionId,
    required this.amount,
    required this.currency,
    required this.description,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.paymentMode,
    required this.paymentChannel,
    this.bankCode,
    required this.status,
    required this.responseCode,
    required this.responseMessage,
    this.errorDescription,
    this.agentName,
    this.agentCode,
    this.agentOriginId,
    this.agentPhone,
    this.agentEmail,
    this.udf1,
    this.udf2,
    this.udf3,
    this.udf4,
    this.udf5,
    required this.createdAt,
    required this.completedAt,
    this.dueDate,
    required this.merchantId,
    required this.merchantName,
    this.corpCode,
    this.tdrAmount,
    this.taxOnTdrAmount,
    this.tdrPercentage,
    this.tdrFixedFee,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'] ?? 0,
      orderId: json['orderId'] ?? '',
      transactionId: json['transactionId'] ?? '',
      paymentGatewayTransactionId:
      json['paymentGatewayTransactionId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      description: json['description'] ?? '',
      customerName: json['customerName'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      paymentMode: json['paymentMode'] ?? '',
      paymentChannel: json['paymentChannel'] ?? '',
      bankCode: json['bankCode'],
      status: json['status'] ?? '',
      responseCode: json['responseCode'] ?? 0,
      responseMessage: json['responseMessage'] ?? '',
      errorDescription: json['errorDescription'],
      agentName: json['agentName'],
      agentCode: json['agentCode'],
      agentOriginId: json['agentOriginId'],
      agentPhone: json['agentPhone'],
      agentEmail: json['agentEmail'],
      udf1: json['udf1'],
      udf2: json['udf2'],
      udf3: json['udf3'],
      udf4: json['udf4'],
      udf5: json['udf5'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      merchantId: json['merchantId'] ?? 0,
      merchantName: json['merchantName'] ?? '',
      corpCode: json['corpCode'],
      tdrAmount: (json['tdrAmount'] as num?)?.toDouble(),
      taxOnTdrAmount:
      (json['taxOnTdrAmount'] as num?)?.toDouble(),
      tdrPercentage:
      (json['tdrPercentage'] as num?)?.toDouble(),
      tdrFixedFee:
      (json['tdrFixedFee'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'transactionId': transactionId,
      'paymentGatewayTransactionId':
      paymentGatewayTransactionId,
      'amount': amount,
      'currency': currency,
      'description': description,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'paymentMode': paymentMode,
      'paymentChannel': paymentChannel,
      'bankCode': bankCode,
      'status': status,
      'responseCode': responseCode,
      'responseMessage': responseMessage,
      'errorDescription': errorDescription,
      'agentName': agentName,
      'agentCode': agentCode,
      'agentOriginId': agentOriginId,
      'agentPhone': agentPhone,
      'agentEmail': agentEmail,
      'udf1': udf1,
      'udf2': udf2,
      'udf3': udf3,
      'udf4': udf4,
      'udf5': udf5,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'merchantId': merchantId,
      'merchantName': merchantName,
      'corpCode': corpCode,
      'tdrAmount': tdrAmount,
      'taxOnTdrAmount': taxOnTdrAmount,
      'tdrPercentage': tdrPercentage,
      'tdrFixedFee': tdrFixedFee,
    };
  }
}

class Pagination {
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  Pagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'totalCount': totalCount,
      'totalPages': totalPages,
    };
  }
}