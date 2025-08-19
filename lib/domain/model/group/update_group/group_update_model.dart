class GroupUpdateResponse {
  final bool status;
  final String message;

  GroupUpdateResponse({
    required this.status,
    required this.message,
  });

  factory GroupUpdateResponse.fromJson(Map<String, dynamic> json) {
    return GroupUpdateResponse(
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
