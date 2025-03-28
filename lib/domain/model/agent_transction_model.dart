// To parse this JSON data, do
//
//     final agentPaymentTransction = agentPaymentTransctionFromJson(jsonString);

import 'dart:convert';

AgentPaymentTransctionModel agentPaymentTransctionFromJson(String str) => AgentPaymentTransctionModel.fromJson(json.decode(str));

String agentPaymentTransctionToJson(AgentPaymentTransctionModel data) => json.encode(data.toJson());

class AgentPaymentTransctionModel {
  String? status;
  List<AgentTransaction>? data;

  AgentPaymentTransctionModel({
    this.status,
    this.data,
  });

  factory AgentPaymentTransctionModel.fromJson(Map<String, dynamic> json) => AgentPaymentTransctionModel(
    status: json["Status"],
    data: json["Data"] == null ? [] : List<AgentTransaction>.from(json["Data"]!.map((x) => AgentTransaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AgentTransaction {
  num? id;
  String? orderId;
  Status? linkStatus;
  LinkCurrency? linkCurrency;
  num? linkAmount;
  LinkPurpose? linkPurpose;
  DateTime? linkCreatedAt;
  CustomerName? customerName;
  String? customerId;
  String? customerPhone;
  String? customerAcctno;
  CorpCode? corpCode;
  CustomerEmail? customerEmail;
  String? agentPhone;
  AgentId? agentId;
  String? agentOrginId;
  AgentMail? agentMail;
  Status? loadStatus;
  dynamic transId;
  dynamic exTransId;
  CardRefNum? cardRefNum;
  String? linkUrl;
  DateTime? linkExpiryTime;
  DateTime? createdAt;

  AgentTransaction({
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
  });

  factory AgentTransaction.fromJson(Map<String, dynamic> json) => AgentTransaction(
    id: json["Id"],
    orderId: json["Order_id"],
    linkStatus: statusValues.map[json["link_status"]]!,
    linkCurrency: linkCurrencyValues.map[json["link_currency"]]!,
    linkAmount: json["link_amount"],
    linkPurpose: linkPurposeValues.map[json["link_purpose"]]!,
    linkCreatedAt: json["link_created_at"] == null ? null : DateTime.parse(json["link_created_at"]),
    customerName: customerNameValues.map[json["customer_name"]]!,
    customerId: json["customer_Id"],
    customerPhone: json["customer_phone"],
    customerAcctno: json["customer_acctno"],
    corpCode: corpCodeValues.map[json["CorpCode"]]!,
    customerEmail: customerEmailValues.map[json["customer_email"]]!,
    agentPhone: json["agent_phone"],
    agentId: agentIdValues.map[json["agent_Id"]]!,
    agentOrginId: json["agent_orginId"],
    agentMail: agentMailValues.map[json["agent_mail"]]!,
    loadStatus: statusValues.map[json["Load_Status"]]!,
    transId: json["TransId"],
    exTransId: json["ExTransId"],
    cardRefNum: cardRefNumValues.map[json["CardRefNum"]]!,
    linkUrl: json["link_url"],
    linkExpiryTime: json["link_expiry_time"] == null ? null : DateTime.parse(json["link_expiry_time"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Order_id": orderId,
    "link_status": statusValues.reverse[linkStatus],
    "link_currency": linkCurrencyValues.reverse[linkCurrency],
    "link_amount": linkAmount,
    "link_purpose": linkPurposeValues.reverse[linkPurpose],
    "link_created_at": linkCreatedAt?.toIso8601String(),
    "customer_name": customerNameValues.reverse[customerName],
    "customer_Id": customerId,
    "customer_phone": customerPhone,
    "customer_acctno": customerAcctno,
    "CorpCode": corpCodeValues.reverse[corpCode],
    "customer_email": customerEmailValues.reverse[customerEmail],
    "agent_phone": agentPhone,
    "agent_Id": agentIdValues.reverse[agentId],
    "agent_orginId": agentOrginId,
    "agent_mail": agentMailValues.reverse[agentMail],
    "Load_Status": statusValues.reverse[loadStatus],
    "TransId": transId,
    "ExTransId": exTransId,
    "CardRefNum": cardRefNumValues.reverse[cardRefNum],
    "link_url": linkUrl,
    "link_expiry_time": linkExpiryTime?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
  };
}

enum AgentId {
  ADSS_AS0_GAY_HP_ZEG,
  AGT12345
}

final agentIdValues = EnumValues({
  "adssAS0GAYHpZeg": AgentId.ADSS_AS0_GAY_HP_ZEG,
  "AGT12345": AgentId.AGT12345
});

enum AgentMail {
  AGENT_EXAMPLE_COM,
  UNKNOWN_ABCD_COM
}

final agentMailValues = EnumValues({
  "agent@example.com": AgentMail.AGENT_EXAMPLE_COM,
  "unknown@abcd.com": AgentMail.UNKNOWN_ABCD_COM
});

enum CardRefNum {
  CARD98765,
  EMPTY
}

final cardRefNumValues = EnumValues({
  "CARD98765": CardRefNum.CARD98765,
  "": CardRefNum.EMPTY
});

enum CorpCode {
  BNKMYL,
  CORP001
}

final corpCodeValues = EnumValues({
  "BNKMYL": CorpCode.BNKMYL,
  "CORP001": CorpCode.CORP001
});

enum CustomerEmail {
  RAHUL_SHARMA_EXAMPLE_COM,
  UNKNOWN_ABCD_COM
}

final customerEmailValues = EnumValues({
  "rahul.sharma@example.com": CustomerEmail.RAHUL_SHARMA_EXAMPLE_COM,
  "unknown@abcd.com": CustomerEmail.UNKNOWN_ABCD_COM
});

enum CustomerName {
  RAHUL_SHARMA,
  SWATHY_U_M
}

final customerNameValues = EnumValues({
  "Rahul Sharma": CustomerName.RAHUL_SHARMA,
  "SWATHY U M": CustomerName.SWATHY_U_M
});

enum LinkCurrency {
  INR
}

final linkCurrencyValues = EnumValues({
  "INR": LinkCurrency.INR
});

enum LinkPurpose {
  ORDER_PAYMENT
}

final linkPurposeValues = EnumValues({
  "Order Payment": LinkPurpose.ORDER_PAYMENT
});

enum Status {
  INITIATED
}

final statusValues = EnumValues({
  "Initiated": Status.INITIATED
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
