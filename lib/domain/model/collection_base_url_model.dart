class CollectionBaseUrlModel {
  final String getCustomerUrl;
  final String getDueListUrl;
  final String userType;

  CollectionBaseUrlModel({
    required this.getCustomerUrl,
    required this.getDueListUrl,
    required this.userType,
  });

  factory CollectionBaseUrlModel.fromJson(Map<String, dynamic> json) {
    return CollectionBaseUrlModel(
      getCustomerUrl: json['getCustomerUrl'],
      getDueListUrl: json['getDueListUrl'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'getCustomerUrl': getCustomerUrl,
      'getDueListUrl': getDueListUrl,
      'userType': userType,
    };
  }
}
