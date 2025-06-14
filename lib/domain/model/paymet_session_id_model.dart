// To parse this JSON data, do
//
//     final paymentSessionIdModel = paymentSessionIdModelFromJson(jsonString);

import 'dart:convert';

PaymentSessionIdModel paymentSessionIdModelFromJson(String str) => PaymentSessionIdModel.fromJson(json.decode(str));

String paymentSessionIdModelToJson(PaymentSessionIdModel data) => json.encode(data.toJson());

class PaymentSessionIdModel {
  dynamic cartDetails;
  String? cfOrderId;
  DateTime? createdAt;
  CustomerDetails? customerDetails;
  String? entity;
  double? orderAmount;
  String? orderCurrency;
  DateTime? orderExpiryTime;
  String? orderId;
  OrderMeta? orderMeta;
  dynamic orderNote;
  List<dynamic>? orderSplits;
  String? orderStatus;
  dynamic orderTags;
  String? paymentSessionId;
  dynamic terminalData;

  PaymentSessionIdModel({
    this.cartDetails,
    this.cfOrderId,
    this.createdAt,
    this.customerDetails,
    this.entity,
    this.orderAmount,
    this.orderCurrency,
    this.orderExpiryTime,
    this.orderId,
    this.orderMeta,
    this.orderNote,
    this.orderSplits,
    this.orderStatus,
    this.orderTags,
    this.paymentSessionId,
    this.terminalData,
  });

  factory PaymentSessionIdModel.fromJson(Map<String, dynamic> json) => PaymentSessionIdModel(
    cartDetails: json["cart_details"],
    cfOrderId: json["cf_order_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    customerDetails: json["customer_details"] == null ? null : CustomerDetails.fromJson(json["customer_details"]),
    entity: json["entity"],
    orderAmount: json["order_amount"],
    orderCurrency: json["order_currency"],
    orderExpiryTime: json["order_expiry_time"] == null ? null : DateTime.parse(json["order_expiry_time"]),
    orderId: json["order_id"],
    orderMeta: json["order_meta"] == null ? null : OrderMeta.fromJson(json["order_meta"]),
    orderNote: json["order_note"],
    orderSplits: json["order_splits"] == null ? [] : List<dynamic>.from(json["order_splits"]!.map((x) => x)),
    orderStatus: json["order_status"],
    orderTags: json["order_tags"],
    paymentSessionId: json["payment_session_id"],
    terminalData: json["terminal_data"],
  );

  Map<String, dynamic> toJson() => {
    "cart_details": cartDetails,
    "cf_order_id": cfOrderId,
    "created_at": createdAt?.toIso8601String(),
    "customer_details": customerDetails?.toJson(),
    "entity": entity,
    "order_amount": orderAmount,
    "order_currency": orderCurrency,
    "order_expiry_time": orderExpiryTime?.toIso8601String(),
    "order_id": orderId,
    "order_meta": orderMeta?.toJson(),
    "order_note": orderNote,
    "order_splits": orderSplits == null ? [] : List<dynamic>.from(orderSplits!.map((x) => x)),
    "order_status": orderStatus,
    "order_tags": orderTags,
    "payment_session_id": paymentSessionId,
    "terminal_data": terminalData,
  };
}

class CustomerDetails {
  String? customerId;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  dynamic customerUid;

  CustomerDetails({
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.customerUid,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) => CustomerDetails(
    customerId: json["customer_id"],
    customerName: json["customer_name"],
    customerEmail: json["customer_email"],
    customerPhone: json["customer_phone"],
    customerUid: json["customer_uid"],
  );

  Map<String, dynamic> toJson() => {
    "customer_id": customerId,
    "customer_name": customerName,
    "customer_email": customerEmail,
    "customer_phone": customerPhone,
    "customer_uid": customerUid,
  };
}

class OrderMeta {
  String? returnUrl;
  dynamic notifyUrl;
  dynamic paymentMethods;

  OrderMeta({
    this.returnUrl,
    this.notifyUrl,
    this.paymentMethods,
  });

  factory OrderMeta.fromJson(Map<String, dynamic> json) => OrderMeta(
    returnUrl: json["return_url"],
    notifyUrl: json["notify_url"],
    paymentMethods: json["payment_methods"],
  );

  Map<String, dynamic> toJson() => {
    "return_url": returnUrl,
    "notify_url": notifyUrl,
    "payment_methods": paymentMethods,
  };
}
