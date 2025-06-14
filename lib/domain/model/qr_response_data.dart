class QrResponseData {
  final String action;
  final String cfPaymentId;
  final String channel;
  final PaymentData data;
  final double paymentAmount;
  final String paymentMethod;

  QrResponseData({
    required this.action,
    required this.cfPaymentId,
    required this.channel,
    required this.data,
    required this.paymentAmount,
    required this.paymentMethod,
  });

  factory QrResponseData.fromJson(Map<String, dynamic> json) {
    return QrResponseData(
      action: json['action'],
      cfPaymentId: json['cf_payment_id'],
      channel: json['channel'],
      data: PaymentData.fromJson(json['data']),
      paymentAmount: (json['payment_amount'] as num).toDouble(),
      paymentMethod: json['payment_method'],
    );
  }
}

class PaymentData {
  final String? url;
  final Payload payload;
  final String? contentType;
  final String? method;

  PaymentData({
    this.url,
    required this.payload,
    this.contentType,
    this.method,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      url: json['url'],
      payload: Payload.fromJson(json['payload']),
      contentType: json['content_type'],
      method: json['method'],
    );
  }
}

class Payload {
  final String qrcode;

  Payload({required this.qrcode});

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      qrcode: json['qrcode'],
    );
  }
}
