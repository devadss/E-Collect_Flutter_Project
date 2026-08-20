import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/integrated_loan_detail_model.dart';
import '../repository/integrated_loan_detail_repository.dart';

class IntegratedLoanDetailProvider with ChangeNotifier{
  final IntegratedLoanDetailRepository _integratedLoanDetailRepository;
  IntegratedLoanDetailProvider(this._integratedLoanDetailRepository);

  IntegratedLoanDetails? _integratedLoanListResponse;
  IntegratedLoanDetails? get integratedLoanListResponse => _integratedLoanListResponse;

  Future<Either<String, IntegratedLoanDetails>> getIntegratedLoanDetails(
      String requestUrl,
      String flag,
      String branchId,
      String schemeCode,
      String demandDate,
      String accountNumber
      ) async {
    final data = await _integratedLoanDetailRepository.getIntegratedLoanDetails( requestUrl,flag, branchId, schemeCode, demandDate, accountNumber);
    data.fold((err){}, (success){
      _integratedLoanListResponse = success;
    });
    notifyListeners();
    return data;
  }
}