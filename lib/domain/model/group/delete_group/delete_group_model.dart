class DeleteGroupResponse {
  final bool status;
  final String message;

  DeleteGroupResponse({
    required this.status,
    required this.message,
  });

  factory DeleteGroupResponse.fromJson(Map<String, dynamic> json) {
    return DeleteGroupResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
