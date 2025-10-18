class AllTransactionHistoryResponse {
  String? status;
  List<AllTransactionHistoryModel>? data;

  AllTransactionHistoryResponse({
    this.status,
    this.data,
  });

  factory AllTransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AllTransactionHistoryResponse(
      status: json["Status"],
      data: json["Data"] != null
          ? List<AllTransactionHistoryModel>.from(
          json["Data"].map((x) => AllTransactionHistoryModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Data": data?.map((x) => x.toJson()).toList(),
  };
}
class AllTransactionHistoryModel {
  String? orderId;
  String? linkStatus;
  String? linkCurrency;
  double? linkAmount;
  String? linkPurpose;
  String? customerName;
  String? customerId;
  String? customerPhone;
  String? customerAcctno;
  String? corpCode;
  String? agentPhone;
  String? agentId;
  String? agentOrginId;
  String? agentMail;
  String? loadStatus;
  String? transId;
  String? exTransId;
  String? cardRefNum;
  String? linkUrl;
  String? paymentMode;
  String? linkExpiryTime;
  String? createdAt;
  String? source;
  int? subAgentId;
  String? subAgentBranch;
  String? subAgentBranchCode;

  AllTransactionHistoryModel({
    this.orderId,
    this.linkStatus,
    this.linkCurrency,
    this.linkAmount,
    this.linkPurpose,
    this.customerName,
    this.customerId,
    this.customerPhone,
    this.customerAcctno,
    this.corpCode,
    this.agentPhone,
    this.agentId,
    this.agentOrginId,
    this.agentMail,
    this.loadStatus,
    this.transId,
    this.exTransId,
    this.cardRefNum,
    this.linkUrl,
    this.paymentMode,
    this.linkExpiryTime,
    this.createdAt,
    this.source,
    this.subAgentId,
    this.subAgentBranch,
    this.subAgentBranchCode,
  });

  factory AllTransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      AllTransactionHistoryModel(
        orderId: json["Order_id"],
        linkStatus: json["link_status"],
        linkCurrency: json["link_currency"],
        linkAmount: (json["link_amount"] != null)
            ? json["link_amount"].toDouble()
            : null,
        linkPurpose: json["link_purpose"],
        customerName: json["customer_name"],
        customerId: json["customer_Id"],
        customerPhone: json["customer_phone"],
        customerAcctno: json["customer_acctno"],
        corpCode: json["CorpCode"],
        agentPhone: json["agent_phone"],
        agentId: json["agent_Id"],
        agentOrginId: json["agent_orginId"],
        agentMail: json["agent_mail"],
        loadStatus: json["Load_Status"],
        transId: json["TransId"],
        exTransId: json["ExTransId"],
        cardRefNum: json["CardRefNum"],
        linkUrl: json["link_url"],
        paymentMode: json["PaymentMode"],
        linkExpiryTime: json["link_expiry_time"],
        createdAt: json["created_at"],
        source: json["Source"],
        subAgentId: json["SubAgentId"],
        subAgentBranch: json["SubAgentBranch"],
        subAgentBranchCode: json["SubAgentBranchCode"],
      );

  Map<String, dynamic> toJson() => {
    "Order_id": orderId,
    "link_status": linkStatus,
    "link_currency": linkCurrency,
    "link_amount": linkAmount,
    "link_purpose": linkPurpose,
    "customer_name": customerName,
    "customer_Id": customerId,
    "customer_phone": customerPhone,
    "customer_acctno": customerAcctno,
    "CorpCode": corpCode,
    "agent_phone": agentPhone,
    "agent_Id": agentId,
    "agent_orginId": agentOrginId,
    "agent_mail": agentMail,
    "Load_Status": loadStatus,
    "TransId": transId,
    "ExTransId": exTransId,
    "CardRefNum": cardRefNum,
    "link_url": linkUrl,
    "PaymentMode": paymentMode,
    "link_expiry_time": linkExpiryTime,
    "created_at": createdAt,
    "Source": source,
    "SubAgentId": subAgentId,
    "SubAgentBranch": subAgentBranch,
    "SubAgentBranchCode": subAgentBranchCode,
  };
}
