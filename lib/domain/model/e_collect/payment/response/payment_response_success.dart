class PaymentResponseSuccess {
  final bool success;
  final String paymentUrl;
  final String orderId;
  final String message;

  PaymentResponseSuccess({
    required this.success,
    required this.paymentUrl,
    required this.orderId,
    required this.message,
  });

  factory PaymentResponseSuccess.fromJson(Map<String, dynamic> json) {
    return PaymentResponseSuccess(
      success: json['success'] as bool,
      paymentUrl: json['payment_url'] as String,
      orderId: json['order_id'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'payment_url': paymentUrl,
      'order_id': orderId,
      'message': message,
    };
  }
}