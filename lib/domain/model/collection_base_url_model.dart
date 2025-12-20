
class CollectionBaseUrlModel {
  final String? getCustomerRdclUrl;
  final String? getDueListRdclUrl;
  final String? getCustomerRdUrl;
  final String? getDueListRdUrl;
  final String? getCustomerLoanUrl;
  final String? getDueListLoanUrl;
  final String? getLoanAccountHolderUrl;
  final String userType;

  CollectionBaseUrlModel({
    this.getCustomerRdclUrl,
    this.getDueListRdclUrl,
    this.getCustomerRdUrl,
    this.getDueListRdUrl,
    this.getCustomerLoanUrl,
    this.getDueListLoanUrl,
    this.getLoanAccountHolderUrl,
    required this.userType,
  });

  factory CollectionBaseUrlModel.fromJson(Map<String, dynamic> json) {
    return CollectionBaseUrlModel(
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

// class CollectionBaseUrlModel {
//   final String getCustomerUrl;
//   final String getDueListUrl;
//   final String userType;
//
//   CollectionBaseUrlModel({
//     required this.getCustomerUrl,
//     required this.getDueListUrl,
//     required this.userType,
//   });
//
//   factory CollectionBaseUrlModel.fromJson(Map<String, dynamic> json) {
//     return CollectionBaseUrlModel(
//       getCustomerUrl: json['getCustomerUrl'],
//       getDueListUrl: json['getDueListUrl'],
//       userType: json['userType'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'getCustomerUrl': getCustomerUrl,
//       'getDueListUrl': getDueListUrl,
//       'userType': userType,
//     };
//   }
// }
