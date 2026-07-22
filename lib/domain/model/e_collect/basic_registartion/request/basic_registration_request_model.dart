class BasicUserRegisterModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final int roleId;
  final int merchantId;
  final int branchId;
  final int agentId;

  BasicUserRegisterModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.roleId,
    required this.merchantId,
    required this.branchId,
    required this.agentId,
  });

  factory BasicUserRegisterModel.fromJson(Map<String, dynamic> json) {
    return BasicUserRegisterModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
      roleId: json['roleId'] ?? 0,
      merchantId: json['merchantId'] ?? 0,
      branchId: json['branchId'] ?? 0,
      agentId: json['agentId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'confirmPassword': confirmPassword,
      'roleId': roleId,
      'merchantId': merchantId,
      'branchId': branchId,
      'agentId': agentId,
    };
  }

  BasicUserRegisterModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    int? roleId,
    int? merchantId,
    int? branchId,
    int? agentId,
  }) {
    return BasicUserRegisterModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      roleId: roleId ?? this.roleId,
      merchantId: merchantId ?? this.merchantId,
      branchId: branchId ?? this.branchId,
      agentId: agentId ?? this.agentId,
    );
  }
}