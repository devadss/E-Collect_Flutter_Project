class ParentAgentCredentialModel {
  final String userName;
  final String password;
  final Business b;
  final String phoneNumber;

  ParentAgentCredentialModel({
    required this.userName,
    required this.password,
    required this.b,
    required this.phoneNumber,
  });

  factory ParentAgentCredentialModel.fromJson(Map<String, dynamic> json) {
    return ParentAgentCredentialModel(
      userName: json['UserName'],
      password: json['Password'],
      b: Business.fromJson(json['b']),
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserName': userName,
      'Password': password,
      'b': b.toJson(),
      'phoneNumber': phoneNumber,
    };
  }
}

class Business {
  final int businessID;
  final String businessCode;
  final String businessName;
  final String phoneNumber;
  final String status;
  final String locality;
  final String userName;
  final String mobPassword;
  final String password;
  final DateTime upateTime;
  final String flag;
  final String entityId;
  final String referralCode;
  final String? referralCodeUsed;

  Business({
    required this.businessID,
    required this.businessCode,
    required this.businessName,
    required this.phoneNumber,
    required this.status,
    required this.locality,
    required this.userName,
    required this.mobPassword,
    required this.password,
    required this.upateTime,
    required this.flag,
    required this.entityId,
    required this.referralCode,
    this.referralCodeUsed,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessID: json['BusinessID'],
      businessCode: json['BusinessCode'],
      businessName: json['BusinessName'],
      phoneNumber: json['PhoneNumber'],
      status: json['Status'],
      locality: json['Locality'],
      userName: json['UserName'],
      mobPassword: json['MobPassword'],
      password: json['Password'],
      upateTime: DateTime.parse(json['UpateTime']),
      flag: json['Flag'],
      entityId: json['EntityId'],
      referralCode: json['referralCode'],
      referralCodeUsed: json['ReferralCodeUsed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BusinessID': businessID,
      'BusinessCode': businessCode,
      'BusinessName': businessName,
      'PhoneNumber': phoneNumber,
      'Status': status,
      'Locality': locality,
      'UserName': userName,
      'MobPassword': mobPassword,
      'Password': password,
      'UpateTime': upateTime.toIso8601String(),
      'Flag': flag,
      'EntityId': entityId,
      'referralCode': referralCode,
      'ReferralCodeUsed': referralCodeUsed,
    };
  }
}
