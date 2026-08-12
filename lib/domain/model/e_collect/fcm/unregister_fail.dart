class DeviceUnregisterFailResponse {
  final bool success;
  final String message;

  DeviceUnregisterFailResponse({
    required this.success,
    required this.message,
  });

  factory DeviceUnregisterFailResponse.fromJson(Map<String, dynamic> json) {
    return DeviceUnregisterFailResponse(
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