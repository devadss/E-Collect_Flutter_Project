import 'package:collection_qr_flutter/core/general.dart';
import 'package:collection_qr_flutter/data/repository/group/bank_account_update_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../../domain/model/group/bank_account/bank_update_model.dart';

class BankAccountUpdateProvider with ChangeNotifier {
  final BankAccountUpdateRepository _bankAccountUpdateRepository;

  BankAccountUpdateProvider(this._bankAccountUpdateRepository);

  BankAccountUpdateResponse? _bankAccountUpdateResponse;

  BankAccountUpdateResponse? get bankAccountUpdateResponse =>
      _bankAccountUpdateResponse;

  Future<void> getBankAccountDetails(int id) async{
    printLog("----------------Fetch Ac Details------------");
    printLog(bankAccountUpdateResponse);
    final result = await _bankAccountUpdateRepository.getBankAccountDetails(id);
    result.fold(
        (error){
          printLog("----------------ERROR------------");
          printLog(error);
        },
        (data){
          _bankAccountUpdateResponse = data;
          printLog("----------------DATA FETCH AC DETAILS------------");
          printLog(data);
          notifyListeners();
        }
    );
  }

  // String? _err;
  //
  // String? get err => _err;

  // Future<Either<String, BankAccountUpdateResponse>?> getBankAccountDetails(
  //     int id) async {
  //   final response =
  //       await _bankAccountUpdateRepository?.getBankAccountDetails(id);
  //   response?.fold((err) {
  //     _err = err;
  //   }, (success) {
  //     _bankAccountUpdateResponse = success;
  //   });
  //   notifyListeners();
  //   return response;
  // }
}
