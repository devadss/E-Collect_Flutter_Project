class MerchantRegistrationRequestModel {
  final String merchantName;
  final String merchantLegalName;
  final String registeredEmail;
  final String registeredPhone;
  final String businessCategory;
  final String entityType;
  final String websiteUrl;
  final String registeredAddress;
  final String entityPAN;
  final String nameOnPAN;
  final String gstNumber;
  final String gstState;
  final int monthlyExpectedVolume;
  final int monthlyExpectedTransactionCount;
  final int averageTicketSize;
  final int branchId;
  final int assignedAgentId;
  final ContactPerson contactPerson;
  final AuthorizedSignatory authorizedSignatory;
  final List<SettlementAccount> settlementAccounts;

  MerchantRegistrationRequestModel({
    required this.merchantName,
    required this.merchantLegalName,
    required this.registeredEmail,
    required this.registeredPhone,
    required this.businessCategory,
    required this.entityType,
    required this.websiteUrl,
    required this.registeredAddress,
    required this.entityPAN,
    required this.nameOnPAN,
    required this.gstNumber,
    required this.gstState,
    required this.monthlyExpectedVolume,
    required this.monthlyExpectedTransactionCount,
    required this.averageTicketSize,
    required this.branchId,
    required this.assignedAgentId,
    required this.contactPerson,
    required this.authorizedSignatory,
    required this.settlementAccounts,
  });

  factory MerchantRegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    return MerchantRegistrationRequestModel(
      merchantName: json['merchantName'] ?? '',
      merchantLegalName: json['merchantLegalName'] ?? '',
      registeredEmail: json['registeredEmail'] ?? '',
      registeredPhone: json['registeredPhone'] ?? '',
      businessCategory: json['businessCategory'] ?? '',
      entityType: json['entityType'] ?? '',
      websiteUrl: json['websiteUrl'] ?? '',
      registeredAddress: json['registeredAddress'] ?? '',
      entityPAN: json['entityPAN'] ?? '',
      nameOnPAN: json['nameOnPAN'] ?? '',
      gstNumber: json['gstNumber'] ?? '',
      gstState: json['gstState'] ?? '',
      monthlyExpectedVolume: json['monthlyExpectedVolume'] ?? 0,
      monthlyExpectedTransactionCount:
      json['monthlyExpectedTransactionCount'] ?? 0,
      averageTicketSize: json['averageTicketSize'] ?? 0,
      branchId: json['branchId'] ?? 0,
      assignedAgentId: json['assignedAgentId'] ?? 0,
      contactPerson:
      ContactPerson.fromJson(json['contactPerson'] ?? {}),
      authorizedSignatory:
      AuthorizedSignatory.fromJson(json['authorizedSignatory'] ?? {}),
      settlementAccounts: (json['settlementAccounts'] as List<dynamic>? ?? [])
          .map((e) => SettlementAccount.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'branchId': branchId,
      'assignedAgentId': assignedAgentId,
      'contactPerson': contactPerson.toJson(),
      'authorizedSignatory': authorizedSignatory.toJson(),
      'settlementAccounts':
      settlementAccounts.map((e) => e.toJson()).toList(),
    };
  }
}

class ContactPerson {
  final String name;
  final String emailAddress;
  final String phoneNumber;

  ContactPerson({
    required this.name,
    required this.emailAddress,
    required this.phoneNumber,
  });

  factory ContactPerson.fromJson(Map<String, dynamic> json) {
    return ContactPerson(
      name: json['name'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'emailAddress': emailAddress,
    'phoneNumber': phoneNumber,
  };
}

class AuthorizedSignatory {
  final String name;
  final String panNumber;
  final String phone;
  final String email;
  final String designation;

  AuthorizedSignatory({
    required this.name,
    required this.panNumber,
    required this.phone,
    required this.email,
    required this.designation,
  });

  factory AuthorizedSignatory.fromJson(Map<String, dynamic> json) {
    return AuthorizedSignatory(
      name: json['name'] ?? '',
      panNumber: json['panNumber'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      designation: json['designation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'panNumber': panNumber,
    'phone': phone,
    'email': email,
    'designation': designation,
  };
}

class SettlementAccount {
  final String accountHolderName;
  final String accountNumber;
  final String accountType;
  final String bankName;
  final String bankBranch;
  final String ifsCCode;
  final bool isPrimary;
  final bool isActive;

  SettlementAccount({
    required this.accountHolderName,
    required this.accountNumber,
    required this.accountType,
    required this.bankName,
    required this.bankBranch,
    required this.ifsCCode,
    required this.isPrimary,
    required this.isActive,
  });

  factory SettlementAccount.fromJson(Map<String, dynamic> json) {
    return SettlementAccount(
      accountHolderName: json['accountHolderName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountType: json['accountType'] ?? '',
      bankName: json['bankName'] ?? '',
      bankBranch: json['bankBranch'] ?? '',
      ifsCCode: json['ifsC_Code'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'accountHolderName': accountHolderName,
    'accountNumber': accountNumber,
    'accountType': accountType,
    'bankName': bankName,
    'bankBranch': bankBranch,
    'ifsC_Code': ifsCCode,
    'isPrimary': isPrimary,
    'isActive': isActive,
  };
}