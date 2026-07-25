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
    data: json["data"] == null ? [] : List<QrTransaction>.from(json["data"].map((x) => QrTransaction.fromJson(x))),
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
  String? orderStatus;
  String? customerAccNo;
  String? customerId;
  String? customerName;
  String? customerPhone;
  CustomerEmail? customerEmail;
  DateTime? createdAt;
  String?   source;
  String? paymentMode;
  String? collectionType;
 // Code? corpCode;
  String? corpCode;
  //Code? branchCode;
  String? branchCode;
  String? vendorPostTransId;
  //CorpName? corpName;
  String? corpName;
  String? shopName;
  Gsttin? gsttin;
  RegNo? regNo;

  QrTransaction({
    this.orderId,
    this.customerAccNo,
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
    this.vendorPostTransId,
    this.corpName,
    this.shopName,
    this.gsttin,
    this.regNo,
    this.paymentMode,
    this.collectionType
  });

  factory QrTransaction.fromJson(Map<String, dynamic> json) => QrTransaction(
    orderId: json["OrderId"],
    cfOrderId: json["CFOrderId"],
    orderAmount: json["OrderAmount"],
    customerAccNo: json["CustomerAccNo"],
    orderCurrency: orderCurrencyValues.map[json["OrderCurrency"]],
    orderStatus:  json["OrderStatus"],
    customerId: json["CustomerId"],
    customerName: json["CustomerName"],
    customerPhone: json["CustomerPhone"],
    customerEmail: customerEmailValues.map[json["CustomerEmail"]],
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    source: json["Source"] ,
    corpCode: json["CorpCode"],
    branchCode:json["BranchCode"],
    vendorPostTransId:json["VendorPostTransId"],
    corpName: json["CorpName"],
    shopName: json["ShopName"],
    collectionType: json["CollectionType"],
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
    "CustomerAccNo":  customerAccNo,
    "CustomerId":  customerId,
    "CustomerName": customerName,
    "CustomerPhone": customerPhone,
    "CustomerEmail": customerEmailValues.reverse[customerEmail],
    "CreatedAt": createdAt?.toIso8601String(),
    "Source":  source,
    "CorpCode": corpCode,
    "BranchCode": branchCode,
    "VendorPostTransId": vendorPostTransId,
    "CorpName": corpName,
    "ShopName":  shopName,
    "CollectionType":  collectionType,
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
