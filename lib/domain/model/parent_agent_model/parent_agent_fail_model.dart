class ParentAgentFailResponse {
  final bool success;
  final String message;

  ParentAgentFailResponse({
    required this.success,
    required this.message,
  });

  factory ParentAgentFailResponse.fromJson(Map<String, dynamic> json) {
    return ParentAgentFailResponse(
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