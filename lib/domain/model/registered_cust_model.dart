// import 'dart:convert';
//
// RegistedCustomerModel registedCoustomerModelFromJson(String str) => RegistedCustomerModel.fromJson(json.decode(str));
//
// String registedCoustomerModelToJson(RegistedCustomerModel data) => json.encode(data.toJson());
//
// class RegistedCustomerModel {
//   Response? response;
//   String? status;
//   String? mpin;
//
//   RegistedCustomerModel({
//     this.response,
//     this.status,
//     this.mpin,
//   });
//
//   factory RegistedCustomerModel.fromJson(Map<String, dynamic> json) => RegistedCustomerModel(
//     response: json["Response"] == null ? null : Response.fromJson(json["Response"]),
//     status: json["status"],
//     mpin: json["MPIN"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Response": response?.toJson(),
//     "status": status,
//     "MPIN": mpin,
//   };
// }
//
// class Response {
//   Data? data;
//   Images? images;
//
//   Response({
//     this.data,
//     this.images,
//   });
//
//   factory Response.fromJson(Map<String, dynamic> json) => Response(
//     data: json["data"] == null ? null : Data.fromJson(json["data"]),
//     images: json["Images"] == null ? null : Images.fromJson(json["Images"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": data?.toJson(),
//     "Images": images?.toJson(),
//   };
// }
//
// class Data {
//   String? custId;
//   String? channelName;
//   String? entityType;
//   String? businessType;
//   String? businessId;
//   String? otp;
//   String? title;
//   String? firstName;
//   String? middleName;
//   String? lastName;
//   String? gender;
//   String? maritalStatus;
//   String? countryCode;
//   String? addressCategory;
//   String? address1;
//   String? address2;
//   String? address3;
//   String? city;
//   String? state;
//   String? country;
//   String? pinCode;
//   String? contactNo;
//   String? emailId;
//   String? cardType;
//   String? cardCategory;
//   String? cardRegStatus;
//   String? kitNo;
//   String? documentType;
//   String? corpCode;
//   String? token;
//   String? branchCode;
//   DateTime? createdTime;
//   String? dateType;
//   DateTime? date;
//   dynamic vcipid;
//   dynamic auditorremark;
//   dynamic agentremark;
//   dynamic vcipidstatus;
//   dynamic cardPurpose;
//   dynamic ecom;
//   dynamic atm;
//   dynamic ecomLmt;
//   dynamic posLmt;
//   dynamic atmLmt;
//   dynamic contactless;
//   dynamic contactlessLmt;
//   dynamic integrationStatus;
//   dynamic vciplink;
//
//   Data({
//     this.custId,
//     this.channelName,
//     this.entityType,
//     this.businessType,
//     this.businessId,
//     this.otp,
//     this.title,
//     this.firstName,
//     this.middleName,
//     this.lastName,
//     this.gender,
//     this.maritalStatus,
//     this.countryCode,
//     this.addressCategory,
//     this.address1,
//     this.address2,
//     this.address3,
//     this.city,
//     this.state,
//     this.country,
//     this.pinCode,
//     this.contactNo,
//     this.emailId,
//     this.cardType,
//     this.cardCategory,
//     this.cardRegStatus,
//     this.kitNo,
//     this.documentType,
//     this.corpCode,
//     this.token,
//     this.branchCode,
//     this.createdTime,
//     this.dateType,
//     this.date,
//     this.vcipid,
//     this.auditorremark,
//     this.agentremark,
//     this.vcipidstatus,
//     this.cardPurpose,
//     this.ecom,
//     this.atm,
//     this.ecomLmt,
//     this.posLmt,
//     this.atmLmt,
//     this.contactless,
//     this.contactlessLmt,
//     this.integrationStatus,
//     this.vciplink,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     custId: json["CustId"],
//     channelName: json["channelName"],
//     entityType: json["entityType"],
//     businessType: json["businessType"],
//     businessId: json["businessId"],
//     otp: json["otp"],
//     title: json["title"],
//     firstName: json["firstName"],
//     middleName: json["middleName"],
//     lastName: json["lastName"],
//     gender: json["gender"],
//     maritalStatus: json["maritalStatus"],
//     countryCode: json["countryCode"],
//     addressCategory: json["addressCategory"],
//     address1: json["address1"],
//     address2: json["address2"],
//     address3: json["address3"],
//     city: json["city"],
//     state: json["state"],
//     country: json["country"],
//     pinCode: json["pinCode"],
//     contactNo: json["contactNo"],
//     emailId: json["emailId"],
//     cardType: json["cardType"],
//     cardCategory: json["cardCategory"],
//     cardRegStatus: json["cardRegStatus"],
//     kitNo: json["kitNo"],
//     documentType: json["documentType"],
//     corpCode: json["CorpCode"],
//     token: json["token"],
//     branchCode: json["BranchCode"],
//     createdTime: json["CreatedTime"] == null ? null : DateTime.parse(json["CreatedTime"]),
//     dateType: json["dateType"],
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//     vcipid: json["vcipid"],
//     auditorremark: json["auditorremark"],
//     agentremark: json["agentremark"],
//     vcipidstatus: json["vcipidstatus"],
//     cardPurpose: json["cardPurpose"],
//     ecom: json["ECOM"],
//     atm: json["ATM"],
//     ecomLmt: json["ECOM_LMT"],
//     posLmt: json["POS_LMT"],
//     atmLmt: json["ATM_LMT"],
//     contactless: json["CONTACTLESS"],
//     contactlessLmt: json["CONTACTLESS_LMT"],
//     integrationStatus: json["Integration_Status"],
//     vciplink: json["vciplink"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "CustId": custId,
//     "channelName": channelName,
//     "entityType": entityType,
//     "businessType": businessType,
//     "businessId": businessId,
//     "otp": otp,
//     "title": title,
//     "firstName": firstName,
//     "middleName": middleName,
//     "lastName": lastName,
//     "gender": gender,
//     "maritalStatus": maritalStatus,
//     "countryCode": countryCode,
//     "addressCategory": addressCategory,
//     "address1": address1,
//     "address2": address2,
//     "address3": address3,
//     "city": city,
//     "state": state,
//     "country": country,
//     "pinCode": pinCode,
//     "contactNo": contactNo,
//     "emailId": emailId,
//     "cardType": cardType,
//     "cardCategory": cardCategory,
//     "cardRegStatus": cardRegStatus,
//     "kitNo": kitNo,
//     "documentType": documentType,
//     "CorpCode": corpCode,
//     "token": token,
//     "BranchCode": branchCode,
//     "CreatedTime": createdTime?.toIso8601String(),
//     "dateType": dateType,
//     "date": date?.toIso8601String(),
//     "vcipid": vcipid,
//     "auditorremark": auditorremark,
//     "agentremark": agentremark,
//     "vcipidstatus": vcipidstatus,
//     "cardPurpose": cardPurpose,
//     "ECOM": ecom,
//     "ATM": atm,
//     "ECOM_LMT": ecomLmt,
//     "POS_LMT": posLmt,
//     "ATM_LMT": atmLmt,
//     "CONTACTLESS": contactless,
//     "CONTACTLESS_LMT": contactlessLmt,
//     "Integration_Status": integrationStatus,
//     "vciplink": vciplink,
//   };
// }
//
// class Images {
//   String? logo;
//   String? banner1;
//   String? banner2;
//   String? banner3;
//   String? banner4;
//   String? banner5;
//   String? corpName;
//   String? collectionStatus;
//   String? integrationStaus;
//
//   Images({
//     this.logo,
//     this.banner1,
//     this.banner2,
//     this.banner3,
//     this.banner4,
//     this.banner5,
//     this.corpName,
//     this.collectionStatus,
//     this.integrationStaus,
//   });
//
//   factory Images.fromJson(Map<String, dynamic> json) => Images(
//     logo: json["Logo"],
//     banner1: json["Banner1"],
//     banner2: json["Banner2"],
//     banner3: json["Banner3"],
//     banner4: json["Banner4"],
//     banner5: json["Banner5"],
//     corpName: json["CorpName"],
//     collectionStatus: json["CollectionStatus"],
//     integrationStaus: json["IntegrationStaus"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Logo": logo,
//     "Banner1": banner1,
//     "Banner2": banner2,
//     "Banner3": banner3,
//     "Banner4": banner4,
//     "Banner5": banner5,
//     "CorpName": corpName,
//     "CollectionStatus": collectionStatus,
//     "IntegrationStaus": integrationStaus,
//   };
// }


// To parse this JSON data, do
//
//     final registedCustomerModel = registedCustomerModelFromJson(jsonString);

import 'dart:convert';

RegistedCustomerModel registedCustomerModelFromJson(String str) => RegistedCustomerModel.fromJson(json.decode(str));

String registedCustomerModelToJson(RegistedCustomerModel data) => json.encode(data.toJson());

class RegistedCustomerModel {
  Response? response;
  String? status;
  String? mpin;

  RegistedCustomerModel({
    this.response,
    this.status,
    this.mpin,
  });

  factory RegistedCustomerModel.fromJson(Map<String, dynamic> json) => RegistedCustomerModel(
    response: json["Response"] == null ? null : Response.fromJson(json["Response"]),
    status: json["status"],
    mpin: json["MPIN"],
  );

  Map<String, dynamic> toJson() => {
    "Response": response?.toJson(),
    "status": status,
    "MPIN": mpin,
  };
}

class Response {
  Map<String, String?>? data;
  Images? images;

  Response({
    this.data,
    this.images,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, String?>(k, v)),
    images: json["Images"] == null ? null : Images.fromJson(json["Images"]),
  );

  Map<String, dynamic> toJson() => {
    "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "Images": images?.toJson(),
  };
}

class Images {
  String? logo;
  String? banner1;
  String? banner2;
  String? banner3;
  String? banner4;
  String? banner5;
  String? corpName;
  String? collectionStatus;
  String? integrationStaus;

  Images({
    this.logo,
    this.banner1,
    this.banner2,
    this.banner3,
    this.banner4,
    this.banner5,
    this.corpName,
    this.collectionStatus,
    this.integrationStaus,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    logo: json["Logo"],
    banner1: json["Banner1"],
    banner2: json["Banner2"],
    banner3: json["Banner3"],
    banner4: json["Banner4"],
    banner5: json["Banner5"],
    corpName: json["CorpName"],
    collectionStatus: json["CollectionStatus"],
    integrationStaus: json["IntegrationStaus"],
  );

  Map<String, dynamic> toJson() => {
    "Logo": logo,
    "Banner1": banner1,
    "Banner2": banner2,
    "Banner3": banner3,
    "Banner4": banner4,
    "Banner5": banner5,
    "CorpName": corpName,
    "CollectionStatus": collectionStatus,
    "IntegrationStaus": integrationStaus,
  };
}
