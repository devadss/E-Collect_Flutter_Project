import 'package:collection_qr_flutter/data/repository/cash_deposit_repository.dart';
import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/model/cash_deposit_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class CashDepositProvider with ChangeNotifier {

  CashDepositRepository _cashDepositRepository;

  CashDepositProvider(this._cashDepositRepository);

  CashDepositModel? cashDepositModel;

  CashDepositModel? get cashDeposit => cashDepositModel;

  Future<Either<ErrorHandler, CashDepositModel>> depositCash(
      String accountNumber, String agentId, String amount) async {
    final response = await _cashDepositRepository.depositCash(
        accountNumber, agentId, amount);
    response.fold((error) {}, (data) {
      cashDepositModel = data;
      notifyListeners();
    });
    return response;
  }
}