import 'dart:convert';

List<GetIvWithSkModel> welcomeFromJson(String str) => List<GetIvWithSkModel>.from(json.decode(str).map((x) => GetIvWithSkModel.fromJson(x)));

String welcomeToJson(List<GetIvWithSkModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetIvWithSkModel {
  int? id;
  String? bbpsClientId;
  String? bbpsClientSecretKey;
  String? adssPayBaseUrlDemo;
  String? adssPayBaseUrl;
  String? secretKeyBytes;
  String? enciv;

  GetIvWithSkModel({
    this.id,
    this.bbpsClientId,
    this.bbpsClientSecretKey,
    this.adssPayBaseUrlDemo,
    this.adssPayBaseUrl,
    this.secretKeyBytes,
    this.enciv,
  });

  factory GetIvWithSkModel.fromJson(Map<String, dynamic> json) => GetIvWithSkModel(
    id: json["id"],
    bbpsClientId: json["BBPS_CLIENT_ID"],
    bbpsClientSecretKey: json["BBPS_CLIENT_SECRET_KEY"],
    adssPayBaseUrlDemo: json["ADSS_PAY_BASE_URL_DEMO"],
    adssPayBaseUrl: json["ADSS_PAY_BASE_URL"],
    secretKeyBytes: json["secretKeyBytes"],
    enciv: json["Enciv"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "BBPS_CLIENT_ID": bbpsClientId,
    "BBPS_CLIENT_SECRET_KEY": bbpsClientSecretKey,
    "ADSS_PAY_BASE_URL_DEMO": adssPayBaseUrlDemo,
    "ADSS_PAY_BASE_URL": adssPayBaseUrl,
    "secretKeyBytes": secretKeyBytes,
    "Enciv": enciv,
  };
}