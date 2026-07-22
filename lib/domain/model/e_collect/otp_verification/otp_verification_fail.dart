class OtpVerificationErrorResponse {
  final String message;

  OtpVerificationErrorResponse({
    required this.message,
  });

  factory OtpVerificationErrorResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationErrorResponse(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}