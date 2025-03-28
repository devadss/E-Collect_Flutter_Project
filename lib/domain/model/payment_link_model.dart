// To parse this JSON data, do
//
//     final paymentLinkModel = paymentLinkModelFromJson(jsonString);

import 'dart:convert';

PaymentLinkModel paymentLinkModelFromJson(String str) => PaymentLinkModel.fromJson(json.decode(str));

String paymentLinkModelToJson(PaymentLinkModel data) => json.encode(data.toJson());

class PaymentLinkModel {
  String? cfLinkId;
  CustomerDetails? customerDetails;
  bool? enableInvoice;
  String? entity;
  int? linkAmount;
  int? linkAmountPaid;
  bool? linkAutoReminders;
  DateTime? linkCreatedAt;
  String? linkCurrency;
  DateTime? linkExpiryTime;
  String? linkId;
  LinkMeta? linkMeta;
  dynamic linkMinimumPartialAmount;
  LinkNotes? linkNotes;
  LinkNotify? linkNotify;
  bool? linkPartialPayments;
  String? linkPurpose;
  String? linkQrcode;
  String? linkStatus;
  String? linkUrl;
  List<dynamic>? orderSplits;
  String? termsAndConditions;
  String? thankYouMsg;

  PaymentLinkModel({
    this.cfLinkId,
    this.customerDetails,
    this.enableInvoice,
    this.entity,
    this.linkAmount,
    this.linkAmountPaid,
    this.linkAutoReminders,
    this.linkCreatedAt,
    this.linkCurrency,
    this.linkExpiryTime,
    this.linkId,
    this.linkMeta,
    this.linkMinimumPartialAmount,
    this.linkNotes,
    this.linkNotify,
    this.linkPartialPayments,
    this.linkPurpose,
    this.linkQrcode,
    this.linkStatus,
    this.linkUrl,
    this.orderSplits,
    this.termsAndConditions,
    this.thankYouMsg,
  });

  factory PaymentLinkModel.fromJson(Map<String, dynamic> json) => PaymentLinkModel(
    cfLinkId: json["cf_link_id"],
    customerDetails: json["customer_details"] == null ? null : CustomerDetails.fromJson(json["customer_details"]),
    enableInvoice: json["enable_invoice"],
    entity: json["entity"],
    linkAmount: json["link_amount"],
    linkAmountPaid: json["link_amount_paid"],
    linkAutoReminders: json["link_auto_reminders"],
    linkCreatedAt: json["link_created_at"] == null ? null : DateTime.parse(json["link_created_at"]),
    linkCurrency: json["link_currency"],
    linkExpiryTime: json["link_expiry_time"] == null ? null : DateTime.parse(json["link_expiry_time"]),
    linkId: json["link_id"],
    linkMeta: json["link_meta"] == null ? null : LinkMeta.fromJson(json["link_meta"]),
    linkMinimumPartialAmount: json["link_minimum_partial_amount"],
    linkNotes: json["link_notes"] == null ? null : LinkNotes.fromJson(json["link_notes"]),
    linkNotify: json["link_notify"] == null ? null : LinkNotify.fromJson(json["link_notify"]),
    linkPartialPayments: json["link_partial_payments"],
    linkPurpose: json["link_purpose"],
    linkQrcode: json["link_qrcode"],
    linkStatus: json["link_status"],
    linkUrl: json["link_url"],
    orderSplits: json["order_splits"] == null ? [] : List<dynamic>.from(json["order_splits"]!.map((x) => x)),
    termsAndConditions: json["terms_and_conditions"],
    thankYouMsg: json["thank_you_msg"],
  );

  Map<String, dynamic> toJson() => {
    "cf_link_id": cfLinkId,
    "customer_details": customerDetails?.toJson(),
    "enable_invoice": enableInvoice,
    "entity": entity,
    "link_amount": linkAmount,
    "link_amount_paid": linkAmountPaid,
    "link_auto_reminders": linkAutoReminders,
    "link_created_at": linkCreatedAt?.toIso8601String(),
    "link_currency": linkCurrency,
    "link_expiry_time": linkExpiryTime?.toIso8601String(),
    "link_id": linkId,
    "link_meta": linkMeta?.toJson(),
    "link_minimum_partial_amount": linkMinimumPartialAmount,
    "link_notes": linkNotes?.toJson(),
    "link_notify": linkNotify?.toJson(),
    "link_partial_payments": linkPartialPayments,
    "link_purpose": linkPurpose,
    "link_qrcode": linkQrcode,
    "link_status": linkStatus,
    "link_url": linkUrl,
    "order_splits": orderSplits == null ? [] : List<dynamic>.from(orderSplits!.map((x) => x)),
    "terms_and_conditions": termsAndConditions,
    "thank_you_msg": thankYouMsg,
  };
}

class CustomerDetails {
  String? customerName;
  String? countryCode;
  String? customerPhone;
  String? customerEmail;

  CustomerDetails({
    this.customerName,
    this.countryCode,
    this.customerPhone,
    this.customerEmail,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) => CustomerDetails(
    customerName: json["customer_name"],
    countryCode: json["country_code"],
    customerPhone: json["customer_phone"],
    customerEmail: json["customer_email"],
  );

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "country_code": countryCode,
    "customer_phone": customerPhone,
    "customer_email": customerEmail,
  };
}

class LinkMeta {
  String? notifyUrl;
  String? paymentMethods;
  String? returnUrl;
  String? upiIntent;

  LinkMeta({
    this.notifyUrl,
    this.paymentMethods,
    this.returnUrl,
    this.upiIntent,
  });

  factory LinkMeta.fromJson(Map<String, dynamic> json) => LinkMeta(
    notifyUrl: json["notify_url"],
    paymentMethods: json["payment_methods"],
    returnUrl: json["return_url"],
    upiIntent: json["upi_intent"],
  );

  Map<String, dynamic> toJson() => {
    "notify_url": notifyUrl,
    "payment_methods": paymentMethods,
    "return_url": returnUrl,
    "upi_intent": upiIntent,
  };
}

class LinkNotes {
  String? note1;
  String? note2;

  LinkNotes({
    this.note1,
    this.note2,
  });

  factory LinkNotes.fromJson(Map<String, dynamic> json) => LinkNotes(
    note1: json["note1"],
    note2: json["note2"],
  );

  Map<String, dynamic> toJson() => {
    "note1": note1,
    "note2": note2,
  };
}

class LinkNotify {
  bool? sendEmail;
  bool? sendSms;

  LinkNotify({
    this.sendEmail,
    this.sendSms,
  });

  factory LinkNotify.fromJson(Map<String, dynamic> json) => LinkNotify(
    sendEmail: json["send_email"],
    sendSms: json["send_sms"],
  );

  Map<String, dynamic> toJson() => {
    "send_email": sendEmail,
    "send_sms": sendSms,
  };
}
