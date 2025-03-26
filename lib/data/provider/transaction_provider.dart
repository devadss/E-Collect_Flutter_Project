import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection_qr_flutter/data/repository/TransactionRepository.dart';
import 'package:collection_qr_flutter/domain/model/transaction_fail_model.dart';
import 'package:collection_qr_flutter/domain/model/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _transactionRepository;

  TransactionProvider(this._transactionRepository);

  TransactionModel? _transactionModel;

  TransactionModel? get transactions => _transactionModel;

  Future<Either<TransactionFailModel, TransactionModel>> fetchTransaction(
      String fDate, String tDate, String entityId, String token) async {

    final result = await _transactionRepository.fetchTransactions(
        fDate, tDate, entityId, token);

    result.fold((failure) {
      notifyListeners();
    }, (success) {
      _transactionModel = success;
      notifyListeners();
    });
    return result;
  }
}
