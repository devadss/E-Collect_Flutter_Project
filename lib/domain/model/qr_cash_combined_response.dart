class CashQrCombinedResponse {
  int filteredCount;
  List<Order> data;

  CashQrCombinedResponse({
    required this.filteredCount,
    required this.data,
  });

  factory CashQrCombinedResponse.fromJson(Map<String, dynamic> json) {
    return CashQrCombinedResponse(
      filteredCount: json['filteredCount'],
      data: List<Order>.from(json['data'].map((x) => Order.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filteredCount': filteredCount,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class Order {
  String orderId;
  String cfOrderId;
  double orderAmount;
  String orderCurrency;
  String orderStatus;
  String customerId;
  String customerName;
  String customerPhone;
  String customerEmail;
  DateTime createdAt;
  String source;
  String corpCode;
  String branchCode;
  String agentOrginId;
  String vendorPostTransId;
  String corpName;
  String shopName;
  String gstin;
  String regNo;

  Order({
    required this.orderId,
    required this.cfOrderId,
    required this.orderAmount,
    required this.orderCurrency,
    required this.orderStatus,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.createdAt,
    required this.source,
    required this.corpCode,
    required this.branchCode,
    required this.agentOrginId,
    required this.vendorPostTransId,
    required this.corpName,
    required this.shopName,
    required this.gstin,
    required this.regNo,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['OrderId'],
      cfOrderId: json['CFOrderId'],
      orderAmount: (json['OrderAmount'] as num).toDouble(),
      orderCurrency: json['OrderCurrency'],
      orderStatus: json['OrderStatus'],
      customerId: json['CustomerId'],
      customerName: json['CustomerName'],
      customerPhone: json['CustomerPhone'] ?? '',
      customerEmail: json['CustomerEmail'] ?? '',
      createdAt: DateTime.parse(json['CreatedAt']),
      source: json['Source'],
      corpCode: json['CorpCode'],
      branchCode: json['BranchCode'],
      agentOrginId: json['AgentOrginId'],
      vendorPostTransId: json['VendorPostTransId'],
      corpName: json['CorpName'],
      shopName: json['ShopName'] ?? '',
      gstin: json['GSTTIN'] ?? '',
      regNo: json['RegNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderId': orderId,
      'CFOrderId': cfOrderId,
      'OrderAmount': orderAmount,
      'OrderCurrency': orderCurrency,
      'OrderStatus': orderStatus,
      'CustomerId': customerId,
      'CustomerName': customerName,
      'CustomerPhone': customerPhone,
      'CustomerEmail': customerEmail,
      'CreatedAt': createdAt.toIso8601String(),
      'Source': source,
      'CorpCode': corpCode,
      'BranchCode': branchCode,
      'AgentOrginId': agentOrginId,
      'VendorPostTransId': vendorPostTransId,
      'CorpName': corpName,
      'ShopName': shopName,
      'GSTTIN': gstin,
      'RegNo': regNo,
    };
  }
}
