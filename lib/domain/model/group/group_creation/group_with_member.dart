class CreateGroupWithMemberResponse {
  final bool status;
  final String message;
  final int groupId;

  CreateGroupWithMemberResponse({
    required this.status,
    required this.message,
    required this.groupId,
  });

  factory CreateGroupWithMemberResponse.fromJson(Map<String, dynamic> json) {
    return CreateGroupWithMemberResponse(
      status: json['status'],
      message: json['message'],
      groupId: json['groupId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'groupId': groupId,
    };
  }
}
