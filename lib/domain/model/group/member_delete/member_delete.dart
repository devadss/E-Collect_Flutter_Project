class DeleteMemberResponse {
  final bool status;
  final String message;

  DeleteMemberResponse({
    required this.status,
    required this.message,
  });

  factory DeleteMemberResponse.fromJson(Map<String, dynamic> json) {
    return DeleteMemberResponse(
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
