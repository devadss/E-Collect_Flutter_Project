class ECollectTokenGenSuccess {
  final bool isAuthenticated;
  final String token;
  final String refreshToken;
  final DateTime expiryDate;
  final String loginType;
  final int userId;
  final String username;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String fullName;
  final String role;
  final bool isActive;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final dynamic permissions;
  final List<dynamic> menus;
  final int merchantId;
  final int branchId;
  final int agentId;
  final String merchantName;
  final String? branchName;
  final String? branchCode;
  final String integrationStatus;
  final String? productType;
  final String? listUrl;

  ECollectTokenGenSuccess({
    required this.isAuthenticated,
    required this.token,
    required this.refreshToken,
    required this.expiryDate,
    required this.loginType,
    required this.userId,
    required this.username,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.role,
    required this.isActive,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.permissions,
    required this.menus,
    required this.merchantId,
    required this.branchId,
    required this.agentId,
    required this.merchantName,
    this.branchName,
    this.branchCode,
    required this.integrationStatus,
    this.productType,
    this.listUrl,
  });

  factory ECollectTokenGenSuccess.fromJson(Map<String, dynamic> json) {
    return ECollectTokenGenSuccess(
      isAuthenticated: json['isAuthenticated'] ?? false,
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiryDate: DateTime.parse(json['expiryDate']),
      loginType: json['loginType'] ?? '',
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? false,
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      permissions: json['permissions'],
      menus: List<dynamic>.from(json['menus'] ?? []),
      merchantId: json['merchantId'] ?? 0,
      branchId: json['branchId'] ?? 0,
      agentId: json['agentId'] ?? 0,
      merchantName: json['merchantName'] ?? '',
      branchName: json['branchName'],
      branchCode: json['branchCode'],
      integrationStatus: json['integrationStatus'] ?? '',
      productType: json['productType'],
      listUrl: json['listUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAuthenticated': isAuthenticated,
      'token': token,
      'refreshToken': refreshToken,
      'expiryDate': expiryDate.toIso8601String(),
      'loginType': loginType,
      'userId': userId,
      'username': username,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'role': role,
      'isActive': isActive,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'permissions': permissions,
      'menus': menus,
      'merchantId': merchantId,
      'branchId': branchId,
      'agentId': agentId,
      'merchantName': merchantName,
      'branchName': branchName,
      'branchCode': branchCode,
      'integrationStatus': integrationStatus,
      'productType': productType,
      'listUrl': listUrl,
    };
  }
}