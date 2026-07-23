class TokenValidationFailureResponse {
  final bool isValid;
  final String message;
  final String? userId;
  final String? role;
  final String? expiryDate;

  TokenValidationFailureResponse({
    required this.isValid,
    required this.message,
    this.userId,
    this.role,
    this.expiryDate,
  });

  factory TokenValidationFailureResponse.fromJson(Map<String, dynamic> json) {
    return TokenValidationFailureResponse(
      isValid: json['isValid'] ?? false,
      message: json['message'] ?? '',
      userId: json['userId'],
      role: json['role'],
      expiryDate: json['expiryDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'message': message,
      'userId': userId,
      'role': role,
      'expiryDate': expiryDate,
    };
  }
}