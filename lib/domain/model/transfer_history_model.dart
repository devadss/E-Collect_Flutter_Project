// To parse this JSON data, do
//
//     final qrTranscationHistoryModel = qrTranscationHistoryModelFromJson(jsonString);

import 'dart:convert';

TransferHistoryModel qrTranscationHistoryModelFromJson(String str) => TransferHistoryModel.fromJson(json.decode(str));

String qrTranscationHistoryModelToJson(TransferHistoryModel data) => json.encode(data.toJson());

class TransferHistoryModel {
  int? filteredCount;
  List<TransferTransaction>? data;

  TransferHistoryModel({
    this.filteredCount,
    this.data,
  });

  factory TransferHistoryModel.fromJson(Map<String, dynamic> json) => TransferHistoryModel(
    filteredCount: json["filteredCount"],
    data: json["data"] == null ? [] : List<TransferTransaction>.from(json["data"].map((x) => TransferTransaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "filteredCount": filteredCount,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TransferTransaction {
  String? orderId;
  String? cfOrderId;
  double? orderAmount;
  OrderCurrency? orderCurrency;
  String? orderStatus;
  String? customerId;
  String? customerName;
  String? customerPhone;
  CustomerEmail? customerEmail;
  DateTime? createdAt;
  String? source;
  String? paymentMode;
  String? collectionType;
  // Code? corpCode;
  String? corpCode;
  //Code? branchCode;
  String? branchCode;
  //CorpName? corpName;
  String? corpName;
  String? shopName;
  Gsttin? gsttin;
  RegNo? regNo;

  TransferTransaction({
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
    this.collectionType,
    this.corpCode,
    this.branchCode,
    this.corpName,
    this.shopName,
    this.paymentMode,
    this.gsttin,
    this.regNo,
  });

  factory TransferTransaction.fromJson(Map<String, dynamic> json) => TransferTransaction(
    orderId: json["OrderId"],
    cfOrderId: json["CFOrderId"],
    orderAmount: json["OrderAmount"],
    orderCurrency: orderCurrencyValues.map[json["OrderCurrency"]],
    orderStatus:  json["OrderStatus"],
    customerId: json["CustomerId"],
    customerName: json["CustomerName"],
    customerPhone: json["CustomerPhone"],
    customerEmail: customerEmailValues.map[json["CustomerEmail"]],
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    source: json["Source"] ,
    corpCode: json["CorpCode"],
    collectionType: json["CollectionType"],
    branchCode:json["BranchCode"],
    corpName: json["CorpName"],
    shopName: json["ShopName"],
    paymentMode: json["PaymentMode"],
    gsttin: gsttinValues.map[json["GSTTIN"]],
    regNo: regNoValues.map[json["RegNo"]],
  );

  Map<String, dynamic> toJson() => {
    "OrderId": orderId,
    "CFOrderId": cfOrderId,
    "OrderAmount": orderAmount,
    "OrderCurrency": orderCurrencyValues.reverse[orderCurrency],
    "OrderStatus":  orderStatus,
    "CustomerId":  customerId,
    "CustomerName": customerName,
    "CustomerPhone": customerPhone,
    "CustomerEmail": customerEmailValues.reverse[customerEmail],
    "CreatedAt": createdAt?.toIso8601String(),
    "Source":  source,
    "CollectionType":  collectionType,
    "CorpCode": corpCode,
    "BranchCode": branchCode,
    "CorpName": corpName,
    "ShopName":  shopName,
    "PaymentMode":  paymentMode,
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



class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
