class CollectionBaseUrlModel {
  final String tu;
  final String pu;

  CollectionBaseUrlModel({required this.tu, required this.pu});

  factory CollectionBaseUrlModel.fromJson(Map<String, dynamic> json) {
    return CollectionBaseUrlModel(
      tu: json['testUrl'] ?? '',
      pu: json['productionUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'A': tu,
      'B': pu,
    };
  }
}
