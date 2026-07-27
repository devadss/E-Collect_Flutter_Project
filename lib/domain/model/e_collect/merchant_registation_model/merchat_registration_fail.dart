class MerchantRegistrationFailResponse {
  final bool success;
  final String message;

  MerchantRegistrationFailResponse({
    required this.success,
    required this.message,
  });

  factory MerchantRegistrationFailResponse.fromJson(Map<String, dynamic> json) {
    return MerchantRegistrationFailResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
