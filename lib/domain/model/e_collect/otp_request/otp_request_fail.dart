class OtpRequestErrorResponse {
  final String message;

  OtpRequestErrorResponse({
    required this.message,
  });

  factory OtpRequestErrorResponse.fromJson(Map<String, dynamic> json) {
    return OtpRequestErrorResponse(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}