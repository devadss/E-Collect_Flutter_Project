import 'dart:convert';

RdclduesListSuccessModel parseRdclDuesSuccess(String body) {
  final decoded = json.decode(body);
  return RdclduesListSuccessModel.fromJson(decoded);
}

class RdclduesListSuccessModel {
  final RdclduesList1? rdclDuesList1;

  const RdclduesListSuccessModel({
    this.rdclDuesList1,
  });

  factory RdclduesListSuccessModel.fromJson(Map<String, dynamic> json) {
    return RdclduesListSuccessModel(
      rdclDuesList1: json['RDCLDuesList1'] != null
          ? RdclduesList1.fromJson(json['RDCLDuesList1'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RDCLDuesList1': rdclDuesList1?.toJson(),
    };
  }
}

class RdclduesList1 {
  final List<RdclduesData> data;

  const RdclduesList1({
    required this.data,
  });

  factory RdclduesList1.fromJson(Map<String, dynamic> json) {
    // Check if 'data' exists and is a List
    final dataJson = json['data'];
    if (dataJson == null) {
      return RdclduesList1(data: []);
    }

    if (dataJson is! List) {
      // If data is not a list, return empty list
      return RdclduesList1(data: []);
    }

    return RdclduesList1(
      data: dataJson
          .map((e) => e is Map<String, dynamic>
          ? RdclduesData.fromJson(e)
          : RdclduesData.empty())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class RdclduesData {
  final String accNo;
  final DateTime? openDate;
  final double installAmt;
  final String paidAmount;
  final double dueAmount;
  final String totalInstallment;
  final String name;
  final String paidInstallments;
  final String dueInstallments;
  final String custId;
  final String brCode;
  final String totalCount;

  const RdclduesData({
    required this.accNo,
    required this.openDate,
    required this.installAmt,
    required this.paidAmount,
    required this.dueAmount,
    required this.totalInstallment,
    required this.name,
    required this.paidInstallments,
    required this.dueInstallments,
    required this.custId,
    required this.brCode,
    required this.totalCount,
  });

  // Empty constructor for handling null data
  factory RdclduesData.empty() {
    return RdclduesData(
      accNo: '',
      openDate: null,
      installAmt: 0.0,
      paidAmount: '',
      dueAmount: 0.0,
      totalInstallment: '',
      name: '',
      paidInstallments: '',
      dueInstallments: '',
      custId: '',
      brCode: '',
      totalCount: '',
    );
  }

  factory RdclduesData.fromJson(Map<String, dynamic> json) {
    return RdclduesData(
      accNo: json['AccNo']?.toString() ?? '',
      openDate: json['OpenDate'] != null
          ? DateTime.tryParse(json['OpenDate'].toString())
          : null,
      installAmt: (json['InstallAmt'] as num?)?.toDouble() ?? 0.0,
      paidAmount: json['PaidAmount']?.toString() ?? '',
      dueAmount: (json['DueAmount'] as num?)?.toDouble() ?? 0.0,
      totalInstallment: json['TotalInstallment']?.toString() ?? '',
      name: json['Name']?.toString() ?? '',
      paidInstallments: json['PaidInstallments']?.toString() ?? '',
      dueInstallments: json['DueInstallments']?.toString() ?? '',
      custId: json['Cust_Id']?.toString() ?? '',
      brCode: json['Br_Code']?.toString() ?? '',
      totalCount: json['Total_Count']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccNo': accNo,
      'OpenDate': openDate?.toIso8601String(),
      'InstallAmt': installAmt,
      'PaidAmount': paidAmount,
      'DueAmount': dueAmount,
      'TotalInstallment': totalInstallment,
      'Name': name,
      'PaidInstallments': paidInstallments,
      'DueInstallments': dueInstallments,
      'Cust_Id': custId,
      'Br_Code': brCode,
      'Total_Count': totalCount,
    };
  }
}