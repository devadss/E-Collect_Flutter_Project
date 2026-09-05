class CompleteLoanLisResponse {
  final String status;
  final bool success;
  final int count;
  final List<LoanData> data;

  CompleteLoanLisResponse({
    required this.status,
    required this.success,
    required this.count,
    required this.data,
  });

  factory CompleteLoanLisResponse.fromJson(Map<String, dynamic> json) {
    return CompleteLoanLisResponse(
      status: json['status'] as String,
      success: json['success'] as bool,
      count: json['count'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => LoanData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'count': count,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class LoanData {
  final int id;
  final int merchantId;
  final String branchCode;
  final String accountNumber;
  final String customerName;
  final String mobileNumber;
  final String productType;
  final num outstandingAmount;
  final num dueAmount;
  final num emiAmount;
  final String emiFrequency;
  final DateTime lastPaidDate;
  final DateTime nextDueDate;
  final int? assignedAgentId;
  final String assignedAgentCode;
  final String assignedAgentName;
  final bool reminderEnabled;
  final int reminderDaysBeforeDue;
  final String reminderChannels;
  final String reminderRiskLevel;
  final DateTime? lastReminderSentAt;
  final String? lastReminderChannel;
  final String? customReminderNote;
  final String status;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? createdBy;

  LoanData({
    required this.id,
    required this.merchantId,
    required this.branchCode,
    required this.accountNumber,
    required this.customerName,
    required this.mobileNumber,
    required this.productType,
    required this.outstandingAmount,
    required this.dueAmount,
    required this.emiAmount,
    required this.emiFrequency,
    required this.lastPaidDate,
    required this.nextDueDate,
    this.assignedAgentId,
    required this.assignedAgentCode,
    required this.assignedAgentName,
    required this.reminderEnabled,
    required this.reminderDaysBeforeDue,
    required this.reminderChannels,
    required this.reminderRiskLevel,
    this.lastReminderSentAt,
    this.lastReminderChannel,
    this.customReminderNote,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
  });

  factory LoanData.fromJson(Map<String, dynamic> json) {
    return LoanData(
      id: json['id'] as int,
      merchantId: json['merchantId'] as int,
      branchCode: json['branchCode'] as String,
      accountNumber: json['accountNumber'] as String,
      customerName: json['customerName'] as String,
      mobileNumber: json['mobileNumber'] as String,
      productType: json['productType'] as String,
      outstandingAmount: json['outstandingAmount'] as num,
      dueAmount: json['dueAmount'] as num,
      emiAmount: json['emiAmount'] as num,
      emiFrequency: json['emiFrequency'] as String,
      lastPaidDate: DateTime.parse(json['lastPaidDate'] as String),
      nextDueDate: DateTime.parse(json['nextDueDate'] as String),
      assignedAgentId: json['assignedAgentId'] as int?,
      assignedAgentCode: json['assignedAgentCode'] as String,
      assignedAgentName: json['assignedAgentName'] as String,
      reminderEnabled: json['reminderEnabled'] as bool,
      reminderDaysBeforeDue: json['reminderDaysBeforeDue'] as int,
      reminderChannels: json['reminderChannels'] as String,
      reminderRiskLevel: json['reminderRiskLevel'] as String,
      lastReminderSentAt: json['lastReminderSentAt'] != null
          ? DateTime.parse(json['lastReminderSentAt'] as String)
          : null,
      lastReminderChannel: json['lastReminderChannel'] as String?,
      customReminderNote: json['customReminderNote'] as String?,
      status: json['status'] as String,
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantId': merchantId,
      'branchCode': branchCode,
      'accountNumber': accountNumber,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'productType': productType,
      'outstandingAmount': outstandingAmount,
      'dueAmount': dueAmount,
      'emiAmount': emiAmount,
      'emiFrequency': emiFrequency,
      'lastPaidDate': lastPaidDate.toIso8601String(),
      'nextDueDate': nextDueDate.toIso8601String(),
      'assignedAgentId': assignedAgentId,
      'assignedAgentCode': assignedAgentCode,
      'assignedAgentName': assignedAgentName,
      'reminderEnabled': reminderEnabled,
      'reminderDaysBeforeDue': reminderDaysBeforeDue,
      'reminderChannels': reminderChannels,
      'reminderRiskLevel': reminderRiskLevel,
      'lastReminderSentAt': lastReminderSentAt?.toIso8601String(),
      'lastReminderChannel': lastReminderChannel,
      'customReminderNote': customReminderNote,
      'status': status,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }
}