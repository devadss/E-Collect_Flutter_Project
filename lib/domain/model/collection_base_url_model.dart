class CollectionBaseUrlModel {
  final String cu;
  final String du;
  final String type;

  CollectionBaseUrlModel({required this.cu, required this.du, required this.type});

  factory CollectionBaseUrlModel.fromJson(Map<String, dynamic> json) {
    return CollectionBaseUrlModel(
      cu: json['getCustomerUrl'] ?? '',
      du: json['getDueListUrl'] ?? '',
      type: json['userType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'A': cu,
      'B': du,
      'C': type,
    };
  }
}
