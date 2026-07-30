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
      success: json['success'] as bool,
      message: json['message'] as String,
      merchantId: json['merchantId'] as int,
      status: json['status'] as String,
      data: MerchantData.fromJson(json['data'] as Map<String, dynamic>),
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
  final double monthlyExpectedVolume;
  final int monthlyExpectedTransactionCount;
  final double averageTicketSize;
  final String status;
  final bool isActive;
  final bool isApproved;
  final String? rejectionReason;
  final int userId;
  final int branchId;
  final int assignedAgentId;
  final int approvedBy;
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
    required this.monthlyExpectedVolume,
    required this.monthlyExpectedTransactionCount,
    required this.averageTicketSize,
    required this.status,
    required this.isActive,
    required this.isApproved,
    this.rejectionReason,
    required this.userId,
    required this.branchId,
    required this.assignedAgentId,
    required this.approvedBy,
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
      id: json['id'] as int,
      merchantName: json['merchantName'] as String,
      merchantLegalName: json['merchantLegalName'] as String,
      registeredEmail: json['registeredEmail'] as String,
      registeredPhone: json['registeredPhone'] as String,
      businessCategory: json['businessCategory'] as String,
      entityType: json['entityType'] as String,
      websiteUrl: json['websiteUrl'] as String?,
      registeredAddress: json['registeredAddress'] as String,
      entityPAN: json['entityPAN'] as String,
      nameOnPAN: json['nameOnPAN'] as String,
      gstNumber: json['gstNumber'] as String,
      gstState: json['gstState'] as String,
      monthlyExpectedVolume:
      (json['monthlyExpectedVolume'] as num).toDouble(),
      monthlyExpectedTransactionCount:
      json['monthlyExpectedTransactionCount'] as int,
      averageTicketSize:
      (json['averageTicketSize'] as num).toDouble(),
      status: json['status'] as String,
      isActive: json['isActive'] as bool,
      isApproved: json['isApproved'] as bool,
      rejectionReason: json['rejectionReason'] as String?,
      userId: json['userId'] as int,
      branchId: json['branchId'] as int,
      assignedAgentId: json['assignedAgentId'] as int,
      approvedBy: json['approvedBy'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: _parseDate(json['updatedAt']),
      approvedAt: _parseDate(json['approvedAt']),
      user: json['user'],
      branch: json['branch'],
      assignedAgent: json['assignedAgent'],
      settlementAccounts: (json['settlementAccounts'] as List<dynamic>?)
          ?.map((e) =>
          SettlementAccount.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      stats: json['stats'],
      branchName: json['branchName'] as String?,
      assignedAgentName: json['assignedAgentName'] as String?,
      integrationStatus: json['integrationStatus'] as String?,
      userType: json['userType'] as String?,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    final str = value.toString();

    if (str.isEmpty || str.startsWith('0001-01-01')) {
      return null;
    }

    return DateTime.parse(str);
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
      accountHolderName: json['accountHolderName'] as String,
      accountNumber: json['accountNumber'] as String,
      accountType: json['accountType'] as String,
      bankName: json['bankName'] as String,
      bankBranch: json['bankBranch'] as String,
      ifscCode:
      (json['ifsC_Code'] ?? json['ifscCode']) as String,
      isPrimary: json['isPrimary'] as bool,
      isActive: json['isActive'] as bool,
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