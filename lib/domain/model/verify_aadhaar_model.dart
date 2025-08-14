// To parse this JSON data, do
//
//     final verifyAadhaarDetailsModel = verifyAadhaarDetailsModelFromJson(jsonString);

import 'dart:convert';

VerifyAadhaarDetailsModel verifyAadhaarDetailsModelFromJson(String str) => VerifyAadhaarDetailsModel.fromJson(json.decode(str));

String verifyAadhaarDetailsModelToJson(VerifyAadhaarDetailsModel data) => json.encode(data.toJson());

class VerifyAadhaarDetailsModel {
  String? refId;
  String? status;
  String? message;
  String? careOf;
  String? address;
  String? dob;
  String? email;
  String? gender;
  String? name;
  SplitAddress? splitAddress;
  String? yearOfBirth;
  String? mobileHash;
  String? photoLink;
  String? shareCode;
  String? xmlFile;

  VerifyAadhaarDetailsModel({
    this.refId,
    this.status,
    this.message,
    this.careOf,
    this.address,
    this.dob,
    this.email,
    this.gender,
    this.name,
    this.splitAddress,
    this.yearOfBirth,
    this.mobileHash,
    this.photoLink,
    this.shareCode,
    this.xmlFile,
  });

  factory VerifyAadhaarDetailsModel.fromJson(Map<String, dynamic> json) => VerifyAadhaarDetailsModel(
    refId: json["ref_id"],
    status: json["status"],
    message: json["message"],
    careOf: json["care_of"],
    address: json["address"],
    dob: json["dob"],
    email: json["email"],
    gender: json["gender"],
    name: json["name"],
    splitAddress: json["split_address"] == null ? null : SplitAddress.fromJson(json["split_address"]),
    yearOfBirth: json["year_of_birth"],
    mobileHash: json["mobile_hash"],
    photoLink: json["photo_link"],
    shareCode: json["share_code"],
    xmlFile: json["xml_file"],
  );

  Map<String, dynamic> toJson() => {
    "ref_id": refId,
    "status": status,
    "message": message,
    "care_of": careOf,
    "address": address,
    "dob": dob,
    "email": email,
    "gender": gender,
    "name": name,
    "split_address": splitAddress?.toJson(),
    "year_of_birth": yearOfBirth,
    "mobile_hash": mobileHash,
    "photo_link": photoLink,
    "share_code": shareCode,
    "xml_file": xmlFile,
  };
}

class SplitAddress {
  String? country;
  String? dist;
  String? house;
  String? landmark;
  String? pincode;
  String? po;
  String? state;
  String? street;
  String? subdist;
  String? vtc;
  String? locality;

  SplitAddress({
    this.country,
    this.dist,
    this.house,
    this.landmark,
    this.pincode,
    this.po,
    this.state,
    this.street,
    this.subdist,
    this.vtc,
    this.locality,
  });

  factory SplitAddress.fromJson(Map<String, dynamic> json) => SplitAddress(
    country: json["country"],
    dist: json["dist"],
    house: json["house"],
    landmark: json["landmark"],
    pincode: json["pincode"],
    po: json["po"],
    state: json["state"],
    street: json["street"],
    subdist: json["subdist"],
    vtc: json["vtc"],
    locality: json["locality"],
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "dist": dist,
    "house": house,
    "landmark": landmark,
    "pincode": pincode,
    "po": po,
    "state": state,
    "street": street,
    "subdist": subdist,
    "vtc": vtc,
    "locality": locality,
  };
}
