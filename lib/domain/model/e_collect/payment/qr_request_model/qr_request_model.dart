class QrPaymentRequestModel {
  final AgentDetails agentDetails;
  final CustomerDetails customerDetails;
  final String collectionType;
  final double amount;
  final String note;
  final String qrSource;
  final String source;
  final int merchantId;

  QrPaymentRequestModel({
    required this.agentDetails,
    required this.customerDetails,
    required this.collectionType,
    required this.amount,
    required this.note,
    required this.qrSource,
    required this.source,
    required this.merchantId,
  });

  factory QrPaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return QrPaymentRequestModel(
      agentDetails: AgentDetails.fromJson(json['agent_details']),
      customerDetails: CustomerDetails.fromJson(json['customer_details']),
      collectionType: json['CollectionType'],
      amount: (json['Amount'] as num).toDouble(),
      note: json['note'],
      qrSource: json['QrSource'],
      source: json['Source'],
      merchantId: json['MerchantId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agent_details': agentDetails.toJson(),
      'customer_details': customerDetails.toJson(),
      'CollectionType': collectionType,
      'Amount': amount,
      'note': note,
      'QrSource': qrSource,
      'Source': source,
      'MerchantId': merchantId,
    };
  }
}

class AgentDetails {
  final String agentName;
  final String agentId;
  final String agentOrginId;
  final String agentPhone;
  final String agentEmail;
  final int agentBranch;

  AgentDetails({
    required this.agentName,
    required this.agentId,
    required this.agentOrginId,
    required this.agentPhone,
    required this.agentEmail,
    required this.agentBranch,
  });

  factory AgentDetails.fromJson(Map<String, dynamic> json) {
    return AgentDetails(
      agentName: json['agent_name'],
      agentId: json['agent_id'],
      agentOrginId: json['agent_orginId'],
      agentPhone: json['agent_phone'],
      agentEmail: json['agent_email'],
      agentBranch: json['agent_branch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agent_name': agentName,
      'agent_id': agentId,
      'agent_orginId': agentOrginId,
      'agent_phone': agentPhone,
      'agent_email': agentEmail,
      'agent_branch': agentBranch,
    };
  }
}

class CustomerDetails {
  final String customerName;
  final String customerPhone;
  final String customerAccno;
  final String customerId;
  final String customerEmail;

  CustomerDetails({
    required this.customerName,
    required this.customerPhone,
    required this.customerAccno,
    required this.customerId,
    required this.customerEmail,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      customerAccno: json['customer_accno'],
      customerId: json['customer_id'],
      customerEmail: json['customer_email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_accno': customerAccno,
      'customer_id': customerId,
      'customer_email': customerEmail,
    };
  }
}