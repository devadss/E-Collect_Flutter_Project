class SubAgentResponse {
  final bool success;
  final SubAgent data;

  SubAgentResponse({
    required this.success,
    required this.data,
  });

  factory SubAgentResponse.fromJson(Map<String, dynamic> json) {
    return SubAgentResponse(
      success: json['success'],
      data: SubAgent.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class SubAgent {
  final int subAgentId;
  final String parentAgentId;
  final String parentAgentCorpCode;
  final String subAgentCode;
  final String parentAgentMobNo;
  final String subAgentName;
  final String mobileNumber;
  final String address;
  final String subAgentOriginId;
  final bool isActive;
  final DateTime createdAt;

  SubAgent({
    required this.subAgentId,
    required this.parentAgentId,
    required this.parentAgentCorpCode,
    required this.subAgentCode,
    required this.parentAgentMobNo,
    required this.subAgentName,
    required this.mobileNumber,
    required this.address,
    required this.subAgentOriginId,
    required this.isActive,
    required this.createdAt,
  });

  factory SubAgent.fromJson(Map<String, dynamic> json) {
    return SubAgent(
      subAgentId: json['SubAgentId'],
      parentAgentId: json['ParentAgentId'],
      parentAgentCorpCode: json['ParentAgentCorpCode'],
      subAgentCode: json['SubAgentCode'],
      parentAgentMobNo: json['ParentAgentMobNo'],
      subAgentName: json['SubAgentName'],
      mobileNumber: json['MobileNumber'],
      address: json['Address'],
      subAgentOriginId: json['SubAgentOriginId'],
      isActive: json['IsActive'],
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SubAgentId': subAgentId,
      'ParentAgentId': parentAgentId,
      'ParentAgentCorpCode': parentAgentCorpCode,
      'SubAgentCode': subAgentCode,
      'ParentAgentMobNo': parentAgentMobNo,
      'SubAgentName': subAgentName,
      'MobileNumber': mobileNumber,
      'Address': address,
      'SubAgentOriginId': subAgentOriginId,
      'IsActive': isActive,
      'CreatedAt': createdAt.toIso8601String(),
    };
  }
}
