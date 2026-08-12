class UnregisterDeviceSuccessResponse {
  final bool success;
  final String message;
  final int deviceId;

  UnregisterDeviceSuccessResponse({
    required this.success,
    required this.message,
    required this.deviceId,
  });

  factory UnregisterDeviceSuccessResponse.fromJson(Map<String, dynamic> json) {
    return UnregisterDeviceSuccessResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      deviceId: json['deviceId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'deviceId': deviceId,
    };
  }
}