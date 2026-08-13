import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../domain/model/e_collect/transaction_report/transaction_ok_report.dart';
import '../../../../domain/model/e_collect/transaction_report/transaction_report.dart';

class TransactionReportRepository {
  Future<TransactionReport> getTransactionReportByMerchantId(
      String merchantID) async {
    final uri = Uri.parse(
        "https://dev.collect.org.in/api/Payment/transaction-history?merchantId=$merchantID");
    final request =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    print("TransactionReport ${request.body}");
    if (request.statusCode == 200) {
      return TransactionSuccessModel(
          TransactionOkReport.fromJson(jsonDecode(request.body)));
    } else {
      return TransactionFailModel("No transaction Found");
    }
  }

  Future<TransactionReport> getTransactionReportByMerchantIdDateStatus(
      String merchantID, String fromDate , String toDate, String status) async {
    final uri = Uri.parse(
        "https://dev.collect.org.in/api/Payment/transaction-history?merchantId=$merchantID&fromDate=$fromDate&toDate=$toDate&status=$status");
    final request =
    await http.get(uri, headers: {"Content-Type": "application/json"});

    print("TransactionReport ${request.body}");
    print("https://dev.collect.org.in/api/Payment/transaction-history?merchantId=$merchantID&fromDate=$fromDate&toDate=$toDate&status=$status");
    if (request.statusCode == 200) {
      return TransactionSuccessModel(
          TransactionOkReport.fromJson(jsonDecode(request.body)));
    } else {
      return TransactionFailModel("No transaction Found");
    }
  }
}
