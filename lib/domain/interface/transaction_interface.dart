import 'package:dartz/dartz.dart';
import '../model/transaction_fail_model.dart';
import '../model/transaction_model.dart';

abstract class TransactionInterface{
  Future<Either<TransactionFailModel, TransactionModel>>fetchTransactions(
      String fDate , String tDate , String entityId, String token
      );
}