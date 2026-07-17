class ComplaintRequest {
  final String complaintType;
  final String complainDesc;
  final String txnRefId;
  final String complaintDisposition;

  ComplaintRequest({
    required this.complaintType,
    required this.complainDesc,
    required this.txnRefId,
    required this.complaintDisposition,
  });

  factory ComplaintRequest.fromJson(Map<String, dynamic> json) {
    return ComplaintRequest(
      complaintType: json['complaintType'] ?? '',
      complainDesc: json['complainDesc'] ?? '',
      txnRefId: json['txnRefId'] ?? '',
      complaintDisposition: json['complaintDisposition'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complaintType': complaintType,
      'complainDesc': complainDesc,
      'txnRefId': txnRefId,
      'complaintDisposition': complaintDisposition,
    };
  }
}