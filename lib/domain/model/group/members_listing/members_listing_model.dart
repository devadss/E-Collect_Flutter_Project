class MemberListResponse {
  final bool status;
  final String message;
  final List<Member> data;

  MemberListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MemberListResponse.fromJson(Map<String, dynamic> json) {
    return MemberListResponse(
      status: json['status'],
      message: json['message'],
      data: List<Member>.from(json['data'].map((item) => Member.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class Member {
  final int memberId;
  final String memberName;
  final String mobileNumber;
  final double amount;
  final DateTime dueDate;
  final DateTime feeCollectionStartDate;
  final String branchCode;
  final String corpCode;
  final String entityId;

  Member({
    required this.memberId,
    required this.memberName,
    required this.mobileNumber,
    required this.amount,
    required this.dueDate,
    required this.feeCollectionStartDate,
    required this.branchCode,
    required this.corpCode,
    required this.entityId,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['MemberId'],
      memberName: json['MemberName'],
      mobileNumber: json['MobileNumber'],
      amount: (json['Amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['DueDate']),
      feeCollectionStartDate: DateTime.parse(json['FeeCollectionStartDate']),
      branchCode: json['BranchCode'],
      corpCode: json['CorpCode'],
      entityId: json['EntityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MemberId': memberId,
      'MemberName': memberName,
      'MobileNumber': mobileNumber,
      'Amount': amount,
      'DueDate': dueDate.toIso8601String(),
      'FeeCollectionStartDate': feeCollectionStartDate.toIso8601String(),
      'BranchCode': branchCode,
      'CorpCode': corpCode,
      'EntityId': entityId,
    };
  }
}
