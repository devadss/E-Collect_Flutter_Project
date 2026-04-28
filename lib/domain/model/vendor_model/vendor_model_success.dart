
class VendorSuccessResponse {
  final String? getCustomerRdclUrl;
  final String? getDueListRdclUrl;
  final String? getCustomerRdUrl;
  final String? getDueListRdUrl;
  final String? getCustomerLoanUrl;
  final String? getDueListLoanUrl;
  final String? getLoanAccountHolderUrl;
  final String userType;

  VendorSuccessResponse({
    this.getCustomerRdclUrl,
    this.getDueListRdclUrl,
    this.getCustomerRdUrl,
    this.getDueListRdUrl,
    this.getCustomerLoanUrl,
    this.getDueListLoanUrl,
    this.getLoanAccountHolderUrl,
    required this.userType,
  });

  factory VendorSuccessResponse.fromJson(Map<String, dynamic> json) {
    return VendorSuccessResponse(
      getCustomerRdclUrl: json['getCustomerRdclUrl'],
      getDueListRdclUrl: json['getDueListRdclUrl'],
      getCustomerRdUrl: json['getCustomerRdUrl'],
      getDueListRdUrl: json['getDueListRdUrl'],
      getCustomerLoanUrl: json['getCustomerLoanUrl'],
      getDueListLoanUrl: json['getDueListLoanUrl'],
      getLoanAccountHolderUrl: json['getLoanAccountHolderUrl'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'getCustomerRdclUrl': getCustomerRdclUrl,
      'getDueListRdclUrl': getDueListRdclUrl,
      'getCustomerRdUrl': getCustomerRdUrl,
      'getDueListRdUrl': getDueListRdUrl,
      'getCustomerLoanUrl': getCustomerLoanUrl,
      'getDueListLoanUrl': getDueListLoanUrl,
      'getLoanAccountHolderUrl': getLoanAccountHolderUrl,
      'userType': userType,
    };
  }
}
