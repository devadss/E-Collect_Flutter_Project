import 'package:collection_qr_flutter/data/repository/group/bank_account_update_repository.dart';
import 'package:collection_qr_flutter/domain/model/group/bank_update_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class BankAccountUpdateProvider with ChangeNotifier {
  final BankAccountUpdateRepository? _bankAccountUpdateRepository;

  BankAccountUpdateProvider(this._bankAccountUpdateRepository);

  BankAccountUpdateResponse? _bankAccountUpdateResponse;

  BankAccountUpdateResponse? get bankAccountUpdateResponse =>
      _bankAccountUpdateResponse;

  String? _err;

  String? get err => _err;

  Future<Either<String, BankAccountUpdateResponse>?> getBankAccountDetails(
      int id) async {
    final response =
        await _bankAccountUpdateRepository?.getBankAccountDetails(id);
    response?.fold((err) {
      _err = err;
    }, (success) {
      _bankAccountUpdateResponse = success;
    });
    notifyListeners();
    return response;
  }
}
