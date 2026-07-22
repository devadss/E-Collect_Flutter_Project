class LoginResponse {
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
  final List<dynamic> permissions;
  final List<dynamic> menus;
  final int? merchantId;
  final int? branchId;
  final int? agentId;
  final String? merchantName;
  final String? branchName;

  LoginResponse({
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
    this.merchantId,
    this.branchId,
    this.agentId,
    this.merchantName,
    this.branchName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
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
      permissions: List<dynamic>.from(json['permissions'] ?? []),
      menus: List<dynamic>.from(json['menus'] ?? []),
      merchantId: json['merchantId'],
      branchId: json['branchId'],
      agentId: json['agentId'],
      merchantName: json['merchantName'],
      branchName: json['branchName'],
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
    };
  }
}