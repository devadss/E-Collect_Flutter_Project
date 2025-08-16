import 'package:collection_qr_flutter/data/repository/group/bank_detail_repository.dart';
import 'package:collection_qr_flutter/domain/model/group/bank_detail_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class BankDetailProvider with ChangeNotifier {
  final BankAccountRepository _bankAccountRepository;

  BankDetailProvider(this._bankAccountRepository);

  BankDetailSubmitApiResponse? _bankAccountModel;

  BankDetailSubmitApiResponse? get bankAccountModel => _bankAccountModel;

  String? _bnkError;

  String? get bnkError => _bnkError;

  Future<Either<String, BankDetailSubmitApiResponse>> submitBankDetails(
      int userID,
      String accountHolderName,
      String accountNumber,
      String ifsc,
      String corpCode,
      String branchCode,
      String entityId) async {
    final response = await _bankAccountRepository.submitBankDetails(userID,
        accountHolderName, accountNumber, ifsc, corpCode, branchCode, entityId);

    response.fold((err) {}, (success) {
      _bankAccountModel = success;
    });
    notifyListeners();
    return response;
  }
}
