import 'package:collection_qr_flutter/data/repository/integrated_loan_detail_repository.dart';
import 'package:collection_qr_flutter/domain/model/integrated_loan_detail_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class IntegratedLoanDetailProvider with ChangeNotifier{
  final IntegratedLoanDetailRepository _integratedLoanDetailRepository;
  IntegratedLoanDetailProvider(this._integratedLoanDetailRepository);

  IntegratedLoanDetails? _integratedLoanListResponse;
  IntegratedLoanDetails? get integratedLoanListResponse => _integratedLoanListResponse;

  Future<Either<String, IntegratedLoanDetails>> getIntegratedLoanDetails(
      String flag,
      String branchId,
      String schemeCode,
      String demandDate,
      String accountNumber
      ) async {
    final data = await _integratedLoanDetailRepository.getIntegratedLoanDetails(flag, branchId, schemeCode, demandDate, accountNumber);
    data.fold((err){}, (success){
      _integratedLoanListResponse = success;
    });
    notifyListeners();
    return data;
  }
}