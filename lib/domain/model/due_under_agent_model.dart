// To parse this JSON data, do
//
//     final dueUnderAgentModel = dueUnderAgentModelFromJson(jsonString);

import 'dart:convert';

DueUnderAgentModel dueUnderAgentModelFromJson(String str) => DueUnderAgentModel.fromJson(json.decode(str));

String dueUnderAgentModelToJson(DueUnderAgentModel data) => json.encode(data.toJson());

class DueUnderAgentModel {
  DuesList1? duesList1;

  DueUnderAgentModel({
    this.duesList1,
  });

  factory DueUnderAgentModel.fromJson(Map<String, dynamic> json) => DueUnderAgentModel(
    duesList1: json["DuesList1"] == null ? null : DuesList1.fromJson(json["DuesList1"]),
  );

  Map<String, dynamic> toJson() => {
    "DuesList1": duesList1?.toJson(),
  };
}

class DuesList1 {
  List<DueUnderAgnet>? data;

  DuesList1({
    this.data,
  });

  factory DuesList1.fromJson(Map<String, dynamic> json) => DuesList1(
    data: json["data"] == null ? [] : List<DueUnderAgnet>.from(json["data"]!.map((x) => DueUnderAgnet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
// "AccNo": "00071001",
// "OpenDate": "2024-01-30",
// "InstallAmt": 372500,
// "PaidAmount": "46902",
// "DueAmount": 325598,
// "TotalInstallment": "17",
// "Name": "UMMAR K",
// "PaidInstallments": "3",
// "DueInstallments": "14"
class DueUnderAgnet {
  String? accNo;
  String? openDate;
  num? installAmt;
  DueMonth? dueMonth;
  num? dueAmount;
  String? custId;
  String? name;
  String? phone;
  String? email;

  DueUnderAgnet({
    this.accNo,
    this.openDate,
    this.installAmt,
    this.dueMonth,
    this.dueAmount,
    this.custId,
    this.name,
    this.phone,
    this.email,
  });

  factory DueUnderAgnet.fromJson(Map<String, dynamic> json) => DueUnderAgnet(
    accNo: json["AccNo"],
    openDate: json["OpenDate"],
    installAmt: json["InstallAmt"],
    dueMonth: dueMonthValues.map[json["DueMonth"]],
    dueAmount: json["DueAmount"],
    custId: json["CustId"],
    name: json["Name"],
    phone: json["Phone"],
    email: json["Email"],
  );

  Map<String, dynamic> toJson() => {
    "AccNo": accNo,
    "OpenDate": openDate,
    "InstallAmt": installAmt,
    "DueMonth": dueMonthValues.reverse[dueMonth],
    "DueAmount": dueAmount,
    "CustId": custId,
    "Name": name,
    "Phone": phone,
    "Email": email,
  };
}

enum DueMonth {
  THE_202406,
  THE_202407,
  THE_202408,
  THE_202409,
  THE_202410,
  THE_202411
}

final dueMonthValues = EnumValues({
  "2024-06": DueMonth.THE_202406,
  "2024-07": DueMonth.THE_202407,
  "2024-08": DueMonth.THE_202408,
  "2024-09": DueMonth.THE_202409,
  "2024-10": DueMonth.THE_202410,
  "2024-11": DueMonth.THE_202411
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
