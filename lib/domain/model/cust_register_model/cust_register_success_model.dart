class RegistedCustomer {
  final ResponseData response;
  final String status;
  String? mpin;

  RegistedCustomer({
    required this.response,
    required this.status,
    required this.mpin,
  });

  factory RegistedCustomer.fromJson(Map<String, dynamic> json) {
    return RegistedCustomer(
      response: ResponseData.fromJson(json['Response']),
      status: json['status'],
      mpin: json['MPIN'],
    );
  }
}

class ResponseData {
  final CustomerData data;
  final Images images;

  ResponseData({
    required this.data,
    required this.images,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      data: CustomerData.fromJson(json['data']),
      images: Images.fromJson(json['Images']),
    );
  }
}

class CustomerData {
  final String custId;
  final String channelName;
  final String entityType;
  final String businessType;
  final String businessId;
  final String otp;
  final String title;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String gender;
  final String maritalStatus;
  final String countryCode;
  final String addressCategory;
  final String address1;
  final String address2;
  final String address3;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String contactNo;
  final String emailId;
  final String cardType;
  final String cardCategory;
  final String cardRegStatus;
  final String kitNo;
  final String documentType;
  final String corpCode;
  final String token;
  final String branchCode;
  final DateTime createdTime;
  final String dateType;
  final DateTime date;
  final String? vcipid;
  final String? auditorremark;
  final String? agentremark;
  final String? vcipidstatus;
  final String? cardPurpose;
  final String ecom;
  final String? atm;
  final String ecomLmt;
  final String posLmt;
  final String? atmLmt;
  final String contactless;
  final String contactlessLmt;
  final String integrationStatus;
  final String? vciplink;
  final String? merchant;
  final String customerType;
  final String agentOrginId;

  CustomerData({
    required this.custId,
    required this.channelName,
    required this.entityType,
    required this.businessType,
    required this.businessId,
    required this.otp,
    required this.title,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.gender,
    required this.maritalStatus,
    required this.countryCode,
    required this.addressCategory,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
    required this.contactNo,
    required this.emailId,
    required this.cardType,
    required this.cardCategory,
    required this.cardRegStatus,
    required this.kitNo,
    required this.documentType,
    required this.corpCode,
    required this.token,
    required this.branchCode,
    required this.createdTime,
    required this.dateType,
    required this.date,
    this.vcipid,
    this.auditorremark,
    this.agentremark,
    this.vcipidstatus,
    this.cardPurpose,
    required this.ecom,
    this.atm,
    required this.ecomLmt,
    required this.posLmt,
    this.atmLmt,
    required this.contactless,
    required this.contactlessLmt,
    required this.integrationStatus,
    this.vciplink,
    this.merchant,
    required this.customerType,
    required this.agentOrginId,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      custId: json['CustId'],
      channelName: json['channelName'],
      entityType: json['entityType'],
      businessType: json['businessType'],
      businessId: json['businessId'],
      otp: json['otp'],
      title: json['title'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      gender: json['gender'],
      maritalStatus: json['maritalStatus'],
      countryCode: json['countryCode'],
      addressCategory: json['addressCategory'],
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pinCode: json['pinCode'],
      contactNo: json['contactNo'],
      emailId: json['emailId'],
      cardType: json['cardType'],
      cardCategory: json['cardCategory'],
      cardRegStatus: json['cardRegStatus'],
      kitNo: json['kitNo'],
      documentType: json['documentType'],
      corpCode: json['CorpCode'],
      token: json['token'],
      branchCode: json['BranchCode'],
      createdTime: DateTime.parse(json['CreatedTime']),
      dateType: json['dateType'],
      date: DateTime.parse(json['date']),
      vcipid: json['vcipid'],
      auditorremark: json['auditorremark'],
      agentremark: json['agentremark'],
      vcipidstatus: json['vcipidstatus'],
      cardPurpose: json['cardPurpose'],
      ecom: json['ECOM'],
      atm: json['ATM'],
      ecomLmt: json['ECOM_LMT'],
      posLmt: json['POS_LMT'],
      atmLmt: json['ATM_LMT'],
      contactless: json['CONTACTLESS'],
      contactlessLmt: json['CONTACTLESS_LMT'],
      integrationStatus: json['Integration_Status'],
      vciplink: json['vciplink'],
      merchant: json['Merchant'],
      customerType: json['Customer_type'],
      agentOrginId: json['AgentOrginId'],
    );
  }
}

class Images {
  final String logo;
  final String banner1;
  final String banner2;
  final String banner3;
  final String banner4;
  final String banner5;
  final String corpName;
  final String collectionStatus;
  final String integrationStatus;

  Images({
    required this.logo,
    required this.banner1,
    required this.banner2,
    required this.banner3,
    required this.banner4,
    required this.banner5,
    required this.corpName,
    required this.collectionStatus,
    required this.integrationStatus,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      logo: json['Logo'] ?? '',
      banner1: json['Banner1'] ?? '',
      banner2: json['Banner2'] ?? '',
      banner3: json['Banner3'] ?? '',
      banner4: json['Banner4'] ?? '',
      banner5: json['Banner5'] ?? '',
      corpName: json['CorpName'],
      collectionStatus: json['CollectionStatus'],
      integrationStatus: json['IntegrationStaus'],
    );
  }
}