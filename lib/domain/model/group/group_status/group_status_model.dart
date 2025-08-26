// To parse this JSON data, do
//
//     final groupStatusModel = groupStatusModelFromJson(jsonString);

import 'dart:convert';

GroupStatusModel groupStatusModelFromJson(String str) => GroupStatusModel.fromJson(json.decode(str));

String groupStatusModelToJson(GroupStatusModel data) => json.encode(data.toJson());

class GroupStatusModel {
  bool? status;
  String? message;
  String? currentStatus;

  GroupStatusModel({
    this.status,
    this.message,
    this.currentStatus,
  });

  factory GroupStatusModel.fromJson(Map<String, dynamic> json) => GroupStatusModel(
    status: json["status"],
    message: json["message"],
    currentStatus: json["currentStatus"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "currentStatus": currentStatus,
  };
}
