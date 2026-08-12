///CashPaymentSuccessResponse
class CashPaymentSuccessResponse {
  final String status;
  final double amount;
  final String transactionId;
  final String message;
  final dynamic error;

  CashPaymentSuccessResponse({
    required this.status,
    required this.amount,
    required this.transactionId,
    required this.message,
    this.error,
  });

  factory CashPaymentSuccessResponse.fromJson(Map<String, dynamic> json) {
    return CashPaymentSuccessResponse(
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionId: json['transactionId'] as String,
      message: json['message'] as String,
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'amount': amount,
      'transactionId': transactionId,
      'message': message,
      'error': error,
    };
  }
}