class GroupListResponse {
  final bool status;
  final String message;
  final List<Group> data;

  GroupListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GroupListResponse.fromJson(Map<String, dynamic> json) {
    return GroupListResponse(
      status: json['status'],
      message: json['message'],
      data: List<Group>.from(json['data'].map((x) => Group.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class Group {
  final int groupId;
  final String groupName;
  final String? corpCode;
  final String? branchCode;
  final double defaultAmount;
  final DateTime defaultDueDate;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final String? status;

  Group({
    required this.groupId,
    required this.groupName,
    this.corpCode,
    this.branchCode,
    required this.defaultAmount,
    required this.defaultDueDate,
    required this.createdDate,
    required this.status,
    this.updatedDate,
    required this.status
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['GroupId'],
      groupName: json['GroupName'],
      corpCode: json['CorpCode'],
      status: json['Status'],
      branchCode: json['BranchCode'],
      defaultAmount: json['DefaultAmount'].toDouble(),
      defaultDueDate: DateTime.parse(json['DefaultDueDate']),
      createdDate: DateTime.parse(json['CreatedDate']),
      updatedDate:
      json['UpdatedDate'] != null ? DateTime.parse(json['UpdatedDate']) : null,
      status: json['Status']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GroupId': groupId,
      'GroupName': groupName,
      'CorpCode': corpCode,
      'BranchCode': branchCode,
      'Status': status,
      'DefaultAmount': defaultAmount,
      'DefaultDueDate': defaultDueDate.toIso8601String(),
      'CreatedDate': createdDate.toIso8601String(),
      'UpdatedDate': updatedDate?.toIso8601String(),
      'Status':status
    };
  }
}
