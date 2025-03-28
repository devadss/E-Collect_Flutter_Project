// To parse this JSON data, do
//
//     final updateDopModel = updateDopModelFromJson(jsonString);

import 'dart:convert';

UpdateDopModel updateDopModelFromJson(String str) => UpdateDopModel.fromJson(json.decode(str));

String updateDopModelToJson(UpdateDopModel data) => json.encode(data.toJson());

class UpdateDopModel {
  String? status;

  UpdateDopModel({
    this.status,
  });

  factory UpdateDopModel.fromJson(Map<String, dynamic> json) => UpdateDopModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
