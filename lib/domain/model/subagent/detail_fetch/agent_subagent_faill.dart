class AgentSubagentDetailFail {
  final bool success;
  final String message;

  AgentSubagentDetailFail({required this.success, required this.message});

  factory AgentSubagentDetailFail.fromJson(Map<String, dynamic> json) {
    return AgentSubagentDetailFail(
      success: json['success'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
