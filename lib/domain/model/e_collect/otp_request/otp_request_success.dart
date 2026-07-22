class OtpRequestSuccessResponse {
  final bool isSuccess;
  final String message;
  final int userId;
  final String mobileNumber;
  final DateTime expiryTime;
  final int resendAfterSeconds;
  final String otp;

  OtpRequestSuccessResponse({
    required this.isSuccess,
    required this.message,
    required this.userId,
    required this.mobileNumber,
    required this.expiryTime,
    required this.resendAfterSeconds,
    required this.otp,
  });

  factory OtpRequestSuccessResponse.fromJson(Map<String, dynamic> json) {
    return OtpRequestSuccessResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      userId: json['userId'] ?? 0,
      mobileNumber: json['mobileNumber'] ?? '',
      expiryTime: DateTime.parse(json['expiryTime']),
      resendAfterSeconds: json['resendAfterSeconds'] ?? 0,
      otp: json['otp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'userId': userId,
      'mobileNumber': mobileNumber,
      'expiryTime': expiryTime.toIso8601String(),
      'resendAfterSeconds': resendAfterSeconds,
      'otp': otp,
    };
  }
}