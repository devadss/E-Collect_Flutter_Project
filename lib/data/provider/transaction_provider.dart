import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchant_app_flutter/data/repository/TransactionRepository.dart';
import 'package:merchant_app_flutter/domain/model/transaction_fail_model.dart';
import 'package:merchant_app_flutter/domain/model/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _transactionRepository;
  TransactionProvider(this._transactionRepository);

Future<Either<TransactionFailModel, TransactionModel>>fetchTransaction(String fDate ,
    String tDate , String entityId , String token)async {
  return _transactionRepository.fetchTransactions(fDate, tDate, entityId, token);
}

}
