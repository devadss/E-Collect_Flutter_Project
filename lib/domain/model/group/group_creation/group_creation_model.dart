class CreateGroupResponse {
  final bool status;
  final String message;

  CreateGroupResponse({
    required this.status,
    required this.message,
  });

  factory CreateGroupResponse.fromJson(Map<String, dynamic> json) {
    return CreateGroupResponse(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
