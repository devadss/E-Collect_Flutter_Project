// To parse this JSON data, do
//
//     final dueListModel = dueListModelFromJson(jsonString);

import 'dart:convert';

DueListModel dueListModelFromJson(String str) => DueListModel.fromJson(json.decode(str));

String dueListModelToJson(DueListModel data) => json.encode(data.toJson());

class DueListModel {
  DuesList? duesList;

  DueListModel({
    this.duesList,
  });

  factory DueListModel.fromJson(Map<String, dynamic> json) => DueListModel(
    duesList: json["DuesList"] == null ? null : DuesList.fromJson(json["DuesList"]),
  );

  Map<String, dynamic> toJson() => {
    "DuesList": duesList?.toJson(),
  };
}

class DuesList {
  List<Datum>? data;

  DuesList({
    this.data,
  });

  factory DuesList.fromJson(Map<String, dynamic> json) => DuesList(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? accNo;
  String? openDate;
  double? installAmt;
  String? dueMonth;
  double? dueAmount;

  Datum({
    this.accNo,
    this.openDate,
    this.installAmt,
    this.dueMonth,
    this.dueAmount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    accNo: json["AccNo"],
    openDate: json["OpenDate"],
    installAmt: json["InstallAmt"],
    dueMonth: json["DueMonth"],
    dueAmount: json["DueAmount"],
  );

  Map<String, dynamic> toJson() => {
    "AccNo": accNo,
    "OpenDate": openDate,
    "InstallAmt": installAmt,
    "DueMonth": dueMonth,
    "DueAmount": dueAmount,
  };
}
