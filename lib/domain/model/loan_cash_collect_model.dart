class LoanCashCollectionResponse {
  final String status;
  final double amount;
  final String transactionId;
  final String message;

  LoanCashCollectionResponse({
    required this.status,
    required this.amount,
    required this.transactionId,
    required this.message,
  });

  factory LoanCashCollectionResponse.fromJson(Map<String, dynamic> json) {
    return LoanCashCollectionResponse(
      status: json['status'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      transactionId: json['transactionId'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'amount': amount,
      'transactionId': transactionId,
      'message': message,
    };
  }
}
