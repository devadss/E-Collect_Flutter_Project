class TokenValidationSuccessResponse {
  final bool isValid;
  final String message;
  final int userId;
  final String role;
  final DateTime expiryDate;

  TokenValidationSuccessResponse({
    required this.isValid,
    required this.message,
    required this.userId,
    required this.role,
    required this.expiryDate,
  });

  factory TokenValidationSuccessResponse.fromJson(Map<String, dynamic> json) {
    return TokenValidationSuccessResponse(
      isValid: json['isValid'] as bool,
      message: json['message'] as String,
      userId: json['userId'] as int,
      role: json['role'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'message': message,
      'userId': userId,
      'role': role,
      'expiryDate': expiryDate.toIso8601String(),
    };
  }
}