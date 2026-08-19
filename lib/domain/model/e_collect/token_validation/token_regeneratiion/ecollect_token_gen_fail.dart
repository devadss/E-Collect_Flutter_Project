class RefreshTokenError {
  final String message;

  RefreshTokenError({
    required this.message,
  });

  factory RefreshTokenError.fromJson(Map<String, dynamic> json) {
    return RefreshTokenError(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}