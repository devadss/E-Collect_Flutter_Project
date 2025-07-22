class RdclDueUnderAgentModel {
  final List<RDCLDueAccount> data;

  RdclDueUnderAgentModel({required this.data});

  factory RdclDueUnderAgentModel.fromJson(Map<String, dynamic> json) {
    return RdclDueUnderAgentModel(
      data: List<RDCLDueAccount>.from(
        (json['RDCLDuesList1']?['data'] ?? []).map((x) => RDCLDueAccount.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RDCLDueAccount {
  final String accNo;
  final String openDate;
  final num installAmt;
  final String paidAmount;
  final num dueAmount;
  final String totalInstallment;
  final String name;
  final String paidInstallments;
  final String dueInstallments;
  final String custId;
  final String brCode;
  final String totalCount;

  RDCLDueAccount({
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

  factory RDCLDueAccount.fromJson(Map<String, dynamic> json) {
    return RDCLDueAccount(
      accNo: json['AccNo'],
      openDate: json['OpenDate'],
      installAmt: json['InstallAmt'],
      paidAmount: json['PaidAmount'],
      dueAmount: json['DueAmount'],
      totalInstallment: json['TotalInstallment'],
      name: json['Name'],
      paidInstallments: json['PaidInstallments'] ?? "0",
      dueInstallments: json['DueInstallments'],
      custId: json['Cust_Id'],
      brCode: json['Br_Code'],
        totalCount: json['Total_Count']
    );
  }

  Map<String, dynamic> toJson() => {
    "AccNo": accNo,
    "OpenDate": openDate,
    "InstallAmt": installAmt,
    "PaidAmount": paidAmount,
    "DueAmount": dueAmount,
    "TotalInstallment": totalInstallment,
    "Name": name,
    "PaidInstallments": paidInstallments,
    "DueInstallments": dueInstallments,
    "Cust_Id": custId,
    "Br_Code": brCode,
    "Total_Count": totalCount,
  };
}
