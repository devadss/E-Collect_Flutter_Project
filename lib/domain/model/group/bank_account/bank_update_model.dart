class BankAccountUpdateResponse {
  final bool status;
  final String message;
  final List<Account> data;

  BankAccountUpdateResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BankAccountUpdateResponse.fromJson(Map<String, dynamic> json) {
    return BankAccountUpdateResponse(
      status: json['status'],
      message: json['message'],
      data: List<Account>.from(json['data'].map((item) => Account.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((account) => account.toJson()).toList(),
    };
  }
}

class Account {
  final int accountId;
  final int userId;
  final String accountHolderName;
  final String accountNumber;
  final String ifsc;
  final String createdDate;
  final String? updatedDate;
  final String corpCode;
  final String branchCode;
  final String entityId;

  Account({
    required this.accountId,
    required this.userId,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifsc,
    required this.createdDate,
    this.updatedDate,
    required this.corpCode,
    required this.branchCode,
    required this.entityId,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['AccountId'],
      userId: json['UserId'],
      accountHolderName: json['AccountHolderName'],
      accountNumber: json['AccountNumber'],
      ifsc: json['IFSC'],
      createdDate: json['CreatedDate'],
      updatedDate: json['UpdatedDate'],
      corpCode: json['CorpCode'],
      branchCode: json['BranchCode'],
      entityId: json['EntityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccountId': accountId,
      'UserId': userId,
      'AccountHolderName': accountHolderName,
      'AccountNumber': accountNumber,
      'IFSC': ifsc,
      'CreatedDate': createdDate,
      'UpdatedDate': updatedDate,
      'CorpCode': corpCode,
      'BranchCode': branchCode,
      'EntityId': entityId,
    };
  }
}
