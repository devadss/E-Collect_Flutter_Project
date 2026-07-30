class MerchantRegistrationRequestModel {
  final String merchantName;
  final String merchantLegalName;
  final String registeredEmail;
  final String registeredPhone;
  final String businessCategory;
  final String entityType;
  final String registeredAddress;
  final String entityPAN;
  final String nameOnPAN;
  final String gstNumber;
  final String gstState;
  final String username;
  final String password;
  final String confirmPassword;
  final String integrationStatus;
  final List<SettlementAccount> settlementAccounts;

  MerchantRegistrationRequestModel({
    required this.merchantName,
    required this.merchantLegalName,
    required this.registeredEmail,
    required this.registeredPhone,
    required this.businessCategory,
    required this.entityType,
    required this.registeredAddress,
    required this.entityPAN,
    required this.nameOnPAN,
    required this.gstNumber,
    required this.gstState,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.settlementAccounts, required this.integrationStatus,
  });

  factory MerchantRegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    return MerchantRegistrationRequestModel(
      merchantName: json['merchantName'] ?? '',
      merchantLegalName: json['merchantLegalName'] ?? '',
      registeredEmail: json['registeredEmail'] ?? '',
      registeredPhone: json['registeredPhone'] ?? '',
      businessCategory: json['businessCategory'] ?? '',
      entityType: json['entityType'] ?? '',
      registeredAddress: json['registeredAddress'] ?? '',
      entityPAN: json['entityPAN'] ?? '',
      nameOnPAN: json['nameOnPAN'] ?? '',
      gstNumber: json['gstNumber'] ?? '',
      gstState: json['gstState'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      integrationStatus: json['integrationStatus'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
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
      'registeredAddress': registeredAddress,
      'entityPAN': entityPAN,
      'nameOnPAN': nameOnPAN,
      'gstNumber': gstNumber,
      'gstState': gstState,
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
      'integrationStatus': integrationStatus,
      'settlementAccounts':
      settlementAccounts.map((e) => e.toJson()).toList(),
    };
  }
  void printValues() {
    print('Merchant Name: $merchantName');
    print('Merchant Legal Name: $merchantLegalName');
    print('Registered Email: $registeredEmail');
    print('Registered Phone: $registeredPhone');
    print('Business Category: $businessCategory');
    print('Entity Type: $entityType');
    print('Registered Address: $registeredAddress');
    print('Entity PAN: $entityPAN');
    print('Name on PAN: $nameOnPAN');
    print('GST Number: $gstNumber');
    print('GST State: $gstState');
    print('Username: $username');
    print('Password: $password');
    print('Confirm Password: $confirmPassword');
    print('integrationStatus: $integrationStatus');

    print('Settlement Accounts:');
    for (int i = 0; i < settlementAccounts.length; i++) {
      print('--- Account ${i + 1} ---');
      settlementAccounts[i].printValues();
    }
  }
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

  Map<String, dynamic> toJson() {
    return {
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
  void printValues() {
    print('Account Holder Name: $accountHolderName');
    print('Account Number: $accountNumber');
    print('Account Type: $accountType');
    print('Bank Name: $bankName');
    print('Bank Branch: $bankBranch');
    print('IFSC Code: $ifsCCode');
    print('Is Primary: $isPrimary');
    print('Is Active: $isActive');
  }
}

