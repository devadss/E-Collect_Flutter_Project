class AadhaarOtpRequestFailModel {
  AadhaarOtpRequestFailModel({
    required this.type,
    required this.code,
    required this.message,
  });

  final String? type;
  final String? code;
  final String? message;

  factory AadhaarOtpRequestFailModel.fromJson(Map<String, dynamic> json){
    return AadhaarOtpRequestFailModel(
      type: json["type"],
      code: json["code"],
      message: json["message"],
    );
  }

}
