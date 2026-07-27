class MerchantRegistrationSuccess {
  final bool success;
  final String message;
  final int merchantId;
  final String status;
  final MerchantData data;

  MerchantRegistrationSuccess({
    required this.success,
    required this.message,
    required this.merchantId,
    required this.status,
    required this.data,
  });

  factory MerchantRegistrationSuccess.fromJson(Map<String, dynamic> json) {
    return MerchantRegistrationSuccess(
      success: json['success'],
      message: json['message'],
      merchantId: json['merchantId'],
      status: json['status'],
      data: MerchantData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'merchantId': merchantId,
    'status': status,
    'data': data.toJson(),
  };
}

class MerchantData {
  final int id;
  final String merchantName;
  final String merchantLegalName;
  final String registeredEmail;
  final String registeredPhone;
  final String businessCategory;
  final String entityType;
  final String? websiteUrl;
  final String registeredAddress;
  final String entityPAN;
  final String nameOnPAN;
  final String gstNumber;
  final String gstState;
  final double? monthlyExpectedVolume;
  final int? monthlyExpectedTransactionCount;
  final double? averageTicketSize;
  final String status;
  final bool isActive;
  final bool isApproved;
  final String? rejectionReason;
  final int? userId;
  final int? branchId;
  final int? assignedAgentId;
  final int? approvedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? approvedAt;
  final dynamic user;
  final dynamic branch;
  final dynamic assignedAgent;
  final List<SettlementAccount> settlementAccounts;
  final dynamic stats;
  final String? branchName;
  final String? assignedAgentName;
  final String? integrationStatus;
  final String? userType;

  MerchantData({
    required this.id,
    required this.merchantName,
    required this.merchantLegalName,
    required this.registeredEmail,
    required this.registeredPhone,
    required this.businessCategory,
    required this.entityType,
    this.websiteUrl,
    required this.registeredAddress,
    required this.entityPAN,
    required this.nameOnPAN,
    required this.gstNumber,
    required this.gstState,
    this.monthlyExpectedVolume,
    this.monthlyExpectedTransactionCount,
    this.averageTicketSize,
    required this.status,
    required this.isActive,
    required this.isApproved,
    this.rejectionReason,
    this.userId,
    this.branchId,
    this.assignedAgentId,
    this.approvedBy,
    required this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.user,
    this.branch,
    this.assignedAgent,
    required this.settlementAccounts,
    this.stats,
    this.branchName,
    this.assignedAgentName,
    this.integrationStatus,
    this.userType,
  });

  factory MerchantData.fromJson(Map<String, dynamic> json) {
    return MerchantData(
      id: json['id'],
      merchantName: json['merchantName'],
      merchantLegalName: json['merchantLegalName'],
      registeredEmail: json['registeredEmail'],
      registeredPhone: json['registeredPhone'],
      businessCategory: json['businessCategory'],
      entityType: json['entityType'],
      websiteUrl: json['websiteUrl'],
      registeredAddress: json['registeredAddress'],
      entityPAN: json['entityPAN'],
      nameOnPAN: json['nameOnPAN'],
      gstNumber: json['gstNumber'],
      gstState: json['gstState'],
      monthlyExpectedVolume:
      (json['monthlyExpectedVolume'] as num?)?.toDouble(),
      monthlyExpectedTransactionCount:
      json['monthlyExpectedTransactionCount'],
      averageTicketSize:
      (json['averageTicketSize'] as num?)?.toDouble(),
      status: json['status'],
      isActive: json['isActive'],
      isApproved: json['isApproved'],
      rejectionReason: json['rejectionReason'],
      userId: json['userId'],
      branchId: json['branchId'],
      assignedAgentId: json['assignedAgentId'],
      approvedBy: json['approvedBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'])
          : null,
      user: json['user'],
      branch: json['branch'],
      assignedAgent: json['assignedAgent'],
      settlementAccounts: (json['settlementAccounts'] as List)
          .map((e) => SettlementAccount.fromJson(e))
          .toList(),
      stats: json['stats'],
      branchName: json['branchName'],
      assignedAgentName: json['assignedAgentName'],
      integrationStatus: json['integrationStatus'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'merchantName': merchantName,
    'merchantLegalName': merchantLegalName,
    'registeredEmail': registeredEmail,
    'registeredPhone': registeredPhone,
    'businessCategory': businessCategory,
    'entityType': entityType,
    'websiteUrl': websiteUrl,
    'registeredAddress': registeredAddress,
    'entityPAN': entityPAN,
    'nameOnPAN': nameOnPAN,
    'gstNumber': gstNumber,
    'gstState': gstState,
    'monthlyExpectedVolume': monthlyExpectedVolume,
    'monthlyExpectedTransactionCount':
    monthlyExpectedTransactionCount,
    'averageTicketSize': averageTicketSize,
    'status': status,
    'isActive': isActive,
    'isApproved': isApproved,
    'rejectionReason': rejectionReason,
    'userId': userId,
    'branchId': branchId,
    'assignedAgentId': assignedAgentId,
    'approvedBy': approvedBy,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'approvedAt': approvedAt?.toIso8601String(),
    'user': user,
    'branch': branch,
    'assignedAgent': assignedAgent,
    'settlementAccounts':
    settlementAccounts.map((e) => e.toJson()).toList(),
    'stats': stats,
    'branchName': branchName,
    'assignedAgentName': assignedAgentName,
    'integrationStatus': integrationStatus,
    'userType': userType,
  };
}

class SettlementAccount {
  final String accountHolderName;
  final String accountNumber;
  final String accountType;
  final String bankName;
  final String bankBranch;
  final String ifscCode;
  final bool isPrimary;
  final bool isActive;

  SettlementAccount({
    required this.accountHolderName,
    required this.accountNumber,
    required this.accountType,
    required this.bankName,
    required this.bankBranch,
    required this.ifscCode,
    required this.isPrimary,
    required this.isActive,
  });

  factory SettlementAccount.fromJson(Map<String, dynamic> json) {
    return SettlementAccount(
      accountHolderName: json['accountHolderName'],
      accountNumber: json['accountNumber'],
      accountType: json['accountType'],
      bankName: json['bankName'],
      bankBranch: json['bankBranch'],
      ifscCode: json['ifsC_Code'],
      isPrimary: json['isPrimary'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
    'accountHolderName': accountHolderName,
    'accountNumber': accountNumber,
    'accountType': accountType,
    'bankName': bankName,
    'bankBranch': bankBranch,
    'ifsC_Code': ifscCode,
    'isPrimary': isPrimary,
    'isActive': isActive,
  };


}
