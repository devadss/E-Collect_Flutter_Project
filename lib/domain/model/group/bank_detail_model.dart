class BankDetailSubmitApiResponse {
  final bool status;
  final String message;

  BankDetailSubmitApiResponse({
    required this.status,
    required this.message,
  });

  factory BankDetailSubmitApiResponse.fromJson(Map<String, dynamic> json) {
    return BankDetailSubmitApiResponse(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
