class IntegratedLoanDetails {
  final String acno;
  final String memberNo;
  final String custNo;
  final String name;
  final String loanNo;
  final String loanDate;
  final double interestRate;
  final double loanAmount;
  final String loanType;
  final String loanPeriod;
  final List<ReceiptDetail> receiptDetails;
  final String status;

  IntegratedLoanDetails({
    required this.acno,
    required this.memberNo,
    required this.custNo,
    required this.name,
    required this.loanNo,
    required this.loanDate,
    required this.interestRate,
    required this.loanAmount,
    required this.loanType,
    required this.loanPeriod,
    required this.receiptDetails,
    required this.status,
  });

  factory IntegratedLoanDetails.fromJson(Map<String, dynamic> json) {
    return IntegratedLoanDetails(
      acno: json['ACNO'] ?? '',
      memberNo: json['Member_No'] ?? '',
      custNo: json['CUST_NO'] ?? '',
      name: json['Name'] ?? '',
      loanNo: json['LoanNo'] ?? '',
      loanDate: json['LoanDate'] ?? '',
      interestRate: (json['InterestRate'] != null)
          ? double.tryParse(json['InterestRate'].toString()) ?? 0.0
          : 0.0,
      loanAmount: (json['LoanAmount'] != null)
          ? double.tryParse(json['LoanAmount'].toString()) ?? 0.0
          : 0.0,
      loanType: json['LoanType'] ?? '',
      loanPeriod: json['LoanPeriod'] ?? '',
      receiptDetails: (json['Receiptdetails'] as List<dynamic>?)
          ?.map((e) => ReceiptDetail.fromJson(e))
          .toList() ??
          [],
      status: json['Status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ACNO': acno,
      'Member_No': memberNo,
      'CUST_NO': custNo,
      'Name': name,
      'LoanNo': loanNo,
      'LoanDate': loanDate,
      'InterestRate': interestRate,
      'LoanAmount': loanAmount,
      'LoanType': loanType,
      'LoanPeriod': loanPeriod,
      'Receiptdetails': receiptDetails.map((e) => e.toJson()).toList(),
      'Status': status,
    };
  }
}

class ReceiptDetail {
  final String particular;
  final double totalReceived;
  final double balance;
  final double overdue;
  final double currentReceipt;

  ReceiptDetail({
    required this.particular,
    required this.totalReceived,
    required this.balance,
    required this.overdue,
    required this.currentReceipt,
  });

  factory ReceiptDetail.fromJson(Map<String, dynamic> json) {
    return ReceiptDetail(
      particular: json['Particular'] ?? '',
      totalReceived: (json['Total Received'] ?? 0).toDouble(),
      balance: (json['Balance'] ?? 0).toDouble(),
      overdue: (json['Overdue'] ?? 0).toDouble(),
      currentReceipt: (json['Current Receipt'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Particular': particular,
      'Total Received': totalReceived,
      'Balance': balance,
      'Overdue': overdue,
      'Current Receipt': currentReceipt,
    };
  }
}
