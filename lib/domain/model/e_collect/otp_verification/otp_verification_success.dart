class LoginResponse {
  final bool success;
  final String message;
  final String token;
  final String refreshToken;
  final DateTime expiryDate;
  final User user;
  final CollectionConfig collectionConfig;

  LoginResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.refreshToken,
    required this.expiryDate,
    required this.user,
    required this.collectionConfig,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiryDate: DateTime.tryParse(json['expiryDate'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      user: User.fromJson(json['user'] ?? {}),
      collectionConfig:
      CollectionConfig.fromJson(json['collectionConfig'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'refreshToken': refreshToken,
      'expiryDate': expiryDate.toIso8601String(),
      'user': user.toJson(),
      'collectionConfig': collectionConfig.toJson(),
    };
  }
}

class User {
  final int id;
  final int? agentId;
  final String agentCode;
  final String name;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String email;
  final String role;
  final int merchantId;
  final String merchantName;
  final int branchId;
  final String branchName;
  final String branchCode;
  final String externalBranchId;
  final String externalBranchCode;
  final double commissionRate;
  final String integrationStatus;
  final bool isActive;
  final bool isVerified;
  final String externalAgentId;

  User({
    required this.id,
    this.agentId,
    required this.agentCode,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
    required this.role,
    required this.merchantId,
    required this.merchantName,
    required this.branchId,
    required this.branchName,
    required this.branchCode,
    required this.externalBranchId,
    required this.externalBranchCode,
    required this.commissionRate,
    required this.integrationStatus,
    required this.isActive,
    required this.isVerified,
    required this.externalAgentId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      agentId: json['agentId'],
      agentCode: json['agentCode'] ?? '',
      name: json['name'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      merchantId: json['merchantId'] ?? 0,
      merchantName: json['merchantName'] ?? '',
      branchId: json['branchId'] ?? 0,
      branchName: json['branchName'] ?? '',
      branchCode: json['branchCode'] ?? '',
      externalBranchId: json['externalBranchId'] ?? '',
      externalBranchCode: json['externalBranchCode'] ?? '',
      commissionRate: (json['commissionRate'] ?? 0).toDouble(),
      integrationStatus: json['integrationStatus'] ?? '',
      isActive: json['isActive'] ?? false,
      isVerified: json['isVerified'] ?? false,
      externalAgentId: json['externalAgentId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agentId': agentId,
      'agentCode': agentCode,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'email': email,
      'role': role,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'branchId': branchId,
      'branchName': branchName,
      'branchCode': branchCode,
      'externalBranchId': externalBranchId,
      'externalBranchCode': externalBranchCode,
      'commissionRate': commissionRate,
      'integrationStatus': integrationStatus,
      'isActive': isActive,
      'isVerified': isVerified,
      'externalAgentId': externalAgentId,
    };
  }
}

class CollectionConfig {
  final int merchantId;
  final String merchantName;
  final String branchCode;
  final String externalBranchId;
  final String externalBranchCode;
  final String integrationStatus;
  final Map<String, List<String>> listUrl;
  final List<CollectionType> collectionTypes;

  CollectionConfig({
    required this.merchantId,
    required this.merchantName,
    required this.branchCode,
    required this.externalBranchId,
    required this.externalBranchCode,
    required this.integrationStatus,
    required this.listUrl,
    required this.collectionTypes,
  });

  factory CollectionConfig.fromJson(Map<String, dynamic> json) {
    final rawListUrl = json['listUrl'];
    final Map<String, List<String>> parsedListUrl = {};

    if (rawListUrl is Map) {
      rawListUrl.forEach((key, value) {
        if (value is List) {
          parsedListUrl[key.toString()] = value
              .map((e) => e.toString().trim())
              .toList();
        }
      });
    }

    return CollectionConfig(
      merchantId: json['merchantId'] ?? 0,
      merchantName: json['merchantName'] ?? '',
      branchCode: json['branchCode'] ?? '',
      externalBranchId: json['externalBranchId'] ?? '',
      externalBranchCode: json['externalBranchCode'] ?? '',
      integrationStatus: json['integrationStatus'] ?? '',
      listUrl: parsedListUrl,
      collectionTypes: (json['collectionTypes'] as List<dynamic>? ?? [])
          .map((e) => CollectionType.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'merchantName': merchantName,
      'branchCode': branchCode,
      'externalBranchId': externalBranchId,
      'externalBranchCode': externalBranchCode,
      'integrationStatus': integrationStatus,
      'listUrl': listUrl,
      'collectionTypes':
      collectionTypes.map((e) => e.toJson()).toList(),
    };
  }
}

class CollectionType {
  final int id;
  final String productType;
  final String apiCode;
  final String apiName;
  final String httpMethod;
  final String urlTemplate;
  final String branchId;
  final int priority;

  CollectionType({
    required this.id,
    required this.productType,
    required this.apiCode,
    required this.apiName,
    required this.httpMethod,
    required this.urlTemplate,
    required this.branchId,
    required this.priority,
  });

  factory CollectionType.fromJson(Map<String, dynamic> json) {
    return CollectionType(
      id: json['id'] ?? 0,
      productType: json['productType'] ?? '',
      apiCode: json['apiCode'] ?? '',
      apiName: json['apiName'] ?? '',
      httpMethod: json['httpMethod'] ?? '',
      urlTemplate: json['urlTemplate'] ?? '',
      branchId: json['branchId']?.toString() ?? '',
      priority: json['priority'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productType': productType,
      'apiCode': apiCode,
      'apiName': apiName,
      'httpMethod': httpMethod,
      'urlTemplate': urlTemplate,
      'branchId': branchId,
      'priority': priority,
    };
  }
}