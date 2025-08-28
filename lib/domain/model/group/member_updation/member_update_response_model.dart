class UpdateMemberResponse {
  final bool status;
  final String message;

  UpdateMemberResponse({
    required this.status,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory UpdateMemberResponse.fromJson(Map<String, dynamic> json) {
    return UpdateMemberResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
