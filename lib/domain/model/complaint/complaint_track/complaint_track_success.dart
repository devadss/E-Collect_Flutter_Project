class ComplaintTrackSuccessResponse {
  final String complaintAssigned;
  final String complaintId;
  final String complaintStatus;
  final String complaintResponseCode;
  final String complaintResponseReason;
  final String complaintRemarks;

  ComplaintTrackSuccessResponse({
    required this.complaintAssigned,
    required this.complaintId,
    required this.complaintStatus,
    required this.complaintResponseCode,
    required this.complaintResponseReason,
    required this.complaintRemarks,
  });

  factory ComplaintTrackSuccessResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintTrackSuccessResponse(
      complaintAssigned: json['complaintAssigned'] ?? '',
      complaintId: json['complaintId'] ?? '',
      complaintStatus: json['complaintStatus'] ?? '',
      complaintResponseCode: json['complaintResponseCode'] ?? '',
      complaintResponseReason: json['complaintResponseReason'] ?? '',
      complaintRemarks: json['complaintRemarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complaintAssigned': complaintAssigned,
      'complaintId': complaintId,
      'complaintStatus': complaintStatus,
      'complaintResponseCode': complaintResponseCode,
      'complaintResponseReason': complaintResponseReason,
      'complaintRemarks': complaintRemarks,
    };
  }
}