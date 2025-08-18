class CreateMemberResponse {
  final bool status;
  final String message;

  CreateMemberResponse({
    required this.status,
    required this.message,
  });

  factory CreateMemberResponse.fromJson(Map<String, dynamic> json) {
    return CreateMemberResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
