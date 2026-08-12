import 'package:collection_qr_flutter/domain/model/e_collect/transaction_report/transaction_ok_report.dart';

sealed class TransactionReport {}

class TransactionSuccessModel extends TransactionReport{
  final TransactionOkReport transactionOkReport;
  TransactionSuccessModel(this.transactionOkReport);
}

class TransactionFailModel extends TransactionReport{
  final String emptyTransaction;
  TransactionFailModel(this.emptyTransaction);
}