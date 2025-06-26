// To parse this JSON data, do
//
//     final qrTranscationHistoryModel = qrTranscationHistoryModelFromJson(jsonString);

import 'dart:convert';

QrTranscationHistoryModel qrTranscationHistoryModelFromJson(String str) => QrTranscationHistoryModel.fromJson(json.decode(str));

String qrTranscationHistoryModelToJson(QrTranscationHistoryModel data) => json.encode(data.toJson());

class QrTranscationHistoryModel {
  int? filteredCount;
  List<QrTransaction>? data;

  QrTranscationHistoryModel({
    this.filteredCount,
    this.data,
  });

  factory QrTranscationHistoryModel.fromJson(Map<String, dynamic> json) => QrTranscationHistoryModel(
    filteredCount: json["filteredCount"],
    data: json["data"] == null ? [] : List<QrTransaction>.from(json["data"]!.map((x) => QrTransaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "filteredCount": filteredCount,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class QrTransaction {
  String? orderId;
  String? cfOrderId;
  double? orderAmount;
  OrderCurrency? orderCurrency;
  OrderStatus? orderStatus;
  CustomerId? customerId;
  CustomerName? customerName;
  String? customerPhone;
  CustomerEmail? customerEmail;
  DateTime? createdAt;
  Source? source;
  Code? corpCode;
  Code? branchCode;
  CorpName? corpName;
  ShopName? shopName;
  Gsttin? gsttin;
  RegNo? regNo;

  QrTransaction({
    this.orderId,
    this.cfOrderId,
    this.orderAmount,
    this.orderCurrency,
    this.orderStatus,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.createdAt,
    this.source,
    this.corpCode,
    this.branchCode,
    this.corpName,
    this.shopName,
    this.gsttin,
    this.regNo,
  });

  factory QrTransaction.fromJson(Map<String, dynamic> json) => QrTransaction(
    orderId: json["OrderId"],
    cfOrderId: json["CFOrderId"],
    orderAmount: json["OrderAmount"],
    orderCurrency: orderCurrencyValues.map[json["OrderCurrency"]]!,
    orderStatus: orderStatusValues.map[json["OrderStatus"]]!,
    customerId: customerIdValues.map[json["CustomerId"]]!,
    customerName: customerNameValues.map[json["CustomerName"]]!,
    customerPhone: json["CustomerPhone"],
    customerEmail: customerEmailValues.map[json["CustomerEmail"]]!,
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    source: sourceValues.map[json["Source"]]!,
    corpCode: codeValues.map[json["CorpCode"]]!,
    branchCode: codeValues.map[json["BranchCode"]]!,
    corpName: corpNameValues.map[json["CorpName"]]!,
    shopName: shopNameValues.map[json["ShopName"]]!,
    gsttin: gsttinValues.map[json["GSTTIN"]]!,
    regNo: regNoValues.map[json["RegNo"]]!,
  );

  Map<String, dynamic> toJson() => {
    "OrderId": orderId,
    "CFOrderId": cfOrderId,
    "OrderAmount": orderAmount,
    "OrderCurrency": orderCurrencyValues.reverse[orderCurrency],
    "OrderStatus": orderStatusValues.reverse[orderStatus],
    "CustomerId": customerIdValues.reverse[customerId],
    "CustomerName": customerNameValues.reverse[customerName],
    "CustomerPhone": customerPhone,
    "CustomerEmail": customerEmailValues.reverse[customerEmail],
    "CreatedAt": createdAt?.toIso8601String(),
    "Source": sourceValues.reverse[source],
    "CorpCode": codeValues.reverse[corpCode],
    "BranchCode": codeValues.reverse[branchCode],
    "CorpName": corpNameValues.reverse[corpName],
    "ShopName": shopNameValues.reverse[shopName],
    "GSTTIN": gsttinValues.reverse[gsttin],
    "RegNo": regNoValues.reverse[regNo],
  };
}

enum Code {
  BNKMYL,
  DOPNKTR
}

final codeValues = EnumValues({
  "BNKMYL": Code.BNKMYL,
  "DOPNKTR": Code.DOPNKTR
});

enum CorpName {
  MAYYIL_SCB,
  NAKSHATHRA
}

final corpNameValues = EnumValues({
  "MAYYIL SCB": CorpName.MAYYIL_SCB,
  "NAKSHATHRA": CorpName.NAKSHATHRA
});

enum CustomerEmail {
  ANANDHU_GMAIL_COM,
  SALIM_GMAIL_COM,
  VIDHYA_GMAIL_COM
}

final customerEmailValues = EnumValues({
  "anandhu@gmail.com": CustomerEmail.ANANDHU_GMAIL_COM,
  "salim@gmail.com": CustomerEmail.SALIM_GMAIL_COM,
  "vidhya@gmail.com": CustomerEmail.VIDHYA_GMAIL_COM
});

enum CustomerId {
  ADSSKAM_ZO_SZVQ_IR,
  ADSSL_WA_IA_PNC_FH6,
  ADSS_Y_UC_Y7_WS_T04_Q
}

final customerIdValues = EnumValues({
  "adsskamZoSZVQIr": CustomerId.ADSSKAM_ZO_SZVQ_IR,
  "adsslWAIaPncFH6": CustomerId.ADSSL_WA_IA_PNC_FH6,
  "adssYUcY7WsT04Q": CustomerId.ADSS_Y_UC_Y7_WS_T04_Q
});

enum CustomerName {
  ANANDHU,
  SALIM,
  VIDHYA
}

final customerNameValues = EnumValues({
  "Anandhu": CustomerName.ANANDHU,
  "Salim": CustomerName.SALIM,
  "Vidhya": CustomerName.VIDHYA
});

enum Gsttin {
  GST124,
  GSTIN251435421,
  THE_562143127371
}

final gsttinValues = EnumValues({
  "gst124": Gsttin.GST124,
  "GSTIN251435421": Gsttin.GSTIN251435421,
  "562143127371": Gsttin.THE_562143127371
});

enum OrderCurrency {
  INR
}

final orderCurrencyValues = EnumValues({
  "INR": OrderCurrency.INR
});

enum OrderStatus {
  ACTIVE
}

final orderStatusValues = EnumValues({
  "ACTIVE": OrderStatus.ACTIVE
});

enum RegNo {
  REG1234,
  THE_21436412634615,
  THE_21536217872623
}

final regNoValues = EnumValues({
  "reg1234": RegNo.REG1234,
  "21436412634615": RegNo.THE_21436412634615,
  "21536217872623": RegNo.THE_21536217872623
});

enum ShopName {
  AL_TAZZAA,
  FOODY,
  SALIM_FOODS
}

final shopNameValues = EnumValues({
  "Al~Tazzaa": ShopName.AL_TAZZAA,
  "foody": ShopName.FOODY,
  "Salim Foods ": ShopName.SALIM_FOODS
});

enum Source {
  MERCHANT
}

final sourceValues = EnumValues({
  "MERCHANT": Source.MERCHANT
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
