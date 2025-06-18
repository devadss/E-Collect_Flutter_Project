class ParentAgentCredentialFailResponse {
  final String message;

  ParentAgentCredentialFailResponse({required this.message});

  factory ParentAgentCredentialFailResponse.fromJson(Map<String, dynamic> json) {
    return ParentAgentCredentialFailResponse(
      message: json['Message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Message': message,
    };
  }
}
