class BankIfscSuccessModel {
  final bool neft;
  final bool imps;
  final String iso3166;
  final String branch;
  final String micr;
  final String city;
  final String contact;
  final String state;
  final String district;
  final String? swift;
  final bool rtgs;
  final String address;
  final String centre;
  final bool upi;
  final String bank;
  final String bankCode;
  final String ifsc;

  BankIfscSuccessModel({
    required this.neft,
    required this.imps,
    required this.iso3166,
    required this.branch,
    required this.micr,
    required this.city,
    required this.contact,
    required this.state,
    required this.district,
    this.swift,
    required this.rtgs,
    required this.address,
    required this.centre,
    required this.upi,
    required this.bank,
    required this.bankCode,
    required this.ifsc,
  });

  factory BankIfscSuccessModel.fromJson(Map<String, dynamic> json) {
    return BankIfscSuccessModel(
      neft: json['NEFT'] ?? false,
      imps: json['IMPS'] ?? false,
      iso3166: json['ISO3166'] ?? '',
      branch: json['BRANCH'] ?? '',
      micr: json['MICR'] ?? '',
      city: json['CITY'] ?? '',
      contact: json['CONTACT'] ?? '',
      state: json['STATE'] ?? '',
      district: json['DISTRICT'] ?? '',
      swift: json['SWIFT'],
      rtgs: json['RTGS'] ?? false,
      address: json['ADDRESS'] ?? '',
      centre: json['CENTRE'] ?? '',
      upi: json['UPI'] ?? false,
      bank: json['BANK'] ?? '',
      bankCode: json['BANKCODE'] ?? '',
      ifsc: json['IFSC'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NEFT': neft,
      'IMPS': imps,
      'ISO3166': iso3166,
      'BRANCH': branch,
      'MICR': micr,
      'CITY': city,
      'CONTACT': contact,
      'STATE': state,
      'DISTRICT': district,
      'SWIFT': swift,
      'RTGS': rtgs,
      'ADDRESS': address,
      'CENTRE': centre,
      'UPI': upi,
      'BANK': bank,
      'BANKCODE': bankCode,
      'IFSC': ifsc,
    };
  }
}