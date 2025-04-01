// To parse this JSON data, do
//
//     final collectionSummaryModel = collectionSummaryModelFromJson(jsonString);

import 'dart:convert';

CollectionSummaryModel collectionSummaryModelFromJson(String str) => CollectionSummaryModel.fromJson(json.decode(str));

String collectionSummaryModelToJson(CollectionSummaryModel data) => json.encode(data.toJson());

class CollectionSummaryModel {
  String? status;
  List<CollectionSummary>? data;

  CollectionSummaryModel({
    this.status,
    this.data,
  });

  factory CollectionSummaryModel.fromJson(Map<String, dynamic> json) => CollectionSummaryModel(
    status: json["Status"],
    data: json["Data"] == null ? [] : List<CollectionSummary>.from(json["Data"]!.map((x) => CollectionSummary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CollectionSummary {
  String? agentId;
  num? totalCollected;
  num? pendingCollections;
  num? totalTransactions;

  CollectionSummary({
    this.agentId,
    this.totalCollected,
    this.pendingCollections,
    this.totalTransactions,
  });

  factory CollectionSummary.fromJson(Map<String, dynamic> json) => CollectionSummary(
    agentId: json["AgentId"],
    totalCollected: json["TotalCollected"],
    pendingCollections: json["PendingCollections"],
    totalTransactions: json["TotalTransactions"],
  );

  Map<String, dynamic> toJson() => {
    "AgentId": agentId,
    "TotalCollected": totalCollected,
    "PendingCollections": pendingCollections,
    "TotalTransactions": totalTransactions,
  };
}
