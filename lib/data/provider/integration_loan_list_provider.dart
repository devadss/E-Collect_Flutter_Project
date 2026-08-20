import 'package:e_Collect/data/repository/integration_loan_repository.dart';
import 'package:e_Collect/domain/model/integrated_loan_list_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class IntegratedLoanListProvider with ChangeNotifier{
  final IntegrationLoanRepository _integrationLoanRepository;
  IntegratedLoanListProvider(this._integrationLoanRepository);

  IntegratedLoanListResponse? _integratedLoanListResponse;
  IntegratedLoanListResponse? get integratedLoanListResponse => _integratedLoanListResponse;

  Future<Either<String , IntegratedLoanListResponse>>fetchIntegratedLoans(
      String? requestUrl ,
      String? agentId ,
      String? branchId ,
      String? schemeCode ,
      String? accNo
      ) async {
    final data = await _integrationLoanRepository.fetchIntegratedLoans(requestUrl, agentId, branchId, schemeCode, accNo);
    data.fold((err){}, (success){
      _integratedLoanListResponse = success;
    });
    notifyListeners();
    return data;

  }
}