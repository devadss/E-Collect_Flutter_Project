class BasicRegistrationSuccessResponse {
  final bool isSuccess;
  final String message;
  final int userId;
  final bool requiresOtpVerification;
  final bool requiresEmailVerification;
  final String otp;
  final DateTime otpExpiryTime;

  BasicRegistrationSuccessResponse({
    required this.isSuccess,
    required this.message,
    required this.userId,
    required this.requiresOtpVerification,
    required this.requiresEmailVerification,
    required this.otp,
    required this.otpExpiryTime,
  });

  factory BasicRegistrationSuccessResponse.fromJson(Map<String, dynamic> json) {
    return BasicRegistrationSuccessResponse(
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
      userId: json['userId'] as int,
      requiresOtpVerification:
      json['requiresOtpVerification'] as bool,
      requiresEmailVerification:
      json['requiresEmailVerification'] as bool,
      otp: json['otp'] as String,
      otpExpiryTime: DateTime.parse(json['otpExpiryTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'userId': userId,
      'requiresOtpVerification': requiresOtpVerification,
      'requiresEmailVerification': requiresEmailVerification,
      'otp': otp,
      'otpExpiryTime': otpExpiryTime.toIso8601String(),
    };
  }
}