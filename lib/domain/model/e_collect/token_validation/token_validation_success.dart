class TokenValidationSuccessResponse {
  final bool isValid;
  final String message;
  final int? userId;
  final String? role;
  final DateTime? expiryDate;

  TokenValidationSuccessResponse({
    required this.isValid,
    required this.message,
    required this.userId,
    required this.role,
    required this.expiryDate,
  });

  factory TokenValidationSuccessResponse.fromJson(
      Map<String, dynamic> json) {
    return TokenValidationSuccessResponse(
      isValid: json['isValid'] ?? false,
      message: json['message'] ?? '',
      userId: json['userId'],
      role: json['role'],
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.tryParse(json['expiryDate'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'message': message,
      'userId': userId,
      'role': role,
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }

}