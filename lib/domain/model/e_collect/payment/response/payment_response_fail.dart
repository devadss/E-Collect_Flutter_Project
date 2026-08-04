class PaymentFailResponse {
  final bool success;
  final String message;

  PaymentFailResponse({
    required this.success,
    required this.message,
  });

  factory PaymentFailResponse.fromJson(Map<String, dynamic> json) {
    return PaymentFailResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}