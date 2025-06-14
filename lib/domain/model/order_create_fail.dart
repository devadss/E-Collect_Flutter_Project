class OrderCreateFailResponse {
  final String message;
  final String status;

  OrderCreateFailResponse({required this.message, required this.status});

  factory OrderCreateFailResponse.fromJson(Map<String, dynamic> json) {
    return OrderCreateFailResponse(
      message: json['Message'] as String,
      status: json['Status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Message': message,
      'Status': status,
    };
  }
}
