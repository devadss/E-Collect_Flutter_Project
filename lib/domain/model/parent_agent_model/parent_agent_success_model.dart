class ParentAgentSuccessResponse {
  final bool success;
  final SubAgentData data;

  ParentAgentSuccessResponse({
    required this.success,
    required this.data,
  });

  factory ParentAgentSuccessResponse.fromJson(Map<String, dynamic> json) {
    return ParentAgentSuccessResponse(
      success: json['success'],
      data: SubAgentData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class SubAgentData {
  final int subAgentId;
  final String parentAgentId;
  final String parentAgentCorpCode;
  final String subAgentCode;
  final String parentAgentMobNo;
  final String subAgentName;
  final String mobileNumber;
  final String address;
  final String subAgentOriginId;
  final String? collectionType;
  final bool isActive;
  final DateTime createdAt;

  SubAgentData({
    required this.subAgentId,
    required this.parentAgentId,
    required this.parentAgentCorpCode,
    required this.subAgentCode,
    required this.parentAgentMobNo,
    required this.subAgentName,
    required this.mobileNumber,
    required this.address,
    required this.subAgentOriginId,
    this.collectionType,
    required this.isActive,
    required this.createdAt,
  });

  factory SubAgentData.fromJson(Map<String, dynamic> json) {
    return SubAgentData(
      subAgentId: json['SubAgentId'],
      parentAgentId: json['ParentAgentId'],
      parentAgentCorpCode: json['ParentAgentCorpCode'],
      subAgentCode: json['SubAgentCode'],
      parentAgentMobNo: json['ParentAgentMobNo'],
      subAgentName: json['SubAgentName'],
      mobileNumber: json['MobileNumber'],
      address: json['Address'],
      subAgentOriginId: json['SubAgentOriginId'],
      collectionType: json['CollectionType'],
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
      'CollectionType': collectionType,
      'IsActive': isActive,
      'CreatedAt': createdAt.toIso8601String(),
    };
  }
}