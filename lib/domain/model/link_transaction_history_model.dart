// To parse this JSON data, do
//
//     final linkTranscationHistoryModel = linkTranscationHistoryModelFromJson(jsonString);

import 'dart:convert';

LinkTranscationHistoryModel linkTranscationHistoryModelFromJson(String str) => LinkTranscationHistoryModel.fromJson(json.decode(str));

String linkTranscationHistoryModelToJson(LinkTranscationHistoryModel data) => json.encode(data.toJson());

class LinkTranscationHistoryModel {
  String? status;
  List<LinkTransactions>? data;

  LinkTranscationHistoryModel({
    this.status,
    this.data,
  });

  factory LinkTranscationHistoryModel.fromJson(Map<String, dynamic> json) => LinkTranscationHistoryModel(
    status: json["Status"],
    data: json["Data"] == null ? [] : List<LinkTransactions>.from(json["Data"].map((x) => LinkTransactions.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class LinkTransactions {
  int? id;
  String? orderId;
  String? linkStatus;
  String? linkCurrency;
  double? linkAmount;
  String? linkPurpose;
  DateTime? linkCreatedAt;
  String? customerName;
  String? customerId;
  String? customerPhone;
  String? customerAcctno;
  String? corpCode;
  String? customerEmail;
  String? agentPhone;
  String? agentId;
  String? agentOrginId;
  String? agentMail;
  String? loadStatus;
  String? transId;
  String? exTransId;
  String? cardRefNum;
  String? linkUrl;
  DateTime? linkExpiryTime;
  DateTime? createdAt;
  String? linkId;
  String? vendorPostTransId;
  String? vendorPostStatus;
  String? source;
  int? subAgentId;

  LinkTransactions({
    this.id,
    this.orderId,
    this.linkStatus,
    this.linkCurrency,
    this.linkAmount,
    this.linkPurpose,
    this.linkCreatedAt,
    this.customerName,
    this.customerId,
    this.customerPhone,
    this.customerAcctno,
    this.corpCode,
    this.customerEmail,
    this.agentPhone,
    this.agentId,
    this.agentOrginId,
    this.agentMail,
    this.loadStatus,
    this.transId,
    this.exTransId,
    this.cardRefNum,
    this.linkUrl,
    this.linkExpiryTime,
    this.createdAt,
    this.linkId,
    this.vendorPostTransId,
    this.vendorPostStatus,
    this.source,
    this.subAgentId,
  });

  factory LinkTransactions.fromJson(Map<String, dynamic> json) => LinkTransactions(
    id: json["Id"],
    orderId: json["Order_id"],
    linkStatus: json["link_status"],
    linkCurrency: json["link_currency"],
    linkAmount: json["link_amount"],
    linkPurpose: json["link_purpose"],
    linkCreatedAt: json["link_created_at"] == null ? null : DateTime.parse(json["link_created_at"]),
    customerName: json["customer_name"],
    customerId: json["customer_Id"],
    customerPhone: json["customer_phone"],
    customerAcctno: json["customer_acctno"],
    corpCode: json["CorpCode"],
    customerEmail: json["customer_email"],
    agentPhone: json["agent_phone"],
    agentId: json["agent_Id"],
    agentOrginId: json["agent_orginId"],
    agentMail: json["agent_mail"],
    loadStatus: json["Load_Status"],
    transId: json["TransId"],
    exTransId: json["ExTransId"],
    cardRefNum: json["CardRefNum"],
    linkUrl: json["link_url"],
    linkExpiryTime: json["link_expiry_time"] == null ? null : DateTime.parse(json["link_expiry_time"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    linkId: json["Link_Id"],
    vendorPostTransId: json["VendorPostTransId"],
    vendorPostStatus: json["VendorPostStatus"],
    source: json["Source"],
    subAgentId: json["SubAgentId"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Order_id": orderId,
    "link_status": linkStatus,
    "link_currency": linkCurrency,
    "link_amount": linkAmount,
    "link_purpose": linkPurpose,
    "link_created_at": linkCreatedAt?.toIso8601String(),
    "customer_name": customerName,
    "customer_Id": customerId,
    "customer_phone": customerPhone,
    "customer_acctno": customerAcctno,
    "CorpCode": corpCode,
    "customer_email": customerEmail,
    "agent_phone": agentPhone,
    "agent_Id": agentId,
    "agent_orginId": agentOrginId,
    "agent_mail": agentMail,
    "Load_Status": loadStatus,
    "TransId": transId,
    "ExTransId": exTransId,
    "CardRefNum": cardRefNum,
    "link_url": linkUrl,
    "link_expiry_time": linkExpiryTime?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "Link_Id": linkId,
    "VendorPostTransId": vendorPostTransId,
    "VendorPostStatus": vendorPostStatus,
    "Source": source,
    "SubAgentId": subAgentId,
  };
}
