import 'package:e_Collect/domain/model/integrated_loan_list_model.dart';
import 'package:dartz/dartz.dart';

import '../model/integrated_loan_detail_model.dart';

abstract class IntegratedLoanDetailInterface{
  Future<Either<String, IntegratedLoanDetails>> getIntegratedLoanDetails(
      String requestUrl,
      String flag,
      String branchId,
      String schemeCode,
      String demandDate,
      String accountNumber
      );

}