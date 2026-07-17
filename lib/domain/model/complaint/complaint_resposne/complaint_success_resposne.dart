class ComplaintResponse {
  final String complaintAssigned;
  final String complaintId;
  final String complaintResponseCode;
  final String complaintResponseReason;

  ComplaintResponse({
    required this.complaintAssigned,
    required this.complaintId,
    required this.complaintResponseCode,
    required this.complaintResponseReason,
  });

  factory ComplaintResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintResponse(
      complaintAssigned: json['complaintAssigned'] ?? '',
      complaintId: json['complaintId'] ?? '',
      complaintResponseCode: json['complaintResponseCode'] ?? '',
      complaintResponseReason: json['complaintResponseReason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complaintAssigned': complaintAssigned,
      'complaintId': complaintId,
      'complaintResponseCode': complaintResponseCode,
      'complaintResponseReason': complaintResponseReason,
    };
  }
}