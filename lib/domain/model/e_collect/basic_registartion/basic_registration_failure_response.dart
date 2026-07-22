class BasicRegistrationErrorResponse {
  final String message;

  BasicRegistrationErrorResponse({
    required this.message,
  });

  factory BasicRegistrationErrorResponse.fromJson(Map<String, dynamic> json) {
    return BasicRegistrationErrorResponse(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}