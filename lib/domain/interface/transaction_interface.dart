import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/domain/model/transaction_fail_model.dart';
import 'package:merchant_app_flutter/domain/model/transaction_model.dart';

abstract class TransactionInterface{
  Future<Either<TransactionFailModel, TransactionModel>>fetchTransactions(
      String fDate , String tDate , String entityId, String token
      );
}